package hxsl;
using hxsl.Ast;

class Linker {

	var varMap : Map<String,{ vmerged : Array<TVar>, vnew : TVar }>;
	var funMap : Map<String,{ fold : TFunction, fnew : TFunction }>;
	
	public function new() {
	}
	
	function error( msg : String, p : Position ) : Dynamic {
		return Error.t(msg, p);
	}
	
	function mergeVar( path : String, v : TVar, v2 : TVar, p : Position ) {
		switch( v.kind ) {
		case Global, Input, Var:
			// shared vars
		case Local, Param:
			throw "assert";
		}
		if( v.kind != v2.kind )
			error("'" + path + "' kind does not match : " + v.kind + " should be " + v2.kind,p);
		switch( [v.type, v2.type] ) {
		case [TStruct(fl1), TStruct(fl2)]:
			for( f1 in fl1 ) {
				var ft = null;
				for( f2 in fl2 )
					if( f1.name == f2.name ) {
						ft = f2;
						break;
					}
				// add a new field
				if( ft == null )
					fl2.push(f1);
				else
					mergeVar(path + "." + ft.name, f1, ft, p);
			}
		default:
			if( !v.type.equals(v2.type) )
				error("'" + path + "' type does not match : " + v.type.toString() + " should be " + v2.type.toString(),p);
		}
	}
	
	function allocVar( v : TVar, ?path : String, ?parent : TVar, p : Position ) {
		if( v.kind == Local )
			return v;
		if( v.parent != null && parent == null ) {
			parent = allocVar(v.parent, null, null, p);
			var p = parent;
			path = p.name;
			p = p.parent;
			while( p != null ) {
				path = p.name + "." + path;
				p = p.parent;
			}
		}
		var key = (path == null ? v.name : path + "." + v.name);
		var v2 = varMap.get(key);
		if( v2 != null ) {
			for( vm in v2.vmerged )
				if( vm == v )
					return v2.vnew;
			if( v.kind == Param ) {
				// allocate a new unique name in the shader
				var k = 2;
				while( varMap.exists(key + k) )
					k++;
				v.name += k;
				key += k;
			} else {
				mergeVar(key, v, v2.vnew, p);
				v2.vmerged.push(v);
				return v2.vnew;
			}
		}
		var v2 = {
			name : v.name,
			type : v.type,
			kind : v.kind,
			qualifiers : v.qualifiers,
			parent : parent,
		};
		varMap.set(key, { vmerged : [v], vnew : v2 });
		switch( v2.type ) {
		case TStruct(vl):
			v2.type = TStruct([for( v in vl ) allocVar(v, key, v2, p)]);
		default:
		}
		return v2;
	}
	
	function allocFun( f : TFunction ) : TFunction {
		var f2 = funMap.get(f.name);
		if( f2 != null ) {
			if( f2.fold == f )
				return f2.fnew;
			// generate unique name
			var k = 2;
			while( funMap.exists(f.name + k) )
				k++;
			f.name = f.name + k;
		}
		var f2 = {
			args : [for( a in f.args) allocVar(a, null, null, f.expr.p)],
			name : f.name,
			ret : f.ret,
			expr : mapExprVar(f.expr),
		};
		funMap.set(f2.name, { fold : f, fnew : f2 });
		return f2;
	}
	
	function mapExprVar( e : TExpr ) {
		switch( e.e ) {
		case TVar(v):
			v = allocVar(v, null, null, e.p);
			return { e : TVar(v), t : v.type, p : e.p };
		case TFunVar(f):
			f = allocFun(f);
			return { e : TFunVar(f), t : e.t, p : e.p };
		default:
			return e.map(mapExprVar);
		}
	}
	
	public function link( shaders : Array<ShaderData>, startFun : String, outVar : String ) {
		varMap = new Map();
		funMap = new Map();
		// globalize vars
		var shaders = [for( s in shaders ) { vars : [for( v in s.vars ) allocVar(v, null, null, null)], funs : [for( f in s.funs ) allocFun(f)] } ];
		return shaders[1];
	}
	
}