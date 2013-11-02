package hxsl;

import hxsl.Ast;

class Checker {
	
	var vars : Map<String,TVar>;
	var functions : Map<String,TFun>;

	public function new() {
	}
	
	function error( msg : String, pos : Position ) : Dynamic {
		return Ast.Error.t(msg,pos);
	}

	public function check( shader : Expr ) : Shader {
		vars = new Map();
		functions = new Map();

		var funs = [];
		checkExpr(shader, funs);
		var tfuns = [];
		for( f in funs ) {
			var pos = f.p, f = f.f;
			var args : Array<TVar> = [for( a in f.args ) {
				if( a.type == null ) error("Argument type required", pos);
				if( a.expr != null ) error("Optional argument not supported", pos);
				if( a.kind == null ) a.kind = Local;
				if( a.kind != Local ) error("Argument should be local", pos);
				if( a.realName != null ) error("No real name allowed for argument", pos);
				if( a.qualifiers.length != 0 ) error("No qualifier allowed for argument", pos);
				{ name : a.name, kind : Local, type : a.type };
			}];
			var f : TFun = {
				name : f.name,
				args : args,
				ret : f.ret == null ? TVoid : f.ret,
				expr : null,
			};
			functions.set(f.name,f);
			tfuns.push(f);
		}
		for( i in 0...tfuns.length )
			typeFun(tfuns[i],funs[i].f.expr);
		return {
			vars : Lambda.array(vars),
			funs : tfuns,
		};
	}
	
	function typeFun( f : TFun, e : Expr ) {
		throw "TODO";
	}
	
	function typeExpr( e : Expr ) : TExpr {
		switch( e.expr ) {
		default:
			throw "TODO " + e.expr;
		}
		return null;
	}
	
	function checkExpr( e : Expr, funs : Array<{ f : FunDecl, p : Position }> ) {
		switch( e.expr ) {
		case EBlock(el):
			for( e in el )
				checkExpr(e,funs);
		case EFunction(f):
			funs.push({ f : f, p : e.pos });
		case EVars(vl):
			for( v in vl ) {
				if( v.kind == null ) v.kind = Var;
				if( v.expr != null ) error("Cannot initialize variable declaration", v.expr.pos);
				if( v.type == null ) error("Type required for variable declaration", e.pos);
				if( vars.exists(v.name) ) error("Duplicate var decl '" + v.name + "'", e.pos);
				vars.set(v.name, v);
			}
		default:
			error("This expression is not allowed at shader declaration level", e.pos);
		}
	}
	
}