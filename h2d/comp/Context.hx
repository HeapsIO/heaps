package h2d.comp;

class Context {
	
	// measure props
	public var measure : Bool;
	public var maxWidth : Float;
	public var maxHeight : Float;
	// arrange props
	public var xPos : Null<Float>;
	public var yPos : Null<Float>;
	
	public function new(w, h) {
		this.maxWidth = w;
		this.maxHeight = h;
		measure = true;
	}
	
	// ------------- STATIC API ---------------------------------------
	
	public static function getFont( name : String, size : Int ) {
		var key = name + "#" + size;
		var f = FONTS.get(key);
		if( f != null )
			return f;
		f = new h2d.Font(name, size);
		FONTS.set(key, f);
		return f;
	}
	
	public static function dispose() {
		for( f in FONTS )
			f.dispose();
		FONTS = new Map();
	}

	static var FONTS = new Map<String,h2d.Font>();
	
	public static var DEFAULT_CSS = h3d.System.getFileContent("h2d/css/default.css");
	
	static var DEF = null;
	public static function getDefaultCss() {
		if( DEF != null )
			return DEF;
		var e = new h2d.css.Engine();
		e.addRules(DEFAULT_CSS);
		return e;
	}
	
}