package hxd.res;

class Loader {
	
	public var fs(default,null) : FileSystem;
	var modelCache : Map<String,Model>;
	var textureCache : Map<String,Texture>;
	var soundCache : Map<String,Sound>;
	var fontCache : Map<String,BitmapFont>;
	
	public function new(fs) {
		this.fs = fs;
		modelCache = new Map();
		textureCache = new Map();
		soundCache = new Map();
		fontCache = new Map();
	}

	public function exists( path : String ) : Bool {
		return fs.exists(path);
	}
	
	public function load( path : String ) : Any {
		return new Any(this, fs.get(path));
	}
	
	function loadModel( path : String ) : Model {
		var m = modelCache.get(path);
		if( m == null ) {
			m = new Model(fs.get(path));
			modelCache.set(path, m);
		}
		return m;
	}
	
	function loadTexture( path : String ) : Texture {
		var t = textureCache.get(path);
		if( t == null ) {
			t = new Texture(fs.get(path));
			textureCache.set(path, t);
		}
		return t;
	}
	
	function loadSound( path : String ) : Sound {
		var s = soundCache.get(path);
		if( s == null ) {
			s = new Sound(fs.get(path));
			soundCache.set(path, s);
		}
		return s;
	}

	function loadFont( path : String ) : Font {
		// no cache necessary (uses FontBuilder which has its own cache)
		return new Font(fs.get(path));
	}

	function loadBitmapFont( path : String ) : BitmapFont {
		var f = fontCache.get(path);
		if( f == null ) {
			f = new BitmapFont(this,fs.get(path));
			fontCache.set(path, f);
		}
		return f;
	}

	function loadData( path : String ) {
		return new Resource(fs.get(path));
	}
	
	function loadTiledMap( path : String ) {
		return new TiledMap(fs.get(path));
	}
	
}