package hxd.prefab;

typedef ShaderDef = {
	var shader : hxsl.SharedShader;
	var inits : Array<{ v : hxsl.Ast.TVar, e : hxsl.Ast.TExpr }>;
}

typedef ShaderDefCache = Map<String, ShaderDef>;

class ContextShared {
	public var root2d : h2d.Object;
	public var root3d : h3d.scene.Object;
	public var contexts : Map<Prefab,Context>;
	public var references : Map<Prefab,Array<Context>>;
	public var currentPath : String;
	public var editorDisplay : Bool;

	var cache : h3d.prim.ModelCache;
	var shaderCache : ShaderDefCache;
	var bakedData : Map<String, haxe.io.Bytes>;

	public function new() {
		root2d = new h2d.Object();
		root3d = new h3d.scene.Object();
		contexts = new Map();
		references = new Map();
		cache = new h3d.prim.ModelCache();
		shaderCache = new ShaderDefCache();
	}

	public function onError( e : Dynamic ) {
		throw e;
	}

	public function elements() {
		return [for(e in contexts.keys()) e];
	}

	public function getContexts(p: Prefab) {
		var ret : Array<Context> = [];
		var ctx = contexts.get(p);
		if(ctx != null)
			ret.push(ctx);
		var ctxs = references.get(p);
		if(ctxs != null)
			return ret.concat(ctxs);
		return ret;
	}

	public function loadDir(p : String, ?dir : String ) : Array<hxd.res.Any> {
		var datPath = new haxe.io.Path(currentPath);
		datPath.ext = "dat";
		var path = datPath.toString() + "/" + p;
		if(dir != null) path += "/" + dir;
		return try hxd.res.Loader.currentInstance.dir(path) catch( e : hxd.res.NotFound ) null;
	}

	public function loadPrefabDat(file : String, ext : String, p : String) : hxd.res.Any {
		var datPath = new haxe.io.Path(currentPath);
		datPath.ext = "dat";
		var path = new haxe.io.Path(datPath.toString() + "/" + p + "/" + file);
		path.ext = ext;
		return try hxd.res.Loader.currentInstance.load(path.toString()) catch( e : hxd.res.NotFound ) null;
	}

	public function savePrefabDat(file : String, ext : String, p : String, bytes : haxe.io.Bytes ) {
		throw "Not implemented";
	}

	public function loadPrefab( path : String ) : Prefab {
		throw "Not implemented";
	}

	public function loadShader( path : String ) : ShaderDef {
		var r = shaderCache.get(path);
		if(r != null)
			return r;
		var cl = Type.resolveClass(path.split("/").join("."));
		var shader = new hxsl.SharedShader(Reflect.field(cl, "SRC"));
		r = {
			shader: shader,
			inits: []
		};
		shaderCache.set(path, r);
		return r;
	}

	public function loadModel( path : String ) {
		return cache.loadModel(hxd.res.Loader.currentInstance.load(path).toModel());
	}

	public function loadAnimation( path : String ) {
		return @:privateAccess cache.loadAnimation(hxd.res.Loader.currentInstance.load(path).toModel());
	}

	public function loadTexture( path : String ) {
		return cache.loadTexture(null, path);
	}

	public function loadBytes( file : String) : haxe.io.Bytes {
		return try hxd.res.Loader.currentInstance.load(file).entry.getBytes() catch( e : hxd.res.NotFound ) null;
	}

	public function loadBakedBytes( file : String ) {
		if( bakedData == null ) loadBakedData();
		return bakedData.get(file);
	}

	public function saveBakedBytes( file : String, bytes : haxe.io.Bytes ) {
		if( bakedData == null ) loadBakedData();
		if( bytes == null ) {
			if( !bakedData.remove(file) )
				return;
		} else
			bakedData.set(file, bytes);
		var keys = Lambda.array({ iterator : bakedData.keys });
		if( keys.length == 0 ) {
			saveBakedFile(null);
			return;
		}
		var bytes = new haxe.io.BytesOutput();
		bytes.writeString("BAKE");
		bytes.writeInt32(keys.length);
		var headerSize = 8;
		for( name in keys )
			headerSize += 2 + name.length + 8;
		for( name in keys ) {
			bytes.writeUInt16(name.length);
			bytes.writeString(name);
			bytes.writeInt32(headerSize);
			var len = bakedData.get(name).length;
			bytes.writeInt32(len);
			headerSize += len + 1;
		}
		for( name in keys ) {
			bytes.write(bakedData.get(name));
			bytes.writeByte(0xFE); // stop
		}
		saveBakedFile(bytes.getBytes());
	}

	public function saveTexture( file : String, bytes : haxe.io.Bytes , dir : String, ext : String) {
		throw "Don't know how to save texture";
	}

	function saveBakedFile( bytes : haxe.io.Bytes ) {
		throw "Don't know how to save baked file";
	}

	function loadBakedFile() {
		var path = new haxe.io.Path(currentPath);
		path.ext = "bake";
		return try hxd.res.Loader.currentInstance.load(path.toString()).entry.getBytes() catch( e : hxd.res.NotFound ) null;
	}

	function loadBakedData() {
		bakedData = new Map();
		var data = loadBakedFile();
		if( data == null )
			return;
		if( data.getString(0,4) != "BAKE" )
			throw "Invalid bake file";
		var count = data.getInt32(4);
		var pos = 8;
		for( i in 0...count ) {
			var len = data.getUInt16(pos);
			pos += 2;
			var name = data.getString(pos, len);
			pos += len;
			var bytesPos = data.getInt32(pos);
			pos += 4;
			var bytesLen = data.getInt32(pos);
			pos += 4;
			bakedData.set(name,data.sub(bytesPos,bytesLen));
			if( data.get(bytesPos+bytesLen) != 0xFE )
				throw "Corrupted bake file";
		}
	}

	function getChildrenRoots( base : h3d.scene.Object, p : Prefab, out : Array<h3d.scene.Object> ) {
		for( c in p.children ) {
			var ctx = contexts.get(c);
			if( ctx == null ) continue;
			if( ctx.local3d == base )
				getChildrenRoots(base, c, out);
			else
				out.push(ctx.local3d);
		}
		return out;
	}

	public function getObjects<T:h3d.scene.Object>( p : Prefab, c: Class<T> ) : Array<T> {
		var ctx = contexts.get(p);
		if( ctx == null )
			return [];
		var root = ctx.local3d;
		var childObjs = getChildrenRoots(root, p, []);
		var ret = [];
		function rec(o : h3d.scene.Object) {
			var m = Std.instance(o, c);
			if(m != null) ret.push(m);
			for( child in o )
				if( childObjs.indexOf(child) < 0 )
					rec(child);
		}
		rec(root);
		return ret;
	}

	public function getMaterials( p : Prefab ) {
		var ctx = contexts.get(p);
		if( ctx == null )
			return [];
		var root = ctx.local3d;
		var childObjs = getChildrenRoots(root, p, []);
		var ret = [];
		function rec(o : h3d.scene.Object) {
			if( o.isMesh() ) {
				var m = o.toMesh();
				var multi = Std.instance(m, h3d.scene.MultiMaterial);
				if( multi != null ) {
					for( m in multi.materials )
						if( m != null )
							ret.push(m);
				} else if( m.material != null )
					ret.push(m.material);
			}
			for( child in o )
				if( childObjs.indexOf(child) < 0 )
					rec(child);
		}
		rec(root);
		return ret;
	}

}