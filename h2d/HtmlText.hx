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
		var f = defaultLoadFont(name);
		if (f == null) return this.font;
		else return f;
	}

	function parseText( text : String ) {
		return try Xml.parse(text) catch( e : Dynamic ) throw "Could not parse " + text + " (" + e +")";
	}

	override function initGlyphs( text : String, rebuild = true ) {
		if( rebuild ) {
			glyphs.clear();
			for( e in elements ) e.remove();
			elements = [];
		}
		glyphs.setDefaultColor(textColor);

		var doc = parseText(text);
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
		var splitNode : SplitNode = { node: null, pos: 0, width: 0, font: font, prevChar: -1 };
		for( e in doc )
			buildSizes(e, font, sizes, heights, baseLines, splitNode);

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

	function buildSizes( e : Xml, font : Font, lines : Array<Float>, heights : Array<Float>, baseLines : Array<Float>, splitNode:SplitNode ) {
		inline function wordSplit() {
			var fnt = splitNode.font;
			var str = splitNode.node.nodeValue;
			var w = lines[lines.length - 1];
			var cc = str.charCodeAt(splitNode.pos);
			lines[lines.length - 1] = splitNode.width;
			if (fnt.charset.isSpace(cc)) {
				// Space characters are converted to \n
				var char = fnt.getChar(cc);
				w -= (splitNode.width + letterSpacing + char.width + char.getKerningOffset(splitNode.prevChar));
				splitNode.node.nodeValue = str.substr(0, splitNode.pos) + "\n" + str.substr(splitNode.pos + 1);
			} else {
				w -= splitNode.width;
				splitNode.node.nodeValue = str.substr(0, splitNode.pos) + str.substr(splitNode.pos);
			}
			splitNode.node = null;
			return w;
		}

		if( e.nodeType == Xml.Element ) {

			inline function makeLineBreak() {
				var fontInfo = lineHeightMode == Constant ? this.font : font;
				lines.push(0);
				heights.push(fontInfo.lineHeight);
				baseLines.push(fontInfo.baseLine);
				splitNode.node = null;
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
					if ( splitNode.node != null ) {
						size = wordSplit() + i.width + letterSpacing;
						lines.push(size);
						// Bug: height/baseLine may be innacurate in case of sizeA sizeB<split>sizeA where sizeB is larger.
						var height = heights[heights.length - 1];
						var base = baseLines[baseLines.length - 1];
						switch ( lineHeightMode ) {
							case Accurate:
								// todo: Proper grow
								heights.push(Math.max(height, i.height));
								baseLines.push(Math.max(base, i.height));
							default:
								heights.push(height);
								baseLines.push(height);
						}
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
			case "b", "bold":
				font = loadFont("bold");
			case "i", "italic":
				font = loadFont("italic");
			default:
			}
			for( child in e )
				buildSizes(child, font, lines, heights, baseLines, splitNode);
			switch( nodeName ) {
			case "p":
				if ( !newLine ) {
					makeLineBreak();
				}
			default:
			}
		} else {
			newLine = false;
			var text = htmlToText(e.nodeValue);
			var leftMargin = lines.length == 0 ? 0 : lines.pop();
			var maxWidth = realMaxWidth < 0 ? Math.POSITIVE_INFINITY : realMaxWidth;
			var textSplit = [], restPos = 0;
			var x = leftMargin;
			for ( i in 0...text.length ) {
				var cc = text.charCodeAt(i);
				var g = font.getChar(cc);
				var newline = cc == '\n'.code;
				var esize = g.width + g.getKerningOffset(prevChar);
				if ( font.charset.isBreakChar(cc) ) {
					if (x > maxWidth && textSplit.length == 0) {
						if ( splitNode.node != null ) {
							lines.push(x);
							heights.push(heights[heights.length - 1]);
							baseLines.push(baseLines[baseLines.length - 1]);
							x = wordSplit();
						} else if (leftMargin != 0) { // Don't insert empty line when it's first word in the line.
							x -= leftMargin;
							textSplit.push("");
							lines.push(leftMargin);
						}
					}

					var size = x + esize + letterSpacing;
					var k = i + 1, max = text.length;
					var prevChar = prevChar;
					var breakFound = false;
					while ( size <= maxWidth && k < max ) {
						var cc = text.charCodeAt(k++);
						if ( font.charset.isSpace(cc) || cc == '\n'.code ) {
							breakFound = true;
							break;
						}
						var e = font.getChar(cc);
						size += e.width + letterSpacing + e.getKerningOffset(prevChar);
						prevChar = cc;
						if ( font.charset.isBreakChar(cc) ) break;
					}
					if ( size > maxWidth || (!breakFound && size > maxWidth) ) {
						newline = true;
						if ( font.charset.isSpace(cc) ) {
							textSplit.push(text.substr(restPos, i - restPos));
							g = null;
						} else {
							textSplit.push(text.substr(restPos, i + 1 - restPos));
						}
						splitNode.node = null;
						restPos = i + 1;
					} else {
						splitNode.node = e;
						splitNode.pos = i;
						splitNode.prevChar = this.prevChar;
						splitNode.width = x;
						splitNode.font = font;
					}
				}
				if ( g != null && cc != '\n'.code )
					x += esize + letterSpacing;
				if ( newline ) {
					lines.push(x);
					x = 0;
					prevChar = -1;
					newLine = true;
				} else {
					prevChar = cc;
					newLine = false;
				}
			}
			if ( restPos < text.length ) {
				if (x > maxWidth) {
					if ( splitNode.node != null && splitNode.node != e ) {
						lines.push(x);
						heights.push(heights[heights.length - 1]);
						baseLines.push(baseLines[baseLines.length - 1]);
						x = wordSplit();
					}
				}
				textSplit.push(text.substr(restPos));
				lines.push(x);
			}

			if ( lineHeightMode == Constant ) {
				while ( heights.length < lines.length ) {
					heights.push( this.font.lineHeight );
					baseLines.push( this.font.lineHeight );
				}
				if (newLine) {
					lines.push(0);
					heights.push(this.font.lineHeight);
					baseLines.push(this.font.baseLine);
					textSplit.push("");
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
				if (newLine) {
					lines.push(0);
					heights.push(font.lineHeight);
					baseLines.push(font.baseLine);
					textSplit.push("");
				}
			}
			// Save node value
			e.nodeValue = textSplit.join("\n");
		}
	}

	static var REG_SPACES = ~/[\r\n\t ]+/g;
	function htmlToText( t : String )  {
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

	override function splitText(text:String):String {
		if( realMaxWidth < 0 )
			return text;
		yPos = 0;
		xMax = 0;
		sizePos = 0;
		calcYMin = 0;

		var doc = parseText(text);

		/*
			This might require a global refactoring at some point.
			We would need a way to somehow build an AST from the XML representation
			with all sizes and word breaks so analysis is much more easy.
		*/

		var splitNode : SplitNode = { node: null, font: font, width: 0, pos: 0, prevChar: -1 };
		var sizes = new Array<Float>();
		prevChar = -1;
		newLine = true;

		for( e in doc )
			buildSizes(e, font, sizes, [], [], splitNode);
		xMax = 0;
		function addBreaks( e : Xml ) {
			if( e.nodeType == Xml.Element ) {
				for( x in e )
					addBreaks(x);
			} else {
				var text = e.nodeValue;
				var startI = 0;
				var index = Lambda.indexOf(e.parent, e);
				for (i in 0...text.length) {
					if (text.charCodeAt(i) == '\n'.code) {
						var pre = text.substring(startI, i - 1);
						if (pre != "") e.parent.insertChild(Xml.createPCData(pre), index++);
						e.parent.insertChild(Xml.createElement("br"),index++);
						startI = i+1;
					}
				}
				if (startI < text.length) {
					e.nodeValue = text.substr(startI);
				} else {
					e.parent.removeChild(e);
				}
			}
		}
		for( d in doc )
			addBreaks(d);
		return doc.toString();
	}

	override function getTextProgress(text:String, progress:Float):String {
		if( progress >= text.length )
			return text;
		var doc = parseText(text);
		function progressRec(e:Xml) {
			if( progress <= 0 ) {
				e.parent.removeChild(e);
				return;
			}
			if( e.nodeType == Xml.Element ) {
				for( x in [for( x in e ) x] )
					progressRec(x);
			} else {
				var text = htmlToText(e.nodeValue);
				if( text.length > progress ) {
					text = text.substr(0, Std.int(progress));
					e.nodeValue = text;
				}
				progress -= text.length;
			}
		}
		for( x in [for( x in doc ) x] )
			progressRec(x);
		return doc.toString();
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
			inline function setFont( v : String ) {
				font = loadFont(v);
				if( prevGlyphs == null ) prevGlyphs = glyphs;
				var prev = glyphs;
				glyphs = new TileGroup(font == null ? null : font.tile, this);
				if ( font != null ) {
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
				}
				@:privateAccess glyphs.curColor.load(prev.curColor);
				elements.push(glyphs);
			}
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
						setFont(v);
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
			case "b","bold":
				setFont("bold");
			case "i","italic":
				setFont("italic");
			case "br":
				makeLineBreak();
				newLine = true;
				prevChar = -1;
			case "img":
				var i : Tile = imageCache.get(e.get("src"));
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

private typedef SplitNode = {
	var node : Xml;
	var prevChar : Int;
	var pos : Int;
	var width : Float;
	var font : h2d.Font;
}