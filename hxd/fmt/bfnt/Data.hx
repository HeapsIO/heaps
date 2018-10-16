package hxd.fmt.bfnt;

#if macro
// Because h2d.Font cannot be used in macro context, and we resolve it during Convert, structure of Font class replicated here.

class FontDescriptor {

	public var name : String;
	public var size : Int;
	public var baseLine : Int;
	public var lineHeight : Int;
	public var tile : TileReference;
	public var glyphs : Map<Int,FontCharDescriptor>;
	public var nullChar : FontCharDescriptor;
	public var defaultChar : FontCharDescriptor;
	public var initSize:Int;
	
	public function new(name : String, size : Int) {
		glyphs = new Map();
		this.name = name;
		this.size = this.initSize = size;
		nullChar = defaultChar = new FontCharDescriptor(null, 0);
	}
	
}
class FontCharDescriptor {
	
	public var t : TileReference;
	public var width : Int;
	var kerning : KerningReference;
	
	public function new(t : TileReference, width : Int) {
		this.t = t;
		this.width = width;
	}
	
	public function addKerning( prevChar : Int, offset : Int ) {
		var k = new KerningReference(prevChar, offset);
		k.next = kerning;
		kerning = k;
	}
}

class KerningReference {
	public var next:KerningReference;
	public var prevChar : Int;
	public var offset : Int;
	
	public function new( pc : Int, off : Int ) {
		this.prevChar = pc;
		this.offset = off;
	}
}

class TileReference {
	
	public var x : Int;
	public var y : Int;
	public var width : Int;
	public var height : Int;
	public var dx : Int;
	public var dy : Int;
	
	public function new(x : Int, y : Int, w : Int, h : Int, dx : Int, dy : Int) {
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
		this.dx = dx;
		this.dy = dy;
	}
	
	public function sub(x : Int, y : Int, w : Int, h : Int, dx : Int = 0, dy : Int = 0) : TileReference {
		return new TileReference(this.x + x, this.y + y, w, h, dx, dy);
	}
}

#else
typedef FontCharDescriptor = h2d.Font.FontChar;
typedef FontDescriptor = h2d.Font;
typedef TileReference = h2d.Tile;
#end