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
	public var text(default, set) : hxd.UString;
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

	function set_text(t : hxd.UString) {
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

	public function calcTextWidth( text : hxd.UString ) {
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

	/**
		Word-wrap the text based on this Text settings.  
		@param text String to word-wrap.
		@param leftMargin Starting x offset of the first line.
		@param afterData Minimum remaining space required at the end of the line.
		@param font Optional overriding font to use instead of currently set.
		@param sizes Optional line width array. Will be populated with sizes of split lines if present. Sizes will include both `leftMargin` in it's first line entry.
		@param prevChar Optional character code for concatenation purposes (proper kernings).
	**/
	public function splitText( text : hxd.UString, leftMargin = 0., afterData = 0., ?font : Font, ?sizes:Array<Float>, ?prevChar:Int = -1 ) {
		var maxWidth = realMaxWidth;
		if( maxWidth < 0 ) {
			if ( sizes == null ) 
				return text;
			else 
				maxWidth = Math.POSITIVE_INFINITY;
		}
		if ( font == null ) font = this.font;
		var lines = [], restPos = 0;
		var x = leftMargin;
		for( i in 0...text.length ) {
			var cc = text.charCodeAt(i);
			var e = font.getChar(cc);
			var newline = cc == '\n'.code;
			var esize = e.width + e.getKerningOffset(prevChar);
			if( font.charset.isBreakChar(cc) ) {
				if( lines.length == 0 && leftMargin > 0 && x > maxWidth ) {
					lines.push("");
					if ( sizes != null ) sizes.push(leftMargin);
					x -= leftMargin;
				}
				var size = x + esize + letterSpacing; /* TODO : no letter spacing */
				var k = i + 1, max = text.length;
				var prevChar = prevChar;
				var breakFound = false;
				while( size <= maxWidth && k < max ) {
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
				if( size > maxWidth || (!breakFound && size + afterData > maxWidth) ) {
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
			if( e != null && cc != '\n'.code )
				x += esize + letterSpacing;
			if( newline ) {
				if ( sizes != null ) sizes.push(x);
				x = 0;
				prevChar = -1;
			} else
				prevChar = cc;
		}
		if( restPos < text.length ) {
			if( lines.length == 0 && leftMargin > 0 && x + afterData - letterSpacing > maxWidth ) {
				lines.push("");
				if ( sizes != null ) sizes.push(leftMargin);
				x -= leftMargin;
			}
			lines.push(text.substr(restPos, text.length - restPos));
			if ( sizes != null ) sizes.push(x);
		}
		return lines.join("\n");
	}

	function initGlyphs( text : hxd.UString, rebuild = true ) : Void {
		if( rebuild ) glyphs.clear();
		var x = 0., y = 0., xMax = 0., xMin = 0., yMin = 0., prevChar = -1, linei = 0;
		var align = textAlign;
		var lines = new Array<Float>();
		var dl = font.lineHeight + lineSpacing;
		var t = splitText(text, 0, 0, lines);

		for ( lw in lines ) {
			if ( lw > x ) x = lw;
		}
		calcWidth = x;

		switch( align ) {
		case Center, Right, MultilineCenter, MultilineRight:
			var max = if( align == MultilineCenter || align == MultilineRight ) hxd.Math.ceil(calcWidth) else realMaxWidth < 0 ? 0 : hxd.Math.ceil(realMaxWidth);
			var k = align == Center || align == MultilineCenter ? 0.5 : 1;
			for( i in 0...lines.length )
				lines[i] = Math.ffloor((max - lines[i]) * k);
			x = lines[0];
			xMin = x;
		case Left:
			x = 0;
		}
		
		for( i in 0...t.length ) {
			var cc = t.charCodeAt(i);
			var e = font.getChar(cc);
			var offs = e.getKerningOffset(prevChar);
			var esize = e.width + offs;
			// if the next word goes past the max width, change it into a newline

			if( cc == '\n'.code ) {
				if( x > xMax ) xMax = x;
				switch( align ) {
				case Left:
					x = 0;
				case Right, Center, MultilineCenter, MultilineRight:
					x = lines[++linei];
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
			x = realMaxWidth >= 0 ? 0 : calcXMin;
			y = calcYMin;
			w = realMaxWidth >= 0 ? realMaxWidth : calcWidth;
			h = calcHeight - calcYMin;
		}
		addBounds(relativeTo, out, x, y, w, h);
	}

}
