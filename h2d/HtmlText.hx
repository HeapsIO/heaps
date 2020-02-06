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

	/**
		A default method HtmlText uses to format assigned text.
	**/
	public static dynamic function defaultFormatText( text : String ) : String {
		return text;
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

	public dynamic function formatText( text : String ) : String {
		return defaultFormatText(text);
	}

	override function set_text(t : String) {
		super.set_text(formatText(t));
		return t;
	}

	function parseText( text : String ) {
		return try Xml.parse(text) catch( e : Dynamic ) throw "Could not parse " + text + " (" + e +")";
	}

	inline function makeLineInfo( width : Float, height : Float, baseLine : Float ) : LineInfo {
		return { width: width, height: height, baseLine: baseLine };
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

		var metrics : Array<LineInfo> = [ makeLineInfo(0, font.lineHeight, font.baseLine) ];
		prevChar = -1;
		newLine = true;
		var splitNode : SplitNode = {
			node: null, pos: 0, font: font, prevChar: -1,
			width: 0, height: 0, baseLine: 0
		};
		for( e in doc )
			buildSizes(e, font, metrics, splitNode);

		var max = 0.;
		for ( info in metrics ) {
			if ( info.width > max ) max = info.width;
		}
		calcWidth = max;

		prevChar = -1;
		newLine = true;
		nextLine(textAlign, metrics[0].width);
		for ( e in doc )
			addNode(e, font, textAlign, rebuild, metrics);

		if( xPos > xMax ) xMax = xPos;

		imageCache = null;
		var y = yPos;
		calcXMin = xMin;
		calcWidth = xMax - xMin;
		calcHeight = y + metrics[sizePos].height;
		calcSizeHeight = y + metrics[sizePos].baseLine;//(font.baseLine > 0 ? font.baseLine : font.lineHeight);
		calcDone = true;
	}

	function buildSizes( e : Xml, font : Font, metrics : Array<LineInfo>, splitNode:SplitNode ) {
		function wordSplit() {
			var fnt = splitNode.font;
			var str = splitNode.node.nodeValue;
			var info = metrics[metrics.length - 1];
			var w = info.width;
			var cc = str.charCodeAt(splitNode.pos);
			// Restore line metrics to ones before split.
			// Potential bug: `Text<split> [Image] text<split>text` - third line will use metrics as if image is present in the line.
			info.width = splitNode.width;
			info.height = splitNode.height;
			info.baseLine = splitNode.baseLine;
 			var char = fnt.getChar(cc);
			if (fnt.charset.isSpace(cc)) {
				// Space characters are converted to \n
				w -= (splitNode.width + letterSpacing + char.width + char.getKerningOffset(splitNode.prevChar));
				splitNode.node.nodeValue = str.substr(0, splitNode.pos) + "\n" + str.substr(splitNode.pos + 1);
			} else {
				w -= (splitNode.width + letterSpacing + char.getKerningOffset(splitNode.prevChar));
				splitNode.node.nodeValue = str.substr(0, splitNode.pos+1) + "\n" + str.substr(splitNode.pos+1);
			}
			splitNode.node = null;
			return w;
		}
		inline function lineFont() {
			return lineHeightMode == Constant ? this.font : font;
		}
		if( e.nodeType == Xml.Element ) {

			inline function makeLineBreak() {
				var fontInfo = lineFont();
				metrics.push(makeLineInfo(0, fontInfo.lineHeight, fontInfo.baseLine));
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

				var size = metrics[metrics.length - 1].width + i.width + letterSpacing;
				if (realMaxWidth >= 0 && size > realMaxWidth && metrics[metrics.length - 1].width > 0) {
					if ( splitNode.node != null ) {
						size = wordSplit() + i.width + letterSpacing;
						var info = metrics[metrics.length - 1];
						// Bug: height/baseLine may be innacurate in case of sizeA sizeB<split>sizeA where sizeB is larger.
						switch ( lineHeightMode ) {
							case Accurate:
								var grow = i.height - i.dy - info.baseLine;
								var h = info.height;
								var bl = info.baseLine;
								if (grow > 0) {
									h += grow;
									bl += grow;
								}
								metrics.push(makeLineInfo(size, Math.max(h, bl + i.dy), bl));
							default:
								metrics.push(makeLineInfo(size, info.height, info.baseLine));
						}
					}
				} else {
					var info = metrics[metrics.length - 1];
					info.width = size;
					if ( lineHeightMode == Accurate ) {
						var grow = i.height - i.dy - info.baseLine;
						if ( grow > 0 ) {
							info.baseLine += grow;
							info.height += grow;
						}
						grow = info.baseLine + i.dy;
						if ( info.height < grow ) info.height = grow;
					}
				}
				newLine = false;
				prevChar = -1;
			case "font":
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
				buildSizes(child, font, metrics, splitNode);
			switch( nodeName ) {
			case "p":
				if ( !newLine ) {
					makeLineBreak();
				}
			default:
			}
		} else if (e.nodeValue.length != 0) {
			newLine = false;
			var text = htmlToText(e.nodeValue);
			var fontInfo = lineFont();
			var info : LineInfo = metrics.pop();
			var leftMargin = info.width;
			var maxWidth = realMaxWidth < 0 ? Math.POSITIVE_INFINITY : realMaxWidth;
			var textSplit = [], restPos = 0;
			var x = leftMargin;
			var breakChars = 0;
			for ( i in 0...text.length ) {
				var cc = text.charCodeAt(i);
				var g = font.getChar(cc);
				var newline = cc == '\n'.code;
				var esize = g.width + g.getKerningOffset(prevChar);
				if ( font.charset.isBreakChar(cc) ) {
					// Case: Very first word in text makes the line too long hence we want to start it off on a new line.
					if (x > maxWidth && textSplit.length == 0 && splitNode.node != null) {
						metrics.push(makeLineInfo(x, info.height, info.baseLine));
						x = wordSplit();
					}

					var size = x + esize + letterSpacing;
					var k = i + 1, max = text.length;
					var prevChar = prevChar;
					while ( size <= maxWidth && k < max ) {
						var cc = text.charCodeAt(k++);
						if ( font.charset.isSpace(cc) || cc == '\n'.code ) break;
						var e = font.getChar(cc);
						size += e.width + letterSpacing + e.getKerningOffset(prevChar);
						prevChar = cc;
						if ( font.charset.isBreakChar(cc) ) break;
					}
					// Avoid empty line when last char causes line-break while being CJK
					if ( size > maxWidth && i != max - 1 ) {
						// Next word will reach maxWidth
						newline = true;
						if ( font.charset.isSpace(cc) ) {
							textSplit.push(text.substr(restPos, i - restPos));
							g = null;
						} else {
							textSplit.push(text.substr(restPos, i + 1 - restPos));
							breakChars++;
						}
						splitNode.node = null;
						restPos = i + 1;
					} else {
						splitNode.node = e;
						splitNode.pos = i + breakChars;
						splitNode.prevChar = this.prevChar;
						splitNode.width = x;
						splitNode.height = info.height;
						splitNode.baseLine = info.baseLine;
						splitNode.font = font;
					}
				}
				if ( g != null && cc != '\n'.code )
					x += esize + letterSpacing;
				if ( newline ) {
					metrics.push(makeLineInfo(x, info.height, info.baseLine));
					info.height = fontInfo.lineHeight;
					info.baseLine = fontInfo.baseLine;
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
						metrics.push(makeLineInfo(x, info.height, info.baseLine));
						x = wordSplit();
					}
				}
				textSplit.push(text.substr(restPos));
				metrics.push(makeLineInfo(x, info.height, info.baseLine));
			}

			if (newLine || metrics.length == 0) {
				metrics.push(makeLineInfo(0, fontInfo.lineHeight, fontInfo.baseLine));
				textSplit.push("");
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

		var splitNode : SplitNode = { node: null, font: font, width: 0, height: 0, baseLine: 0, pos: 0, prevChar: -1 };
		var metrics = [makeLineInfo(0, font.lineHeight, font.baseLine)];
		prevChar = -1;
		newLine = true;

		for( e in doc )
			buildSizes(e, font, metrics, splitNode);
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
						var pre = text.substring(startI, i);
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
				var len = text.length;
				if( len > progress ) {
					text = text.substr(0, Std.int(progress));
					e.nodeValue = text;
				}
				progress -= len;
			}
		}
		for( x in [for( x in doc ) x] )
			progressRec(x);
		return doc.toString();
	}

	function addNode( e : Xml, font : Font, align : Align, rebuild : Bool, metrics : Array<LineInfo> ) {
		inline function makeLineBreak()
		{
			if( xPos > xMax ) xMax = xPos;
			yPos += metrics[sizePos].height + lineSpacing;
			nextLine(align, metrics[++sizePos].width);
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
					nextLine(align, metrics[sizePos].width);
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
				var py = yPos + metrics[sizePos].baseLine - i.height;
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
				addNode(child, font, align, rebuild, metrics);
			align = oldAlign;
			switch( nodeName ) {
			case "p":
				if ( newLine ) {
					nextLine(align, metrics[sizePos].width);
				} else if ( sizePos < metrics.length - 2 || metrics[sizePos + 1].width != 0 ) {
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
		} else if (e.nodeValue.length != 0) {
			newLine = false;
			var t = e.nodeValue;
			var dy = metrics[sizePos].baseLine - font.baseLine;
			for( i in 0...t.length ) {
				var cc = t.charCodeAt(i);
				if( cc == "\n".code ) {
					makeLineBreak();
					dy = metrics[sizePos].baseLine - font.baseLine;
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

private typedef LineInfo = {
	var width : Float;
	var height : Float;
	var baseLine : Float;
}

private typedef SplitNode = {
	var node : Xml;
	var prevChar : Int;
	var pos : Int;
	var width : Float;
	var height : Float;
	var baseLine : Float;
	var font : h2d.Font;
}