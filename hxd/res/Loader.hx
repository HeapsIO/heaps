package hxd.res;

class Loader {
	
	var root : Dynamic;
	
	public function new(?root) {
		if( root == null )
			root = @:privateAccess haxe.Unserializer.run(hxd.Res._ROOT);
		this.root = root;
	}

	function get(path:String) : Dynamic {
		var r = root;
		for( p in path.split("/") )
			r = Reflect.field(r, p);
		return r;
	}
	
	public function exists( path : String ) : Bool {
		return get(path) != null;
	}
	
	function resolveDynamic( path : String, ext : String ) : Dynamic {
		return switch( ext.toLowerCase() ) {
		case "fbx", "xbx": loadModel(path);
		case "png", "jpg": loadTexture(path);
		case "ttf": loadFont(path);
		case "wav", "mp3": loadSound(path);
		default: throw "Unknown extension " + ext;
		};
	}
	
	public function load( path : String ) : Any {
		var inf : Dynamic = get(path);
		if( inf == null ) throw "Resource not found '" + path + "'";
		if( Std.is(inf, String) )
			return new Any(path, resolveDynamic(path, inf));
		var ext = inf._e;
		if( ext != null )
			return new Any(path, resolveDynamic(path, ext));
		return new Any(path, @:privateAccess new Directory(this,path,inf));
	}
	
	function loadModel( path : String ) : Model {
		return null;
	}
	
	function loadTexture( path : String ) : Texture {
		return null;
	}
	
	function loadFont( path : String ) : Font {
		return null;
	}
	
	function loadSound( path : String ) : Sound {
		return null;
	}

}