package h3d.prim;

class ModelCache {

	var models : Map<String, hxd.fmt.hmd.Library>;
	var textures : Map<String, h3d.mat.Texture>;
	var anims : Map<String, h3d.anim.Animation>;

	public function new() {
		models = new Map();
		textures = new Map();
		anims = new Map();
	}

	public function dispose() {
		anims = new Map();
		models = new Map();
		for( t in textures )
			t.dispose();
		textures = new Map();
	}

	function loadLibrary( res : hxd.res.Model ) : hxd.fmt.hmd.Library {
		var path = res.entry.path;
		var lib = models.get(path);
		if( lib == null ) {
			lib = res.toHmd();
			models.set(path, lib);
		}
		return lib;
	}

	public function loadModel( res : hxd.res.Model ) : h3d.scene.Object {
		var obj = loadLibrary(res).makeObject(loadTexture.bind(res));
		for( m in obj.getMaterials() )
			initMaterial(res, Std.instance(m, h3d.mat.MeshMaterial));
		return obj;
	}

	public function loadTexture( model : hxd.res.Model, texturePath ) : h3d.mat.Texture {
		var fullPath = model.entry.path + "@" + texturePath;
		var t = textures.get(fullPath);
		if( t != null )
			return t;
		var tres;
		try {
			tres = hxd.res.Loader.currentInstance.load(texturePath);
		} catch( error : hxd.res.NotFound ) {
			// try again to load into the current model directory
			var path = model.entry.directory;
			if( path != "" ) path += "/";
			path += texturePath.split("/").pop();
			try {
				tres = hxd.res.Loader.currentInstance.load(path);
			} catch( e : hxd.res.NotFound ) try {
				// if this still fails, maybe our first letter is wrongly cased
				var name = path.split("/").pop();
				var c = name.charAt(0);
				if(c == c.toLowerCase())
					name = c.toUpperCase() + name.substr(1);
				else
					name = c.toLowerCase() + name.substr(1);
				path = path.substr(0, -name.length) + name;
				tres = hxd.res.Loader.currentInstance.load(path);
			} catch( e : hxd.res.NotFound ) {
				// force good path error
				throw error;
			}
		}

		t = tres.toTexture();
		textures.set(fullPath, t);
		return t;
	}

	/**
		This can be overriden by subclasses in order to customize material setup depending on your game semantics
	**/
	public function initMaterial( model : hxd.res.Model, material : h3d.mat.MeshMaterial ) {
		material.mainPass.enableLights = true;
		material.shadows = true;
	}

	public function loadAnimation( anim : hxd.res.Model, ?name : String ) : h3d.anim.Animation {
		var path = anim.entry.path;
		if( name != null ) path += ":" + name;
		var a = anims.get(path);
		if( a != null )
			return a;
		a = loadLibrary(anim).loadAnimation(name);
		anims.set(path, a);
		return a;
	}

}