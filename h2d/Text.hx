package h2d;

enum Align {
	Left;
	Right;
	Center;
}

class Text extends Drawable {

	public var font(default, set) : Font;
	public var text(default, set) : String;
	public var textColor(default, set) : Int;
	public var maxWidth(default, set) : Null<Float>;
	public var dropShadow : { dx : Float, dy : Float, color : Int, alpha : Float };
	
	public var textWidth(get, null) : Int;
	public var textHeight(get, null) : Int;
	public var textAlign(default, set) : Align;
	public var letterSpacing(default,set) : Int;
	
	var glyphs : TileGroup;
	
	public function new( font : Font, ?parent ) {
		super(parent);
		this.font = font;
		textAlign = Left;
		letterSpacing = 1;
		text = "";
		textColor = 0xFFFFFF;
	}
	
	function set_font(font) {
		this.font = font;
		if( glyphs != null ) glyphs.remove();
		glyphs = new TileGroup(font == null ? null : font.tile, this);
		shader = glyphs.shader;
		rebuild();
		return font;
	}
	
	function set_textAlign(a) {
		textAlign = a;
		rebuild();
		return a;
	}

	function set_letterSpacing(s) {
		letterSpacing = s;
		rebuild();
		return s;
	}
	
	override function onAlloc() {
		super.onAlloc();
		rebuild();
	}
	
	override function draw(ctx:RenderContext) {
		glyphs.blendMode = blendMode;
		if( dropShadow != null ) {
			glyphs.x += dropShadow.dx;
			glyphs.y += dropShadow.dy;
			glyphs.calcAbsPos();
			var old = glyphs.color;
			glyphs.color = h3d.Vector.fromColor(dropShadow.color);
			glyphs.color.w = dropShadow.alpha;
			glyphs.draw(ctx);
			glyphs.x -= dropShadow.dx;
			glyphs.y -= dropShadow.dy;
			glyphs.color = old;
		}
		super.draw(ctx);
	}
	
	function set_text(t) {
		var t = t == null ? "null" : t;
		if( t == this.text ) return t;
		this.text = t;
		rebuild();
		return t;
	}
	
	function rebuild() {
		if( allocated && text != null && font != null ) initGlyphs(text);
	}
	
	public function calcTextWidth( text : String ) {
		return initGlyphs(text,false).width;
	}

	function initGlyphs( text : String, rebuild = true, lines : Array<Int> = null ) : { width : Int, height : Int } {
		if( rebuild ) glyphs.reset();
		var x = 0, y = 0, xMax = 0, prevChar = -1;
		var align = rebuild ? textAlign : Left;
		switch( align ) {
		case Center, Right:
			lines = [];
			var inf = initGlyphs(text, false, lines);
			var max = maxWidth == null ? inf.width : Std.int(maxWidth);
			var k = align == Center ? 1 : 0;
			for( i in 0...lines.length )
				lines[i] = (max - lines[i]) >> k;
			x = lines.shift();
		default:
		}
		var calcLines = !rebuild && lines != null;
		for( i in 0...text.length ) {
			var cc = text.charCodeAt(i);
			var e = font.getChar(cc);
			var newline = cc == '\n'.code;
			var esize = e.width + e.getKerningOffset(prevChar);
			// if the next word goes past the max width, change it into a newline
			if( font.charset.isBreakChar(cc) && maxWidth != null ) {
				var size = x + esize + letterSpacing;
				var k = i + 1, max = text.length;
				var prevChar = prevChar;
				while( size <= maxWidth && k < text.length ) {
					var cc = text.charCodeAt(k++);
					if( font.charset.isSpace(cc) || cc == '\n'.code ) break;
					var e = font.getChar(cc);
					size += e.width + letterSpacing + e.getKerningOffset(prevChar);
					prevChar = cc;
				}
				if( size > maxWidth ) {
					newline = true;
					if( font.charset.isSpace(cc) ) e = null;
				}
			}
			if( e != null ) {
				if( rebuild ) glyphs.add(x, y, e.t);
				x += esize + letterSpacing;
			}
			if( newline ) {
				if( x > xMax ) xMax = x;
				if( calcLines ) lines.push(x);
				if( rebuild )
					switch( align ) {
					case Left:
						x = 0;
					case Right, Center:
						x = lines.shift();
					}
				else
					x = 0;
				y += font.lineHeight;
				prevChar = -1;
			} else
				prevChar = cc;
		}
		if( calcLines ) lines.push(x);
		return { width : x > xMax ? x : xMax, height : x > 0 ? y + font.lineHeight : y > 0 ? y : font.lineHeight };
	}
	
	function get_textHeight() {
		return initGlyphs(text,false).height;
	}
	
	function get_textWidth() {
		return initGlyphs(text,false).width;
	}
	
	function set_maxWidth(w) {
		maxWidth = w;
		rebuild();
		return w;
	}
	
	function set_textColor(c) {
		this.textColor = c;
		glyphs.color = h3d.Vector.fromColor(c);
		glyphs.color.w = alpha;
		return c;
	}

}