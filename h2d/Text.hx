package h2d;

enum Align {
	Left;
	Right;
	Center;
	MultilineRight;
	MultilineCenter;
}

class Text extends Drawable {

	public var font(default, set) : Font;
	public var text(default, set) : String;
	public var textColor(default, set) : Int;
	public var maxWidth(default, set) : Null<Float>;
	public var dropShadow : { dx : Float, dy : Float, color : Int, alpha : Float };

	public var textWidth(get, null) : Float;
	public var textHeight(get, null) : Float;
	public var textAlign(default, set) : Align;
	public var letterSpacing(default, set) : Float;
	public var lineSpacing(default,set) : Float;

	var glyphs : TileGroup;

	var calcDone:Bool;
	var calcXMin:Float;
	var calcYMin:Float;
	var calcWidth:Float;
	var calcHeight:Float;
	var calcSizeHeight:Float;
	var constraintWidth:Float = -1;
	var realMaxWidth:Float = -1;

	#if lime
	var waShader : h3d.shader.WhiteAlpha;
	#end
	var sdfShader : h3d.shader.SignedDistanceField;

	public function new( font : Font, ?parent : h2d.Object ) {
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
		if ( font != null ) {
			#if lime
			if( font.tile.getTexture().format == ALPHA ){
				if( waShader == null ) addShader( waShader = new h3d.shader.WhiteAlpha() );
			}else{
				if( waShader != null ) removeShader( waShader );
			}
			#end
			switch( font.type ) {
				case BitmapFont:
					if ( sdfShader != null ) {
						removeShader(sdfShader);
						sdfShader = null;
					}
				case SignedDistanceField(channel, alphaCutoff, smoothing):
					if ( sdfShader == null ) {
						sdfShader = new h3d.shader.SignedDistanceField();
						addShader(sdfShader);
					}
					sdfShader.alphaCutoff = alphaCutoff;
					sdfShader.smoothing = smoothing;
					sdfShader.channel = channel;
			}
		}
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

	override function constraintSize(width:Float, height:Float) {
		constraintWidth = width;
		updateConstraint();
	}

	override function onAdd() {
		super.onAdd();
		rebuild();
	}

	override function draw(ctx:RenderContext) {
		if( glyphs == null ) {
			emitTile(ctx, h2d.Tile.fromColor(0xFF00FF, 16, 16));
			return;
		}
		if ( !calcDone && text != null && font != null ) initGlyphs(text);

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
		}
		glyphs.drawWith(ctx,this);
	}

	function set_text(t : String) {
		var t = t == null ? "null" : t;
		if( t == this.text ) return t;
		this.text = t;
		rebuild();
		return t;
	}

	function rebuild() {
		calcDone = false;
		if( allocated && text != null && font != null ) initGlyphs(text);
		onContentChanged();
	}

	public function calcTextWidth( text : String ) {
		if( calcDone ) {
			var ow = calcWidth, oh = calcHeight, osh = calcSizeHeight, ox = calcXMin, oy = calcYMin;
			initGlyphs(text, false);
			var w = calcWidth;
			calcWidth = ow;
			calcHeight = oh;
			calcSizeHeight = osh;
			calcXMin = ox;
			calcYMin = oy;
			return w;
		} else {
			initGlyphs(text, false);
			calcDone = false;
			return calcWidth;
		}
	}

	public function splitText( text : String, leftMargin = 0., afterData = 0. ) {
		if( realMaxWidth < 0 )
			return text;
		var lines = [], rest = text, restPos = 0;
		var x = leftMargin, prevChar = -1;
		for( i in 0...text.length ) {
			var cc = text.charCodeAt(i);
			var e = font.getChar(cc);
			var newline = cc == '\n'.code;
			var esize = e.width + e.getKerningOffset(prevChar);
			if( font.charset.isBreakChar(cc) ) {
				if( lines.length == 0 && leftMargin > 0 && x > realMaxWidth ) {
					lines.push("");
					x -= leftMargin;
				}
				var size = x + esize + letterSpacing; /* TODO : no letter spacing */
				var k = i + 1, max = text.length;
				var prevChar = prevChar;
				var breakFound = false;
				while( size <= realMaxWidth && k < max ) {
					var cc = text.charCodeAt(k++);
					if( font.charset.isSpace(cc) || cc == '\n'.code ) {
						breakFound = true;
						break;
					}
					var e = font.getChar(cc);
					size += e.width + letterSpacing + e.getKerningOffset(prevChar);
					prevChar = cc;
					if( font.charset.isBreakChar(cc) ) break;
				}
				if( size > realMaxWidth || (!breakFound && size + afterData > realMaxWidth) ) {
					newline = true;
					if( font.charset.isSpace(cc) ){
						lines.push(text.substr(restPos, i - restPos));
						e = null;
					}else{
						lines.push(text.substr(restPos, i + 1 - restPos));
					}
					restPos = i + 1;
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
			if( lines.length == 0 && leftMargin > 0 && x + afterData - letterSpacing > realMaxWidth )
				lines.push("");
			lines.push(text.substr(restPos, text.length - restPos));
		}
		return lines.join("\n");
	}

	function initGlyphs( text : String, rebuild = true, handleAlign = true, lines : Array<Int> = null ) : Void {
		if( rebuild ) glyphs.clear();
		var x = 0., y = 0., xMax = 0., xMin = 0., prevChar = -1;
		var align = handleAlign ? textAlign : Left;
		switch( align ) {
		case Center, Right, MultilineCenter, MultilineRight:
			lines = [];
			initGlyphs(text, false, false, lines);
			var max = if( align == MultilineCenter || align == MultilineRight ) hxd.Math.ceil(calcWidth) else realMaxWidth < 0 ? 0 : hxd.Math.ceil(realMaxWidth);
			var k = align == Center || align == MultilineCenter ? 1 : 0;
			for( i in 0...lines.length )
				lines[i] = (max - lines[i]) >> k;
			x = lines.shift();
			xMin = x;
		default:
		}
		var dl = font.lineHeight + lineSpacing;
		var calcLines = !handleAlign && !rebuild && lines != null;
		var yMin = 0.;
		var t = splitText(text);
		for( i in 0...t.length ) {
			var cc = t.charCodeAt(i);
			var e = font.getChar(cc);
			var offs = e.getKerningOffset(prevChar);
			var esize = e.width + offs;
			// if the next word goes past the max width, change it into a newline

			if( cc == '\n'.code ) {
				if( x > xMax ) xMax = x;
				if( calcLines ) lines.push(Math.ceil(x));
				switch( align ) {
				case Left:
					x = 0;
				case Right, Center, MultilineCenter, MultilineRight:
					x = lines.shift();
					if( x < xMin ) xMin = x;
				}
				y += dl;
				prevChar = -1;
			} else {
				if( e != null ) {
					if( rebuild ) glyphs.add(x + offs, y, e.t);
					if( y == 0 && e.t.dy < yMin ) yMin = e.t.dy;
					x += esize + letterSpacing;
				}
				prevChar = cc;
			}
		}
		if( calcLines ) lines.push(Math.ceil(x));
		if( x > xMax ) xMax = x;

		calcXMin = xMin;
		calcYMin = yMin;
		calcWidth = xMax - xMin;
		calcHeight = y + font.lineHeight;
		calcSizeHeight = y + (font.baseLine > 0 ? font.baseLine : font.lineHeight);
		calcDone = true;
	}

	inline function updateSize() {
		if( !calcDone ) initGlyphs(text, false);
	}

	function get_textHeight() {
		updateSize();
		return calcHeight;
	}

	function get_textWidth() {
		updateSize();
		return calcWidth;
	}

	function set_maxWidth(w) {
		if( maxWidth == w ) return w;
		maxWidth = w;
		updateConstraint();
		return w;
	}

	function updateConstraint() {
		var old = realMaxWidth;
		if( maxWidth == null )
			realMaxWidth = constraintWidth;
		else if( constraintWidth < 0 )
			realMaxWidth = maxWidth;
		else
			realMaxWidth = hxd.Math.min(maxWidth, constraintWidth);
		if( realMaxWidth != old )
			rebuild();
	}

	function set_textColor(c) {
		if( this.textColor == c ) return c;
		this.textColor = c;
		var a = color.w;
		color.setColor(c);
		color.w = a;
		return c;
	}

	override function getBoundsRec( relativeTo : Object, out : h2d.col.Bounds, forSize : Bool ) {
		super.getBoundsRec(relativeTo, out, forSize);
		updateSize();
		var x, y, w : Float, h;
		if ( forSize ) {
			x = calcXMin;  // TODO: Should be 0 as well for consistency, but currently causes problems with Flows
			y = 0.;
			w = calcWidth;
			h = calcSizeHeight;
		} else {
			x = calcXMin;
			y = calcYMin;
			w = calcWidth;
			h = calcHeight - calcYMin;
		}
		addBounds(relativeTo, out, x, y, w, h);
	}

}
