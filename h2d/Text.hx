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
	public var letterSpacing(default, set) : Int;
	public var lineSpacing(default,set) : Int;

	var glyphs : TileGroup;
	var cachedSize : { width : Int, height : Int };

	public function new( font : Font, ?parent ) {
		super(parent);
		this.font = font;
		textAlign = Left;
		letterSpacing = 1;
        lineSpacing = 0;
		text = "";
		textColor = 0xFFFFFF;
	}

	function set_font(font) {
		if( this.font == font ) return font;
		this.font = font;
		if( glyphs != null ) glyphs.remove();
		glyphs = new TileGroup(font == null ? null : font.tile, this);
		glyphs.visible = false;
		rebuild();
		return font;
	}

	function set_textAlign(a) {
		if( textAlign == a ) return a;
		textAlign = a;
		rebuild();
		return a;
	}

	function set_letterSpacing(s) {
		if( letterSpacing == s ) return s;
		letterSpacing = s;
		rebuild();
		return s;
	}

	function set_lineSpacing(s) {
		if( lineSpacing == s ) return s;
		lineSpacing = s;
		rebuild();
		return s;
	}

	override function onAlloc() {
		super.onAlloc();
		rebuild();
	}

	override function draw(ctx:RenderContext) {
		if( dropShadow != null ) {
			var oldX = absX, oldY = absY;
			absX += dropShadow.dx * matA + dropShadow.dy * matC;
			absY += dropShadow.dx * matB + dropShadow.dy * matD;
			var oldR = color.r;
			var oldG = color.g;
			var oldB = color.b;
			var oldA = color.a;
			color.setColor(dropShadow.color);
			color.a = dropShadow.alpha * oldA;
			glyphs.drawWith(ctx, this);
			absX = oldX;
			absY = oldY;
			color.set(oldR, oldG, oldB, oldA);
			calcAbsPos();
		}
		glyphs.drawWith(ctx,this);
	}

	function set_text(t) {
		var t = t == null ? "null" : t;
		if( t == this.text ) return t;
		this.text = t;
		rebuild();
		return t;
	}

	function rebuild() {
		cachedSize = null;
		if( allocated && text != null && font != null ) initGlyphs(text);
	}

	public function calcTextWidth( text : String ) {
		var old = cachedSize;
		var w = initGlyphs(text,false).width;
		cachedSize = old;
		return w;
	}

	public function splitText( text : String, leftMargin = 0 ) {
		if( maxWidth == null )
			return text;
		var lines = [], rest = text, restPos = 0;
		var x = leftMargin, prevChar = -1;
		for( i in 0...text.length ) {
			var cc = text.charCodeAt(i);
			var e = font.getChar(cc);
			var newline = cc == '\n'.code;
			var esize = e.width + e.getKerningOffset(prevChar);
			if( font.charset.isBreakChar(cc) ) {
				if( lines.length == 0 && leftMargin > 0 && x > maxWidth ) {
					lines.push("");
					x -= leftMargin;
				}
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
					lines.push(text.substr(restPos, i - restPos));
					restPos = i;
					if( font.charset.isSpace(cc) ) {
						e = null;
						restPos++;
					}
				}
			}
			if( e != null )
				x += esize + letterSpacing;
			if( newline ) {
				x = 0;
				prevChar = -1;
			} else
				prevChar = cc;
		}
		if( restPos < text.length ) {
			if( lines.length == 0 && leftMargin > 0 && x > maxWidth )
				lines.push("");
			lines.push(text.substr(restPos, text.length - restPos));
		}
		return lines.join("\n");
	}

	function initGlyphs( text : String, rebuild = true, lines : Array<Int> = null ) : { width : Int, height : Int } {
		if( rebuild ) glyphs.clear();
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
		var dl = font.lineHeight + lineSpacing;
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
				y += dl;
				prevChar = -1;
			} else
				prevChar = cc;
		}
		if( calcLines ) lines.push(x);
		return cachedSize = { width : x > xMax ? x : xMax, height : x > 0 ? y + dl : y > 0 ? y : dl };
	}

	function get_textHeight() {
		if( cachedSize != null ) return cachedSize.height;
		return initGlyphs(text,false).height;
	}

	function get_textWidth() {
		if( cachedSize != null ) return cachedSize.width;
		return initGlyphs(text,false).width;
	}

	function set_maxWidth(w) {
		if( maxWidth == w ) return w;
		maxWidth = w;
		rebuild();
		return w;
	}

	function set_textColor(c) {
		if( this.textColor == c ) return c;
		this.textColor = c;
		var a = color.w;
		color.setColor(c);
		color.w = a;
		return c;
	}

	override function getBoundsRec( relativeTo : Sprite, out : h2d.col.Bounds ) {
		if( !allocated ) {
			// if not on scene, the text is not yet built !
			super.getBoundsRec(relativeTo, out);
			var size = cachedSize == null ? initGlyphs(text, false) : cachedSize;
			addBounds(relativeTo, out, 0, 0, size.width, size.height);
		} else {
			glyphs.visible = true;
			super.getBoundsRec(relativeTo, out);
			glyphs.visible = false;
		}
	}

}
