package hxsl;
using hxsl.Ast;
import hxsl.RuntimeShader;

class SearchMap {
	public var linked : RuntimeShader;
	public var next : Map<Int,SearchMap>;
	public function new() {
	}
}

class Cache {

	var linkCache : Map<Int,SearchMap>;
	var outVarsMap : Map<String, Int>;
	var outVars : Array<Array<String>>;
	var byID : Map<String, RuntimeShader>;
	public var constsToGlobal : Bool;

	function new() {
		constsToGlobal = false;
		linkCache = new Map();
		outVarsMap = new Map();
		outVars = [];
		byID = new Map();
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

	@:noDebug
	public function link( shaders : hxsl.ShaderList, outVars : Int ) {
		var c = linkCache.get(outVars);
		if( c == null ) {
			c = new SearchMap();
			linkCache.set(outVars, c);
		}
		for( s in shaders ) {
			var i = @:privateAccess s.instance;
			if( c.next == null ) c.next = new Map();
			var cs = c.next.get(i.id);
			if( cs == null ) {
				cs = new SearchMap();
				c.next.set(i.id, cs);
			}
			c = cs;
		}
		if( c.linked == null )
			c.linked = compileRuntimeShader(shaders, outVars);
		return c.linked;
	}

	function compileRuntimeShader( shaders : hxsl.ShaderList, outVars : Int ) {
		var shaderDatas = [];
		var index = 0;
		for( s in shaders ) {
			var i = @:privateAccess s.instance;
			shaderDatas.push( { inst : i, p : s.priority, index : index++ } );
		}
		shaderDatas.reverse(); // default is reverse order
		haxe.ds.ArraySort.sort(shaderDatas, function(s1, s2) return s2.p - s1.p);

		var linker = new hxsl.Linker();
		var s = linker.link([for( s in shaderDatas ) s.inst.shader], this.outVars[outVars]);

		// params tracking
		var paramVars = new Map();
		for( v in linker.allVars )
			if( v.v.kind == Param ) {
				switch( v.v.type ) {
				case TStruct(_): continue;
				default:
				}
				var inf = shaderDatas[v.instanceIndex];
				paramVars.set(v.id, { instance : inf.index, index : inf.inst.params.get(v.merged[0].id) } );
			}

		var s = new hxsl.Splitter().split(s);
		var s = new hxsl.Dce().dce(s.vertex, s.fragment);

		var r = new RuntimeShader();
		r.vertex = flattenShader(s.vertex, Vertex, paramVars);
		r.vertex.vertex = true;
		r.fragment = flattenShader(s.fragment, Fragment, paramVars);
		r.globals = new Map();
		var p = r.vertex.globals;
		while( p != null ) {
			r.globals.set(p.gid, true);
			p = p.next;
		}
		p = r.fragment.globals;
		while( p != null ) {
			r.globals.set(p.gid, true);
			p = p.next;
		}

		var sid = haxe.crypto.Md5.encode(Printer.shaderToString(r.vertex.data) + Printer.shaderToString(r.fragment.data));
		var r2 = byID.get(sid);
		if( r2 != null )
			r.id = r2.id; // same id but different variable mapping
		else
			byID.set(sid, r);

		return r;
	}

	function getPath( v : TVar ) {
		if( v.parent == null )
			return v.name;
		return getPath(v.parent) + "." + v.name;
	}

	function flattenShader( s : ShaderData, kind : FunctionKind, params : Map<Int,{ instance:Int, index:Int }> ) {
		var flat = new Flatten();
		var c = new RuntimeShaderData();
		var data = flat.flatten(s, kind, constsToGlobal);
		c.consts = flat.consts;
		for( g in flat.allocData.keys() ) {
			var alloc = flat.allocData.get(g);
			switch( g.kind ) {
			case Param:
				var out = [];
				for( a in alloc ) {
					if( a.v == null ) continue; // padding
					var p = params.get(a.v.id);
					if( p == null ) {
						var ap = new AllocParam(a.v.name, a.pos, -1, -1, a.v.type);
						ap.perObjectGlobal = new AllocGlobal( -1, getPath(a.v), a.v.type);
						out.push(ap);
						continue;
					}
					out.push(new AllocParam(a.v.name, a.pos, p.instance, p.index, a.v.type));
				}
				for( i in 0...out.length - 1 )
					out[i].next = out[i + 1];
				switch( g.type ) {
				case TArray(TSampler2D, _):
					c.textures2D = out[0];
					c.textures2DCount = out.length;
				case TArray(TSamplerCube, _):
					c.texturesCube = out[0];
					c.texturesCubeCount = out.length;
				case TArray(TVec(4, VFloat), SConst(size)):
					c.params = out[0];
					c.paramsSize = size;
				default: throw "assert";
				}
			case Global:
				var out = [for( a in alloc ) if( a.v != null ) new AllocGlobal(a.pos, getPath(a.v), a.v.type)];
				for( i in 0...out.length - 1 )
					out[i].next = out[i + 1];
				switch( g.type ) {
				case TArray(TVec(4, VFloat),SConst(size)):
					c.globals = out[0];
					c.globalsSize = size;
				default:
					throw "assert";
				}
			default: throw "assert";
			}
		}
		if( c.globals == null )
			c.globalsSize = 0;
		if( c.params == null )
			c.paramsSize = 0;
		if( c.textures2D == null )
			c.textures2DCount = 0;
		if( c.texturesCube == null )
			c.texturesCubeCount = 0;
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