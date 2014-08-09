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
		return hxd.res.FontBuilder.getFont(name, size);
	}

	public static function makeTileIcon( pixels : hxd.Pixels ) : h2d.Tile {
		var t = cachedIcons.get(pixels);
		if( t != null && !t.isDisposed() )
			return t;
		t = h2d.Tile.fromPixels(pixels);
		cachedIcons.set(pixels, t);
		return t;
	}

	static var cachedIcons = new Map<hxd.Pixels,h2d.Tile>();

	public static var DEFAULT_CSS = hxd.res.Embed.getFileContent("h2d/css/default.css");

	static var DEF = null;
	public static function getDefaultCss() {
		if( DEF != null )
			return DEF;
		var e = new h2d.css.Engine();
		e.addRules(DEFAULT_CSS);
		return e;
	}

}