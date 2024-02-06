package hxsl;
using hxsl.Ast;

private class VarProps {
	public var origin : TVar;
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

	public function split( s : ShaderData ) : Array<ShaderData> {
		var vfun = null, vvars = new Map();
		var ffun = null, fvars = new Map();
		var isCompute = false;
		varNames = new Map();
		varMap = new Map();
		for( f in s.funs )
			switch( f.kind ) {
			case Vertex, Main:
				vars = vvars;
				vfun = f;
				checkExpr(f.expr);
				if( f.kind == Main ) isCompute = true;
			case Fragment:
				vars = fvars;
				ffun = f;
				checkExpr(f.expr);
			default:
				throw "assert";
			}

		var vafterMap = [];
		for( inf in Lambda.array(vvars) ) {
			var v = inf.v;
			if( inf.local ) continue;
			switch( v.kind ) {
			case Var, Local:
				var fv = fvars.get(inf.origin.id);
				v.kind = fv != null && fv.read > 0 ? Var : Local;
			default:
			}
			switch( v.kind ) {
			case Var, Output:
				// alloc a new var if read or multiple writes
				if( inf.read > 0 || inf.write > 1 ) {
					var nv : TVar = {
						id : Tools.allocVarId(),
						name : v.name,
						kind : Local,
						type : v.type,
					};
					uniqueName(nv);
					varMap.set(inf.origin, nv);

					var ninf = new VarProps(nv);
					ninf.read++;
					vvars.set(nv.id, ninf);

					var p = vfun.expr.p;
					var e = { e : TBinop(OpAssign, { e : TVar(v), t : nv.type, p : p }, { e : TVar(nv), t : v.type, p : p } ), t : nv.type, p : p };
					vafterMap.push(() -> addExpr(vfun, e));

					if( v.kind == Var )
						vafterMap.push(() -> varMap.set(inf.origin, v)); // restore
				}
			default:
			}
		}

		// perform a first mapVars before we map fragment shader vars
		vfun = {
			ret : vfun.ret,
			ref : vfun.ref,
			kind : vfun.kind,
			args : vfun.args,
			expr : mapVars(vfun.expr),
		};

		for( f in vafterMap )
			f();

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
				var i = vvars.get(inf.origin.id);
				if( i == null ) {
					i = new VarProps(v);
					vvars.set(inf.origin.id, i);
				}
				i.read++;
				varMap.set(inf.origin, nv);

				var ninf = new VarProps(nv);
				ninf.origin = inf.origin;

				// make sure it's listed in variables
				fvars.set(inf.origin.id, ninf);
				vvars.set(nv.id, ninf);

				addExpr(vfun, { e : TBinop(OpAssign, { e : TVar(nv), t : v.type, p : vfun.expr.p }, { e : TVar(v), t : v.type, p : vfun.expr.p } ), t : v.type, p : vfun.expr.p } );
			case Var if( inf.write > 0 ):
				// prevent error when writing to a varying
				var nv : TVar = {
					id : Tools.allocVarId(),
					name : v.name,
					kind : Local,
					type : v.type,
				};
				uniqueName(nv);
				finits.push( { e : TVarDecl(nv, { e : TVar(v), t : v.type, p : ffun.expr.p } ), t:TVoid, p:ffun.expr.p } );
				varMap.set(inf.origin, nv);
			default:
			}
		}

		// final check
		for( v in vvars )
			checkVar(v, true, vvars, vfun.expr.p);
		for( v in fvars )
			checkVar(v, false, vvars, ffun.expr.p);

		if( ffun != null ) {
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
		}

		var vvars = [for( v in vvars ) if( !v.local ) v];
		var fvars = [for( v in fvars ) if( !v.local ) v];
		// make sure we sort the inputs the same way they were sent in
		inline function getId(v:VarProps) return v.origin == null ? v.v.id : v.origin.id;
		vvars.sort(function(v1, v2) return getId(v1) - getId(v2));
		fvars.sort(function(v1, v2) return getId(v1) - getId(v2));

		return isCompute ? [
			{
				name : "main",
				vars : [for( v in vvars ) v.v],
				funs : [vfun],
			}
		] : [
			{
				name : "vertex",
				vars : [for( v in vvars ) v.v],
				funs : [vfun],
			},
			{
				name : "fragment",
				vars : [for( v in fvars ) v.v],
				funs : [ffun],
			}
		];
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
				var i = vvars.get(v.origin.id);
				if( i != null && i.v.kind == Input ) return;
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
			v2 == null ? e.map(mapVars) : { e : TVarDecl(v2,init == null ? null : mapVars(init)), t : e.t, p : e.p };
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
			var nv = varMap.get(v);
			if( nv == null ) {
				if( v.kind == Global || v.kind == Output || v.kind == Input )
					nv = v;
				else {
					nv = {
						id : Tools.allocVarId(),
						name : v.name,
						kind : v.kind,
						type : v.type,
					};
					if( v.qualifiers != null && v.qualifiers.indexOf(Final) >= 0 )
						nv.qualifiers = [Final];
					uniqueName(nv);
				}
				varMap.set(v,nv);
			}
			i = new VarProps(nv);
			i.origin = v;
			vars.set(v.id, i);
		}
		return i;
	}

	function uniqueName( v : TVar ) {
		if( v.kind == Global || v.kind == Output || v.kind == Input )
			return;
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