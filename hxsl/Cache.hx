package hxsl;
using hxsl.Ast;

class AllocParam {
	public var pos : Int;
	public var instance : Int;
	public var index : Int;
	public var perObjectGlobal : AllocGlobal;
	public function new(pos, instance, index) {
		this.pos = pos;
		this.instance = instance;
		this.index = index;
	}
}

class AllocGlobal {
	public var pos : Int;
	public var gid : Int;
	public var path : String;
	public function new(pos, path) {
		this.pos = pos;
		this.path = path;
		this.gid = Globals.allocID(path);
	}
}

class CompleteShader {
	public var data : ShaderData;
	public var params : Array<AllocParam>;
	public var paramsSize : Int;
	public var globals : Array<AllocGlobal>;
	public var globalsSize : Int;
	public var paramsTexture : Array<AllocParam>;
	public var globalsTexture : Array<AllocGlobal>;
	public function new() {
	}
}

class SearchMap {
	public var linked : { vertex : CompleteShader, fragment : CompleteShader };
	public var next : Map<Int,SearchMap>;
	public function new() {
	}
}

class Cache {

	var linkCache : Map<Int,SearchMap>;
	var outVarsMap : Map<String, Int>;
	var outVars : Array<Array<String>>;
	
	function new() {
		linkCache = new Map();
		outVarsMap = new Map();
		outVars = [];
	}
	
	public function allocOutputVars( vars : Array<String> ) {
		var key = vars.join(",");
		var id = outVarsMap.get(key);
		if( id != null )
			return id;
		vars = vars.copy();
		vars.sort(Reflect.compare);
		id = outVarsMap.get(vars.join(","));
		if( id != null ) {
			outVarsMap.set(key, id);
			return id;
		}
		id = outVars.length;
		outVars.push(vars);
		outVarsMap.set(key, id);
		return id;
	}
	
	public function link( instances : Array<SharedShader.ShaderInstance>, outVars : Int ) {
		var c = linkCache.get(outVars);
		if( c == null ) {
			c = new SearchMap();
			linkCache.set(outVars, c);
		}
		for( i in instances ) {
			if( c.next == null ) c.next = new Map();
			var cs = c.next.get(i.id);
			if( cs == null ) {
				cs = new SearchMap();
				c.next.set(i.id, cs);
			}
			c = cs;
		}
		if( c.linked != null )
			return c.linked;
			
		var linker = new hxsl.Linker();
		var s = linker.link([for( s in instances ) s.shader], this.outVars[outVars]);
		
		// params tracking
		var paramVars = new Map();
		for( v in linker.allVars )
			if( v.v.kind == Param ) {
				switch( v.v.type ) {
				case TStruct(_): continue;
				default:
				}
				var i = instances[v.instanceIndex];
				paramVars.set(v.id, { instance : v.instanceIndex, index : i.params.get(v.merged[0].id) } );
			}
		
		var s = new hxsl.Splitter().split(s);
		c.linked = {
			vertex : flattenShader(s.vertex, Vertex, paramVars),
			fragment : flattenShader(s.fragment, Fragment, paramVars),
		};
		return c.linked;
	}
	
	function getPath( v : TVar ) {
		if( v.parent == null )
			return v.name;
		return getPath(v.parent) + "." + v.name;
	}
	
	function flattenShader( s : ShaderData, kind : FunctionKind, params : Map < Int, { instance:Int, index:Int } > ) {
		var flat = new Flatten();
		var c = new CompleteShader();
		var data = flat.flatten(s, kind);
		for( g in flat.allocData.keys() ) {
			var alloc = flat.allocData.get(g);
			switch( g.kind ) {
			case Param:
				var out = [];
				for( a in alloc ) {
					if( a.v == null ) continue; // padding
					var p = params.get(a.v.id);
					if( p == null ) {
						var ap = new AllocParam(a.pos, -1, -1);
						ap.perObjectGlobal = new AllocGlobal( -1, getPath(a.v));
						out.push(ap);
						continue;
					}
					out.push(new AllocParam(a.pos, p.instance, p.index));
				}
				switch( g.type ) {
				case TArray(TSampler2D, _):
					c.paramsTexture = out;
				case TArray(TVec(4, VFloat),SConst(size)):
					c.params = out;
					c.paramsSize = size;
				default: throw "assert";
				}
			case Global:
				var out = [for( a in alloc ) if( a.v != null ) new AllocGlobal(a.pos, getPath(a.v))];
				switch( g.type ) {
				case TArray(TSampler2D, _):
					c.globalsTexture = out;
				case TArray(TVec(4, VFloat),SConst(size)):
					c.globals = out;
					c.globalsSize = size;
				default:
					throw "assert";
				}
			default: throw "assert";
			}
		}
		trace(c);
		c.data = data;
		return c;
	}
	
	static var INST : Cache;
	public static function get() : Cache {
		var c = INST;
		if( c == null )
			INST = c = new Cache();
		return c;
	}
	
	public static function clear() {
		INST = null;
	}
	
}