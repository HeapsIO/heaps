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

	public function new() {
	}

	public dynamic function error( msg : String, p : Position ) {
		throw msg;
	}

	public function compile( s : RuntimeShaderData, version ) : Data {
		current = s;
		nullReg = { t : RTemp, index : -1, swiz : null, access : null };
		this.version = version;
		opcodes = [];
		tmpCount = 0;
		varMap = new Map();

		var varying = [];
		var paramCount = 0, varCount = 0, inputCount = 0, outCount = 0, texCount = 0;
		for( v in s.data.vars ) {
			var r : Reg;
			switch( v.kind ) {
			case Param, Global:
				switch( v.type ) {
				case TArray(TSampler2D | TSamplerCube, SConst(n)):
					r = { t : RTexture, index : texCount, swiz : null, access : null };
					texCount += n;
				default:
					r = { t : RConst, index : paramCount, swiz : defSwiz(v.type), access : null };
					paramCount += regSize(v.type);
				}
			case Var:
				r = { t : RVar, index : varCount, swiz : defSwiz(v.type), access : null };
				varying.push(r);
				varCount += regSize(v.type);
			case Output:
				r = { t : ROut, index : outCount, swiz : defSwiz(v.type), access : null };
				outCount += regSize(v.type);
			case Input:
				r = { t : RAttr, index : inputCount, swiz : defSwiz(v.type), access : null };
				inputCount += regSize(v.type);
			case Local, Function:
				continue;
			}
			varMap.set(v.id, r);
		}
		if( paramCount != s.globalsSize + s.paramsSize )
			throw "assert";

		if( s.data.funs.length != 1 ) throw "assert";
		expr(s.data.funs[0].expr);

		// force write of all varying components
		for( v in varying ) {
			if( v.swiz == null ) continue;
			for( i in 0...opcodes.length )
				switch( opcodes[i] ) {
				case OMov(dst, val) if( dst == v ):
					var dst = Reflect.copy(dst);
					var val = Reflect.copy(val);
					val.swiz = null;
					dst.swiz = null;
					opcodes[i] = OMov(dst, val);
					break;
				default:
				}
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
		return {
			t : r.t,
			index : r.index,
			swiz : sw,
			access : null
		};
	}

	inline function offset( r : Reg, k : Int ) : Reg {
		if( r.swiz != null || r.access != null ) throw "assert";
		return {
			t : r.t,
			index : r.index + k,
			swiz : null,
			access : null,
		};
	}

	function allocConst( v : Float ) : Reg {
		for( i in 0...current.consts.length )
			if( current.consts[i] == v ) {
				var g = null;
				for( v in current.globals )
					if( v.path == "__consts__" ) {
						g = v;
						break;
					}
				var p = g.pos + i;
				return { t : RConst, index : p >> 2, swiz : [COMPS[p & 3]], access : null };
			}
		throw "TODO";
	}

	function expr( e : TExpr ) : Reg {
		switch( e.e ) {
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
			return reg(v);
		case TBinop(bop, e1, e2):
			inline function std(bop) {
				var r = allocReg(e.t);
				op(bop(r, expr(e1), expr(e2)));
				return r;
			}
			switch( bop ) {
			case OpAdd: return std(OAdd);
			case OpSub: return std(OSub);
			case OpDiv: return std(ODiv);
			case OpAssign:
				var r = expr(e1);
				mov(r, expr(e2), e1.t);
				return r;
			case OpAssignOp(op):
				var r1 = expr(e1);
				mov(r1, expr( { e : TBinop(op, e1, e2), t : e1.t, p : e.p } ), e1.t);
				return r1;
			case OpMult:
				var r = allocReg(e.t);
				var r1 = expr(e1);
				var r2 = expr(e2);
				switch( [e1.t, e2.t] ) {
				case [TFloat | TVec(_), TFloat | TVec(_)]:
					op(OMul(r, r1, r2));
				case [TVec(3, VFloat), TMat3]:
					op(OM33(r, r1, r2));
				case [TVec(3, VFloat), TMat3x4]:
					if( r1.t == RTemp ) {
						var r = allocReg();
						op(OMov(swiz(r, [X, Y, Z]), r1));
						op(OMov(swiz(r, [W]), allocConst(1)));
						r1 = r;
					} else {
						r1 = Reflect.copy(r1);
						r1.swiz = null;
					}
					op(OM34(r, r1, r2));
				case [TVec(4, VFloat), TMat4]:
					op(OM44(r, r1, r2));
				default:
					throw "assert " + [e1.t, e2.t];
				}
				return r;
			default:
				throw "TODO " + bop;
			}
		case TCall(c, args):
			switch( c.e ) {
			case TGlobal(g):
				return global(g, args, e.t);
			default:
				throw "TODO CALL " + e.e;
			}
		case TArray(e, index):
			switch( index.e ) {
			case TConst(CInt(v)):
				var r = expr(e);
				var stride = switch( e.t ) {
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
				return { t : r.t, index : r.index + (index>>2), swiz : swiz, access : null };
			default:
				throw "TODO " + index.e;
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
				throw "Discard cond not supported " + e.e;
			}
		default:
		}
		throw "TODO " + e.e;
		return null;
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
		case [Max, _]:
			return binop(OMax);
		case [Min, _]:
			return binop(OMin);
		case [Sqrt, _]:
			return unop(OSqt);
		case [Vec4, _]:
			var r = allocReg();
			var pos = 0;
			for( a in args ) {
				var e = expr(a);
				switch( a.t ) {
				case TFloat:
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
		case [Texture2D, [t,uv]]:
			var t = expr(t);
			var uv = expr(uv);
			var r = allocReg();
			if( t.t != RTexture ) throw "assert";
			op(OTex(r, uv, { index : t.index, flags : [TIgnoreSampler] }));
			return r;
		case [Dot, [a, b]]:
			var r = allocReg(TFloat);
			switch( a.t ) {
			case TVec(3, _):
				op(ODp3(r, expr(a), expr(b)));
			case TVec(4, _):
				op(ODp4(r, expr(a), expr(b)));
			default:
				throw "assert " + a.t;
			}
			return r;
		case [Mat3, _]:
			var regs = [for( a in args ) expr(a)];
			var r0 = regs[0];
			var align = true;
			for( i in 0...regs.length ) {
				var r = regs[i];
				if( r.t == r0.t && r.index == r0.index + i && r.swiz == null && r.access == null ) continue;
				align = false;
				break;
			}
			if( align )
				return r0;
			throw "TODO";
		case [Mat3x4, _]:
			var regs = [for( a in args ) expr(a)];
			var r0 = regs[0];
			var align = true;
			for( i in 0...regs.length ) {
				var r = regs[i];
				if( r.t == r0.t && r.index == r0.index + i && r.swiz == null && r.access == null ) continue;
				align = false;
				break;
			}
			if( align )
				return r0;
			throw "TODO";
		case [Mat4, _]:
			var regs = [for( a in args ) expr(a)];
			var r0 = regs[0];
			var align = true;
			for( i in 0...regs.length ) {
				var r = regs[i];
				if( r.t == r0.t && r.index == r0.index + i && r.swiz == null && r.access == null ) continue;
				align = false;
				break;
			}
			if( align )
				return r0;
			throw "TODO";
		case [Normalize, [e]]:
			switch( e.t ) {
			case TVec(3, VFloat):
				var r = allocReg(e.t);
				op(ONrm(r, expr(e)));
				return r;
			default:
				throw "TODO "+e.t;
			}
		default:
		}

		throw "TODO " + g + ":" + args.length;
		return null;
	}

	function regSize( t : Type ) {
		return switch( t ) {
		case TInt, TFloat, TVec(_), TBytes(_): 1;
		case TMat3, TMat3x4: 3;
		case TMat4: 4;
		case TArray(t, SConst(size)): (Tools.size(t) * size + 3) >> 2;
		case TStruct(vl): throw "TODO";
		case TVoid, TString, TBool, TSampler2D, TSamplerCube, TFun(_), TArray(_): throw "assert "+t;
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
		if( r != null ) return r;
		if( v.kind != Local ) throw "assert " + v;
		r = allocReg(v.type);
		varMap.set(v.id, r);
		return r;
	}

	function allocReg( ?t : Type ) : Reg {
		var r = { t : RTemp, index : tmpCount, swiz : t == null ? null : defSwiz(t), access : null };
		tmpCount += t == null ? 1 : regSize(t);
		return r;
	}

	public static function toAgal( shader, version ) {
		var a = new AgalOut();
		return a.compile(shader, version);
	}

}
