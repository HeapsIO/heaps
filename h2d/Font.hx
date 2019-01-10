package h2d;

class Kerning {
	public var prevChar : Int;
	public var offset : Float;
	public var next : Null<Kerning>;
	public function new(c, o) {
		this.prevChar = c;
		this.offset = o;
	}
}

class FontChar {

	public var t : h2d.Tile;
	public var width : Float;
	var kerning : Null<Kerning>;

	public function new(t,w) {
		this.t = t;
		this.width = w;
	}

	public function addKerning( prevChar : Int, offset : Int ) {
		var k = new Kerning(prevChar, offset);
		k.next = kerning;
		kerning = k;
	}

	public function getKerningOffset( prevChar : Int ) {
		var k = kerning;
		while( k != null ) {
			if( k.prevChar == prevChar )
				return k.offset;
			k = k.next;
		}
		return 0;
	}

	public function clone() {
		var c = new FontChar(t.clone(), width);
		// Clone entire kerning tree in case Font got resized.
		var k = kerning;
		if ( k != null ) {
			var kc = new Kerning(k.prevChar, k.offset);
			c.kerning = kc;
			k = k.next;
			while ( k != null ) {
				var kn = new Kerning(k.prevChar, k.offset);
				kc = kc.next = kn;
				k = k.next;
			}
		}
		return c;
	}

}

/** Channel reading method for SDF. **/
@:enum abstract SDFChannel(Int) from Int to Int {
	/** Use red channel of a texture to determine distance. **/
	var Red = 0;
	/** Use green channel of a texture to determine distance. **/
	var Green = 1;
	/** Use blue channel of a texture to determine distance. **/
	var Blue = 2;
	/** Use alpha channel of a texture to determine distance. **/
	var Alpha = 3;
	/** Use RGB channels of a texture to determine distance. See here for details: https://github.com/Chlumsky/msdfgen **/
	var MultiChannel = 4;
}

enum FontType {
	BitmapFont;
	/** Signed Distance Field font. Channel indexes are in RGBA order. See here for info: https://github.com/libgdx/libgdx/wiki/Distance-field-fonts **/
	SignedDistanceField(channel : SDFChannel, alphaCutoff : Float, smoothing : Float);
}

class Font {

	public var name(default, null) : String;
	public var size(default, null) : Int;
	public var baseLine(default, null) : Float;
	public var lineHeight(default, null) : Float;
	public var tile(default,null) : h2d.Tile;
	public var tilePath(default,null) : String;
	public var type : FontType;
	public var charset : hxd.Charset;
	var glyphs : Map<Int,FontChar>;
	var nullChar : FontChar;
	var defaultChar : FontChar;
	var initSize:Int;
	var offsetX:Float = 0;
	var offsetY:Float = 0;

	function new(name : String, size : Int, ?type : FontType) {
		this.name = name;
		this.size = size;
		this.initSize = size;
		glyphs = new Map();
		defaultChar = nullChar = new FontChar(new Tile(null, 0, 0, 0, 0),0);
		charset = hxd.Charset.getDefault();
		if (name != null)
			this.tilePath = haxe.io.Path.withExtension(name, "png");
		if (type == null)
			this.type = BitmapFont;
		else
			this.type = type;
	}

	public inline function getChar( code : Int ) {
		var c = glyphs.get(code);
		if( c == null ) {
			c = charset.resolveChar(code, glyphs);
			if( c == null )
				c = code == "\r".code || code == "\n".code ? nullChar : defaultChar;
		}
		return c;
	}

	public function setOffset( x : Float, y :Float ) {
		var dx = x - offsetX;
		var dy = y - offsetY;
		if( dx == 0 && dy == 0 ) return;
		for( g in glyphs ) {
			g.t.dx += dx;
			g.t.dy += dy;
		}
		this.offsetX += dx;
		this.offsetY += dy;
	}

	public function clone() {
		var f = new Font(name, size);
		f.baseLine = baseLine;
		f.lineHeight = lineHeight;
		f.tile = tile.clone();
		f.charset = charset;
		f.defaultChar = defaultChar.clone();
		for( g in glyphs.keys() ) {
			var c = glyphs.get(g);
			var c2 = c.clone();
			if( c == defaultChar )
				f.defaultChar = c2;
			f.glyphs.set(g, c2);
		}
		return f;
	}

	/**
		This is meant to create smoother fonts by creating them with double size while still keeping the original glyph size.
	**/
	public function resizeTo( size : Int ) {
		var ratio = size / initSize;
		for( c in glyphs ) {
			c.width *= ratio;
			c.t.scaleToSize(c.t.width * ratio, c.t.height * ratio);
			c.t.dx *= ratio;
			c.t.dy *= ratio;
			var k = @:privateAccess c.kerning;
			while ( k != null ) {
				k.offset *= ratio;
				k = k.next;
			}
		}
		lineHeight = lineHeight * ratio;
		baseLine = baseLine * ratio;
		this.size = size;
	}

	public function hasChar( code : Int ) {
		return glyphs.get(code) != null;
	}

	public function dispose() {
		tile.dispose();
	}

}
