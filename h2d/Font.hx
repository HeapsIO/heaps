package h2d;

class Kerning {
	public var prevChar : Int;
	public var offset : Int;
	public var next : Null<Kerning>;
	public function new(c, o) {
		this.prevChar = c;
		this.offset = o;
	}
}

class FontChar {

	public var t : h2d.Tile;
	public var width : Int;
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
		c.kerning = kerning;
		return c;
	}

}

enum FontType {
	BitmapFont;
	/** Signed Distance Field font. Channel indexes are in RGBA order. See here for info: https://github.com/libgdx/libgdx/wiki/Distance-field-fonts **/
	SignedDistanceField(channel : h3d.shader.SignedDistanceField.SDFChannel, buffer : Float, gamma : Float);
}

class Font {

	public var name(default, null) : String;
	public var size(default, null) : Int;
	public var baseLine(default, null) : Int;
	public var lineHeight(default, null) : Int;
	public var tile(default,null) : h2d.Tile;
	public var tilePath(default,null) : String;
	public var type : FontType;
	public var charset : hxd.Charset;
	var glyphs : Map<Int,FontChar>;
	var nullChar : FontChar;
	var defaultChar : FontChar;
	var initSize:Int;
	var offsetX:Int = 0;
	var offsetY:Int = 0;

	function new(name,size,?type) {
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

	public function setOffset(x,y) {
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
			c.width = Std.int(c.width * ratio);
			c.t.scaleToSize(Std.int(c.t.width * ratio), Std.int(c.t.height * ratio));
			c.t.dx = Std.int(c.t.dx * ratio);
			c.t.dy = Std.int(c.t.dy * ratio);
		}
		lineHeight = Std.int(lineHeight * ratio);
		baseLine = Std.int(baseLine * ratio);
		this.size = size;
	}

	public function hasChar( code : Int ) {
		return glyphs.get(code) != null;
	}

	public function dispose() {
		tile.dispose();
	}

}
