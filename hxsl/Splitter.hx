package hxsl;
using hxsl.Ast;

private class VarProps {
	public var v : TVar;
	public var read : Int;
	public var write : Int;
	public var local : Bool;
	public var requireInit : Bool;
	public function new(v) {
		this.v = v;
		read = 0;
		write = 0;
	}
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
		varMap = new Map();
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

		// perform a first mapVars before we map fragment shader vars		
		vfun = {
			ret : vfun.ret,
			ref : vfun.ref,
			kind : vfun.kind,
			args : vfun.args,
			expr : mapVars(vfun.expr),
		};

		for( inf in Lambda.array(vvars) ) {
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
					var nv : TVar = {
						id : Tools.allocVarId(),
						name : v.name,
						kind : v.kind,
						type : v.type,
					};
					vars = vvars;
					var ninf = get(nv);
					v.kind = Local;
					var p = vfun.expr.p;
					var e = { e : TBinop(OpAssign, { e : TVar(nv), t : nv.type, p : p }, { e : TVar(v), t : v.type, p : p } ), t : nv.type, p : p };
					addExpr(vfun, e);
					checkExpr(e);
					if( nv.kind == Var ) {
						var old = fvars.get(v.id);
						varMap.set(v, nv);
						fvars.remove(v.id);
						var np = new VarProps(nv);
						np.read = old.read;
						np.write = old.write;
						fvars.set(nv.id, np);
					}
				}
			default:
			}
		}
		var finits = [];
		var todo = [];
		for( inf in fvars ) {
			var v = inf.v;
			switch( v.kind ) {
			case Input:
				// create a var that will pass the input from vertex to fragment
				var nv : TVar = {
					id : Tools.allocVarId(),
					name : v.name,
					kind : Var,
					type : v.type,
				};
				uniqueName(nv);
				var i = vvars.get(v.id);
				if( i == null ) {
					i = new VarProps(v);
					vvars.set(v.id, i);
				}
				i.read++;
				var vp = new VarProps(nv);
				vp.write = 1;
				vvars.set(nv.id, vp);
				var fp = new VarProps(nv);
				fp.read = 1;
				todo.push(fp);
				addExpr(vfun, { e : TBinop(OpAssign, { e : TVar(nv), t : v.type, p : vfun.expr.p }, { e : TVar(v), t : v.type, p : vfun.expr.p } ), t : v.type, p : vfun.expr.p } );
				varMap.set(v, nv);
				inf.local = true;
			case Var if( inf.write > 0 ):
				var nv : TVar = {
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
		for( v in todo )
			fvars.set(v.v.id, v);

		// final check
		for( v in vvars )
			checkVar(v, true, vvars, vfun.expr.p);
		for( v in fvars )
			checkVar(v, false, vvars, ffun.expr.p);

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

		var vvars = [for( v in vvars ) if( !v.local ) v.v];
		var fvars = [for( v in fvars ) if( !v.local ) v.v];
		// make sure we sort the inputs the same way they were sent in
		vvars.sort(function(v1, v2) return v1.id - v2.id);
		fvars.sort(function(v1, v2) return v1.id - v2.id);

		return {
			vertex : {
				name : "vertex",
				vars : vvars,
				funs : [vfun],
			},
			fragment : {
				name : "fragment",
				vars : fvars,
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

	function checkVar( v : VarProps, vertex : Bool, vvars : Map<Int,VarProps>, p ) {
		switch( v.v.kind ) {
		case Local if( v.requireInit ):
			throw new Error("Variable " + v.v.name + " is used without being initialized", p);
		case Var:
			if( !vertex ) {
				var i = vvars.get(v.v.id);
				if( i == null || i.write == 0 ) throw new Error("Varying " + v.v.name + " is not written by vertex shader",p);
			}
		default:
		}
	}

	function mapVars( e : TExpr ) {
		return switch( e.e ) {
		case TVar(v):
			var v2 = varMap.get(v);
			v2 == null ? e : { e : TVar(v2), t : e.t, p : e.p };
		case TVarDecl(v, init):
			var v2 = varMap.get(v);
			v2 == null ? e.map(mapVars) : { e : TVarDecl(v2,mapVars(init)), t : e.t, p : e.p };
		case TFor(v, it, loop):
			var v2 = varMap.get(v);
			v2 == null ? e.map(mapVars) : { e : TFor(v2,mapVars(it),mapVars(loop)), t : e.t, p : e.p };
		default:
			e.map(mapVars);
		}
	}

	function get( v : TVar ) {
		var i = vars.get(v.id);
		if( i == null ) {
			var v2 = varMap.get(v);
			if( v2 != null )
				return get(v2);
			var oldName = v.name;
			uniqueName(v);
			if( v.kind == Local && oldName != v.name ) {
				// variable renamed : restore its name and create a new one
				var nv : TVar = {
					id : Tools.allocVarId(),
					name : v.name,
					kind : v.kind,
					type : v.type,
				};
				varMap.set(v,nv);
				v.name = oldName;
				v = nv;
			}
			i = new VarProps(v);
			vars.set(v.id, i);
		}
		return i;
	}

	function uniqueName( v : TVar ) {
		if( v.kind == Global || v.kind == Output || v.kind == Input )
			return;
		v.parent = null;
		var n = varNames.get(v.name);
		if( n != null && n != v ) {
			var prefix = v.name;
			while( prefix.charCodeAt(prefix.length - 1) >= '0'.code && prefix.charCodeAt(prefix.length - 1) <= '9'.code )
				prefix = prefix.substr(0, -1);
			var k = prefix == v.name ? 2 : Std.parseInt(v.name.substr(prefix.length));
			while( varNames.exists(prefix + k) )
				k++;
			v.name = prefix + k;
		}
		varNames.set(v.name, v);
	}

	function checkExpr( e : TExpr ) {
		switch( e.e ) {
		case TVar(v):
			var inf = get(v);
			if( inf.write == 0 ) inf.requireInit = true;
			inf.read++;
		case TBinop(OpAssign, { e : (TVar(v) | TSwiz( { e : TVar(v) }, _)) }, e):
			var inf = get(v);
			inf.write++;
			checkExpr(e);
		case TBinop(OpAssignOp(_), { e : (TVar(v) | TSwiz( { e : TVar(v) }, _)) }, e):
			var inf = get(v);
			if( inf.write == 0 ) inf.requireInit = true;
			inf.read++;
			inf.write++;
			checkExpr(e);
		case TVarDecl(v, init):
			var inf = get(v);
			inf.local = true;
			if( init != null ) {
				checkExpr(init);
				inf.write++;
			}
		case TFor(v, it, loop):
			checkExpr(it);
			var inf = get(v);
			inf.local = true;
			inf.write++;
			checkExpr(loop);
		default:
			e.iter(checkExpr);
		}
	}

}