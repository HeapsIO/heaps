package h3d.prim;

typedef HideProps = {
	var animations : haxe.DynamicAccess<{ events : Array<{ frame : Int, data : String }> }>;
}

class ModelCache {

	var models : Map<String, { lib : hxd.fmt.hmd.Library, props : HideProps }>;
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

	public function loadLibrary(res) : hxd.fmt.hmd.Library {
		return loadLibraryData(res).lib;
	}

	function loadLibraryData( res : hxd.res.Model ) {
		var path = res.entry.path;
		var m = models.get(path);
		if( m == null ) {
			var props = try {
				var parts = path.split(".");
				parts.pop();
				parts.push("props");
				haxe.Json.parse(hxd.res.Loader.currentInstance.load(parts.join(".")).toText());
			} catch( e : hxd.res.NotFound )
				null;
			m = { lib : res.toHmd(), props : props };
		}
		return m;
	}

	public function loadModel( res : hxd.res.Model ) : h3d.scene.Object {
		var m = loadLibraryData(res);
		return m.lib.makeObject(loadTexture.bind(res));
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

	public function loadAnimation( anim : hxd.res.Model, ?name : String, ?forModel : hxd.res.Model ) : h3d.anim.Animation {
		var path = anim.entry.path;
		if( name != null ) path += ":" + name;
		var a = anims.get(path);
		if( a != null )
			return a;
		a = initAnimation(anim,name,forModel);
		anims.set(path, a);
		return a;
	}

	function setAnimationProps( a : h3d.anim.Animation, resName : String, props : HideProps ) {
		if( props == null || props.animations == null ) return;
		var n = props.animations.get(resName);
		if( n != null && n.events != null )
			a.setEvents(n.events);
	}

	function initAnimation( res : hxd.res.Model, name : String, ?forModel : hxd.res.Model ) {
		var m = loadLibraryData(res);
		var a = m.lib.loadAnimation(name);
		setAnimationProps(a, res.name, m.props);
		if( forModel != null ) {
			var m = loadLibraryData(forModel);
			setAnimationProps(a, res.name, m.props);
		}
		return a;
	}

}