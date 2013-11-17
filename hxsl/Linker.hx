package hxsl;
using hxsl.Ast;

private class AllocatedVar {
	public var id : Int;
	public var v : TVar;
	public var path : String;
	public var merged : Array<TVar>;
	public function new() {
	}
}

private class ShaderInfos {
	public var priority : Int;
	public var body : TExpr;
	public var deps : Array<TFunction>;
	public var read : Map<Int,AllocatedVar>;
	public var write : Map<Int,AllocatedVar>;
	public function new() {
		deps = [];
		read = new Map();
		write = new Map();
	}
}

class Linker {

	var varMap : Map<String,AllocatedVar>;
	var allVars : Array<AllocatedVar>;
	var curShader : ShaderInfos;
	var shaders : Array<ShaderInfos>;
	
	public function new() {
	}
	
	function error( msg : String, p : Position ) : Dynamic {
		return Error.t(msg, p);
	}
	
	function mergeVar( path : String, v : TVar, v2 : TVar, p : Position ) {
		switch( v.kind ) {
		case Global, Input, Var:
			// shared vars
		case Local, Param, Function:
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
	
	function allocVar( v : TVar, ?path : String, ?parent : TVar, p : Position ) : AllocatedVar {
		if( v.kind == Local )
			throw "assert";
		if( v.parent != null && parent == null ) {
			parent = allocVar(v.parent, null, null, p).v;
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
			for( vm in v2.merged )
				if( vm == v )
					return v2;
			if( v.kind == Param || v.kind == Function || (v.kind == Var && v.hasQualifier(Private)) ) {
				// allocate a new unique name in the shader if already in use
				var k = 2;
				while( varMap.exists(key + k) )
					k++;
				v.name += k;
				key += k;
			} else {
				mergeVar(key, v, v2.v, p);
				v2.merged.push(v);
				return v2;
			}
		}
		var v2 : TVar = {
			name : v.name,
			type : v.type,
			kind : v.kind,
			qualifiers : v.qualifiers,
			parent : parent,
		};
		var a = new AllocatedVar();
		a.v = v2;
		a.merged = [v];
		a.path = key;
		a.id = allVars.length;
		allVars.push(a);
		varMap.set(key, a);
		switch( v2.type ) {
		case TStruct(vl):
			v2.type = TStruct([for( v in vl ) allocVar(v, key, v2, p).v]);
		default:
		}
		return a;
	}
	
	/*
	function allocFun( f : TFunction ) : TFunction {
		var f2 = funMap.get(f.ref.name);
		if( f2 != null ) {
			if( f2.fold == f )
				return f2.fnew;
			// generate unique name
			var k = 2;
			while( funMap.exists(f.ref.name + k) )
				k++;
			f.ref.name = f.ref.name + k;
		}
		var f2 : TFunction = {
			ref : allocVar(f.ref, null, null, f.expr.p).v,
			args : f.args, // no-op
			ret : f.ret,
			expr : mapExprVar(f.expr),
		};
		funMap.set(f2.ref.name, { fold : f, fnew : f2 });
		return f2;
	}
	*/
	
	function mapExprVar( e : TExpr ) {
		switch( e.e ) {
		case TVar(v) if( v.kind != Local ):
			var v = allocVar(v, null, null, e.p);
			return { e : TVar(v.v), t : v.v.type, p : e.p };
		default:
			return e.map(mapExprVar);
		}
	}
	
	public function link( shaders : Array<ShaderData>, startFun : String, outVar : String ) : ShaderData {
		varMap = new Map();
		allVars = new Array();
		// globalize vars
		for( s in shaders ) {
			for( v in s.vars )
				allocVar(v, null, null, null);
		}
		var vars = [];
		for( v in allVars )
			if( v.v.parent == null )
				vars.push(v.v);
		return { vars : vars, funs : [] };
	}
	
}