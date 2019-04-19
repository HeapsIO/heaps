package h2d;

import h2d.Text;

enum LineHeightMode {
	/**
		Accurate line height calculations. Each line will adjust it's height according to it's contents.
	**/
	Accurate;
	/**
		Only text adjusts line heights, and `<img>` tags do not affect it (partial legacy behavior).
	**/
	TextOnly;
	/**
		Legacy line height mode. When used, line heights are remain constant based on `HtmlText.font` variable.
	**/
	Constant;
}

class HtmlText extends Text {

	/**
		A default method HtmlText uses to load images for `<img>` tag. See `HtmlText.loadImage` for details.
	**/
	public static dynamic function defaultLoadImage( url : String ) : h2d.Tile {
		return null;
	}

	/**
		A default method HtmlText uses to load fonts for `<font>` tags with `face` attribute. See `HtmlText.loadFont` for details.
	**/
	public static dynamic function defaultLoadFont( name : String ) : h2d.Font {
		return null;
	}

	public var condenseWhite(default,set) : Bool = true;

	/**
		Line height calculation mode controls how much space lines take up vertically. ( default : Accurate )  
		Changing mode to `Constant` restores legacy behavior of HtmlText.
	**/
	public var lineHeightMode(default,set) : LineHeightMode = Accurate;

	var elements : Array<Object> = [];
	var xPos : Float;
	var yPos : Float;
	var xMax : Float;
	var xMin : Float;
	var imageCache : Map<String, Tile>;
	var sizePos : Int;
	var dropMatrix : h3d.shader.ColorMatrix;
	var prevChar : Int;
	var newLine : Bool;

	override function draw(ctx:RenderContext) {
		if( dropShadow != null ) {
			var oldX = absX, oldY = absY;
			absX += dropShadow.dx * matA + dropShadow.dy * matC;
			absY += dropShadow.dx * matB + dropShadow.dy * matD;
			if( dropMatrix == null )
				dropMatrix = new h3d.shader.ColorMatrix();
			addShader(dropMatrix);
			var m = dropMatrix.matrix;
			m.zero();
			m._41 = ((dropShadow.color >> 16) & 0xFF) / 255;
			m._42 = ((dropShadow.color >> 8) & 0xFF) / 255;
			m._43 = (dropShadow.color & 0xFF) / 255;
			m._44 = dropShadow.alpha;
			glyphs.drawWith(ctx, this);
			removeShader(dropMatrix);
			absX = oldX;
			absY = oldY;
		} else
			dropMatrix = null;
		glyphs.drawWith(ctx,this);
	}

	/**
		Method that should return `h2d.Tile` instance for `<img>` tags. By default calls `HtmlText.defaultLoadImage` method.  
		Loaded Tiles are temporary cached internally and if text contains multiple same images - this method will be called only once. Cache is invalidated whenever text changes.
		@param url A value contained in `src` attribute.
	**/
	public dynamic function loadImage( url : String ) : Tile {
		return defaultLoadImage(url);
	}

	/**
		Method that should return `h2d.Font` instance for `<font>` tags with `face` attribute. By default calls `HtmlText.defaultLoadFont` method.  
		HtmlText does not cache font instances and it's recommended to perform said caching from outside.
		@param name A value contained in `face` attribute.
		@returns Method should return loaded font instance or `null`. If `null` is returned - currently active font is used.
	**/
	public dynamic function loadFont( name : String ) : Font {
		return defaultLoadFont(name);
	}

	override function initGlyphs( text : String, rebuild = true ) {
		if( rebuild ) {
			glyphs.clear();
			for( e in elements ) e.remove();
			elements = [];
		}
		glyphs.setDefaultColor(textColor);

		var doc = try Xml.parse(text) catch( e : Dynamic ) throw "Could not parse " + text + " (" + e +")";
		imageCache = new Map();

		yPos = 0;
		xMax = 0;
		xMin = Math.POSITIVE_INFINITY;
		sizePos = 0;
		calcYMin = 0;

		var sizes = new Array<Float>();
		var heights = [0.];
		var baseLines = [0.];
		prevChar = -1;
		newLine = true;
		for( e in doc )
			buildSizes(e, font, sizes, heights, baseLines);

		var max = 0.;
		for ( lw in sizes ) {
			if ( lw > max ) max = lw;
		}
		calcWidth = max;

		prevChar = -1;
		newLine = true;
		nextLine(textAlign, sizes[0]);
		for ( e in doc )
			addNode(e, font, textAlign, rebuild, sizes, heights, baseLines);
		
		if( xPos > xMax ) xMax = xPos;

		imageCache = null;
		var y = yPos;
		calcXMin = xMin;
		calcWidth = xMax - xMin;
		calcHeight = y + heights[sizePos];
		calcSizeHeight = y + baseLines[sizePos];//(font.baseLine > 0 ? font.baseLine : font.lineHeight);
		calcDone = true;
	}

	function buildSizes( e : Xml, font : Font, lines : Array<Float>, heights : Array<Float>, baseLines : Array<Float> ) {
		if( e.nodeType == Xml.Element ) {

			inline function makeLineBreak() {
				var fontInfo = lineHeightMode == Constant ? this.font : font;
				lines.push(0);
				heights.push(fontInfo.lineHeight);
				baseLines.push(fontInfo.baseLine);
				newLine = true;
				prevChar = -1;
			}

			var nodeName = e.nodeName.toLowerCase();
			switch( nodeName ) {
			case "p":
				if ( !newLine ) {
					makeLineBreak();
				}
			case "br":
				makeLineBreak();
			case "img":
				// TODO: Support width/height attributes
				// Support max-width/max-height attributes (downscale)
				// Support min-width/min-height attributes (upscale)
				var src = e.get("src");
				var i : Tile = imageCache.get(src);
				if ( i == null ) {
					i = loadImage(src);
					if( i == null ) i = Tile.fromColor(0xFF00FF, 8, 8);
					imageCache.set(src, i);
				}
				if ( lines.length == 0 ) lines.push(0);

				var size = lines[lines.length - 1] + i.width + letterSpacing;
				if (realMaxWidth >= 0 && size > realMaxWidth && lines[lines.length - 1] > 0) {
					lines.push(i.width);
					switch ( lineHeightMode ) {
						case Accurate:
							heights.push(i.height);
							baseLines.push(i.height);
						case TextOnly:
							heights.push(font.lineHeight);
							baseLines.push(font.baseLine);
						case Constant:
							heights.push(this.font.lineHeight);
							baseLines.push(this.font.baseLine);
					}
				} else {
					lines[lines.length - 1] = size;
					if ( lineHeightMode == Accurate ) {
						var idx = heights.length - 1;
						var grow = i.height - i.dy - baseLines[idx];
						if ( grow > 0 ) {
							baseLines[idx] += grow;
							heights[idx] += grow;
						}
						grow = baseLines[idx] + i.dy;
						if ( heights[idx] < grow ) heights[idx] = grow;
					}
				}
				newLine = false;
				prevChar = -1;
			case "font":
				var size : Null<Int> = null;
				for( a in e.attributes() ) {
					var v = e.get(a);
					switch( a.toLowerCase() ) {
					case "face": font = loadFont(v);
					default:
					}
				}
			default:
			}
			for( child in e )
				buildSizes(child, font, lines, heights, baseLines);
			switch( nodeName ) {
			case "p":
				if ( !newLine ) {
					makeLineBreak();
				}
			default:
			}
		} else {
			newLine = false;
			var text = splitText(htmlToText(e.nodeValue), lines.length == 0 ? 0 : lines.pop(), 0, font, lines, prevChar);
			if ( text.length > 0 ) {
				var lastChar = text.charCodeAt(text.length - 1);
				prevChar = lastChar == "\n".code ? -1 : lastChar;
			}
			if ( lineHeightMode == Constant ) {
				while ( heights.length < lines.length ) {
					heights.push( this.font.lineHeight );
					baseLines.push( this.font.lineHeight );
				}
			} else {
				// TODO: Should adjust lineHeight in offset to bottom of baseLine.
				var idx = heights.length - 1;
				if ( heights[idx] < font.lineHeight )
					heights[idx] = font.lineHeight;
				if ( baseLines[idx] < font.baseLine )
					baseLines[idx] = font.baseLine;
				while ( heights.length < lines.length ) {
					heights.push(font.lineHeight);
					baseLines.push(font.baseLine);
				}
			}
				
			// Save node value
			e.nodeValue = text;
		}
	}

	static var REG_SPACES = ~/[\r\n\t ]+/g;
	function htmlToText( t : hxd.UString )  {
		if (condenseWhite)
			t = REG_SPACES.replace(t, " ");
		return t;
	}

	inline function nextLine( align : Align, size : Float )
	{
		switch( align ) {
			case Left:
				xPos = 0;
				if (xMin > 0) xMin = 0;
			case Right, Center, MultilineCenter, MultilineRight:
				var max = if( align == MultilineCenter || align == MultilineRight ) hxd.Math.ceil(calcWidth) else calcWidth < 0 ? 0 : hxd.Math.ceil(realMaxWidth);
				var k = align == Center || align == MultilineCenter ? 0.5 : 1;
				xPos = Math.ffloor((max - size) * k);
				if( xPos < xMin ) xMin = xPos;
		}
	}

	function addNode( e : Xml, font : Font, align : Align, rebuild : Bool, sizes : Array<Float>, heights : Array<Float>, baseLines : Array<Float> ) {
		inline function makeLineBreak()
		{
			if( xPos > xMax ) xMax = xPos;
			yPos += heights[sizePos] + lineSpacing;
			nextLine(align, sizes[++sizePos]);
		}
		if( e.nodeType == Xml.Element ) {
			var prevColor = null, prevGlyphs = null;
			var oldAlign = align;
			var nodeName = e.nodeName.toLowerCase();
			switch( nodeName ) {
			case "font":
				for( a in e.attributes() ) {
					var v = e.get(a);
					switch( a.toLowerCase() ) {
					case "color":
						if( prevColor == null ) prevColor = @:privateAccess glyphs.curColor.clone();
						if( v.charCodeAt(0) == '#'.code && v.length == 4 )
							v = "#" + v.charAt(1) + v.charAt(1) + v.charAt(2) + v.charAt(2) + v.charAt(3) + v.charAt(3);
						glyphs.setDefaultColor(Std.parseInt("0x" + v.substr(1)));
					case "opacity":
						if( prevColor == null ) prevColor = @:privateAccess glyphs.curColor.clone();
						@:privateAccess glyphs.curColor.a *= Std.parseFloat(v);
					case "face":
						font = loadFont(v);
						if ( font != null ) {
							if( prevGlyphs == null ) prevGlyphs = glyphs;
							var prev = glyphs;
							glyphs = new TileGroup(font.tile, this);
							switch( font.type ) {
								case SignedDistanceField(channel, alphaCutoff, smoothing):
									var shader = new h3d.shader.SignedDistanceField();
									shader.channel = channel;
									shader.alphaCutoff = alphaCutoff;
									shader.smoothing = smoothing;
									glyphs.smooth = true;
									glyphs.addShader(shader);
								default:
							}
							@:privateAccess glyphs.curColor.load(prev.curColor);
							elements.push(glyphs);
						}
					default:
					}
				}
			case "p":
				for( a in e.attributes() ) {
					switch( a.toLowerCase() ) {
						case "align":
							var v = e.get(a);
							if ( v != null )
							switch( v.toLowerCase() ) {
							case "left":
								align = Left;
							case "center":
								align = Center;
							case "right":
								align = Right;
							case "multiline-center":
								align = MultilineCenter;
							case "multiline-right":
								align = MultilineRight;
							//?justify
							}
						default:
					}
				}
				if ( !newLine ) {
					makeLineBreak();
					newLine = true;
					prevChar = -1;
				} else {
					nextLine(align, sizes[sizePos]);
				}
			case "br":
				makeLineBreak();
				newLine = true;
				prevChar = -1;
			case "img":
				var i : Tile = imageCache.get(e.get("src"));
				if( realMaxWidth >= 0 && xPos + i.width + letterSpacing > realMaxWidth && xPos > 0 ) {
					makeLineBreak();
				}
				var py = yPos + baseLines[sizePos] - i.height;
				if( py + i.dy < calcYMin )
					calcYMin = py + i.dy;
				if( rebuild ) {
					var b = new Bitmap(i, this);
					b.x = xPos;
					b.y = py;
					elements.push(b);
				}
				newLine = false;
				prevChar = -1;
				xPos += i.width + letterSpacing;
			default:
			}
			for( child in e )
				addNode(child, font, align, rebuild, sizes, heights, baseLines);
			align = oldAlign;
			switch( nodeName ) {
			case "p":
				if ( newLine ) {
					nextLine(align, sizes[sizePos]);
				} else if ( sizePos < sizes.length - 2 || sizes[sizePos + 1] != 0 ) {
					// Condition avoid extra empty line if <p> was the last tag.
					makeLineBreak();
					newLine = true;
					prevChar = -1;
				}
			default:
			}
			if( prevGlyphs != null )
				glyphs = prevGlyphs;
			if( prevColor != null )
				@:privateAccess glyphs.curColor.load(prevColor);
		} else {
			newLine = false;
			var t = e.nodeValue;
			var dy = baseLines[sizePos] - font.baseLine;
			for( i in 0...t.length ) {
				var cc = t.charCodeAt(i);
				if( cc == "\n".code ) {
					makeLineBreak();
					dy = baseLines[sizePos] - font.baseLine;
					prevChar = -1;
					continue;
				}
				else {
					var fc = font.getChar(cc);
					if (fc != null) {
						xPos += fc.getKerningOffset(prevChar);
						if( rebuild ) glyphs.add(xPos, yPos + dy, fc.t);
						if( yPos == 0 && fc.t.dy+dy < calcYMin ) calcYMin = fc.t.dy + dy;
						xPos += fc.width + letterSpacing;
					}
					prevChar = cc;
				}
			}
		}
	}

	override function set_textColor(c) {
		if( this.textColor == c ) return c;
		this.textColor = c;
		rebuild();
		return c;
	}

	function set_condenseWhite(value: Bool) {
		if ( this.condenseWhite != value ) {
			this.condenseWhite = value;
			rebuild();
		}
		return value;
	}

	function set_lineHeightMode(v) {
		if ( this.lineHeightMode != v ) {
			this.lineHeightMode = v;
			rebuild();
		}
		return v;
	}

	override function getBoundsRec( relativeTo : Object, out : h2d.col.Bounds, forSize : Bool ) {
		if( forSize )
			for( i in elements )
				if( Std.is(i,h2d.Bitmap) )
					i.visible = false;
		super.getBoundsRec(relativeTo, out, forSize);
		if( forSize )
			for( i in elements )
				i.visible = true;
	}

}