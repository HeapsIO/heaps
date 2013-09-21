package h2d;

class Kerning {
	public var prevChar : Int;
	public var offset : Int;
	public var next : Null<Kerning>;
}

class FontChar {
	
	public var t : h2d.Tile;
	public var width : Int;
	var kerning : Null<Kerning>;
	
	public function new(t,w) {
		this.t = t;
		this.width = w;
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

}

class Font {
	
	public var name(default, null) : String;
	public var size(default, null) : Int;
	public var lineHeight(default, null) : Int;
	public var tile(default,null) : h2d.Tile;
	public var charset : hxd.Charset;
	var glyphs : Map<Int,FontChar>;
	var defaultChar : FontChar;
	
	function new(name,size) {
		this.name = name;
		this.size = size;
		glyphs = new Map();
		defaultChar = new FontChar(new Tile(null, 0, 0, 0, 0),0);
		charset = hxd.Charset.getDefault();
	}
	
	public inline function getChar( code : Int ) {
		var c = glyphs.get(code);
		if( c == null ) {
			c = charset.resolveChar(code, glyphs);
			if( c == null ) c = defaultChar;
		}
		return c;
	}
	
	/**
		Divides by two the glyphs size. This is meant to create smoother fonts by creating them with double size
		while still keeping the original glyph size.
	**/
	public function halfSize() {
		for( c in glyphs ) {
			c.width >>= 1;
			c.t.scaleToSize(c.t.width >> 1, c.t.height >> 1);
		}
		lineHeight >>= 1;
	}
	
	public function hasChar( code : Int ) {
		return glyphs.get(code) != null;
	}
	
	public function dispose() {
		tile.dispose();
	}
	
}
