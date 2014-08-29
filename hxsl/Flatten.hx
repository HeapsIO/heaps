package hxsl;
using hxsl.Ast;

private class Alloc {
	public var t : VecType;
	public var pos : Int;
	public var size : Int;
	public var g : TVar;
	public var v : Null<TVar>;
	public function new(g, t, pos, size) {
		this.g = g;
		this.t = t;
		this.pos = pos;
		this.size = size;
	}
}

class Flatten {

	var globals : Array<TVar>;
	var params : Array<TVar>;
	var outVars : Array<TVar>;
	var varMap : Map<TVar,Alloc>;
	var econsts : TExpr;
	public var consts : Array<Float>;
	public var allocData : Map< TVar, Array<Alloc> >;

	public function new() {
	}

	public function flatten( s : ShaderData, kind : FunctionKind, constsToGlobal : Bool ) : ShaderData {
		globals = [];
		params = [];
		outVars = [];
		if( constsToGlobal ) {
			consts = [];
			var p = s.funs[0].expr.p;
			var gc : TVar = {
				id : Tools.allocVarId(),
				name : "__consts__",
				kind : Global,
				type : null,
			};
			econsts = {
				e : TVar(gc),
				t : null,
				p : p,
			};
			s = {
				name : s.name,
				vars : s.vars.copy(),
				funs : [for( f in s.funs ) mapFun(f, mapConsts)],
			};
			for( v in s.vars )
				switch( v.type ) {
				case TBytes(_):
					allocConst(255, p);
				default:
				}
			if( consts.length > 0 ) {
				gc.type = econsts.t = TArray(TFloat, SConst(consts.length));
				s.vars.push(gc);
			}
		}
		varMap = new Map();
		allocData = new Map();
		for( v in s.vars )
			gatherVar(v);
		var prefix = switch( kind ) {
		case Vertex: "vertex";
		case Fragment: "fragment";
		default: throw "assert";
		}
		pack(prefix + "Globals", Global, globals, VFloat);
		pack(prefix + "Params", Param, params, VFloat);
		var textures = packTextures(prefix + "Textures", globals.concat(params), TSampler2D);
		var funs = [for( f in s.funs ) mapFun(f, mapExpr)];
		for( t in textures )
			t.pos >>= 2;
		return {
			name : s.name,
			vars : outVars,
			funs : funs,
		};
	}

	function mapFun( f : TFunction, mapExpr : TExpr -> TExpr ) : TFunction {
		return {
			kind : f.kind,
			ret : f.ret,
			args : f.args,
			ref : f.ref,
			expr : mapExpr(f.expr),
		};
	}

	function mapExpr( e : TExpr ) : TExpr {
		e = switch( e.e ) {
		case TVar(v):
			var a = varMap.get(v);
			if( a == null )
				e
			else
				access(a, v.type, e.p, readIndex.bind(a));
		case TArray( { e : TVar(v), p : vp }, eindex) if( !eindex.e.match(TConst(CInt(_))) ):
			var a = varMap.get(v);
			if( a == null )
				e
			else {
				switch( v.type ) {
				case TArray(t, _):
					var stride = varSize(t, a.t);
					if( stride == 0 || stride & 3 != 0 ) throw new Error("Dynamic access to an Array which size is not 4 components-aligned is not allowed", e.p);
					stride >>= 2;
					eindex = mapExpr(eindex);
					var toInt = { e : TCall( { e : TGlobal(ToInt), t : TFun([]), p : vp }, [eindex]), t : TInt, p : vp };
					access(a, t, vp, readOffset.bind(a,stride, stride == 1 ? toInt : { e : TBinop(OpMult,toInt,mkInt(stride,vp)), t : TInt, p : vp }));
				default:
					throw "assert";
				}
			}
		default:
			e.map(mapExpr);
		};
		return optimize(e);
	}

	function mapConsts( e : TExpr ) : TExpr {
		switch( e.e ) {
		case TArray(ea, eindex = { e : TConst(CInt(_)) } ):
			return { e : TArray(mapConsts(ea), eindex), t : e.t, p : e.p };
		case TBinop(OpMult, _, { t : TMat3x4 } ):
			allocConst(1, e.p); // pre-alloc
		case TArray(ea, eindex):
			switch( ea.t ) {
			case TArray(t, _):
				var stride = varSize(t, VFloat) >> 2;
				allocConst(stride, e.p); // pre-alloc
			default:
			}
		case TConst(c):
			switch( c ) {
			case CFloat(v):
				return allocConst(v, e.p);
			case CInt(v):
				return allocConst(v, e.p);
			default:
				return e;
			}
		case TGlobal(g):
			switch( g ) {
			case Pack:
				allocConsts([1, 255, 255 * 255, 255 * 255 * 255], e.p);
				allocConsts([1/255, 1/255, 1/255, 0], e.p);
			case Unpack:
				allocConsts([1, 1 / 255, 1 / (255 * 255), 1 / (255 * 255 * 255)], e.p);
			case Radians:
				allocConst(Math.PI / 180, e.p);
			case Degrees:
				allocConst(180 / Math.PI, e.p);
			case Log:
				allocConst(0.6931471805599453, e.p);
			case Exp:
				allocConst(1.4426950408889634, e.p);
			case Mix:
				allocConst(1, e.p);
			default:
			}
		case TCall( { e : TGlobal(Vec4) }, [ { e : TVar( { kind : Global | Param | Input | Var } ), t : TVec(3, VFloat) }, { e : TConst(CInt(1)) } ]):
			// allow var expansion without relying on a constant
			return e;
		default:
		}
		return e.map(mapConsts);
	}

	function allocConst( v : Float, p ) : TExpr {
		var index = consts.indexOf(v);
		if( index < 0 ) {
			index = consts.length;
			consts.push(v);
		}
		return { e : TArray(econsts, { e : TConst(CInt(index)), t : TInt, p : p } ), t : TFloat, p : p };
	}

	function allocConsts( va : Array<Float>, p ) : TExpr {
		var pad = (va.length - 1) & 3;
		var index = -1;
		for( i in 0...consts.length - (va.length - 1) ) {
			if( (i >> 2) != (i + pad) >> 2 ) continue;
			var found = true;
			for( j in 0...va.length )
				if( consts[i + j] != va[j] ) {
					found = false;
					break;
				}
			if( found ) {
				index = i;
				break;
			}
		}
		if( index < 0 ) {
			// pad
			while( consts.length >> 2 != (consts.length + pad) >> 2 )
				consts.push(0);
			index = consts.length;
			for( v in va )
				consts.push(v);
		}
		inline function get(i) : TExpr {
			return { e : TArray(econsts, { e : TConst(CInt(index+i)), t : TInt, p : p } ), t : TFloat, p : p };
		}
		switch( va.length ) {
		case 1:
			return get(0);
		case 2:
			return { e : TCall( { e : TGlobal(Vec2), t : TVoid, p : p }, [get(0), get(1)]), t : TVec(2, VFloat), p : p };
		case 3:
			return { e : TCall( { e : TGlobal(Vec3), t : TVoid, p : p }, [get(0), get(1), get(2)]), t : TVec(3, VFloat), p : p };
		case 4:
			return { e : TCall( { e : TGlobal(Vec4), t : TVoid, p : p }, [get(0), get(1), get(3), get(4)]), t : TVec(4, VFloat), p : p };
		default:
			throw "assert";
		}
	}

	inline function mkInt(v:Int,pos) {
		return { e : TConst(CInt(v)), t : TInt, p : pos };
	}

	function readIndex( a : Alloc, index : Int, pos ) : TExpr {
		return { e : TArray({ e : TVar(a.g), t : a.g.type, p : pos },mkInt((a.pos>>2)+index,pos)), t : TVec(4,a.t), p : pos }
	}

	function readOffset( a : Alloc, stride : Int, delta : TExpr, index : Int, pos ) : TExpr {
		var index = (a.pos >> 2) + index;
		var offset : TExpr = index == 0 ? delta : { e : TBinop(OpAdd, delta, mkInt(index, pos)), t : TInt, p : pos };
		return { e : TArray({ e : TVar(a.g), t : a.g.type, p : pos }, offset), t : TVec(4,a.t), p:pos };
	}

	function access( a : Alloc, t : Type, pos : Position, read : Int -> Position -> TExpr ) : TExpr {
		switch( t ) {
		case TMat4:
			return { e : TCall( { e : TGlobal(Mat4), t : TFun([]), p : pos }, [
				read(0,pos),
				read(1,pos),
				read(2,pos),
				read(3,pos),
			]), t : TMat4, p : pos }
		case TMat3x4:
			return { e : TCall( { e : TGlobal(Mat3x4), t : TFun([]), p : pos }, [
				read(0,pos),
				read(1,pos),
				read(2,pos),
			]), t : TMat3x4, p : pos }
		case TArray(t, SConst(len)):
			var stride = Std.int(a.size / len);
			var earr = [for( i in 0...len ) { var a = new Alloc(a.g, a.t, a.pos + stride * i, stride); access(a, t, pos, readIndex.bind(a)); }];
			return { e : TArrayDecl(earr), t : t, p : pos };
		case TSampler2D, TSamplerCube:
			return read(0,pos);
		default:
			var size = varSize(t, a.t);
			if( size <= 4 ) {
				var k = read(0,pos);
				if( size == 4 ) {
					if( a.pos & 3 != 0 ) throw "assert";
					return k;
				} else {
					var sw = [];
					for( i in 0...size )
						sw.push(Tools.SWIZ[i + (a.pos & 3)]);
					return { e : TSwiz(k, sw), t : t, p : pos };
				}
			}
			return Error.t("Access not supported for " + t.toString(), null);
		}
	}


	function optimize( e : TExpr ) {
		switch( e.e ) {
		case TCall( { e : TGlobal(Mat3x4) }, [ { e : TCall( { e : TGlobal(Mat4) }, args) } ]):
			var rem = 0;
			var size = 0;
			while( size < 4 ) {
				var t = args[args.length - 1 - rem].t;
				size += varSize(t,VFloat);
				rem++;
			}
			if( size == 4 ) {
				for( i in 0...rem )
					args.pop();
				var emat = switch( e.e ) { case TCall(e, _): e; default: throw "assert"; };
				return { e : TCall(emat, args), t : e.t, p : e.p };
			}
		case TArray( { e : TArrayDecl(el) }, { e : TConst(CInt(i)) } ):
			if( i >= 0 && i < el.length )
				return el[i];
			Error.t("Reading outside array bounds", e.p);
		default:
		}
		return e;
	}

	function packTextures( name : String, vars : Array<TVar>, t : Type ) {
		var alloc = new Array<Alloc>();
		var g : TVar = {
			id : Tools.allocVarId(),
			name : name,
			type : t,
			kind : Param,
		};
		for( v in vars ) {
			if( v.type != t ) continue;
			// use << 2 for readAccess purposes, then we will fix it before returning
			var a = new Alloc(g, null, alloc.length << 2, 1);
			a.v = v;
			varMap.set(v, a);
			alloc.push(a);
		}
		g.type = TArray(t, SConst(alloc.length));
		if( alloc.length > 0 ) {
			outVars.push(g);
			allocData.set(g, alloc);
		}
		return alloc;
	}

	function pack( name : String, kind : VarKind, vars : Array<TVar>, t : VecType ) {
		var alloc = new Array<Alloc>(), apos = 0;
		var g : TVar = {
			id : Tools.allocVarId(),
			name : name,
			type : TVec(0,t),
			kind : kind,
		};
		for( v in vars ) {
			switch( v.type ) {
			case TSampler2D, TSamplerCube:
				continue;
			default:
			}
			var size = varSize(v.type, t);
			var best : Alloc = null;
			for( a in alloc )
				if( a.v == null && a.size >= size && (best == null || best.size > a.size) )
					best = a;
			if( best != null ) {
				var free = best.size - size;
				if( free > 0 ) {
					var i = Lambda.indexOf(alloc, best);
					var a = new Alloc(g, t, best.pos + size, free);
					alloc.insert(i + 1, a);
					best.size = size;
				}
				best.v = v;
				varMap.set(v, best);
			} else {
				var a = new Alloc(g, t, apos, size);
				apos += size;
				a.v = v;
				varMap.set(v, a);
				alloc.push(a);
				var pad = (4 - (size % 4)) % 4;
				if( pad > 0 ) {
					var a = new Alloc(g, t, apos, pad);
					apos += pad;
					alloc.push(a);
				}
			}
		}
		g.type = TArray(TVec(4, t), SConst(apos >> 2));
		if( apos > 0 ) {
			outVars.push(g);
			allocData.set(g, alloc);
		}
		return g;
	}

	function varSize( v : Type, t : VecType ) {
		return switch( v ) {
		case TFloat if( t == VFloat ): 1;
		case TVec(n, t2) if( t == t2 ): n;
		case TMat4 if( t == VFloat ): 16;
		case TMat3x4 if( t == VFloat ): 12;
		case TMat3 if( t == VFloat ): 9;
		case TArray(at, SConst(n)): varSize(at, t) * n;
		default:
			throw v.toString() + " size unknown for type " + t;
		}
	}

	function gatherVar( v : TVar ) {
		switch( v.type ) {
		case TStruct(vl):
			for( v in vl )
				gatherVar(v);
		default:
			switch( v.kind ) {
			case Global:
				if( v.hasQualifier(PerObject) )
					params.push(v);
				else
					globals.push(v);
			case Param:
				params.push(v);
			default:
				outVars.push(v);
			}
		}
	}

}