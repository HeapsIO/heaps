package h2d;

/**
	A `FontChar` kerning information as well as linked list of kernings. See `FontChar.kerning`.
**/
class Kerning {
	/**
		A character that should precede current character in order to apply this kerning.
	**/
	public var prevChar : Int;
	/**
		A kerning offset between the character pair in pixels.
	**/
	public var offset : Float;
	/**
		The next kerning reference.
	**/
	public var next : Null<Kerning>;

	/**
		Create a new kerning instance.
		@param c The preceding character.
		@param o The kerning offset.
	**/
	public function new(c, o) {
		this.prevChar = c;
		this.offset = o;
	}
}

/**
	A single `Font` character descriptor.
**/
class FontChar {
	/**
		A Tile representing position of a character on the texture.
	**/
	public var t : h2d.Tile;
	/**
		Horizontal advance value of the character.

		On top of advance, letter spacing is affected by `FontChar.kerning` matches and `Text.letterSpacing`.
	**/
	public var width : Float;
	/**
		Linked list of kerning values.

		In order to add new kerning values use `FontChar.addKerning` and `FontChar.getKerningOffset` to retrieve kerning offsets.
	**/
	@:dox(show)
	var kerning : Null<Kerning>;

	/**
		Create a new font character.
		@param t The character Tile.
		@param width The horizontal advance of the character.
	**/
	public function new(t,w) {
		this.t = t;
		this.width = w;
	}

	/**
		Adds a new kerning to the character with specified `prevChar` and `offset`.
	**/
	public function addKerning( prevChar : Int, offset : Int ) {
		var k = new Kerning(prevChar, offset);
		k.next = kerning;
		kerning = k;
	}

	/**
		Returns kerning offset for a pair `[prevChar, currentChar]` or `0` if there was no paired kerning value.
	**/
	public function getKerningOffset( prevChar : Int ) {
		var k = kerning;
		while( k != null ) {
			if( k.prevChar == prevChar )
				return k.offset;
			k = k.next;
		}
		return 0;
	}

	/**
		Clones the character instance.
	**/
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

/**
	Channel reading method for `FontType.SignedDistanceField`.
**/
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

/**
	The rendering type of the of the `Font` instance.
**/
enum FontType {
	/**
		A simple raster bitmap font.
	**/
	BitmapFont;
	/**
		A Signed Distance Field font data. Each glyph pixel contains the distance to the closest glyph edge instead of actual color.

		To render an SDF font, `Text` utilizes `h3d.shader.SignedDistanceField` shader to produce smoothed and scalable text.
		Because shader expects texture to use bilinear filtering, Text automatically enables `Drawable.smooth` on itself.

		See [Text](https://github.com/HeapsIO/heaps/wiki/Text) manual and [libgdx wiki](https://github.com/libgdx/libgdx/wiki/Distance-field-fonts) for more details.

		@param channel The channel that serves as distance data source.
		@param alphaCutoff The distance value that is considered to be the edge. Usually should be 0.5.
		@param smoothing The smoothing of edge. Lower value lead to sharper edges. Value of -1 sets it to automatic.
	**/
	SignedDistanceField(channel : SDFChannel, alphaCutoff : Float, smoothing : Float);
}

/**
	An instance of a text font.

	Heaps comes with a default Font that covers basic ASCII characters, and can be retrieved via `hxd.res.DefaultFont.get()`.
**/
class Font {
	/**
		The font name. Assigned on font creation and can be used to identify font instances.
	**/
	public var name(default, null) : String;
	/**
		Current font size. Font can be resized with `resizeTo`.
	**/
	public var size(default, null) : Int;
	/**
		The baseline value of the font represents the base on which characters will sit.

		Used primarily with `HtmlText` to sit multiple fonts and images at the same line.
	**/
	public var baseLine(default, null) : Float;
	/**
		Font line height provides vertical offset for each new line of the text.
	**/
	public var lineHeight(default, null) : Float;
	/**
		Reference to the source Tile containing all glyphs of the Font.
	**/
	public var tile(default,null) : h2d.Tile;
	/**
		The resource path of the source Tile. Either relative to .fnt or to resources root.
	**/
	public var tilePath(default,null) : String;
	/**
		The font type. BitmapFonts rendered as-is, but SDF fonts will use an extra shader to produce scalable smooth fonts.
		See `FontType.SignedDistanceField` for more details.
	**/
	public var type : FontType;
	/**
		Font charset allows to resolve specific char codes that are not directly present in glyph map as well as detect spaces.
		Defaults to `hxd.Charset.getDefault()`.
	**/
	public var charset : hxd.Charset;
	var glyphs : Map<Int,FontChar>;
	var nullChar : FontChar;
	var defaultChar : FontChar;
	var initSize:Int;
	var offsetX:Float = 0;
	var offsetY:Float = 0;

	/**
		Creates an empty font instance with specified parameters.
		@param name The name of the font.
		@param size Initial size of the font.
		@param type The font type.
	**/
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

	/**
		Returns a `FontChar` instance corresponding to the `code`.
		If font char is not present in glyph list, `charset.resolveChar` is called.
		Returns `null` if glyph under specified charcode does not exist.
		@param code The charcode to search for.
	**/
	public inline function getChar( code : Int ) {
		var c = glyphs.get(code);
		if( c == null ) {
			c = charset.resolveChar(code, glyphs);
			if( c == null )
				c = code == "\r".code || code == "\n".code ? nullChar : defaultChar;
		}
		return c;
	}

	/**
		Offsets all glyphs by specified amount.
		Affects each glyph `Tile.dx` and `Tile.dy`.
		@param x The X offset of the glyphs.
		@param y The Y offset of the glyphs.
	**/
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

	/**
		Creates a copy of the font instance.
	**/
	public function clone() {
		var f = new Font(name, size);
		f.baseLine = baseLine;
		f.lineHeight = lineHeight;
		f.tile = tile.clone();
		f.charset = charset;
		f.defaultChar = defaultChar.clone();
		f.type = type;
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
		Resizes the Font instance to specified size.

		For BitmapFonts it can be used to create smoother fonts by rasterizing them with double size while still keeping the original glyph size by downscaling the font.
		And SDF fonts can be resized to arbitrary sizes to produce scalable fonts of any size.

		@param size The new font size.
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

	/**
		Checks if character is present in glyph list.
		Compared to `getChar` does not check if it exists through `Font.charset`.
		@param code The charcode to look up.
	**/
	public function hasChar( code : Int ) : Bool {
		return glyphs.get(code) != null;
	}

	/**
		Disposes of the Font instance. Equivalent to `Tile.dispose`.
	**/
	public function dispose() {
		tile.dispose();
	}

}
