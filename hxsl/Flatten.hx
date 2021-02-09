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

enum ARead {
	AIndex( a : Alloc );
	AOffset( a : Alloc, stride : Int, delta : TExpr );
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
		var allVars = globals.concat(params);
		var textures = packTextures(prefix + "Textures", allVars, TSampler2D)
			.concat(packTextures(prefix+"TexturesCube", allVars, TSamplerCube))
			.concat(packTextures(prefix+"TexturesArray", allVars, TSampler2DArray));
		packBuffers(allVars);
		var funs = [for( f in s.funs ) mapFun(f, mapExpr)];
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
				access(a, v.type, e.p, AIndex(a));
		case TArray( { e : TVar(v), p : vp }, eindex) if( !eindex.e.match(TConst(CInt(_))) ):
			var a = varMap.get(v);
			if( a == null )
				e
			else {
				switch( v.type ) {
				case TArray(t, _) if( t.isSampler() ):
					eindex = toInt(mapExpr(eindex));
					access(a, t, vp, AOffset(a,1,eindex));
				case TArray(t, _):
					var stride = varSize(t, a.t);
					if( stride == 0 || stride & 3 != 0 ) throw new Error("Dynamic access to an Array which size is not 4 components-aligned is not allowed", e.p);
					stride >>= 2;
					eindex = toInt(mapExpr(eindex));
					access(a, t, vp, AOffset(a,stride, stride == 1 ? eindex : { e : TBinop(OpMult,eindex,mkInt(stride,vp)), t : TInt, p : vp }));
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
			case UnpackNormal:
				allocConst(0.5, e.p);
			case PackNormal:
				allocConst(1, e.p);
				allocConst(0.5, e.p);
			case ScreenToUv:
				allocConsts([0.5,0.5], e.p);
				allocConsts([0.5,-0.5], e.p);
			case UvToScreen:
				allocConsts([2,-2], e.p);
				allocConsts([-1,1], e.p);
			case Smoothstep:
				allocConst(2.0, e.p);
				allocConst(3.0, e.p);
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

	inline function readIndex( a : Alloc, index : Int, pos ) : TExpr {
		var offs = a.t == null ? a.pos : a.pos >> 2;
		return { e : TArray({ e : TVar(a.g), t : a.g.type, p : pos },mkInt(offs+index,pos)), t : TVec(4,a.t), p : pos }
	}

	inline function readOffset( a : Alloc, stride : Int, delta : TExpr, index : Int, pos ) : TExpr {
		var index = (a.t == null ? a.pos : a.pos >> 2) + index;
		var offset : TExpr = index == 0 ? delta : { e : TBinop(OpAdd, delta, mkInt(index, pos)), t : TInt, p : pos };
		return { e : TArray({ e : TVar(a.g), t : a.g.type, p : pos }, offset), t : TVec(4,a.t), p:pos };
	}

	function access( a : Alloc, t : Type, pos : Position, acc : ARead ) : TExpr {
		inline function read(index, pos) {
			return switch( acc ) {
			case AIndex(a): readIndex(a, index, pos);
			case AOffset(a, stride, delta): readOffset(a, stride, delta, index, pos);
			}
		}
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
		case TMat3:
			return { e : TCall( { e : TGlobal(Mat3), t : TFun([]), p : pos } , [access(a, TMat3x4, pos, acc)] ), t : TMat3, p : pos };
		case TArray(t, SConst(len)):
			var stride = Std.int(a.size / len);
			var earr = [for( i in 0...len ) { var a = new Alloc(a.g, a.t, a.pos + stride * i, stride); access(a, t, pos, AIndex(a)); }];
			return { e : TArrayDecl(earr), t : t, p : pos };
		default:
			if( t.isSampler() ) {
				var e = read(0, pos);
				e.t = t;
				return e;
			}
			var size = varSize(t, a.t);
			if( size > 4 )
				return Error.t("Access not supported for " + t.toString(), null);
			var e = read(0, pos);
			if( size == 4 ) {
				if( a.pos & 3 != 0 ) throw "assert";
			} else {
				var sw = [];
				for( i in 0...size )
					sw.push(Tools.SWIZ[i + (a.pos & 3)]);
				e = { e : TSwiz(e, sw), t : t, p : pos };
			}
			switch( t ) {
			case TInt:
				e.t = TFloat;
				e = toInt(e);
			case TVec(size,VInt):
				e.t = TVec(size,VFloat);
				e = { e : TCall({ e : TGlobal([IVec2,IVec3,IVec4][size-2]), t : TFun([]), p : pos }, [e]), t : t, p : pos };
			default:
			}
			return e;
		}
	}

	function toInt( e : TExpr ) {
		if( e.t == TInt ) return e;
		return { e : TCall({ e : TGlobal(ToInt), t : TFun([]), p : e.p }, [e]), t : TInt, p : e.p };
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
		var pos = 0;
		var samplers = [];
		for( v in vars ) {
			var count = 1;
			if( v.type != t ) {
				switch( v.type ) {
				case TChannel(_) if( t == TSampler2D ):
				case TArray(t2,SConst(n)) if( t2 == t ):
					count = n;
				default:
					continue;
				}
			}
			var a = new Alloc(g, null, pos, count);
			a.v = v;
			if( v.qualifiers != null )
				for( q in v.qualifiers )
					switch( q ) {
					case Sampler(name):
						for( i in 0...count )
							samplers[pos+i] = name;
					default:
					}
			varMap.set(v, a);
			alloc.push(a);
			pos += count;
		}
		g.type = TArray(t, SConst(pos));
		if( samplers.length > 0 ) {
			for( i in 0...pos )
				if( samplers[i] == null )
					samplers[i] = "";
			if( g.qualifiers == null )
				g.qualifiers = [];
			g.qualifiers.push(Sampler(samplers.join(",")));
		}
		if( alloc.length > 0 ) {
			outVars.push(g);
			allocData.set(g, alloc);
		}
		return alloc;
	}

	function packBuffers( vars : Array<TVar> ) {
		var alloc = new Array<Alloc>();
		var g : TVar = {
			id : Tools.allocVarId(),
			name : "buffers",
			type : TVoid,
			kind : Param,
		};
		for( v in vars )
			if( v.type.match(TBuffer(_)) ) {
				var a = new Alloc(g, null, alloc.length, 1);
				a.v = v;
				alloc.push(a);
				outVars.push(v);
			}
		g.type = TArray(TBuffer(TVoid,SConst(0)),SConst(alloc.length));
		allocData.set(g, alloc);
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
			if( v.type.isSampler() || v.type.match(TBuffer(_)) )
				continue;
			switch( v.type ) {
			case TArray(t,_) if( t.isSampler() ): continue;
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
					var i = alloc.indexOf(best);
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
		case TFloat, TInt if( t == VFloat ): 1;
		case TVec(n, t2) if( t == t2 ): n;
		case TMat4 if( t == VFloat ): 16;
		case TMat3, TMat3x4 if( t == VFloat ): 12;
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