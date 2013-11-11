package hxsl;
import hxsl.Ast;

/**
	Retreive which variables are read/written by a given entry function and all its dependencies.
**/
class GetVars {
	
	var functions : Map<String,Bool>;
	var vars : Map<TVar, { v : TVar, read : Bool, written : Bool } >;
	var nullVar : { v : TVar, read : Bool, written : Bool };
	
	public function new() {
		nullVar = { v : null, read : true, written : true };
	}
	
	public function getVars( s : ShaderData, entryFunc : String ) {
		vars = new Map();
		functions = new Map();
		for( f in s.funs )
			if( f.name == entryFunc ) {
				getFun(f);
				return Lambda.array(vars);
			}
		return [];
	}
	
	function getVar( v : TVar ) {
		switch( v.kind ) {
		case Local:
			return nullVar;
		case Var, Input, Param, Global:
			var vinf = vars.get(v);
			if( vinf == null ) {
				vinf = { v : v, read : false, written : false };
				vars.set(v, vinf);
			}
			return vinf;
		}
	}
	
	function getFun( f : TFunction ) {
		if( functions.exists(f.name) )
			return;
		functions.set(f.name, true);
		getExpr(f.expr);
	}
	
	function getExpr( e : TExpr ) {
		switch( e.e ) {
		case TBinop(OpAssign, { e : TVar(v) }, e2):
			getExpr(e2);
			getVar(v).written = true;
		case TBinop(OpAssignOp(_), { e : TVar(v) }, e2):
			getExpr(e2);
			var v = getVar(v);
			v.read = true;
			v.written = true;
		case TVar(v):
			getVar(v).read = true;
		case TFunVar(f):
			getFun(f);
		default:
			Tools.iter(e, getExpr);
		}
	}
	
	
}