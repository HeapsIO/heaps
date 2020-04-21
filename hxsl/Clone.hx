package hxsl;
using hxsl.Ast;

class Clone {

	public var varMap : Map<Int,TVar>;

	public function new() {
		varMap = new Map();
	}

	public function tvar( v : TVar ) : TVar {
		var v2 = varMap.get(v.id);
		if( v2 != null ) return v2;
		v2 = {
			id : Tools.allocVarId(),
			type : v.type,
			name : v.name,
			kind : v.kind,
		};
		varMap.set(v.id, v2);
		if( v.parent != null ) v2.parent = tvar(v.parent);
		if( v.qualifiers != null ) v2.qualifiers = v.qualifiers.copy();
		v2.type = ttype(v.type);
		return v2;
	}

	public function tfun( f : TFunction ) : TFunction {
		return {
			ret : ttype(f.ret),
			kind : f.kind,
			ref : tvar(f.ref),
			args : [for( a in f.args ) tvar(a)],
			expr : texpr(f.expr),
		};
	}

	public function ttype( t : Type ) {
		switch( t ) {
		case TStruct(vl):
			return TStruct([for( v in vl ) tvar(v)]);
		case TArray(t, size):
			return TArray(ttype(t), switch( size ) { case SConst(_): size; case SVar(v): SVar(tvar(v)); } );
		case TFun(vars):
			return TFun(#if macro [for( v in vars ) { args : [for( a in v.args ) { name : a.name, type : ttype(a.type) } ], ret : ttype(v.ret) }] #else vars #end);
		default:
			return t;
		}
	}

	public function texpr( e : TExpr ) : TExpr {
		var e2 : TExpr = e.map(texpr);
		e2.t = ttype(e.t);
		e2.e = switch( e2.e ) {
		case TVar(v):
			TVar(tvar(v));
		case TVarDecl(v, init):
			TVarDecl(tvar(v), init);
		case TFor(v, it, loop):
			TFor(tvar(v), it, loop);
		default:
			e2.e;
		}
		return e2;
	}

	public function shader( s : ShaderData ) : ShaderData {
		return {
			name : s.name,
			vars : [for( v in s.vars ) tvar(v)],
			funs : [for( f in s.funs ) tfun(f)],
		};
	}

	public static function shaderData( s : ShaderData ) {
		return new Clone().shader(s);
	}

}