package hxsl;

import hxsl.Ast;
import hxsl.RuntimeShader;
import format.agal.Data;

class AgalOut {

	static var COMPS = [X, Y, Z, W];

	var code : Array<Opcode>;
	var current : RuntimeShaderData;
	var version : Int;
	var opcodes : Array<Opcode>;
	var varMap : Map<Int, Reg>;
	var tmpCount : Int;
	var nullReg : Reg;
	var unused : Map<Int, Reg>;

	public function new() {
	}

	public dynamic function error( msg : String, p : Position ) {
		throw msg;
	}

	public function compile( s : RuntimeShaderData, version ) : Data {
		current = s;
		nullReg = new Reg(RTemp, -1, null);
		this.version = version;
		opcodes = [];
		tmpCount = 0;
		varMap = new Map();
		unused = new Map();

		var varying = [];
		var paramCount = 0, inputCount = 0, outCount = 0, texCount = 0;
		for( v in s.data.vars ) {
			var r : Reg;
			switch( v.kind ) {
			case Param, Global:
				switch( v.type ) {
				case TArray(TSampler2D | TSamplerCube, SConst(n)):
					r = new Reg(RTexture, texCount, null);
					texCount += n;
				default:
					r = new Reg(RConst, paramCount, defSwiz(v.type));
					paramCount += regSize(v.type);
				}
			case Var:
				r = new Reg(RVar, v.id, defSwiz(v.type));
				varying.push(r);
			case Output:
				r = new Reg(ROut, outCount, defSwiz(v.type));
				outCount += regSize(v.type);
			case Input:
				r = new Reg(RAttr, inputCount, defSwiz(v.type));
				inputCount += regSize(v.type);
			case Local, Function:
				continue;
			}
			varMap.set(v.id, r);
			unused.set(v.id, r);
		}
		if( paramCount != s.globalsSize + s.paramsSize )
			throw "assert";

		// optimize varying
		// make sure the order is the same in both fragment and vertex shader
		varying.sort(function(r1, r2) return ((r2.swiz == null ? 4 : r2.swiz.length) - (r1.swiz == null ? 4 : r1.swiz.length)) * 100000 + (r1.index - r2.index));
		var valloc : Array<Array<C>> = [];
		for( r in varying ) {
			var size = r.swiz == null ? 4 : r.swiz.length;
			var found = -1;
			for( i in 0...valloc.length ) {
				var v = valloc[i];
				if( v.length < size ) continue;
				found = i;
				break;
			}
			if( found < 0 ) {
				found = valloc.length;
				valloc.push([X, Y, Z, W]);
			}
			r.index = found;
			var v = valloc[found];
			if( size == 4 )
				valloc[found] = [];
			else if( size == 1 )
				r.swiz[0] = v.pop();
			else {
				for( i in 0...size )
					r.swiz[i] = v.shift();
			}
		}

		if( s.data.funs.length != 1 ) throw "assert";
		expr(s.data.funs[0].expr);

		// force write of missing varying components
		for( vid in 0...valloc.length ) {
			var v = valloc[vid];
			if( v.length == 0 ) continue;
			for( i in 0...opcodes.length )
				switch( opcodes[i] ) {
				case OMov(dst, val) if( dst.index == vid && dst.t == RVar ):
					var dst = dst.clone();
					var val = val.clone();
					var last = X;
					val.swiz = [for( i in 0...4 ) { var k = dst.swiz.indexOf(COMPS[i]); if( k >= 0 ) last = val.swiz[k]; last; } ];
					dst.swiz = null;
					opcodes[i] = OMov(dst, val);
					break;
				default:
				}
		}

		// force write of unused inputs
		for( r in unused )
			switch( r.t ) {
			case RAttr:
				var t = allocReg();
				t.swiz = r.swiz == null ? null : [for( i in 0...r.swiz.length ) COMPS[i]];
				op(OMov(t, r));
			default:
			}

		return {
			fragmentShader : !current.vertex,
			version : version,
			code : opcodes,
		};
	}

	function mov(dst, src, t) {
		var n = regSize(t);
		op(OMov(dst, src));
		if( n > 1 )
			for( i in 1...n )
				op(OMov(offset(dst, i), offset(src, i)));
	}

	inline function op(o) {
		opcodes.push(o);
	}

	inline function swiz( r : Reg, sw : Array<C> ) : Reg {
		if( r.access != null ) throw "assert";
		var sw = sw;
		if( r.swiz != null )
			sw = [for( c in sw ) r.swiz[c.getIndex()]];
		return new Reg(r.t, r.index, sw);
	}

	inline function offset( r : Reg, k : Int ) : Reg {
		if( r.access != null ) throw "assert";
		return new Reg(r.t, r.index + k, r.swiz == null ? null : r.swiz.copy());
	}

	function getConst( v : Float ) : Reg {
		for( i in 0...current.consts.length )
			if( current.consts[i] == v ) {
				var g = current.globals;
				while( g != null ) {
					if( g.path == "__consts__" )
						break;
					g = g.next;
				}
				var p = g.pos + i;
				return new Reg(RConst, p >> 2, [COMPS[p & 3]]);
			}
		throw "Missing required const "+v;
	}

	function getConsts( va : Array<Float> ) : Reg {
		var pad = (va.length - 1) & 3;
		for( i in 0...current.consts.length - (va.length - 1) ) {
			if( (i >> 2) != (i + pad) >> 2 ) continue;
			var found = true;
			for( j in 0...va.length )
				if( current.consts[i + j] != va[j] ) {
					found = false;
					break;
				}
			if( found ) {
				var g = current.globals;
				while( g != null ) {
					if( g.path == "__consts__" )
						break;
					g = g.next;
				}
				var p = g.pos + i;
				return new Reg(RConst, p >> 2, defSwiz(TVec(va.length,VFloat)));
			}
		}
		throw "Missing required consts "+va;
	}

	function expr( e : TExpr ) : Reg {
		switch( e.e ) {
		case TConst(c):
			switch( c ) {
			case CInt(v):
				return getConst(v);
			case CFloat(f):
				return getConst(f);
			default:
				throw "assert " + c;
			}
		case TParenthesis(e):
			return expr(e);
		case TVarDecl(v, init):
			if( init != null )
				mov(reg(v), expr(init), v.type);
			return nullReg;
		case TBlock(el):
			var r = nullReg;
			for( e in el )
				r = expr(e);
			return r;
		case TVar(v):
			var r = reg(v);
			switch( v.type ) {
			case TBytes(n):
				// multiply by 255 on read
				var ro = allocReg();
				var c = getConst(255);
				var sw = [];
				for( i in 0...n ) {
					sw.push(COMPS[i]);
					if( i > 0 ) c.swiz.push(c.swiz[0]);
				}
				op(OMul(swiz(ro, sw), swiz(r, sw), c));
				return ro;
			default:
			}
			return r;
		case TBinop(bop, e1, e2):
			return binop(bop, e.t, e1, e2);
		case TCall(c, args):
			switch( c.e ) {
			case TGlobal(g):
				return global(g, args, e.t);
			default:
				throw "TODO CALL " + e.e;
			}
		case TArray(ea, index):
			switch( index.e ) {
			case TConst(CInt(v)):
				var r = expr(ea);
				var stride = switch( ea.t ) {
				case TArray(TSampler2D | TSamplerCube, _): 4;
				case TArray(t, _): Tools.size(t);
				default: throw "assert " + e.t;
				};
				var index = v * stride;
				var swiz = null;
				if( stride < 4 ) {
					swiz = [];
					for( i in 0...stride )
						swiz.push(COMPS[(i + index) & 3]);
				} else if( index & 3 != 0 ) throw "assert"; // not register-aligned !
				return new Reg(r.t, r.index + (index>>2), swiz);
			default:
				var r = expr(ea);
				var delta = 0;
				// remove ToInt and extract delta when the form is [int(offset) * stride + delta] as produced by Flatten
				switch( index.e ) {
				case TBinop(OpAdd, { e : TBinop(OpMult,{ e : TCall({ e : TGlobal(ToInt) },[epos]) },stride) } , { e : TConst(CInt(d)) } ):
					delta = d;
					index = { e : TBinop(OpMult, epos, stride), t : TFloat, p : index.p };
				case TBinop(OpMult,{ e : TCall({ e : TGlobal(ToInt) },[epos]) },stride):
					index = { e : TBinop(OpMult, epos, stride), t : TFloat, p : index.p };
				case TBinop(OpAdd, { e : TCall({ e : TGlobal(ToInt) },[epos]) }, { e : TConst(CInt(d)) } ):
					delta = d;
					index = epos;
				case TCall({ e : TGlobal(ToInt) },[epos]):
					index = epos;
				default:
				}
				var i = expr(index);
				if( r.swiz != null || r.access != null ) throw "assert";
				if( i.swiz == null || i.swiz.length != 1 || i.access != null ) throw "assert";
				var out = allocReg();
				op(OMov(out, new Reg(i.t, i.index, null, new RegAccess(r.t, i.swiz[0], r.index + delta))));
				return out;
			}
		case TSwiz(e, regs):
			var r = expr(e);
			return swiz(r, [for( r in regs ) COMPS[r.getIndex()]]);
		case TIf( cond, { e : TDiscard }, null ):
			switch( cond.e ) {
			case TBinop(bop = OpLt | OpGt, e1, e2) if( e1.t == TFloat ):
				if( bop == OpGt ) {
					var tmp = e1;
					e1 = e2;
					e2 = e1;
				}
				var r = allocReg(TFloat);
				op(OSub(r, expr(e1), expr(e2)));
				op(OKil(r));
				return nullReg;
			default:
				throw "Discard cond not supported " + e.e+ " "+e.p;
			}
		case TUnop(uop, e):
			switch( uop ) {
			case OpNeg:
				var r = allocReg(e.t);
				op(ONeg(r, expr(e)));
				return r;
			default:
			}
		case TIf(econd, eif, eelse):
			switch( econd.e ) {
			case TBinop(bop, e1, e2) if( e1.t == TFloat ):
				inline function cop(f) {
					op(f(expr(e1), expr(e2)));
					expr(eif);
					if( eelse != null ) {
						op(OEls);
						expr(eelse);
					}
					op(OEif);
					return nullReg;
				}
				switch( bop ) {
				case OpEq:
					return cop(OIfe);
				case OpNotEq:
					return cop(OIfe);
				case OpGt:
					return cop(OIfg);
				case OpLt:
					return cop(OIfl);
				default:
					throw "Conditional operation not supported " + bop+" " + econd.p;
				}
			default:
			}
			throw "Conditional not supported " + econd.e+" " + econd.p;
		case TMeta(_, _, e):
			return expr(e);
		default:
			throw "Expression '" + Printer.toString(e)+"' not supported in AGAL "+e.p;
		}
		return null;
	}

	function binop( bop, et : Type, e1 : TExpr, e2 : TExpr ) {
		inline function std(bop) {
			var r = allocReg(et);
			op(bop(r, expr(e1), expr(e2)));
			return r;
		}
		inline function compare(bop,e1,e2) {
			var r = allocReg(et);
			op(bop(r, expr(e1), expr(e2)));
			return r;
		}
		switch( bop ) {
		case OpAdd: return std(OAdd);
		case OpSub: return std(OSub);
		case OpDiv: return std(ODiv);
		case OpMod:
			var tmp = allocReg(e2.t);
			op(OMov(tmp, expr(e2)));
			var r = allocReg(et);
			op(ODiv(r, expr(e1), tmp));
			op(OFrc(r, r));
			op(OMul(r, r, tmp));
			return r;
		case OpAssign:
			var r = expr(e1);
			mov(r, expr(e2), e1.t);
			return r;
		case OpAssignOp(op):
			var r1 = expr(e1);
			mov(r1, expr( { e : TBinop(op, e1, e2), t : e1.t, p : e1.p } ), e1.t);
			return r1;
		case OpMult:
			var r = allocReg(et);
			var r1 = expr(e1);
			var r2 = expr(e2);
			switch( [e1.t, e2.t] ) {
			case [TFloat | TInt | TVec(_), TFloat | TInt | TVec(_)]:
				op(OMul(r, r1, r2));
			case [TVec(3, VFloat), TMat3]:
				var r2 = swiz(r2,[X,Y,Z]);
				op(ODp3(swiz(r,[X]), r1, r2));
				op(ODp3(swiz(r,[Y]), r1, offset(r2,1)));
				op(ODp3(swiz(r,[Z]), r1, offset(r2,2)));
			case [TVec(3, VFloat), TMat3x4]:
				if( r1.t == RTemp ) {
					var r = allocReg();
					op(OMov(swiz(r, [X, Y, Z]), r1));
					op(OMov(swiz(r, [W]), getConst(1)));
					r1 = r;
				} else {
					r1 = r1.clone();
					r1.swiz = null;
				}
				op(ODp4(swiz(r,[X]), r1, r2));
				op(ODp4(swiz(r,[Y]), r1, offset(r2,1)));
				op(ODp4(swiz(r,[Z]), r1, offset(r2,2)));
			case [TVec(4, VFloat), TMat4]:
				op(ODp4(swiz(r,[X]), r1, r2));
				op(ODp4(swiz(r,[Y]), r1, offset(r2,1)));
				op(ODp4(swiz(r,[Z]), r1, offset(r2,2)));
				op(ODp4(swiz(r, [W]), r1, offset(r2, 3)));
			case [TMat4, TMat4]:
				var tmp = allocReg(TMat4);
				colsToRows(r1, tmp, TMat4);
				for( i in 0...4 ) {
					var b = offset(r2, i);
					var o = offset(r, i);
					op(ODp4(swiz(o, [X]), tmp, b));
					op(ODp4(swiz(o, [Y]), offset(tmp, 1), b));
					op(ODp4(swiz(o, [Z]), offset(tmp, 2), b));
					op(ODp4(swiz(o, [W]), offset(tmp, 3), b));
				}
			default:
				throw "assert " + [e1.t, e2.t];
			}
			return r;
		case OpGt:
			return compare(OSlt, e2, e1);
		case OpLt:
			return compare(OSlt, e1, e2);
		case OpGte:
			return compare(OSge, e1, e2);
		case OpLte:
			return compare(OSlt, e2, e1);
		case OpEq:
			return compare(OSeq, e1, e2);
		case OpNotEq:
			return compare(OSne, e1, e2);
		default:
			throw "TODO " + bop;
		}
		return null;
	}

	function colsToRows( src : Reg, dst : Reg, t : Type ) {
		switch( t ) {
		case TMat4:
			for( i in 0...4 ) {
				var ldst = offset(dst, i);
				for( j in 0...4 )
					op(OMov(swiz(ldst, [COMPS[j]]), swiz(offset(src, j), [COMPS[i]])));
			}
		default:
			throw "Can't transpose " + t;
		}
	}


	function global( g : TGlobal, args : Array<TExpr>, ret : Type ) : Reg {
		inline function binop(bop) {
			if( args.length != 2 ) throw "assert";
			var r = allocReg(ret);
			op(bop(r, expr(args[0]), expr(args[1])));
			return r;
		}
		inline function unop(uop) {
			if( args.length != 1 ) throw "assert";
			var r = allocReg(ret);
			op(uop(r, expr(args[0])));
			return r;
		}

		switch( [g, args] ) {
		case [ToFloat, [a]]:
			return expr(a);
		case [Max, _]:
			return binop(OMax);
		case [Min, _]:
			return binop(OMin);
		case [Pow, _]:
			return binop(OPow);
		case [Sqrt, _]:
			return unop(OSqt);
		case [Inversesqrt, _]:
			return unop(ORsq);
		case [Abs, _]:
			return unop(OAbs);
		case [Sin, _]:
			return unop(OSin);
		case [Cos, _]:
			return unop(OCos);
		case [Tan | Asin | Acos | Atan | Sign, _]:
			throw "TODO" + g;
		case [Log2, _]:
			return unop(OLog);
		case [Exp2, _]:
			return unop(OExp);
		case [Log, _]:
			var r = unop(OLog);
			op(OMul(r, r, getConst(0.6931471805599453))); // log(2)/log(e)
			return r;
		case [Exp, [e]]:
			var r = allocReg(e.t);
			op(OMul(r, expr(e), getConst(1.4426950408889634))); // log(e)/log(2)
			op(OExp(r, r));
			return r;
		case [Radians, [e]]:
			var r = allocReg(e.t);
			op(OMul(r, expr(e), getConst(Math.PI / 180)));
			return r;
		case [Degrees, [e]]:
			var r = allocReg(e.t);
			op(OMul(r, expr(e), getConst(180 / Math.PI)));
			return r;
		case [Cross, [a, b]]:
			var r = allocReg(a.t);
			op(OCrs(r, expr(a), expr(b)));
			return r;
		case [Length, [e]]:
			var r = allocReg(TFloat);
			switch( e.t  ) {
			case TFloat:
				op(OAbs(r, expr(e)));
				return r;
			case TVec(2, VFloat):
				var e = expr(e);
				var tmp = allocReg(TVec(3,VFloat));
				op(OMul(swiz(tmp, [X, Y]), e, e));
				op(OAdd(r, swiz(tmp, [X]), swiz(tmp, [Y])));
			case TVec(3, VFloat):
				var e = expr(e);
				op(ODp3(r, e, e));
			case TVec(4, VFloat):
				var e = expr(e);
				op(ODp4(r, e, e));
			default:
				throw "TODO length(" + e.t + ")";
			}
			op(OSqt(r, r));
			return r;

		case [Mix, [a, b, t]]:
			var ra = allocReg(a.t);
			var rb = allocReg(b.t);
			var r = allocReg(t.t);
			op(OMov(r, expr(t)));
			op(OMul(rb, expr(b), r));
			op(OSub(r, getConst(1), r));
			op(OMul(ra, expr(a), r));
			op(OAdd(ra, ra, rb));
			return ra;

		case [Fract, _]:
			return unop(OFrc);
		case [Saturate, _]:
			return unop(OSat);
		case [Floor | ToInt, [a]]:
			// might not be good for negative values...
			var r = expr(a);
			var tmp = allocReg(a.t);
			op(OFrc(tmp, r));
			op(OSub(r, r, tmp));
			return r;
		case [Clamp, [a, min, max]]:
			var r = allocReg(ret);
			op(OMax(r, expr(a), expr(min)));
			var r2 = allocReg(ret);
			op(OMin(r2, r, expr(max)));
			return r2;
		case [Vec4, _]:
			var r = allocReg();
			var pos = 0;
			for( a in args ) {
				var e = expr(a);
				switch( a.t ) {
				case TFloat:
					if( args.length == 1 )
						mov(r, swiz(e,[X,X,X,X]), a.t);
					else
						mov(swiz(r, [COMPS[pos++]]), e, a.t);
				case TVec(2, VFloat):
					mov(swiz(r, [COMPS[pos++], COMPS[pos++]]), e, a.t);
				case TVec(3, VFloat):
					mov(swiz(r, [COMPS[pos++], COMPS[pos++], COMPS[pos++]]), e, a.t);
				case TVec(4, VFloat):
					mov(r, e, a.t);
				default:
					throw "assert " + e.t;
				}
			}
			return r;
		case [Vec3, _]:
			var r = allocReg(TVec(3,VFloat));
			var pos = 0;
			for( a in args ) {
				var e = expr(a);
				switch( a.t ) {
				case TFloat:
					if( args.length == 1 )
						mov(r, swiz(e,[X,X,X]), a.t);
					else
						mov(swiz(r, [COMPS[pos++]]), e, a.t);
				case TVec(2, VFloat):
					mov(swiz(r, [COMPS[pos++], COMPS[pos++]]), e, a.t);
				case TVec(3, VFloat):
					mov(r, e, a.t);
				default:
					throw "assert " + e.t;
				}
			}
			return r;
		case [Vec2, _]:
			var r = allocReg(TVec(2,VFloat));
			var pos = 0;
			for( a in args ) {
				var e = expr(a);
				switch( a.t ) {
				case TFloat:
					if( args.length == 1 )
						mov(r, swiz(e,[X,X]), a.t);
					else
						mov(swiz(r, [COMPS[pos++]]), e, a.t);
				case TVec(2, VFloat):
					mov(r, e, a.t);
				default:
					throw "assert " + e.t;
				}
			}
			return r;
		case [Texture, [et,uv]]:
			var t = expr(et);
			var uv = expr(uv);
			var r = allocReg();
			if( t.t != RTexture ) throw "assert";
			var flags = [TIgnoreSampler];
			if( et.t == TSamplerCube )
				flags.push(TCube);
			op(OTex(r, uv, { index : t.index, flags : flags }));
			return r;
		case [Dot, [a, b]]:
			switch( a.t ) {
			case TFloat | TInt:
				var r = allocReg(TFloat);
				op(OMul(r, expr(a), expr(b)));
				return r;
			case TVec(2, _):
				var r = allocReg(TFloat);
				var tmp = allocReg(TVec(2,VFloat));
				op(OMul(tmp, expr(a), expr(b)));
				op(OAdd(r, swiz(tmp, [X]), swiz(tmp, [Y])));
				return r;
			case TVec(3, _):
				var r = allocReg(TFloat);
				op(ODp3(r, expr(a), expr(b)));
				return r;
			case TVec(4, _):
				var r = allocReg(TFloat);
				op(ODp4(r, expr(a), expr(b)));
				return r;
			default:
			}
		case [Mat3, _]:
			return copyToMatrix(args, 3, 3);
		case [Mat3x4, _]:
			return copyToMatrix(args, 3, 4);
		case [Mat4, _]:
			return copyToMatrix(args, 4, 4);
		case [Normalize, [e]]:
			switch( e.t ) {
			case TVec(3, VFloat):
				var r = allocReg(e.t);
				op(ONrm(r, expr(e)));
				return r;
			default:
			}
		case [LReflect, [a, b]]:
			var ra = expr(a);
			var rb = expr(b);
			var tmp = allocReg(TFloat);
			switch( a.t ) {
			case TFloat | TInt:
				op(OMul(tmp, ra, rb));
			case TVec(2, _):
				var r = allocReg(TVec(2,VFloat));
				op(OMul(r, ra, rb));
				op(OAdd(tmp, swiz(r, [X]), swiz(r, [Y])));
			case TVec(3, _):
				op(ODp3(tmp, ra, rb));
			case TVec(4, _):
				op(ODp4(tmp, ra, rb));
			default:
			}
			op(OAdd(tmp, tmp, tmp));
			var o = allocReg(a.t);
			var sw = defSwiz(a.t);
			op(OMul(o, swiz(tmp, sw == null ? [X, X, X, X] : [for( _ in sw ) X]), rb));
			op(OSub(o, ra, o));
			return o;
		case [ScreenToUv,[e]]:
			var r = allocReg();
			op(OMul(r,expr(e),getConsts([0.5,-0.5])));
			op(OAdd(r,r,getConsts([0.5,0.5])));
			return r;
		case [UvToScreen,[e]]:
			var r = allocReg();
			op(OMul(r,expr(e),getConsts([2,-2])));
			op(OAdd(r,r,getConsts([-1,1])));
			return r;
		case [Pack, [e]]:
			var c = getConsts([1, 255, 255 * 255, 255 * 255 * 255]);
			var r = allocReg();
			op(OMul(r, swiz(expr(e), [X, X, X, X]), c));
			op(OFrc(r, r));
			var r2 = allocReg();
			op(OMul(r2, swiz(r, [Y, Z, W, W]), getConsts([1/255,1/255,1/255,0])));
			op(OSub(r, r, r2));
			return r;
		case [Unpack, [e]]:
			var c = getConsts([1, 1/255, 1/(255 * 255), 1/(255 * 255 * 255)]);
			var r = allocReg(TFloat);
			op(ODp4(r, expr(e), c));
			return r;
		case [PackNormal, [e]]:
			var r = allocReg();
			op(OAdd(r, expr(e), getConst(1)));
			op(OMul(r, r, getConst(0.5)));
			return r;
		case [UnpackNormal, [e]]:
			var r = allocReg(TVec(3,VFloat));
			op(OSub(r, swiz(expr(e), [X, Y,Z]) , getConst(0.5) ));
			op(ONrm(r, r));
			return r;
		case [Step, [a, b]]:
			return this.binop(OpGt, ret, a, b);
		case [DFdx, [v]]:
			var v = expr(v);
			var r = allocReg();
			op(ODdx(r, v));
			return r;
		case [DFdy, [v]]:
			var v = expr(v);
			var r = allocReg();
			op(ODdy(r, v));
			return r;
		case [Fwidth, [v]]:
			var v = expr(v);
			var r = allocReg();
			op(ODdx(r, v));
			op(OAbs(r, r));
			var r2 = allocReg();
			op(ODdy(r2, v));
			op(OAbs(r2, r2));
			op(OAdd(r, r, r2));
			return r;
		case [Smoothstep, [e0, e1, x]]:
			//:x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
			var edge0 = expr(e0);
			var edge1 = expr(e1);
			var r = allocReg(ret);
			var t = allocReg(ret);
			op(OMov(r, expr(x)));
			op(OMov(t, edge1));
			op(OSub(r, r, edge0));
			op(OSub(t, t, edge0));
			op(ORcp(t, t));
			op(OMul(r, r, t));
			op(OSat(r, r));
			//:return x * x * (3 - 2 * x);
			op(OMul(t, r, getConst(2.0)));
			op(OMul(r, r, r));
			op(OSub(t, getConst(3.0), t));
			op(OMul(r, r, t));
			return r;
		default:
		}

		throw "TODO " + g + ":" + args.length;
		return null;
	}

	function copyToMatrix( args : Array<TExpr>, w : Int, h : Int ) {
		var regs = [for( a in args ) expr(a)];
		var out = [for( i in 0...w ) allocReg()];
		var comps = [for( o in out ) for( i in 0...h ) swiz(o, [COMPS[i]])];
		var defSwiz = [X, Y, Z, W];
		// copy all regs to output components
		for( i in 0...args.length ) {
			var regs = [regs[i]];
			switch( args[i].t ) {
			case TFloat, TVec(_):
			case TMat3, TMat3x4:
				if( args.length != 1 ) throw "assert";
				regs.push(offset(regs[0], 1));
				regs.push(offset(regs[0], 2));
				if( h < 4 ) defSwiz = [X, Y, Z];
			case TMat4:
				if( args.length != 1 ) throw "assert";
				regs.push(offset(regs[0], 1));
				regs.push(offset(regs[0], 2));
				if( w == 4 ) regs.push(offset(regs[0], 3));
				// we allow to reduce the size of the output matrix
				if( h < 4 ) defSwiz = [X, Y, Z];
			default:
				throw "assert " + args[i].t;
			}
			for( i in 0...regs.length ) {
				regs[i] = regs[i].clone();
				if( regs[i].swiz == null ) regs[i].swiz = defSwiz.copy();
				if( regs[i].access != null ) throw "assert";
			}
			while( regs.length > 0 ) {
				var w = comps[0].index;
				var r = regs[0];
				var sw = [], sr = [];
				while( regs[0].swiz.length > 0 && comps[0].index == w ) {
					sw.push(comps.shift().swiz[0]);
					sr.push(regs[0].swiz.shift());
				}
				if( regs[0].swiz.length == 0 ) regs.shift();
				var m = OMov( new Reg(RTemp, w, sw), new Reg(r.t, r.index, sr) );
				op(m);
			}
		}
		if( comps.length != 0 ) throw "assert";
		return out[0];
	}

	function regSize( t : Type ) {
		return switch( t ) {
		case TInt, TFloat, TVec(_), TBytes(_), TBool: 1;
		case TMat2: throw "Mat2 is not supported in AGAL";
		case TMat3, TMat3x4: 3;
		case TMat4: 4;
		case TArray(t, SConst(size)), TBuffer(t, SConst(size)): (Tools.size(t) * size + 3) >> 2;
		case TStruct(vl): throw "TODO";
		case TVoid, TString, TSampler2D, TSampler2DArray, TSamplerCube, TFun(_), TArray(_), TBuffer(_), TChannel(_): throw "assert "+t;
		}
	}

	function defSwiz( t : Type ) {
		return switch( t ) {
		case TInt, TFloat: [X];
		case TVec(2, _), TBytes(2): [X, Y];
		case TVec(3, _), TBytes(3): [X, Y, Z];
		default: null;
		}
	}

	function reg( v : TVar ) : Reg {
		var r = varMap.get(v.id);
		if( r != null ) {
			unused.remove(v.id);
			return r;
		}
		if( v.kind != Local ) throw "assert " + v;
		r = allocReg(v.type);
		varMap.set(v.id, r);
		return r;
	}

	function allocReg( ?t : Type ) : Reg {
		var r = new Reg(RTemp, tmpCount, t == null ? null : defSwiz(t));
		tmpCount += t == null ? 1 : regSize(t);
		return r;
	}

	public static function toAgal( shader, version ) {
		var a = new AgalOut();
		return a.compile(shader, version);
	}

}
