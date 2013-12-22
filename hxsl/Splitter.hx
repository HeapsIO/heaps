package hxsl;
using hxsl.Ast;

private typedef VarProps = {
	var v : TVar;
	var read : Int;
	var write : Int;
	var local : Bool;
}

class Splitter {

	var vars : Map<Int,VarProps>;
	var varNames : Map<String,TVar>;
	var varMap : Map<TVar,TVar>;
	
	public function new() {
	}
	
	public function split( s : ShaderData ) : { vertex : ShaderData, fragment : ShaderData } {
		var vfun = null, vvars = new Map();
		var ffun = null, fvars = new Map();
		varNames = new Map();
		for( f in s.funs )
			switch( f.kind ) {
			case Vertex:
				vars = vvars;
				vfun = f;
				checkExpr(f.expr);
			case Fragment:
				vars = fvars;
				ffun = f;
				checkExpr(f.expr);
			default:
				throw "assert";
			}
		varMap = new Map();
		for( inf in vvars ) {
			var v = inf.v;
			switch( v.kind ) {
			case Var, Local:
				v.kind = fvars.exists(v.id) ? Var : Local;
			default:
			}
			switch( v.kind ) {
			case Var, Output:
				// alloc a new var if read or multiple writes
				if( inf.read > 0 || inf.write > 1 ) {
					var nv = {
						id : Tools.allocVarId(),
						name : v.name,
						kind : v.kind,
						type : v.type,
					};
					vars = vvars;
					var ninf = get(nv);
					v.kind = Local;
					var p = vfun.expr.p;
					addExpr(vfun, { e : TBinop(OpAssign, { e : TVar(nv), t : nv.type, p : p }, { e : TVar(v), t : v.type, p : p } ), t : nv.type, p : p });
					if( nv.kind == Var ) {
						var old = fvars.get(v.id);
						varMap.set(v, nv);
						fvars.remove(v.id);
						fvars.set(nv.id, { v : nv, read : old.read, write : old.write, local : false });
					}
				}
			default:
			}
		}
		var finits = [];
		for( inf in fvars ) {
			var v = inf.v;
			switch( v.kind ) {
			case Input:
				// create a var that will pass the input from vertex to fragment
				throw "TODO";
			case Var if( inf.write > 0 ):
				var nv = {
					id : Tools.allocVarId(),
					name : v.name,
					kind : Local,
					type : v.type,
				};
				uniqueName(nv);
				finits.push( { e : TVarDecl(nv, { e : TVar(v), t : v.type, p : ffun.expr.p } ), t:TVoid, p:ffun.expr.p } );
				varMap.set(v, nv);
			default:
			}
		}
		// support for double mapping v -> v1 -> v2
		for( v in varMap.keys() ) {
			var v2 = varMap.get(varMap.get(v));
			if( v2 != null )
				varMap.set(v, v2);
		}
		ffun = {
			ret : ffun.ret,
			ref : ffun.ref,
			kind : ffun.kind,
			args : ffun.args,
			expr : mapVars(ffun.expr),
		};
		switch( ffun.expr.e ) {
		case TBlock(el):
			for( e in finits )
				el.unshift(e);
		default:
			finits.push(ffun.expr);
			ffun.expr = { e : TBlock(finits), t : TVoid, p : ffun.expr.p };
		}
		return {
			vertex : {
				name : "vertex",
				vars : [for( v in vvars ) if( !v.local ) v.v],
				funs : [vfun],
			},
			fragment : {
				name : "fragment",
				vars : [for( v in fvars ) if( !v.local ) v.v],
				funs : [ffun],
			},
		};
	}
	
	function addExpr( f : TFunction, e : TExpr ) {
		switch( f.expr.e ) {
		case TBlock(el):
			el.push(e);
		default:
			f.expr = { e : TBlock([f.expr, e]), t : TVoid, p : f.expr.p };
		}
	}
	
	function mapVars( e : TExpr ) {
		return switch( e.e ) {
		case TVar(v):
			var v2 = varMap.get(v);
			v2 == null ? e : { e : TVar(v2), t : e.t, p : e.p };
		default:
			e.map(mapVars);
		}
	}
	
	function get( v : TVar ) {
		var i = vars.get(v.id);
		if( i == null ) {
			i = { v : v, read : 0, write : 0, local : false };
			vars.set(v.id, i);
			uniqueName(v);
		}
		return i;
	}
	
	function uniqueName( v : TVar ) {
		v.parent = null;
		var n = varNames.get(v.name);
		if( n != null && n != v ) {
			var k = 2;
			while( varNames.exists(v.name + k) ) {
				k++;
			}
			v.name += k;
		}
		varNames.set(v.name, v);
	}
	
	function checkExpr( e : TExpr ) {
		switch( e.e ) {
		case TVar(v):
			var inf = get(v);
			inf.read++;
		case TBinop(OpAssign, { e : (TVar(v) | TSwiz( { e : TVar(v) }, _)) }, e):
			var inf = get(v);
			inf.write++;
			checkExpr(e);
		case TBinop(OpAssignOp(_), { e : (TVar(v) | TSwiz( { e : TVar(v) }, _)) }, e):
			var inf = get(v);
			inf.read++;
			inf.write++;
			checkExpr(e);
		case TVarDecl(v, init):
			var inf = get(v);
			inf.local = true;
			if( init != null ) checkExpr(init);
		default:
			e.iter(checkExpr);
		}
	}
	
}