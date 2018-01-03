package hxsl;

class CacheUnserializer extends hxsl.Cache {

	var allowRuntimeCompilation : Bool;
	public var shaders : Array<hxsl.RuntimeShader>;
	var ctx : hxbit.Serializer;

	public function new( bytes : haxe.io.Bytes, allowRuntimeCompilation = true){
		super();
		this.allowRuntimeCompilation = allowRuntimeCompilation;
		@:privateAccess hxsl.Cache.INST = this;
		unserialize(bytes);
	}

	function unserialize( bytes : haxe.io.Bytes ){
		bytes = haxe.zip.Uncompress.run(bytes);
		ctx = new hxbit.Serializer();
		ctx.setInput(bytes,0);
		var ncode = ctx.getInt();
		var codes = [for( i in 0...ncode ) ctx.getString()];
		var ninstance = ctx.getInt();
		var UID = 0;
		for( i in 0...ninstance ){
			var c : Dynamic = Type.resolveClass(ctx.getString());
			if( allowRuntimeCompilation ){
				var inst : hxsl.Shader = Type.createEmptyInstance(c);
				@:privateAccess inst.initialize();
			}
			var s = c._SHADER;
			if( s == null ) c._SHADER = s = new hxsl.SharedShader("");

			var nsub = ctx.getInt();
			for( j in 0...nsub ) @:privateAccess {
				var id = -ctx.getInt();
				if( id < UID ) UID = id - 1;
				var constBits = ctx.getInt();

				if( allowRuntimeCompilation ){
					var si = s.getInstance(constBits);
					si.id = id;
				}else{
					var si = new hxsl.SharedShader.ShaderInstance(null);
					si.id = id;
					s.instanceCache.set(constBits, si);
				}
			}
		}

		var nOutputList = ctx.getInt();
		shaders = [];
		if( linkCache.next == null ) 
			linkCache.next = new Map();
		for( i in 0...nOutputList ) @:privateAccess { 
			var outputs = haxe.Unserializer.run(ctx.getString());
			var linkShader = getLinkShader(outputs);
			linkShader.instance.id = UID--;
			var cache = new hxsl.Cache.SearchMap();
			linkCache.next.set(linkShader.instance.id, cache);
			var nShaderList = ctx.getInt();
			for( j in 0...nShaderList ){
				var n = ctx.getInt();
				var c = cache;
				var tmp = [linkShader.instance.id];
				for( k in 0...n ){
					var iid = -ctx.getInt();
					if( c.next == null ) c.next = new Map();
					var cs = c.next.get(iid);
					if( cs == null )
						c.next.set(iid, cs = new hxsl.Cache.SearchMap());
					c = cs;
					tmp.push(iid);
				}
				c.linked = haxe.Unserializer.run(ctx.getString());
				c.linked.globals = new Map();
				reallocGlobals(c.linked, c.linked.vertex);
				reallocGlobals(c.linked, c.linked.fragment);
				c.linked.vertex.code = codes[ctx.getInt()];
				c.linked.fragment.code = codes[ctx.getInt()];
				shaders.push( c.linked );
			}
		}
		ctx = null;
	}

	override function compileRuntimeShader( shaders : hxsl.ShaderList ) {
		onRuntimeCompilation(shaders);
		if( allowRuntimeCompilation )
			return super.compileRuntimeShader(shaders);
		throw "Invalid shaderList";
		return null;
	}

	public dynamic function onRuntimeCompilation( shader : hxsl.ShaderList ){
	}

	static function reallocGlobals(r : hxsl.RuntimeShader, s : hxsl.RuntimeShader.RuntimeShaderData){
		var p = s.globals;
		while( p != null ) {
			if( p.gid < 0 ) p.gid = hxsl.Globals.allocID(p.path);
			r.globals.set(p.gid, true);
			p = p.next;
		}
		var p = s.params;
		while( p != null ) {
			if( p.perObjectGlobal != null ){
				if( p.perObjectGlobal.gid < 0 ) p.perObjectGlobal.gid = hxsl.Globals.allocID(p.perObjectGlobal.path);
				r.globals.set(p.perObjectGlobal.gid, true);
			}
			p = p.next;
		}
		var p = s.textures2D;
		while( p != null ) {
			if( p.perObjectGlobal != null ){
				if( p.perObjectGlobal.gid < 0 ) p.perObjectGlobal.gid = hxsl.Globals.allocID(p.perObjectGlobal.path);
			}
			p = p.next;
		}
		var p = s.texturesCube;
		while( p != null ) {
			if( p.perObjectGlobal != null ){
				if( p.perObjectGlobal.gid < 0 ) p.perObjectGlobal.gid = hxsl.Globals.allocID(p.perObjectGlobal.path);
			}
			p = p.next;
		}
	}

}