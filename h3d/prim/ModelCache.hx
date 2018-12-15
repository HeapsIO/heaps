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

	public function loadLibrary( res : hxd.res.Model ) : hxd.fmt.hmd.Library {
		var path = res.entry.path;
		var lib = models.get(path);
		if( lib == null ) {
			lib = res.toHmd();
			models.set(path, lib);

			function loadHideData( path : String ) : hxd.fmt.hmd.Library.HideData {
				var parts = path.split("/");
				parts.pop();
				var propsPath = parts.join("/") + "/model.props";
				if(!hxd.res.Loader.currentInstance.exists(propsPath)) return null;
				var props = hxd.res.Loader.currentInstance.load(propsPath).toText();
				return haxe.Json.parse(props);
			}
			lib.hideData = loadHideData(path);
		}
		return lib;
	}

	public function loadModel( res : hxd.res.Model ) : h3d.scene.Object {
		return loadLibrary(res).makeObject(loadTexture.bind(res));
	}

	public function loadTexture( model : hxd.res.Model, texturePath ) : h3d.mat.Texture {
		var fullPath = texturePath;
		if(model != null)
			fullPath = model.entry.path + "@" + fullPath;
		var t = textures.get(fullPath);
		if( t != null )
			return t;
		var tres;
		try {
			tres = hxd.res.Loader.currentInstance.load(texturePath);
		} catch( error : hxd.res.NotFound ) {
			if(model == null)
				throw error;
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

	public function loadAnimation( anim : hxd.res.Model, ?name : String ) : h3d.anim.Animation {
		var path = anim.entry.path;
		if( name != null ) path += ":" + name;
		var a = anims.get(path);
		if( a != null )
			return a;
		a = initAnimation(anim,name);
		anims.set(path, a);
		return a;
	}

	function initAnimation( anim : hxd.res.Model, name : String ) {
		return loadLibrary(anim).loadAnimation(name);
	}

}