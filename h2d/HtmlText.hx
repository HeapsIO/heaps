package h2d;

import h2d.Text;

class HtmlText extends Text {

	public var condenseWhite(default,set) : Bool = true;

	var elements : Array<Object> = [];
	var xPos : Int;
	var yPos : Int;
	var xMax : Int;
	var xMin : Int;
	var sizePos : Int;
	var dropMatrix : h3d.shader.ColorMatrix;
	var prevChar : Int;
	var newLine : Bool;
	var doc:Xml;

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

	override function initGlyphs( text : String, rebuild = true, handleAlign = true, ?lines : Array<Int> ) {
		if( rebuild ) {
			glyphs.clear();
			for( e in elements ) e.remove();
			elements = [];
			doc = null;
		}
		glyphs.setDefaultColor(textColor);

		xPos = 0;
		xMin = 0;
		if ( doc == null ) doc = try Xml.parse(text) catch( e : Dynamic ) throw "Could not parse " + text + " (" + e +")";

		if ( handleAlign ) {
			// Calculate line sizes.
			lines = [];
			initGlyphs(text, false, false, lines);
		}

		yPos = 0;
		xMax = 0;
		sizePos = 0;
		calcYMin = 0;

		var sizes = [];
		prevChar = -1;
		newLine = true;
		for( e in doc )
			buildSizes(e, sizes, font);

		prevChar = -1;
		newLine = true;
		if ( handleAlign ) nextLine(textAlign, lines.shift());
		for( e in doc )
			addNode(e, font, textAlign, rebuild, handleAlign, sizes, lines);

		if (!handleAlign && !rebuild && lines != null) lines.push(xPos);
		if( xPos > xMax ) xMax = xPos;

		var y = yPos;
		calcXMin = xMin;
		calcWidth = xMax - xMin;
		calcHeight = y + font.lineHeight;
		calcSizeHeight = y + (font.baseLine > 0 ? font.baseLine : font.lineHeight);
		calcDone = true;
	}

	function buildSizes( e : Xml, sizes : Array<Int>, font : Font ) {
		if( e.nodeType == Xml.Element ) {
			var len = 0;
			var nodeName = e.nodeName.toLowerCase();
			switch( nodeName ) {
			case "p":
				len = -1;
				newLine = true;
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
			default:
			}
			sizes.push(len);
			for( child in e )
				buildSizes(child, sizes, font);
			switch( nodeName ) {
			case "p":
				if ( !newLine ) {
					sizes.push( -1);// break
					newLine = true;
				}
			default:
			}
		} else {
			newLine = false;
			var text = htmlToText(e.nodeValue);
			var xp = 0;
			for( i in 0...text.length ) {
				var cc = text.charCodeAt(i);
				var fc = font.getChar(cc);
				var sz = fc.getKerningOffset(prevChar) + fc.width;
				if( cc == "\n".code || font.charset.isBreakChar(cc) ) {
					if( cc != "\n".code && !font.charset.isSpace(cc) )
						xp += sz;
					sizes.push( -(xp + 1));
					return;
				}
				xp += sz + letterSpacing;
			}
			sizes.push(xp);
		}
	}

	static var REG_SPACES = ~/[\r\n\t ]+/g;
	function htmlToText( t : hxd.UString )  {
		if (condenseWhite)
			t = REG_SPACES.replace(t, " ");
		return t;
	}

	inline function nextLine( align : Align, size : Int )
	{
		switch( align ) {
			case Left:
				xPos = 0;
			case Right, Center, MultilineCenter, MultilineRight:
				var max = if( align == MultilineCenter || align == MultilineRight ) calcWidth else realMaxWidth < 0 ? 0 : Std.int(realMaxWidth);
				var k = align == Center || align == MultilineCenter ? 1 : 0;
				xMin = xPos;
				xPos = (max - size) >> k;
				if( xPos < xMin ) xMin = xPos;
		}
	}

	function remainingSize( sizes : Array<Int> ) {
		var size = 0;
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

	function addNode( e : Xml, font : Font, align : Align, rebuild : Bool, handleAlign:Bool, sizes : Array<Int>, ?lines : Array<Int> = null ) {
		sizePos++;
		var calcLines = !handleAlign && !rebuild && lines != null;
		if( e.nodeType == Xml.Element ) {
			var prevColor = null, prevGlyphs = null;
			function makeLineBreak()
			{
				if( xPos > xMax ) xMax = xPos;
				if( calcLines ) lines.push(xPos);
				if ( handleAlign ) {
					nextLine(align, lines.shift());
				} else {
					xPos = 0;
				}
				yPos += font.lineHeight + lineSpacing;
				prevChar = -1;
				newLine = true;
			}
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
						if( prevGlyphs == null ) prevGlyphs = glyphs;
						var prev = glyphs;
						glyphs = new TileGroup(font == null ? null : font.tile, this);
						if ( font != null ) {
							switch ( font.type ) {
								case SignedDistanceField(channel, alphaCutoff, smoothing):
									var shader = new h3d.shader.SignedDistanceField();
									shader.channel = channel;
									shader.alphaCutoff = alphaCutoff;
									shader.smoothing = smoothing;
									glyphs.addShader(shader);
									glyphs.smooth = true;
								default:
							}
						}
						@:privateAccess glyphs.curColor.load(prev.curColor);
						elements.push(glyphs);
					default:
					}
				}
			case "p":
				if ( handleAlign ) {
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
								//?justify
								}
							default:
						}
					}
				}
				if ( !newLine )
					makeLineBreak();
				else
					nextLine(align, lines[0]);
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
				addNode(child, font, align, rebuild, handleAlign, sizes, lines);
			switch( nodeName ) {
			case "p":
				if ( !newLine ) {
					makeLineBreak();
					sizePos++;
				}
			default:
			}
			if( prevGlyphs != null )
				glyphs = prevGlyphs;
			if( prevColor != null )
				@:privateAccess glyphs.curColor.load(prevColor);
		} else {
			newLine = false;
			var t = splitText(htmlToText(e.nodeValue), xPos, remainingSize(sizes));
			var dy = this.font.baseLine - font.baseLine;
			for( i in 0...t.length ) {
				var cc = t.charCodeAt(i);
				if( cc == "\n".code ) {
					if( xPos > xMax ) xMax = xPos;
					if( calcLines ) lines.push(xPos);
					nextLine(align, lines.shift());
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