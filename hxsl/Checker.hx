package hxsl;

using hxsl.Ast;

private enum FieldAccess {
	FField( e : TExpr );
	FGlobal( g : TGlobal, arg : TExpr, variants : Array<FunType> );
}

private enum WithType {
	NoValue;
	Value;
	InBlock;
	With( t : Type );
}

/**
	Type Checker : will take an untyped Expr and turn it into a typed TExpr, resolving identifiers and ensuring type safety.
**/
class Checker {

	static var vec2 = TVec(2, VFloat);
	static var vec3 = TVec(3, VFloat);
	static var vec4 = TVec(4, VFloat);
	static var ivec2 = TVec(2, VInt);
	static var ivec3 = TVec(3, VInt);
	static var ivec4 = TVec(4, VInt);

	var vars : Map<String,TVar>;
	var globals : Map<String,{ g : TGlobal, t : Type }>;
	var curFun : TFunction;
	var inLoop : Bool;
	var inWhile : Bool;
	public var inits : Array<{ v : TVar, e : TExpr }>;

	public function new() {
		globals = initGlobals();
	}

	static var GLOBALS = null;
	static function initGlobals() {
		var globals = GLOBALS;
		if( GLOBALS != null ) return GLOBALS;
		var globals = new Map();
		var genType = [TFloat, vec2, vec3, vec4];
		var baseType = [TFloat, TBool, TInt];
		var genFloat = [for( t in genType ) { args : [ { name : "value", type : t } ], ret : t } ];
		var genFloat2 = [for( t in genType ) { args : [ { name : "a", type : t }, { name : "b", type : t } ], ret : t } ];
		var genWithFloat = [for( t in genType ) { args : [ { name : "a", type : t }, { name : "b", type : TFloat } ], ret : t } ];
		for( g in Ast.TGlobal.createAll() ) {
			var def = switch( g ) {
			case Vec2, Vec3, Vec4, Mat2, Mat3, Mat3x4, Mat4, IVec2, IVec3, IVec4, BVec2, BVec3, BVec4: [];
			case Radians, Degrees, Cos, Sin, Tan, Asin, Acos, Exp, Log, Exp2, Log2, Sqrt, Inversesqrt, Abs, Sign, Floor, Ceil, Fract, Saturate: genFloat;
			case Atan: genFloat.concat(genFloat2);
			case Pow: genFloat2;
			case LReflect:
				genFloat2;
			case Mod, Min, Max:
				genFloat2.concat(genWithFloat);
			case Length:
				[for( t in genType ) { args : [ { name : "value", type : t } ], ret : TFloat } ];
			case Distance, Dot:
				[for( t in genType ) { args : [ { name : "a", type : t }, { name : "b", type : t } ], ret : TFloat } ];
			case Normalize:
				genFloat;
			case Cross:
				[ { args : [ { name : "a", type : vec3 }, { name : "b", type : vec3 } ], ret : vec3 } ];
			case Texture:
				[
					{ args : [ { name : "tex", type : TSampler2D }, { name : "uv", type : vec2 } ], ret : vec4 },
					{ args : [ { name : "tex", type : TSamplerCube }, { name : "normal", type : vec3 } ], ret : vec4 },
					{ args : [ { name : "tex", type : TSampler2DArray }, { name : "uv", type : vec3 } ], ret : vec4 },
				];
			case TextureLod:
				[
					{ args : [ { name : "tex", type : TSampler2D }, { name : "uv", type : vec2 }, { name : "lod", type : TFloat } ], ret : vec4 },
					{ args : [ { name : "tex", type : TSamplerCube }, { name : "normal", type : vec3 }, { name : "lod", type : TFloat } ], ret : vec4 },
					{ args : [ { name : "tex", type : TSampler2DArray }, { name : "uv", type : vec3 }, { name : "lod", type : TFloat } ], ret : vec4 },
				];
			case Texel:
				[
					{ args : [ { name: "tex", type: TSampler2D }, { name: "pos", type: ivec2 } ], ret: vec4 },
					{ args : [ { name: "tex", type: TSampler2DArray }, { name: "pos", type: ivec3 } ], ret: vec4 },
					{ args : [ { name: "tex", type: TSampler2D }, { name: "pos", type: ivec2 }, { name: "lod", type: TInt } ], ret: vec4 },
					{ args : [ { name: "tex", type: TSampler2DArray }, { name: "pos", type: ivec3 }, { name: "lod", type: TInt } ], ret: vec4 },
				];
			case TextureSize:
				[
					{ args : [ { name: "tex", type: TSampler2D } ], ret: vec2 },
					{ args : [ { name: "tex", type: TSampler2DArray } ], ret: vec3 },
					{ args : [ { name: "tex", type: TSamplerCube } ], ret: vec2 },
					{ args : [ { name: "tex", type: TSampler2D }, { name: "lod", type: TInt } ], ret: vec2 },
					{ args : [ { name: "tex", type: TSampler2DArray }, { name: "lod", type: TInt } ], ret: vec3 },
					{ args : [ { name: "tex", type: TSamplerCube }, { name: "lod", type: TInt } ], ret: vec2 },
				];
			case ToInt:
				[for( t in baseType ) { args : [ { name : "value", type : t } ], ret : TInt } ];
			case ToFloat:
				[for( t in baseType ) { args : [ { name : "value", type : t } ], ret : TFloat } ];
			case ToBool:
				[for( t in baseType ) { args : [ { name : "value", type : t } ], ret : TBool } ];
			case Clamp:
				var r = [];
				for( t in genType ) {
					r.push( { args : [ { name : "value", type : t }, { name : "min", type : t }, { name : "max", type : t } ], ret : t } );
					if( t != TFloat )
						r.push( { args : [ { name : "value", type : t }, { name : "min", type : TFloat }, { name : "max", type : TFloat } ], ret : t } );
				}
				r;
			case Mix:
				var r = [];
				for( t in genType ) {
					r.push( { args : [ { name : "x", type : t }, { name : "y", type : t }, { name : "a", type : t } ], ret : t } );
					if( t != TFloat )
						r.push( { args : [ { name : "x", type : t }, { name : "y", type : t }, { name : "a", type : TFloat } ], ret : t } );
				}
				r;
			case Step:
				var r = [];
				for( t in genType ) {
					r.push( { args : [ { name : "edge", type : t }, { name : "x", type : t } ], ret : t } );
					if( t != TFloat )
						r.push( { args : [ { name : "edge", type : TFloat }, { name : "x", type : t } ], ret : t } );
				}
				r;
			case Smoothstep:
				var r = [];
				for( t in genType ) {
					r.push( { args : [ { name : "edge0", type : t }, { name : "edge1", type : t }, { name : "x", type : t } ], ret : t } );
					if( t != TFloat )
						r.push( { args : [ { name : "edge0", type : TFloat }, { name : "edge1", type : TFloat }, { name : "x", type : t } ], ret : t } );
				}
				r;
			case DFdx, DFdy, Fwidth:
				genFloat;
			case Pack:
				[ { args : [ { name : "value", type : TFloat } ], ret : vec4 } ];
			case Unpack:
				[ { args : [ { name : "value", type : vec4 } ], ret : TFloat } ];
			case UnpackNormal:
				[ { args : [ { name : "value", type : vec4 } ], ret : vec3 } ];
			case PackNormal:
				[ { args : [ { name : "value", type : vec3 } ], ret : vec4 } ];
			case ChannelRead:
				[
					{ args : [ { name : "channel", type : TChannel(1) }, { name : "uv", type : vec2 } ], ret : TFloat },
					{ args : [ { name : "channel", type : TChannel(2) }, { name : "uv", type : vec2 } ], ret : vec2 },
					{ args : [ { name : "channel", type : TChannel(3) }, { name : "uv", type : vec2 } ], ret : vec3 },
					{ args : [ { name : "channel", type : TChannel(4) }, { name : "uv", type : vec2 } ], ret : vec4 },
				];
			case ChannelReadLod:
				[
					{ args : [ { name : "channel", type : TChannel(1) }, { name : "uv", type : vec2 }, { name : "lod", type : TFloat } ], ret : TFloat },
					{ args : [ { name : "channel", type : TChannel(2) }, { name : "uv", type : vec2 }, { name : "lod", type : TFloat } ], ret : vec2 },
					{ args : [ { name : "channel", type : TChannel(3) }, { name : "uv", type : vec2 }, { name : "lod", type : TFloat } ], ret : vec3 },
					{ args : [ { name : "channel", type : TChannel(4) }, { name : "uv", type : vec2 }, { name : "lod", type : TFloat } ], ret : vec4 },
				];
			case ChannelFetch:
				[
					{ args : [ { name : "channel", type : TChannel(1) }, { name : "pos", type : ivec2 } ], ret : TFloat },
					{ args : [ { name : "channel", type : TChannel(2) }, { name : "pos", type : ivec2 } ], ret : vec2 },
					{ args : [ { name : "channel", type : TChannel(3) }, { name : "pos", type : ivec2 } ], ret : vec3 },
					{ args : [ { name : "channel", type : TChannel(4) }, { name : "pos", type : ivec2 } ], ret : vec4 },
					{ args : [ { name : "channel", type : TChannel(1) }, { name : "pos", type : ivec2 }, { name : "lod", type : TInt } ], ret : TFloat },
					{ args : [ { name : "channel", type : TChannel(2) }, { name : "pos", type : ivec2 }, { name : "lod", type : TInt } ], ret : vec2 },
					{ args : [ { name : "channel", type : TChannel(3) }, { name : "pos", type : ivec2 }, { name : "lod", type : TInt } ], ret : vec3 },
					{ args : [ { name : "channel", type : TChannel(4) }, { name : "pos", type : ivec2 }, { name : "lod", type : TInt } ], ret : vec4 },
				];
			case ChannelTextureSize:
				[
					{ args : [ { name: "channel", type: TChannel(1) } ], ret: vec2 },
					{ args : [ { name: "channel", type: TChannel(2) } ], ret: vec2 },
					{ args : [ { name: "channel", type: TChannel(3) } ], ret: vec2 },
					{ args : [ { name: "channel", type: TChannel(4) } ], ret: vec2 },
					{ args : [ { name: "channel", type: TChannel(1) }, { name : "lod", type : TInt } ], ret: vec2 },
					{ args : [ { name: "channel", type: TChannel(2) }, { name : "lod", type : TInt } ], ret: vec2 },
					{ args : [ { name: "channel", type: TChannel(3) }, { name : "lod", type : TInt } ], ret: vec2 },
					{ args : [ { name: "channel", type: TChannel(4) }, { name : "lod", type : TInt } ], ret: vec2 },
				];
			case ScreenToUv:
				[{ args : [{ name : "screenPos", type : vec2 }], ret : vec2 }];
			case UvToScreen:
				[{ args : [{ name : "uv", type : vec2 }], ret : vec2 }];
			case Trace:
				[];
			case VertexID, InstanceID, FragCoord, FrontFacing:
				null;
			}
			if( def != null )
				globals.set(g.toString(), { t : TFun(def), g : g } );
		}
		globals.set("vertexID", { t : TInt, g : VertexID });
		globals.set("instanceID", { t : TInt, g : InstanceID });
		globals.set("fragCoord", { t : vec4, g : FragCoord });
		globals.set("frontFacing", { t : TBool, g : FrontFacing });
		globals.set("int", globals.get("toInt"));
		globals.set("float", globals.get("toFloat"));
		globals.set("reflect", globals.get("lReflect"));
		for( i in 2...5 ) {
			globals.set("ivec"+i, globals.get("iVec"+i));
			globals.remove("iVec"+i);
		}
		globals.remove("lReflect");
		globals.remove("toInt");
		globals.remove("toFloat");
		GLOBALS = globals;
		return globals;
	}

	function error( msg : String, pos : Position ) : Dynamic {
		return Ast.Error.t(msg,pos);
	}

	public dynamic function warning( msg : String, pos : Position ) {
	}

	public dynamic function loadShader( path : String ) : Expr {
		throw "Not implemented";
		return null;
	}

	public function check( name : String, shader : Expr ) : ShaderData {
		vars = new Map();
		inits = [];
		inLoop = false;
		inWhile = false;

		var funs = [];
		checkExpr(shader, funs, false, false);
		var tfuns = [];
		for( f in funs ) {
			var pos = f.p, f = f.f;
			var args : Array<TVar> = [for( a in f.args ) {
				if( a.type == null ) error("Argument type required", pos);
				if( a.expr != null ) error("Optional argument not supported", pos);
				if( a.kind == null ) a.kind = Local;
				if( a.kind != Local ) error("Argument should be local", pos);
				if( a.qualifiers.length != 0 ) error("No qualifier allowed for argument", pos);
				{ id : Tools.allocVarId(), name : a.name, kind : Local, type : a.type };
			}];
			var kind = switch( f.name ) {
			case "vertex":  Vertex;
			case "fragment": Fragment;
			case "__init__", "__init__vertex", "__init__fragment": Init;
			default: Helper;
			}
			if( args.length != 0 && kind != Helper )
				error(kind+" function should have no argument", pos);
			var fv : TVar = {
				id : Tools.allocVarId(),
				name : f.name,
				kind : Function,
				type : TFun([{ args : [for( a in args ) { type : a.type, name : a.name }], ret : f.ret == null ? TVoid : f.ret }]),
			};
			var f : TFunction = {
				kind : kind,
				ref : fv,
				args : args,
				ret : f.ret == null ? TVoid : f.ret,
				expr : null,
			};
			if( vars.exists(fv.name) )
				error("Duplicate function name", pos);
			vars.set(fv.name,fv);
			tfuns.push(f);
		}
		for( i in 0...tfuns.length )
			typeFun(tfuns[i], funs[i].f.expr);

		var vars = Lambda.array(vars);
		vars.sort(function(v1, v2) return (v1.id < 0 ? -v1.id : v1.id) - (v2.id < 0 ? -v2.id : v2.id));
		return {
			name : name,
			vars : vars,
			funs : tfuns,
		};
	}

	function saveVars() {
		var old = new Map();
		for( v in vars.keys() )
			old.set(v, vars.get(v));
		return old;
	}

	function typeFun( f : TFunction, e : Expr ) {
		var old = saveVars();
		for( a in f.args )
			vars.set(a.name, a);
		curFun = f;
		f.expr = typeExpr(e,NoValue);
		vars = old;
	}

	function tryUnify( t1 : Type, t2 : Type ) {
		if( t1 == t2 )
			return true;
		switch( [t1, t2] ) {
		case [TVec(s1, t1), TVec(s2, t2)] if( s1 == s2 && t1 == t2 ):
			return true;
		case [TArray(t1, size1), TArray(t2, size2)]:
			switch( [size1,size2] ) {
			case [SConst(a),SConst(b)] if( a == b ):
			case [SVar(v1),SVar(v2)] if( v1 == v2 ):
			default: return false;
			}
			return tryUnify(t1,t2);
		case [TChannel(n1), TChannel(n2)] if( n1 == n2 ):
			return true;
		default:
		}
		return false;
	}

	function unify( t1 : Type, t2 : Type, p : Position ) {
		if( !tryUnify(t1,t2) )
			error(t1.toString() + " should be " + t2.toString(), p);
	}

	function unifyExpr( e : TExpr, t : Type ) {
		if( !tryUnify(e.t, t) ) {
			if( e.t == TInt && t == TFloat ) {
				toFloat(e);
				return;
			}
			error(e.t.toString() + " should be " + t.toString(), e.p);
		}
	}

	function checkWrite( e : TExpr ) {
		switch( e.e ) {
		case TVar(v):
			switch( v.kind ) {
			case Local, Var, Output:
				return;
			default:
			}
		case TSwiz(e, _):
			checkWrite(e);
			return;
		default:
		}
		error("This expression cannot be assigned", e.p);
	}

	function typeWith( e : Expr, ?t : Type ) {
		if( t == null )
			return typeExpr(e, Value);
		var e = typeExpr(e, With(t));
		unifyExpr(e, t);
		return e;
	}

	function typeExpr( e : Expr, with : WithType ) : TExpr {
		var type = null;
		var ed = switch( e.expr ) {
		case EConst(c):
			type = switch( c ) {
			case CInt(i):
				switch( with ) {
				case With(TFloat):
					c = CFloat(i);
					TFloat;
				default:
					TInt;
				}
			case CString(_): TString;
			case CNull: TVoid;
			case CBool(_): TBool;
			case CFloat(_): TFloat;
			};
			TConst(c);
		case EMeta(name, args, e):
			var e = typeExpr(e, with);
			type = e.t;
			TMeta(name, [for( c in args ) switch( c.expr ) {
				case EConst(c): c;
				case EIdent(i): CString(i); // convert ident to string
				default: error("Metadata parameter should be constant", c.pos);
			}], e);
		case EBlock(el):
			var old = saveVars();
			var el = el.copy(), tl = [];
			with = propagate(with);
			if( el.length == 0 && with != NoValue ) error("Value expected", e.pos);
			while( true ) {
				var e = el.shift();
				if( e == null ) break;
				// split vars decls
				switch( e.expr ) {
				case EVars(vl) if( vl.length > 1 ):
					var v0 = vl.shift();
					el.unshift(e);
					e = { expr : EVars([v0]), pos : e.pos };
				default:
				}
				var ew = switch( e.expr ) {
				case EVars(_): InBlock;
				default: if( el.length == 0 ) with else NoValue;
				}
				var et = typeExpr(e, ew);
				if( el.length != 0 && !et.hasSideEffect() ) warning("This expression has no side effect", e.pos);
				tl.push(et);
			}
			vars = old;
			type = with == NoValue ? TVoid : tl[tl.length - 1].t;
			TBlock(tl);
		case EBinop(op, e1, e2):
			var e1 = typeExpr(e1, Value);
			var e2 = typeExpr(e2, With(e1.t));
			switch( op ) {
			case OpAssign:
				checkWrite(e1);
				unify(e2.t, e1.t, e2.p);
				type = e1.t;
			case OpAssignOp(op):
				checkWrite(e1);
				unify(typeBinop(op, e1, e2, e.pos), e1.t, e2.p);
				type = e1.t;
			default:
				type = typeBinop(op, e1, e2, e.pos);
			}
			TBinop(op, e1, e2);
		case EIdent(name):
			var v = vars.get(name);
			if( v != null ) {
				switch( name ) {
				case "vertex", "fragment", "__init__", "__init__vertex", "__init__fragment":
					error("Function cannot be accessed", e.pos);
				default:
				}
				type = v.type;
				TVar(v);
			} else {
				var g = globals.get(name);
				if( g != null ) {
					type = g.t;
					TGlobal(g.g);
				} else {
					switch( name ) {
					case "PI":
						type = TFloat;
						TConst(CFloat(Math.PI));
					default:
						error("Unknown identifier '" + name + "'", e.pos);
					}
				}
			}
		case EField(e1, f):
			var e1 = typeExpr(e1, Value);
			var ef = fieldAccess(e1, f, with, e.pos);
			if( ef == null ) error(e1.t.toString() + " has no field '" + f + "'", e.pos);
			switch( ef ) {
			case FField(ef):
				type = ef.t;
				ef.e;
			case FGlobal(_):
				// not closure support
				error("Global function must be called immediately", e.pos);
			}
		case ECall(e1, args):
			function makeCall(e1) {
				return switch( e1.t ) {
				case TFun(variants):
					var e = unifyCallParams(e1, args, variants, e.pos);
					type = e.t;
					e.e;
				default:
					error(e1.t.toString() + " cannot be called", e.pos);
				}
			}
			switch( e1.expr ) {
			case EField(e1, f):
				var e1 = typeExpr(e1, Value);
				var ef = fieldAccess(e1, f, with, e.pos);
				if( ef == null ) error(e1.t.toString() + " has no field '" + f + "'", e.pos);
				switch( ef ) {
				case FField(ef):
					makeCall(ef);
				case FGlobal(g, arg, variants):
					var eg = { e : TGlobal(g), t : TFun(variants), p : e1.p };
					if( variants.length == 0 ) {
						var args = [for( a in args ) typeExpr(a, Value)];
						args.unshift(arg);
						var e = specialGlobal(g, eg, args, e.pos);
						type = e.t;
						e.e;
					} else {
						var e = unifyCallParams(eg, args, variants, e.pos);
						switch( [e.e, eg.t] ) {
						case [TCall(_, args), TFun([f])]:
							args.unshift(arg);
							f.args.unshift({ name : "_", type : arg.t });
						default:
							throw "assert";
						}
						type = e.t;
						e.e;
					}
				}
			default:
				makeCall(typeExpr(e1, Value));
			}
		case EParenthesis(e):
			var e = typeExpr(e, with);
			type = e.t;
			TParenthesis(e);
		case EFunction(_):
			throw "assert";
		case EVars(vl):
			if( with != InBlock )
				error("Cannot declare a variable outside of a block", e.pos);
			if( vl.length != 1 ) throw "assert";
			var v = vl[0];
			if( v.kind == null ) v.kind = Local;
			if( v.kind != Local ) error("Should be local var", e.pos);
			if( v.qualifiers.length != 0 ) error("Unexpected qualifier", e.pos);
			var tv = makeVar(vl[0],e.pos);
			var init = v.expr == null ? null : typeWith(v.expr, tv.type);
			if( tv.type == null ) {
				if( init == null ) error("Type required for unitialized local var", e.pos);
				tv.type = init.t;
			}
			vars.set(tv.name, tv);
			type = TVoid;
			TVarDecl(tv, init);
		case EUnop(op,e1):
			var e1 = typeExpr(e1, Value);
			switch( op ) {
			case OpNot:
				unifyExpr(e1, TBool);
				type = TBool;
				TUnop(op, e1);
			case OpNeg:
				switch( e1.t ) {
				case TFloat, TInt, TVec(_,VFloat|VInt):
				default: error("Cannot negate " + e1.t.toString(), e.pos);
				}
				type = e1.t;
				TUnop(op, e1);
			case OpIncrement, OpDecrement:
				switch( e1.t ) {
				case TFloat, TInt:
				default: error("Cannot increment " + e1.t.toString(), e.pos);
				}
				type = TVoid;
				TBinop(OpAssignOp(op == OpIncrement ? OpAdd : OpSub), e1, { e : TConst(CInt(1)), t : TInt, p : e1.p });
			default:
				error("Operation non supported", e.pos);
			}
		case EIf(cond, e1, e2):
			with = propagate(with);
			var cond = typeWith(cond, TBool);
			var e1 = typeExpr(e1, with);
			var e2 = e2 == null ? null : typeExpr(e2, with);
			if( with == NoValue ) {
				type = TVoid;
				TIf(cond, e1, e2);
			} else {
				if( e2 == null ) error("Missing else", e.pos);
				if( tryUnify(e1.t, e2.t) )
					type = e1.t;
				else {
					unifyExpr(e2, e1.t);
					type = e2.t;
				}
				TIf(cond, e1, e2);
			}
		case EDiscard:
			type = TVoid;
			TDiscard;
		case EReturn(e1):
			if( (e1 == null) != (curFun.ret == TVoid) )
				error("This function should return " + curFun.ret.toString(), e.pos);
			var e = e1 == null ? null : typeWith(e1, curFun.ret);
			type = TVoid;
			TReturn(e);
		case EFor(v, it, block):
			type = TVoid;
			var it = typeExpr(it, Value);
			switch( it.t ) {
			case TArray(t, _):
				var v : TVar = {
					id : Tools.allocVarId(),
					name : v,
					type : t,
					kind : Local,
				};
				var old = vars.get(v.name);
				vars.set(v.name, v);
				var oldL = inLoop;
				inLoop = true;
				var block = typeExpr(block, NoValue);
				inLoop = oldL;
				if( old == null ) vars.remove(v.name) else vars.set(v.name, old);
				TFor(v, it, block);
			default:
				error("Cannot iterate on " + it.t.toString(), it.p);
			}
		case EWhile(cond, loop, normalWhile):
			type = TVoid;
			var cond = typeWith(cond, TBool);
			var oldL = inLoop, oldW = inWhile;
			inLoop = true;
			inWhile = true;
			var loop = typeExpr(loop, NoValue);
			inLoop = oldL;
			inWhile = oldW;
			TWhile(cond, loop, normalWhile);
		case EContinue:
			if( !inLoop ) error("Continue outside loop", e.pos);
			type = TVoid;
			TContinue;
		case EBreak:
			if( !inLoop ) error("Break outside loop", e.pos);
			type = TVoid;
			TBreak;
		case EArray(e1, e2):
			var e1 = typeExpr(e1, Value);
			var e2 = typeExpr(e2, With(TInt));
			switch( e2.t ) {
			case TInt:
			default: unify(e2.t, TInt, e2.p);
			}
			switch( e1.t ) {
			case TArray(t, size), TBuffer(t,size):
				switch( [size, e2.e] ) {
				case [SConst(v), TConst(CInt(i))] if( i >= v ):
					error("Indexing outside array bounds", e.pos);
				case [_, TConst(CInt(i))] if( i < 0 ):
					error("Cannot index with negative value", e.pos);
				default:
				}
				type = t;
				TExprDef.TArray(e1, e2);
			default:
				error("Cannot index " + e1.t.toString() + " : should be an array", e.pos);
			}
		case EArrayDecl(el):
			if( el.length == 0 ) error("Empty array not supported", e.pos);
			var el = [for( e in el ) typeExpr(e, Value)];
			var t = el[0].t;
			for( i in 1...el.length )
				unifyExpr(el[i], t);
			type = TArray(t, SConst(el.length));
			TArrayDecl(el);
		case ESwitch(e, cases, def):
			var et = typeExpr(e, Value);
			var cases = [for( c in cases ) { values : [for( v in c.values ) typeWith(v, et.t)], expr : typeExpr(c.expr, with) }];
			var def = def == null ? null : typeExpr(def, with);
			type = TVoid;
			TSwitch(et, cases, def);
		}
		if( type == null ) throw "assert";
		return { e : ed, t : type, p : e.pos };
	}

	function propagate( with : WithType ) {
		return switch( with ) {
		case InBlock: NoValue;
		default: with;
		}
	}

	function checkExpr( e : Expr, funs : Array<{ f : FunDecl, p : Position, inherit : Bool }>, isImport, isExtends ) {
		switch( e.expr ) {
		case EBlock(el):
			for( e in el )
				checkExpr(e,funs, isImport, isExtends);
		case EFunction(f):
			if( isImport && (f.name == "fragment" || f.name == "vertex" || StringTools.startsWith(f.name,"__init__")) )
				return;
			for( f2 in funs.copy() ){
				if( f2.f.name == f.name && f2.inherit )
					funs.remove(f2);
			}
			funs.push({ f : f, p : e.pos, inherit : isExtends || isImport });
		case EVars(vl):
			for( v in vl ) {
				if( v.kind == null ) {
					v.kind = Local;
					for( q in v.qualifiers )
						switch( q ) {
						case Const(_): v.kind = Param;
						default:
						}
				}
				var einit = null;
				if( v.expr != null ) {
					if( v.kind != Param )
						error("Cannot initialize variable declaration if not @param", v.expr.pos);
					var e = typeExpr(v.expr, v.type == null ? Value : With(v.type));
					if( v.type == null )
						v.type = e.t;
					else
						unify(e.t, v.type, v.expr.pos);
					checkConst(e);
					einit = e;
				}
				if( v.type == null ) error("Type required for variable declaration", e.pos);
				if( vars.exists(v.name) ) error("Duplicate var decl '" + v.name + "'", e.pos);
				var v = makeVar(v, e.pos);
				if( isImport && v.kind == Param )
					continue;
				if( einit != null )
					inits.push({ v : v, e : einit });
				vars.set(v.name, v);
			}
		case ECall( { expr : EIdent("import") }, [e]):
			var path = [];
			function loop( e : Expr ) {
				switch( e.expr ) {
				case EIdent(n): path.push(n);
				case EField(e, f): loop(e); path.push(f);
				default:
					error("Should be a shader type path", e.pos);
				}
			}
			loop(e);
			var sexpr = null;
			try sexpr = loadShader(path.join(".")) catch( err : haxe.macro.Expr.Error ) throw err catch( err : Dynamic ) error(Std.string(err), e.pos);
			if( sexpr != null )
				checkExpr(sexpr, funs, true, isExtends);
		case ECall( { expr : EIdent("extends") }, [e]):
			var path = [];
			function loop( e : Expr ) {
				switch( e.expr ) {
				case EIdent(n): path.push(n);
				case EField(e, f): loop(e); path.push(f);
				case EConst(CString(s)): path.push(s);
				default:
					error("Should be a shader type path", e.pos);
				}
			}
			loop(e);
			var sexpr = null;
			try sexpr = loadShader(path.join(".")) catch( err : Error ) error(Std.string(err), e.pos);
			if( sexpr != null )
				checkExpr(sexpr, funs, isImport, true);
		default:
			error("This expression is not allowed at shader declaration level", e.pos);
		}
	}

	function checkConst( e : TExpr ) {
		switch( e.e ) {
		case TConst(_):
		case TParenthesis(e): checkConst(e);
		case TCall({ e : TGlobal(Vec2 | Vec3 | Vec4 | IVec2 | IVec3 | IVec4) }, args):
			for( a in args ) checkConst(a);
		default:
			error("This expression should be constant", e.p);
		}
	}

	function makeVar( v : VarDecl, pos : Position, ?parent : TVar ) {
		var tv : TVar = {
			id : Tools.allocVarId(),
			name : v.name,
			kind : v.kind,
			type : v.type,
		};
		if( parent != null )
			tv.parent = parent;
		if( tv.kind == null ) {
			if( parent == null )
				tv.kind = Local;
			else
				tv.kind = parent.kind;
		} else if( parent != null && tv.kind != parent.kind ) {
			switch( [parent.kind, tv.kind] ) {
			case [Global, Var]:
				// allow declaring Vars inside globals (pseudo globals built by shader)
			default:
				error("Variable " + parent.kind + " cannot be changed to " + tv.kind, pos);
			}
		}
		if( v.qualifiers.length > 0 ) {
			tv.qualifiers = v.qualifiers;
			for( q in v.qualifiers )
				switch( q ) {
				case Private:
				case Const(_):
					var p = parent;
					while( p != null ) {
						if( !p.isStruct() ) error("@const only allowed in structure", pos);
						p = p.parent;
					}
					if( tv.kind != Global && tv.kind != Param ) error("@const only allowed on parameter or global", pos);
				case PerObject: if( tv.kind != Global ) error("@perObject only allowed on global", pos);
				case PerInstance(_): if( tv.kind != Input ) error("@perInstance only allowed on input", pos);
				case Nullable: if( tv.kind != Param ) error("@nullable only allowed on parameter or global", pos);
				case Name(_):
					if( parent != null ) error("Cannot have an explicit name for a structure variable", pos);
					if( tv.kind != Global ) error("Explicit name is only allowed for global var", pos);
				case Shared:
					if( parent != null ) error("Cannot share a structure field", pos);
					if( tv.kind != Param ) error("Can only share a @param", pos);
				case Precision(_):
					switch( v.type ) {
					case TVec(_, VFloat), TFloat:
					default:
						error("Precision qualifier not supported on " + v.type, pos);
					}
				case Range(min,max):
					switch( v.type ) {
					case TFloat, TInt, TVec(_, VFloat):
					default:
						error("Precision qualifier not supported on " + v.type, pos);
					}
				case Borrow(source):
					if ( v.kind != Local ) error("Borrow should not have a type qualifier", pos);
				case Sampler(_):
					switch( v.type ) {
					case TArray(t, _) if( t.isSampler() ):
					case t if( t.isSampler() ):
					default: error("Sampler should be on sampler type or sampler array", pos);
					}
				case Ignore, Doc(_):
				}
		}
		if( tv.type != null )
			tv.type = makeVarType(tv.type, tv, pos);
		return tv;
	}

	function makeVarType( vt : Type, parent : TVar, pos : Position ) {
		switch( vt ) {
		case TStruct(vl):
			// mutate to allow TArray to access previously declared vars
			var vl = vl.copy();
			parent.type = TStruct(vl);
			for( i in 0...vl.length ) {
				var v = vl[i];
				vl[i] = makeVar( { type : v.type, qualifiers : v.qualifiers, name : v.name, kind : v.kind, expr : null }, pos, parent);
			}
			return parent.type;
		case TArray(t, size), TBuffer(t,size):
			switch( t ) {
			case TArray(_):
				error("Multidimentional arrays are not allowed", pos);
			case TStruct(_):
				error("Array of structures are not allowed", pos);
			default:
			}
			var s = switch( size ) {
			case SConst(_): size;
			case SVar(v):
				var path = v.name.split(".");
				var v2 = null;
				for( n in path ) {
					if( v2 == null ) {
						v2 = vars.get(n);
						// special handling when we reference our own variable which is being currently declared
						if( v2 == null && parent != null ) {
							var p = parent;
							while( p.parent != null )
								p = p.parent;
							if( p.name == n )
								v2 = p;
						}
					} else {
						v2 = switch( v2.type ) {
						case TStruct(vl):
							var f = null;
							for( v in vl )
								if( v.name == n ) {
									f = v;
									break;
								}
							f;
						default:
							null;
						}
					}
					if( v2 == null ) break;
				}
				if( v2 == null ) error("Array size variable '" + v.name + "'not found", pos);
				if( !v2.isConst() ) error("Array size variable '" + v.name + "'should be a constant", pos);
				SVar(v2);
			}
			t = makeVarType(t,parent,pos);
			return vt.match(TArray(_)) ? TArray(t, s) : TBuffer(t,s);
		default:
			return vt;
		}
	}

	function fieldAccess( e : TExpr, f : String, with : WithType, pos : Position ) : FieldAccess {
		var ef = switch( e.t ) {
		case TStruct(vl):
			var found = null;
			for( v in vl )
				if( v.name == f ) {
					found = v;
					break;
				}
			if( found == null )
				null;
			else
				{ e : TVar(found), t : found.type, p : pos };
		default:
			null;
		}
		if( ef != null )
			return FField(ef);
		var g = globals.get(f);
		if( g == null ) {
			var gl : TGlobal = switch( [f, e.t] ) {
			case ["get", TSampler2D|TSampler2DArray|TSamplerCube]: Texture;
			case ["get", TChannel(_)]: ChannelRead;
			case ["getLod", TSampler2D|TSampler2DArray|TSamplerCube]: TextureLod;
			case ["getLod", TChannel(_)]: ChannelReadLod;
			case ["fetch"|"fetchLod", TSampler2D|TSampler2DArray]: Texel;
			case ["fetch"|"fetchLod", TChannel(_)]: ChannelFetch;
			case ["size", TSampler2D|TSampler2DArray|TSamplerCube]: TextureSize;
			case ["size", TChannel(_)]: ChannelTextureSize;
			default: null;
			}
			if( gl != null ) {
				if( f == "get" && inWhile ) error("Cannot use .get() in while loop, use .getLod instead", pos);
				g = globals.get(gl.toString());
			}
		}
		if( g != null ) {
			switch( g.t ) {
			case TFun(variants):
				var sel = [];
				for( v in variants ) {
					if( v.args.length == 0 || !tryUnify(e.t, v.args[0].type) ) continue;
					var args = v.args.copy();
					args.shift();
					sel.push({ args : args, ret : v.ret });
				}
				if( sel.length > 0 || variants.length == 0 )
					return FGlobal(g.g, e, sel);
			default:
			}
		}
		// swizzle ?
		var stype;
		var ncomps = switch( e.t ) {
		case TFloat: stype = VFloat; 1;
		case TInt: stype = VInt; 1;
		case TBool: stype = VBool; 1;
		case TVec(size, t): stype = t; size;
		case TBytes(size): stype = VFloat; size;
		default: stype = null; 0;
		}
		if( ncomps > 0 && f.length <= 4 ) {
			var str = "xrsygtzbpwaq";
			var comps = [X, Y, Z, W];
			var cat = -1;
			var out = [];
			for( i in 0...f.length ) {
				var idx = str.indexOf(f.charAt(i));
				if( idx < 0 ) return null;
				var icat = idx % 3;
				if( cat < 0 ) cat = icat else if( icat != cat ) return null; // down't allow .ryz
				var cid = Std.int(idx / 3);
				if( cid >= ncomps )
					error(e.t.toString() + " does not have component " + f.charAt(i), pos);
				out.push(comps[cid]);
			}
			return FField( { e : TSwiz(e, out), t: out.length == 1 ? stype.toType() : TVec(out.length,stype), p:pos } );
		}
		return null;
	}

	function specialGlobal( g : TGlobal, e : TExpr, args : Array<TExpr>, pos : Position ) : TExpr {
		var type = null;
		inline function checkLength(n,t) {
			var tsize = 0;
			for( a in args )
				switch( a.t ) {
				case TVec(size, k):
					if( k.toType() != t )
						unify(a.t, t, a.p);
					tsize += size;
				default:
					unifyExpr(a, t);
					tsize++; // if we manage to unify
				}
			if( tsize != n && tsize > 1 )
				error(g.toString() + " requires " + n + " "+t.toString()+" values but has " + tsize, pos);
		}
		switch( g ) {
		case Vec2:
			checkLength(2,TFloat);
			type = TVec(2,VFloat);
		case Vec3:
			checkLength(3,TFloat);
			type = TVec(3,VFloat);
		case Vec4:
			checkLength(4,TFloat);
			type = TVec(4,VFloat);
		case IVec2, IVec3, IVec4:
			var k = switch(g) {
			case IVec2: 2;
			case IVec3: 3;
			case IVec4: 4;
			default: throw "assert";
			}
			if( args.length == 1 ) {
				switch( args[0].t ) {
				case TInt, TFloat:
				case TVec(n,VFloat):
					if( n != 3 ) error("Invalid input vector length: "+n+" should be "+k, pos);
				default:
					checkLength(k,TInt);
				}
			} else
				checkLength(k,TInt);
			type = TVec(k,VInt);
		case BVec2:
			checkLength(2,TBool);
			type = TVec(2,VBool);
		case BVec3:
			checkLength(3,TBool);
			type = TVec(3,VBool);
		case BVec4:
			checkLength(4,TBool);
			type = TVec(4,VBool);
		case Mat3x4:
			switch( ([for( a in args ) a.t]) ) {
			case [TMat4]: type = TMat3x4;
			case [TVec(4, VFloat), TVec(4, VFloat), TVec(4, VFloat)]: type = TMat3x4;
			default:
				error("Cannot apply " + g.toString() + " to these parameters", pos);
			}
		case Mat2:
			switch( ([for( a in args ) a.t]) ) {
			case [TMat2]: type = TMat2;
			case [TVec(2, VFloat), TVec(2, VFloat)]: type = TMat2;
			case [TFloat, TFloat, TFloat, TFloat]: type = TMat2;
			default:
				error("Cannot apply " + g.toString() + " to these parameters", pos);
			}
		case Mat3:
			switch( ([for( a in args ) a.t]) ) {
			case [TMat3x4 | TMat4]: type = TMat3;
			case [TVec(3, VFloat), TVec(3, VFloat), TVec(3, VFloat)]: type = TMat3;
			case [TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat]: type = TMat3;
			default:
				error("Cannot apply " + g.toString() + " to these parameters", pos);
			}
		case Mat4:
			switch( ([for( a in args ) a.t]) ) {
			case [TMat4]: type = TMat4;
			case [TVec(4, VFloat), TVec(4, VFloat), TVec(4, VFloat), TVec(4, VFloat)]: type = TMat4;
			default:
				error("Cannot apply " + g.toString() + " to these parameters", pos);
			}
		case Trace:
			type = TVoid;
		default:
		}
		if( type == null )
			throw "Custom Global not supported " + g;
		return { e : TCall(e, args), t : type, p : pos };
	}

	function unifyCallParams( efun : TExpr, args : Array<Expr>, variants : Array<FunType>, pos : Position ) {
		var minArgs = 1000, maxArgs = -1000, sel = [];
		for( v in variants ) {
			var n = v.args.length;
			if( n < minArgs ) minArgs = n;
			if( n > maxArgs ) maxArgs = n;
			if( n == args.length ) sel.push(v);
		}
		switch( sel ) {
		case [] if( variants.length == 0 ):
			switch( efun.e ) {
			case TGlobal(g):
				return specialGlobal(g, efun, [for( a in args ) typeExpr(a,Value)], pos);
			default:
				throw "assert";
			}
		case []:
			return error("Function expects " + (minArgs == maxArgs ? "" + minArgs : minArgs + "-" + maxArgs)  + " arguments", pos);
		case [f]:
			var targs = [];
			for( i in 0...args.length ) {
				var ft = f.args[i].type;
				var a = typeExpr(args[i], With(ft));
				try {
					unifyExpr(a, ft);
				} catch( e : Error ) {
					e.msg += " for argument '" + f.args[i].name + "'";
					throw e;
				}
				targs.push(a);
			}
			if( variants.length > 1 ) efun.t = TFun([f]);
			return { e : TCall(efun, targs), t : f.ret, p : pos };
		default:
			var bestMatch = null, mcount = -1;
			for( f in sel ) {
				var outArgs = [];
				for( i in 0...args.length ) {
					var a = typeExpr(args[i], With(f.args[i].type));
					if( !tryUnify(a.t, f.args[i].type) )
						break;
					outArgs.push(a);
				}
				if( outArgs.length > mcount ) {
					bestMatch = f;
					mcount = outArgs.length;
					if( mcount == args.length ) {
						efun.t = TFun([f]);
						return { e : TCall(efun, outArgs), t : f.ret, p : pos };
					}
				}
			}
			for( i in 0...args.length )
				try {
					var e = typeExpr(args[i], Value);
					unify(e.t, bestMatch.args[i].type, e.p);
				} catch( e : Error ) {
					e.msg += " for argument '" + bestMatch.args[i].name + "'";
					throw e;
				}
			throw "assert";
		}

	}

	function toFloat( e : TExpr ) {
		if( e.t != TInt ) throw "assert";
		switch( e.e ) {
		case TConst(CInt(v)):
			e.e = TConst(CFloat(v));
			e.t = TFloat;
		default:
			e.e = TCall( { e : TGlobal(ToFloat), t : TFun([]), p : e.p }, [{ e : e.e, t : e.t, p : e.p }]);
			e.t = TFloat;
		}
	}

	function typeBinop(op, e1:TExpr, e2:TExpr, pos : Position) {
		return switch( op ) {
		case OpAssign, OpAssignOp(_): throw "assert";
		case OpMult, OpAdd, OpSub, OpDiv, OpMod:
			switch( [op, e1.t, e2.t] ) {
			case [OpMult,TVec(4,VFloat), TMat4]:
				vec4;
			case [OpMult,TVec(3,VFloat), TMat3x4]:
				vec3;
			case [OpMult, TVec(3,VFloat), TMat3]:
				vec3;
			case [OpMult, TVec(2,VFloat), TMat2]:
				vec2;
			case [_, TInt, TInt]: TInt;
			case [_, TFloat, TFloat]: TFloat;
			case [_, TInt, TFloat]: toFloat(e1); TFloat;
			case [_, TFloat, TInt]: toFloat(e2); TFloat;
			case [_, TVec(a,VFloat), TVec(b,VFloat)] if( a == b ): TVec(a,VFloat);
			case [_, TFloat, TVec(_,VFloat)]: e2.t;
			case [_, TVec(_,VFloat), TFloat]: e1.t;
			case [_, TInt, TVec(_, VFloat)]: toFloat(e1); e2.t;
			case [_, TVec(_,VFloat), TInt]: toFloat(e2); e1.t;
			case [OpMult, TMat4, TMat4]: TMat4;
			default:
				var opName = switch( op ) {
				case OpMult: "multiply";
				case OpAdd: "add";
				case OpSub: "subtract";
				case OpDiv: "divide";
				default: throw "assert";
				}
				error("Cannot " + opName + " " + e1.t.toString() + " and " + e2.t.toString(), pos);
			}
		case OpLt, OpGt, OpLte, OpGte, OpEq, OpNotEq:
			switch( e1.t ) {
			case TFloat, TInt, TString if( e2.t != TVoid ):
				unifyExpr(e2, e1.t);
				TBool;
			case TBool if( (op == OpEq || op == OpNotEq) && e2.t != TVoid ):
				unifyExpr(e2, e1.t);
				TBool;
			case TVec(_) if( e2.t != TVoid ):
				unifyExpr(e2, e1.t);
				e1.t;
			default:
				switch( [e1.e, e2.e] ) {
				case [TVar(v), TConst(CNull)], [TConst(CNull), TVar(v)]:
					if( !v.hasQualifier(Nullable) )
						error("Variable is not declared as nullable", e1.p);
					TBool;
				default:
					error("Cannot compare " + e1.t.toString() + " and " + e2.t.toString(), pos);
				}
			}
		case OpBoolAnd, OpBoolOr:
			unifyExpr(e1, TBool);
			unifyExpr(e2, TBool);
			TBool;
		case OpInterval:
			unifyExpr(e1, TInt);
			unifyExpr(e2, TInt);
			TArray(TInt, SConst(0));
		case OpShl, OpShr, OpUShr, OpOr, OpAnd, OpXor:
			unifyExpr(e1, TInt);
			unifyExpr(e2, TInt);
			TInt;
		default:
			error("Unsupported operator " + op, pos);
		}
	}
}
