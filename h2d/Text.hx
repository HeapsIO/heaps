package h2d;

class Text extends Sprite {

	public var font(default, null) : Font;
	public var text(default, set) : String;
	public var textColor(default, set) : Int;
	public var alpha(default, set) : Float;
	
	var glyphs : TileGroup;
	
	public function new( font : Font, ?parent ) {
		super(parent);
		this.font = font;
		glyphs = new TileGroup(font, this);
		glyphs.color = new h3d.Vector(1,1,1,1);
		text = "";
		textColor = 0xFFFFFF;
		alpha = 1.0;
	}
	
	override function onRemove() {
		glyphs.onRemove();
	}
	
	function set_text(t) {
		this.text = t;
		glyphs.reset();
		var letters = font.elements[0];
		var x = 0, y = 0;
		for( i in 0...t.length ) {
			var cc = t.charCodeAt(i);
			var e = letters[cc];
			if( e == null ) continue;
			glyphs.add(x, y, e);
			x += e.w + 1;
		}
		return t;
	}
	
	function set_textColor(c) {
		this.textColor = c;
		glyphs.color.x = ((c >> 16) & 0xFF) / 255.0;
		glyphs.color.y = ((c >> 8) & 0xFF) / 255.0;
		glyphs.color.z = (c & 0xFF) / 255.0;
		return c;
	}
	
	function set_alpha(a) {
		this.alpha = a;
		glyphs.color.w = a;
		return a;
	}

}