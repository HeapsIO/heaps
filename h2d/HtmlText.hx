package h2d;

import h2d.Text;

class HtmlText extends Text {

	public var condenseWhite(default,set) : Bool = true;

	var elements : Array<Object> = [];
	var xPos : Float;
	var yPos : Float;
	var xMax : Float;
	var xMin : Float;
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

	public dynamic function loadImage( url : String ) : Tile {
		return null;
	}

	public dynamic function loadFont( name : String ) : Font {
		return font;
	}

	function parseText( text : String ) {
		return try Xml.parse(text) catch( e : Dynamic ) throw "Could not parse " + text + " (" + e +")";
	}

	override function initGlyphs( text : String, rebuild = true, handleAlign = true, ?lines : Array<Int> ) {
		if( rebuild ) {
			glyphs.clear();
			for( e in elements ) e.remove();
			elements = [];
		}
		glyphs.setDefaultColor(textColor);

		xPos = 0;
		xMin = 0;

		var align = handleAlign ? textAlign : Left;
		switch( align ) {
			case Center, Right, MultilineCenter, MultilineRight:
				lines = [];
				initGlyphs(text, false, false, lines);
				var max = if( align == MultilineCenter || align == MultilineRight ) hxd.Math.ceil(calcWidth) else realMaxWidth < 0 ? 0 : hxd.Math.ceil(realMaxWidth);
				var k = align == Center || align == MultilineCenter ? 1 : 0;
				for( i in 0...lines.length )
					lines[i] = (max - lines[i]) >> k;
				xPos = lines.shift();
				xMin = xPos;
			default:
		}

		yPos = 0;
		xMax = 0;
		sizePos = 0;
		calcYMin = 0;

		var doc = parseText(text);

		var sizes = new Array<Float>();
		prevChar = -1;
		newLine = true;
		for( e in doc )
			buildSizes(e, font, sizes, false);

		prevChar = -1;
		newLine = true;
		for( e in doc )
			addNode(e, font, rebuild, handleAlign, sizes, lines);

		if (!handleAlign && !rebuild && lines != null) lines.push(hxd.Math.ceil(xPos));
		if( xPos > xMax ) xMax = xPos;

		var y = yPos;
		calcXMin = xMin;
		calcWidth = xMax - xMin;
		calcHeight = y + font.lineHeight;
		calcSizeHeight = y + (font.baseLine > 0 ? font.baseLine : font.lineHeight);
		calcDone = true;
	}

	function buildSizes( e : Xml, font : Font, sizes : Array<Float>, forSplit ) {
		if( e.nodeType == Xml.Element ) {
			var len = 0.;
			var nodeName = e.nodeName.toLowerCase();
			switch( nodeName ) {
			case "p":
				if ( !newLine )
				{
					len = -1; // break
					newLine = true;
				}
			case "br":
				len = -1; // break
				newLine = true;
			case "img":
				var i = loadImage(e.get("src"));
				len = (i == null ? 8 : i.width) + letterSpacing;
				newLine = false;
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
			sizes.push(len);
			for( child in e )
				buildSizes(child, font, sizes, forSplit);
			switch( nodeName ) {
			case "p":
				sizes.push( -1);// break
				newLine = true;
			default:
			}
		} else {
			newLine = false;
			var text = htmlToText(e.nodeValue);
			var xp = 0.;
			for( i in 0...text.length ) {
				var cc = text.charCodeAt(i);
				var fc = font.getChar(cc);
				var sz = fc.getKerningOffset(prevChar) + fc.width;
				if( cc == "\n".code || font.charset.isBreakChar(cc) ) {
					if( cc != "\n".code && !font.charset.isSpace(cc) )
						xp += sz;
					if( !forSplit ) {
						sizes.push( -(xp + 1));
						return;
					}
					sizes.push(xp);
					if( font.charset.isSpace(cc) )
						sizes.push(sz);
					xp = 0;
					continue;
				}
				xp += sz + letterSpacing;
			}
			sizes.push(xp);
		}
	}

	static var REG_SPACES = ~/[\r\n\t ]+/g;
	function htmlToText( t : String )  {
		if (condenseWhite)
			t = REG_SPACES.replace(t, " ");
		return t;
	}

	function remainingSize( sizes : Array<Float> ) {
		var size = 0.;
		for( i in sizePos...sizes.length ) {
			var s = sizes[i];
			if( s < 0 ) {
				size += -s - 1;
				return size;
			}
			size += s;
		}
		return size;
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

		var sizes = new Array<Float>();
		prevChar = -1;
		newLine = true;
		for( e in doc )
			buildSizes(e, font, sizes, true);
		xMax = 0;
		function addBreaks( e : Xml ) {
			if( e.nodeType == Xml.Element ) {
				var sz = sizes[sizePos++];
				if( sz < 0 )
					xMax = 0;
				else
					xMax += sz;
				for( x in e )
					addBreaks(x);
				if( e.nodeName == "p" ) {
					sizePos++;
					xMax = 0;
				}
			} else {
				var text = htmlToText(e.nodeValue);
				var startI = 0, prevI = 0;
				for( i in 0...text.length ) {
					var cc = text.charCodeAt(i);
					if( cc == "\n".code || font.charset.isBreakChar(cc) ) {
						var sz = sizes[sizePos++];
						var sp = font.charset.isSpace(cc) ? sizes[sizePos++] : 0;
						xMax += sz;
						if( xMax > realMaxWidth ) {
							var index = Lambda.indexOf(e.parent,e);
							var pre = text.substr(startI,prevI - startI);
							if( pre != "" )
								e.parent.insertChild(Xml.createPCData(pre),index++);
							e.parent.insertChild(Xml.createElement("br"),index);
							e.nodeValue = text.substr(prevI+1);
							startI = prevI+1;
							xMax = sz;
						}
						xMax += sp + letterSpacing;
						prevI = i;
					}
				}
				var sz = sizes[sizePos++];
				xMax += sz;
				if( xMax > realMaxWidth ) {
					e.parent.insertChild(Xml.createElement("br"),Lambda.indexOf(e.parent,e));
					xMax = sz;
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

	function addNode( e : Xml, font : Font, rebuild : Bool, handleAlign:Bool, sizes : Array<Float>, ?lines : Array<Int> = null ) {
		sizePos++;
		var calcLines = !handleAlign && !rebuild && lines != null;
		var align = handleAlign ? textAlign : Left;
		if( e.nodeType == Xml.Element ) {
			var prevColor = null, prevGlyphs = null;
			function makeLineBreak()
			{
				if( xPos > xMax ) xMax = xPos;
				if( calcLines ) lines.push(hxd.Math.ceil(xPos));
				switch( align ) {
					case Left:
						xPos = 0;
					case Right, Center, MultilineCenter, MultilineRight:
						xPos = lines.shift();
						if( xPos < xMin ) xMin = xPos;
				}
				yPos += font.lineHeight + lineSpacing;
				prevChar = -1;
				newLine = true;
			}
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
			/*
				??need lines != null even if Left==textAlign
					for( a in e.attributes() ) {
						switch( a.toLowerCase() ) {
						case "align":
							var v = e.get(a);
							if ( v != null )
							switch( v.toLowerCase() ) {
							case "left":
								new_align = Left;
							case "center":
								new_align = Center;
							case "right":
								new_align = Right;
							//?justify
							}
						default:
						}
					}
				}
			*/
				if ( !newLine )
					makeLineBreak();
			case "b","bold":
				setFont("bold");
			case "i","italic":
				setFont("italic");
			case "br":
				makeLineBreak();
			case "img":
				newLine = false;
				var i = loadImage(e.get("src"));
				if( i == null ) i = Tile.fromColor(0xFF00FF, 8, 8);
				if( realMaxWidth >= 0 && xPos + i.width + letterSpacing + remainingSize(sizes) > realMaxWidth && xPos > 0 ) {
					if( xPos > xMax ) xMax = xPos;
					xPos = 0;
					yPos += font.lineHeight + lineSpacing;
				}
				var py = yPos + font.baseLine - i.height;
				if( py + i.dy < calcYMin )
					calcYMin = py + i.dy;
				if( rebuild ) {
					var b = new Bitmap(i, this);
					b.x = xPos;
					b.y = py;
					elements.push(b);
				}
				xPos += i.width + letterSpacing;
			default:
			}
			for( child in e )
				addNode(child, font, rebuild, handleAlign, sizes, lines);
			switch( nodeName ) {
			case "p":
				sizePos++;
				makeLineBreak();
			default:
			}
			if( prevGlyphs != null )
				glyphs = prevGlyphs;
			if( prevColor != null )
				@:privateAccess glyphs.curColor.load(prevColor);
		} else {
			newLine = false;
			var t = splitRawText(htmlToText(e.nodeValue), xPos, remainingSize(sizes));
			var dy = this.font.baseLine - font.baseLine;
			for( i in 0...t.length ) {
				var cc = t.charCodeAt(i);
				if( cc == "\n".code ) {
					if( xPos > xMax ) xMax = xPos;
					if( calcLines ) lines.push(hxd.Math.ceil(xPos));
					switch( align ) {
						case Left:
							xPos = 0;
						case Right, Center, MultilineCenter, MultilineRight:
							xPos = lines.shift();
							if( xPos < xMin ) xMin = xPos;
					}
					yPos += font.lineHeight + lineSpacing;
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