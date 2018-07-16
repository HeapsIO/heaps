package hxd.prefab;

typedef ShaderDef = {
	var shader : hxsl.SharedShader;
	var inits : Array<{ v : hxsl.Ast.TVar, e : hxsl.Ast.TExpr }>;
}

typedef ShaderDefCache = Map<String, ShaderDef>;

class ContextShared {
	public var root2d : h2d.Sprite;
	public var root3d : h3d.scene.Object;
	public var contexts : Map<Prefab,Context>;
	public var references : Map<Prefab,Array<Context>>;
	public var cleanups : Array<Void->Void>;
	var cache : h3d.prim.ModelCache;
	var shaderCache : ShaderDefCache;

	public function new() {
		root2d = new h2d.Sprite();
		root3d = new h3d.scene.Object();
		contexts = new Map();
		references = new Map();
		cache = new h3d.prim.ModelCache();
		cleanups = [];
		shaderCache = new ShaderDefCache();
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

}