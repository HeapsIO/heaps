package hxsl;
using hxsl.Ast;
import hxsl.Debug.traceDepth in debug;

private class AllocatedVar {
	public var id : Int;
	public var v : TVar;
	public var path : String;
	public var mergedV : TVar;
	public var merged(get, default) : Array<TVar>;
	public var kind : Null<FunctionKind>;
	public var parent : AllocatedVar;
	public var rootShaderName : String;
	public var instanceIndex : Int;
	public function new() {
	}
	inline function get_merged() {
		if( merged == null )
			merged = [mergedV];
		return merged;
	}
}

private enum ShaderStage {
	Undefined;
	Vertex;
	Fragment;
}

private class ShaderInfos {
	static var UID = 0;
	public var uid : Int;
	public var name : String;
	public var priority : Int;
	public var body : TExpr;
	public var usedFunctions : Array<TFunction>;
	public var deps : Map<ShaderInfos, Bool>;
	public var readMap : Map<Int,AllocatedVar>;
	public var readVars : Array<AllocatedVar>;
	public var writeMap : Map<Int,AllocatedVar>;
	public var writeVars : Array<AllocatedVar>;
	public var processed : Map<Int, Bool>;
	public var stage : ShaderStage;
	public var onStack : Bool;
	public var hasDiscard : Bool;
	public var isCompute : Bool;
	public var isBatchInit : Bool;
	public var hasSyntax : Bool;
	public var marked : haxe.EnumFlags<ShaderStage>;
	public var added : haxe.EnumFlags<ShaderStage>;

	public function new(n, s) {
		this.name = n;
		this.uid = UID++;
		this.stage = s;
		processed = new Map();
		usedFunctions = [];
		readMap = new Map();
		readVars = [];
		writeMap = new Map();
		writeVars = [];
		marked = new haxe.EnumFlags();
		added = new haxe.EnumFlags();
	}
}

class Linker {

	public var allVars : Array<AllocatedVar>;
	var varMap : Map<String,AllocatedVar>;
	var curShader : ShaderInfos;
	var shaders : Array<ShaderInfos>;
	var varIdMap : Map<Int,Int>;
	var locals : Map<Int,Bool>;
	var curInstance : Int;
	var mode : hxsl.RuntimeShader.LinkMode;
	var isBatchShader : Bool;
	var debugDepth = 0;

	var lowercaseMap : Map<String, String>;
	var mapExprVarFun : TExpr -> TExpr;

	public function new(mode) {
		this.mode = mode;
		this.lowercaseMap = new Map();
		this.mapExprVarFun = mapExprVar;
	}

	function error( msg : String, p : Position ) : Dynamic {
		return Error.t(msg, p);
	}

	function mergeVar( path : String, v : TVar, v2 : TVar, p : Position, shaderName : String ) {
		switch( v.kind ) {
		case Global, Input, Var, Local, Output:
			// shared vars
		case Param if ( shaderName != null && v2.hasBorrowQualifier(shaderName) ):
			// Other variable attempts to borrow.
		case Param, Function:
			throw "assert";
		}
		if( v.kind != v2.kind && v.kind != Local && v2.kind != Local )
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
					fl2.push(allocVar(f1,p, shaderName).v);
				else
					mergeVar(path + "." + ft.name, f1, ft, p, shaderName);
			}
		default:
			if( !v.type.equals(v2.type) )
				error("'" + path + "' type does not match : " + v.type.toString() + " should be " + v2.type.toString(),p);
		}
	}

	function allocVar( v : TVar, p : Position, ?shaderName : String, ?path : String, ?parent : AllocatedVar ) : AllocatedVar {
		if( v.parent != null && parent == null ) {
			parent = allocVar(v.parent, p, shaderName);
			var p = parent.v;
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
		var ukey = lowercaseMap.get(key);
		if( ukey == null ) {
			ukey = key.toLowerCase();
			lowercaseMap.set(key, ukey);
		}
		var v2 = varMap.get(ukey);
		var vname = v.name;
		if( v2 != null ) {
			for( vm in v2.merged )
				if( vm == v )
					return v2;
			inline function isUnique( v : TVar, borrowed : Bool ) {
				return (v.kind == Param && !borrowed && !v.hasQualifier(Shared) && !isBatchShader) || v.kind == Function || ((v.kind == Var || v.kind == Local) && v.hasQualifier(Private));
			}
			if( isUnique(v, v2.v.hasBorrowQualifier(shaderName)) || isUnique(v2.v, v.hasBorrowQualifier(v2.rootShaderName)) || (v.kind == Param && v2.v.kind == Param) /* two shared : one takes priority */ ) {
				// allocate a new unique name in the shader if already in use
				var k = 2;
				while( true ) {
					var a = varMap.get(ukey + k);
					if( a == null ) break;
					for( vm in a.merged )
						if( vm == v )
							return a;
					k++;
				}
				if( v.kind == Input ) {
					// it's not allowed to rename an input var, let's rename existing var instead
					varMap.remove(ukey);
					varMap.set(ukey + k, v2);
					v2.v.name += k;
					v2.path += k;
				} else {
					vname += k;
					key += k;
					ukey += k;
				}
			} else {
				v2.merged.push(v);
				mergeVar(key, v, v2.v, p, v2.rootShaderName);
				varIdMap.set(v.id, v2.id);
				return v2;
			}
		}
		var v2 : TVar = {
			id : Tools.allocVarId(),
			name : vname,
			type : v.type,
			kind : v.kind,
			qualifiers : v.qualifiers,
			parent : parent == null ? null : parent.v,
		};
		var a = new AllocatedVar();
		a.v = v2;
		a.mergedV = v;
		a.path = key;
		a.id = v2.id;
		a.parent = parent;
		a.instanceIndex = curInstance;
		a.rootShaderName = shaderName;
		allVars.push(a);
		varMap.set(ukey, a);
		switch( v2.type ) {
		case TStruct(vl):
			v2.type = TStruct([for( v in vl ) allocVar(v, p, shaderName, key, a).v]);
		default:
		}
		return a;
	}

	function mapExprVar( e : TExpr ) : TExpr {
		switch( e.e ) {
		case TVar(v) if( !locals.exists(v.id) ):
			var v = allocVar(v, e.p);
			if( curShader != null && !curShader.writeMap.exists(v.id) ) {
				debug(curShader.name + " read " + v.path);
				if( !curShader.readMap.exists(v.id) ) {
					curShader.readMap.set(v.id, v);
					curShader.readVars.push(v);
				}
				// if we read a varying, force into fragment
				if( curShader.stage == Undefined && v.v.kind == Var ) {
					debug("Force " + curShader.name+" into fragment (read varying)");
					curShader.stage = Fragment;
				}
			}
			return { e : TVar(v.v), t : v.v.type, p : e.p };
		case TBinop(op, e1, e2):
			switch( [op, e1.e] ) {
			case [OpAssign, TVar(v)] if( !locals.exists(v.id) ):
				var e2 = mapExprVar(e2);
				var v = allocVar(v, e1.p);
				if( curShader != null && !curShader.writeMap.exists(v.id) ) {
					debug(curShader.name + " write " + v.path);
					curShader.writeMap.set(v.id, v);
					curShader.writeVars.push(v);
					if( curShader.stage == Undefined && v.v.kind == Var ) {
						debug("Force " + curShader.name+" into vertex (write varying)");
						curShader.stage = Vertex;
					}
				}
				// don't read the var
				return { e : TBinop(op, { e : TVar(v.v), t : v.v.type, p : e.p }, e2), t : e.t, p : e.p };
			case [OpAssign | OpAssignOp(_), (TVar(v) | TSwiz( { e : TVar(v) }, _))] if( !locals.exists(v.id) ):
				// read the var
				var e1 = mapExprVar(e1);
				var e2 = mapExprVar(e2);

				var v = allocVar(v, e1.p);
				if( curShader != null && !curShader.writeMap.exists(v.id) ) {
					// TODO : mark as partial write if SWIZ
					debug(curShader.name + " write " + v.path);
					curShader.writeMap.set(v.id, v);
					curShader.writeVars.push(v);
				}
				return { e : TBinop(op, e1, e2), t : e.t, p : e.p };
			default:
			}
		case TDiscard:
			if( curShader != null ) {
				curShader.stage = Fragment;
				curShader.hasDiscard = true;
			}
		case TVarDecl(v, _):
			locals.set(v.id, true);
		case TFor(v, _, _):
			locals.set(v.id, true);
		case TSyntax(target, code, args):
			var mappedArgs: Array<SyntaxArg> = [];
			for ( arg in args ) {
				var e = switch ( arg.access ) {
					case Read:
						mapExprVar(arg.e);
					case Write:
						var e = curShader != null ? mapSyntaxWrite(arg.e) : arg.e;
						mapExprVar(e);
					case ReadWrite:
						// Make sure syntax writes are appended after reads.
						var e = mapExprVar(arg.e);
						if (curShader != null) e = mapSyntaxWrite(e);
						e;
				}
				mappedArgs.push({ e: e, access: arg.access });
			}
			if ( curShader != null ) curShader.hasSyntax = true;
			return { e : TSyntax(target, code, mappedArgs), t : e.t, p : e.p };
		case TCall({ e : TGlobal(ResolveSampler)}, [handle, { e : TVar(v)}]):
			var handle = mapExprVar(handle);
			var v = allocVar(v, handle.p);
			if( curShader != null && !curShader.writeMap.exists(v.id) ) {
				debug(curShader.name + " write " + v.path);
				curShader.writeMap.set(v.id, v);
				curShader.writeVars.push(v);
			}
			return { e : TCall({ e : TGlobal(ResolveSampler),  t : TFun([]), p : e.p }, [handle, { e : TVar(v.v), t : v.v.type, p : e.p }] ), t : e.t, p : e.p };
		default:
		}
		return e.map(mapExprVarFun);
	}

	function mapSyntaxWrite( e : TExpr ) : TExpr {
		switch ( e.e ) {
			case TVar(v):
				var v = allocVar(v, e.p);
				if( !curShader.writeMap.exists(v.id) ) {
					debug(curShader.name + " syntax write " + v.path);
					curShader.writeMap.set(v.id, v);
					curShader.writeVars.push(v);
				}
				return { e : TVar(v.v), t : v.v.type, p : e.p };
			default:
				return e.map(mapSyntaxWrite);
		}
	}

	function addShader( name : String, stage : ShaderStage, e : TExpr, p : Int, isBatchInit : Bool ) {
		var s = new ShaderInfos(name, stage);
		curShader = s;
		s.priority = p;
		s.body = mapExprVar(e);
		s.isBatchInit = isBatchInit;
		shaders.push(s);
		curShader = null;
		debug("Adding shader "+name+" with priority "+p);
		return s;
	}

	function sortByPriorityDesc( s1 : ShaderInfos, s2 : ShaderInfos ) {
		if( s1.priority == s2.priority )
			return s1.uid - s2.uid;
		return s2.priority - s1.priority;
	}

	function buildDependency( s : ShaderInfos, v : AllocatedVar, isWritten : Bool ) {
		var found = !isWritten;
		for( parent in shaders ) {
			if( parent == s ) {
				found = true;
				continue;
			} else if( !found )
				continue;
			if( !parent.writeMap.exists(v.id) )
				continue;
			if( s.stage == Vertex ) {
				if( parent.stage == Fragment )
					continue;
				if( parent.stage == Undefined )
					parent.stage = Vertex;
			}
			debug(s.name + " => " + parent.name + " (" + v.path + ")");
			s.deps.set(parent, true);
			debugDepth++;
			initDependencies(parent);
			debugDepth--;
			if( !parent.readMap.exists(v.id) )
				return;
		}
		if( v.v.kind == Var )
			error("Variable " + v.path + " required by " + s.name + " is missing initializer", null);
	}

	function initDependencies( s : ShaderInfos ) {
		if( s.deps != null )
			return;
		s.deps = new Map();
		for( r in s.readVars )
			buildDependency(s, r, s.writeMap.exists(r.id));
	}

	function collect( cur : ShaderInfos, vout : Array<ShaderInfos>, fout : Array<ShaderInfos>, stage : ShaderStage ) {
		if( cur.onStack )
			error("Loop in shader dependencies ("+cur.name+")", null);
		if( cur.marked.has(stage) )
			return;
		cur.marked.set(stage);
		cur.onStack = true;

		var deps = [for( d in cur.deps.keys() ) d];
		deps.sort(sortByPriorityDesc);
		for( d in deps )
			collect(d, vout, fout, cur.stage == Vertex ? Vertex : stage);

		inline function add(stage : ShaderStage) {
			cur.added.set(stage);
			var isVertex = stage == Vertex;
			var out = isVertex ? vout : fout;
			out.push(cur);
			debug("COLLECT " + cur.name + " " + (isVertex?"vertex":"fragment"));
		}

		if ( cur.isBatchInit ) {
			// Batch init can be added multiple times, once per stage
			if ( !cur.added.has(stage) )
				add(stage);
		} else if ( cur.added.toInt() == 0 ) {
			add(cur.stage == Undefined ? stage : cur.stage);
		} else if ( !cur.added.has(Vertex) && stage == Vertex ) {
			if ( cur.stage == Fragment )
				error("Shader " + cur.name + " cannot be added to vertex stage because it is marked as fragment", null);
			// Init was first encountered as fragment dependency, but is also needed in vertex
			debug("REMOVE " + cur.name + " from fragment");
			cur.added.unset(Fragment);
			fout.remove(cur);
			add(stage);
		}
		cur.onStack = false;
	}

	public function link( shadersData : Array<ShaderData> ) : ShaderData {
		debug("---------------------- LINKING -----------------------");
		varMap = new Map();
		varIdMap = new Map();
		allVars = new Array();
		shaders = [];
		locals = new Map();

		var dupShaders = [];
		shadersData = [for( i => s in shadersData ) {
			if( shadersData.indexOf(s) < i ) {
				var s2 = Clone.shaderData(s);
				dupShaders.push({ origin : s, cloned : s2 });
				s2;
			} else {
				s;
			}
		}];

		// globalize vars
		curInstance = 0;
		var outVars = [];
		for( s in shadersData ) {
			isBatchShader = mode == Batch && StringTools.startsWith(s.name,"batchShader_");
			for( v in s.vars ) {
				var v2 = allocVar(v, null, s.name);
				if( isBatchShader ) {
					var isBatchParam = StringTools.startsWith(v2.path,"Batch_");
					if ( v2.v.kind == Param && !isBatchParam )
						v2.v.kind = Local;
					if ( v.kind == Local ) {
						if ( v2.v.qualifiers == null )
							v2.v.qualifiers = [];
						#if heaps_compact_mem
						else
							v2.v.qualifiers = v2.v.qualifiers.copy();
						#end
						var qualifier = isBatchParam ? Flat : NoVar;
						if ( !v2.v.hasQualifier(qualifier) )
							v2.v.qualifiers.push(qualifier);
					}
				}
				if( v.kind == Output ) outVars.push(v);
			}
			for( f in s.funs ) {
				var v = allocVar(f.ref, f.expr.p);
				v.kind = f.kind;
			}
			curInstance++;
		}

		// create shader segments
		var priority = 0;
		var initPrio = {
			init : [-3000],
			vert : [-2000],
			frag : [-1000],
			main : [-2500],
		};
		var shaderOffset = {
			vert : -1500,
			frag : -500,
		}
		for( s in shadersData ) {
			isBatchShader = mode == Batch && StringTools.startsWith(s.name,"batchShader_");
			for( f in s.funs ) {
				var v = allocVar(f.ref, f.expr.p);
				if( v.kind == null ) throw "assert";
				switch( v.kind ) {
				case Vertex, Fragment:
					if( mode == Compute )
						throw "Unexpected "+v.kind.getName().toLowerCase()+"() function in compute shader";
					var offset = v.kind == Vertex ? shaderOffset.vert : shaderOffset.frag;
					addShader(s.name + "." + (v.kind == Vertex ? "vertex" : "fragment"), v.kind == Vertex ? Vertex : Fragment, f.expr, priority + offset, false);
				case Main:
					if( mode != Compute )
						throw "Unexpected main() outside compute shader";
					addShader(s.name, Vertex, f.expr, priority, false).isCompute = true;
				case Init:
					var prio : Array<Int>;
					var isBatchInit = false;
					var status : ShaderStage = switch( f.ref.name ) {
					case "__init__vertex": prio = initPrio.vert; Vertex;
					case "__init__fragment": prio = initPrio.frag; Fragment;
					case "__init__main": prio = initPrio.main; Fragment;
					default: prio = initPrio.init; isBatchInit = isBatchShader; Undefined;
					}
					switch( f.expr.e ) {
					case TBlock(el):
						var index = 0;
						for( e in el )
							addShader(s.name+"."+f.ref.name+(index++),status,e, prio[0]++, isBatchInit);
					default:
						addShader(s.name+"."+f.ref.name,status,f.expr, prio[0]++, isBatchInit);
					}
				case Helper:
					throw "Unexpected helper function in linker "+v.v.name;
				}
			}
			priority++;
		}
		shaders.sort(sortByPriorityDesc);

		var uid = 0;
		for( s in shaders )
			s.uid = uid++;

		#if shader_debug_dump
		for( s in shaders )
			debug("Found shader "+s.name+":"+s.uid);
		#end

		// build dependency tree
		var ventry = new ShaderInfos("<vertexEntry>", Vertex);
		ventry.deps = new Map();
		if ( outVars.length > 0 )
			buildDependency(ventry, allocVar(outVars[0],null), false);
		var fentry = new ShaderInfos("<fragmentEntry>", Fragment);
		fentry.deps = new Map();
		for( v in outVars )
			buildDependency(fentry, allocVar(v,null), false);

		// force shaders containing discard to be included
		for( s in shaders )
			if( s.hasDiscard || s.isCompute || s.hasSyntax ) {
				initDependencies(s);
				if ( s.stage == Vertex )
					ventry.deps.set(s, true);
				else
					fentry.deps.set(s, true);
			}

		// force shaders reading only params into fragment shader
		// (pixelColor = color with no effect in BaseMesh)
		for( s in shaders ) {
			if( s.stage != Undefined ) continue;
			var onlyParams = true;
			for( r in s.readVars )
				if( r.v.kind != Param ) {
					onlyParams = false;
					break;
				}
			if( onlyParams ) {
				debug("Force " + s.name + " into fragment since it only reads params");
				s.stage = Fragment;
			}
		}

		for( s in shaders ) {
			if ( s.deps == null)
				continue;
			// propagate fragment flag
			if( s.stage == Undefined )
				for( d in s.deps.keys() )
					if( d.stage == Fragment ) {
						debug(s.name + " marked as fragment because of " + d.name);
						s.stage = Fragment;
						break;
					}
			// propagate vertex flag
			if( s.stage == Vertex )
				for( d in s.deps.keys() )
					if( d.stage == Undefined ) {
						debug(d.name + " marked as vertex because of " + s.name);
						d.stage = Vertex;
					}
		}

		// collect needed dependencies
		var v = [], f = [];
		collect(ventry, v, f, Vertex);
		if( v.pop() != ventry ) throw "assert";
		collect(fentry, v, f, Fragment);
		if( f.pop() != fentry ) throw "assert";

		// check that all dependencies are matched
		for( s in shaders )
			s.marked = haxe.EnumFlags.ofInt(0);
		for( s in v.concat(f) ) {
			for( d in s.deps.keys() )
				if( d.marked.toInt() == 0 )
					error(d.name + " needed by " + s.name + " is unreachable", null);
			s.marked.set(Vertex);
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
			for( v in s.readVars )
				addVar(v);
			for( v in s.writeVars )
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
		function build(kind, name, a:Array<ShaderInfos> ) : TFunction {
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
			var expr : TExpr = { e : TBlock(exprs), t : TVoid, p : exprs.length == 0 ? null : exprs[0].p };
			return {
				kind : kind,
				ref : v,
				ret : TVoid,
				args : [],
				expr : expr,
			};
		}
		var funs = mode == Compute ? [build(Main,"main",v)] : [
			build(Vertex, "vertex", v),
			build(Fragment, "fragment", f),
		];

		// make sure the first merged var is the original for duplicate shaders
		for( d in dupShaders ) {
			for( i in 0...d.cloned.vars.length )
				allocVar(d.cloned.vars[i],null).merged.unshift(d.origin.vars[i]);
		}

		return { name : "out", vars : outVars, funs : funs };
	}

}