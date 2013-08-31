package hxd.res;

class Loader {
	
	var fs : FileSystem;
	
	public function new(fs) {
		this.fs = fs;
	}

	public function exists( path : String ) : Bool {
		return fs.exists(path);
	}
	
	function resolveDynamic( path : String ) : Dynamic {
		var extParts = path.split(".");
		extParts.shift();
		var ext = extParts.join(".").toLowerCase();
		switch( ext ) {
		case "fbx", "xbx": return loadModel(path);
		case "png", "jpg": return loadTexture(path);
		case "ttf": return loadFont(path);
		case "wav", "mp3": return loadSound(path);
		case "":
			var f = fs.get(path);
			if( f.isDirectory )
				return new Directory(f);
		default:
		};
		throw "Unknown extension " + ext;
		return null;
	}
	
	public function load( path : String ) : Any {
		return new Any(fs.get(path));
	}
	
	function loadModel( path : String ) : Model {
		return new Model(fs.get(path));
	}
	
	function loadTexture( path : String ) : Texture {
		return new Texture(fs.get(path));
	}
	
	function loadFont( path : String ) : Font {
		return new Font(fs.get(path));
	}
	
	function loadSound( path : String ) : Sound {
		return new Sound(fs.get(path));
	}

}