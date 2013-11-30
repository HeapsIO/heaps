package hxsl;
using hxsl.Ast;

class SearchMap {
	public var linked : ShaderData;
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
		c.linked = new hxsl.Linker().link([for( s in instances ) s.shader], this.outVars[outVars]);
		return c.linked;
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