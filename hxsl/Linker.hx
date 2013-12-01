package hxsl;
using hxsl.Ast;

private enum VarKind {
	Var;
	Function;
	Vertex;
	Fragment;
	Init;
}

private class AllocatedVar {
	public var id : Int;
	public var v : TVar;
	public var path : String;
	public var merged : Array<TVar>;
	public var kind : VarKind;
	public var parent : AllocatedVar;
	public function new() {
		kind = Var;
	}
}

private class ShaderInfos {
	public var name : String;
	public var priority : Int;
	public var body : TExpr;
	public var usedFunctions : Array<TFunction>;
	public var deps : Map<ShaderInfos, Bool>;
	public var read : Map<Int,AllocatedVar>;
	public var write : Map<Int,AllocatedVar>;
	public var processed : Map<Int, Bool>;
	public var vertex : Bool;
	public var onStack : Bool;
	public var marked : Null<Bool>;
	public function new(n, v) {
		this.name = n;
		this.vertex = v;
		processed = new Map();
		usedFunctions = [];
		read = new Map();
		write = new Map();
	}
}

class Linker {

	var varMap : Map<String,AllocatedVar>;
	var allVars : Array<AllocatedVar>;
	var allFuns : Map<Int,TFunction>;
	var curShader : ShaderInfos;
	var shaders : Array<ShaderInfos>;
	var varIdMap : Map<Int,Int>;
	
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
	
	function allocVar( v : TVar, p : Position, ?path : String, ?parent : TVar ) : AllocatedVar {
		if( v.kind == Local )
			throw "assert";
		if( v.parent != null && parent == null ) {
			parent = allocVar(v.parent, p).v;
			var p = parent;
			path = p.name;
			p = p.parent;
			while( p != null ) {
				path = p.name + "." + path;
				p = p.parent;
			}
		}
		var key = (path == null ? v.name : path + "." + v.name);
		if( v.qualifiers != null )
			for( q in v.qualifiers )
				switch( q ) {
				case Name(n): key = n;
				default:
				}
		var v2 = varMap.get(key);
		var vname = v.name;
		if( v2 != null ) {
			for( vm in v2.merged )
				if( vm == v )
					return v2;
			if( v.kind == Param || v.kind == Function || (v.kind == Var && v.hasQualifier(Private)) ) {
				// allocate a new unique name in the shader if already in use
				var k = 2;
				while( true ) {
					var a = varMap.get(key + k);
					if( a == null ) break;
					for( vm in a.merged )
						if( vm == v )
							return a;
					k++;
				}
				vname += k;
				key += k;
			} else {
				mergeVar(key, v, v2.v, p);
				v2.merged.push(v);
				varIdMap.set(v.id, v2.id);
				return v2;
			}
		}
		var vid = allVars.length;
		var v2 : TVar = {
			id : vid,
			name : vname,
			type : v.type,
			kind : v.kind,
			qualifiers : v.qualifiers,
			parent : parent,
		};
		var a = new AllocatedVar();
		a.v = v2;
		a.merged = [v];
		a.path = key;
		a.id = vid;
		a.parent = parent == null ? null : allocVar(parent, p);
		allVars.push(a);
		varMap.set(key, a);
		switch( v2.type ) {
		case TStruct(vl):
			v2.type = TStruct([for( v in vl ) allocVar(v, p, key, v2).v]);
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
			var v = allocVar(v, e.p);
			if( curShader != null ) {
				//trace(curShader.name + " read " + v.path);
				curShader.read.set(v.id, v);
			}
			return { e : TVar(v.v), t : v.v.type, p : e.p };
		case TBinop(op, e1, e2):
			switch( [op,e1.e] ) {
			case [OpAssign | OpAssignOp(_), (TVar(v) | TSwiz({ e : TVar(v) },_))] if( v.kind != Local ):
				var v = allocVar(v, e1.p);
				if( curShader != null ) {
					//trace(curShader.name + " write " + v.path);
					curShader.write.set(v.id, v);
				}
				// TSwiz might only assign part of the components, let's then consider that we read the other
				if( op == OpAssign && (switch( e1.e ) { case TVar(_): true; default: false; }) ) {
					var eout = { e : TVar(v.v), t : e1.t, p : e1.p };
					return { e : TBinop(OpAssign, eout, mapExprVar(e2)), t : e.t, p : e.p };
				}
			default:
			}
		default:
		}
		return e.map(mapExprVar);
	}
	
	function addShader( name : String, vertex : Bool, e : TExpr, p : Int ) {
		curShader = new ShaderInfos(name, vertex);
		curShader.priority = p;
		curShader.body = mapExprVar(e);
		shaders.push(curShader);
		curShader = null;
	}
	
	function sortByPriorityDesc( s1 : ShaderInfos, s2 : ShaderInfos ) {
		return s2.priority - s1.priority;
	}
	
	function buildDependency( parent : ShaderInfos, v : AllocatedVar, isWritten : Bool ) {
		var found = !isWritten;
		for( s in shaders ) {
			if( parent == s ) {
				found = true;
				continue;
			} else if( !found )
				continue;
			if( !s.write.exists(v.id) )
				continue;
//			trace(parent.name + " => " + s.name + " (" + v.path + ")");
			parent.deps.set(s, true);
			if( s.deps == null ) {
				s.deps = new Map();
				for( r in s.read )
					buildDependency(s, r, s.write.exists(r.id));
			}
			if( !s.read.exists(v.id) )
				return;
		}
		if( v.v.kind == Var )
			error("Variable " + v.path + " required by " + parent.name + " is missing initializer", null);
	}
	
	function collect( cur : ShaderInfos, out : Array<ShaderInfos>, vertex : Bool ) {
		if( cur.onStack )
			error("Loop in shader dependencies ("+cur.name+")", null);
		if( cur.marked == vertex )
			return;
		cur.marked = vertex;
		cur.onStack = true;
		for( d in cur.deps.keys() )
			collect(d, out, vertex);
		if( cur.vertex == vertex )
			out.push(cur);
		cur.onStack = false;
	}
	
	public function link( shadersData : Array<ShaderData>, outVars : Array<String> ) : ShaderData {
		varMap = new Map();
		varIdMap = new Map();
		allVars = new Array();
		allFuns = new Map();
		shaders = [];
		
		// globalize vars
		for( s in shadersData ) {
			for( v in s.vars ) {
				// check name before rename
				var kind = switch( v.name ) {
				case "vertex": Vertex;
				case "fragment": Fragment;
				case "__init__": Init;
				default: null;
				}
				var v = allocVar(v, null);
				if( kind != null ) v.kind = kind;
			}
			for( f in s.funs ) {
				var v = allocVar(f.ref, f.expr.p);
				if( v.kind == Var ) v.kind = Function;
			}
		}
		
		// create shader segments
		var priority = 0;
		for( s in shadersData ) {
			for( f in s.funs ) {
				var v = allocVar(f.ref, f.expr.p);
				switch( v.kind ) {
				case Vertex, Fragment:
					addShader(s.name+"."+(v.kind == Vertex ? "vertex" : "fragment"),v.kind == Vertex,f.expr, priority);
				case Init:
					switch( f.expr.e ) {
					case TBlock(el):
						var index = 0;
						for( e in el )
							addShader(s.name+".__init__"+(index++),true,e, -1);
					default:
						addShader(s.name+".__init__",true,f.expr, -1);
					}
				case Function:
					allFuns.set(v.id, {
						ref : v.v,
						args : f.args,
						ret : f.ret,
						expr : mapExprVar(f.expr),
					});
				case Var:
					throw "assert "+v.v.name;
				}
			}
			priority++;
		}
		shaders.sort(sortByPriorityDesc);
		
		// build dependency tree
		var s = new ShaderInfos("", true);
		s.deps = new Map();
		for( outVar in outVars ) {
			var v = varMap.get(outVar);
			if( v == null )
				throw "Variable not found " + outVar;
			buildDependency(s, v, false);
		}
		
		// collect needed dependencies
		var v = [], f = [];
		collect(s, v, true);
		collect(s, f, false);
		if( v.pop().name != "" ) throw "assert";
		
		// check that all dependencies are matched
		for( s in shaders )
			s.marked = null;
		for( s in v.concat(f) ) {
			for( d in s.deps.keys() )
				if( d.marked == null )
					error(d.name + " needed by " + s.name + " is unreachable", null);
			s.marked = true;
		}
		
		// build resulting vars
		var outVars = [];
		var varMap = new Map();
		function addVar(v:AllocatedVar) {
			if( varMap.exists(v.id) )
				return;
			varMap.set(v.id, true);
			if( v.v.parent != null )
				addVar(v.parent);
			else
				outVars.push(v.v);
		}
		for( s in v.concat(f) ) {
			for( v in s.read )
				addVar(v);
			for( v in s.write )
				addVar(v);
		}
		// cleanup unused structure vars
		function cleanVar( v : TVar ) {
			switch( v.type ) {
			case TStruct(vl) if( v.kind != Input ):
				var vout = [];
				for( v in vl )
					if( varMap.exists(v.id) ) {
						cleanVar(v);
						vout.push(v);
					}
				v.type = TStruct(vout);
			default:
			}
		}
		for( v in outVars )
			cleanVar(v);
		// build resulting shader functions
		function build(name, a:Array<ShaderInfos> ) : TFunction {
			var v : TVar = {
				id : Tools.allocVarId(),
				name : name,
				type : TFun([ { ret : TVoid, args : [] } ]),
				kind : Function,
			};
			outVars.push(v);
			var exprs = [];
			for( s in a )
				switch( s.body.e ) {
				case TBlock(el):
					for( e in el ) exprs.push(e);
				default:
					exprs.push(s.body);
				}
			return {
				ref : v,
				ret : TVoid,
				args : [],
				expr : { e : TBlock(exprs), t : TVoid, p : exprs[0].p },
			};
		}
		var funs = [
			build("vertex", v),
			build("fragment", f),
		];
		return { name : "out", vars : outVars, funs : funs };
	}
	
}