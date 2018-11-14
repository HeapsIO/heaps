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
		}
		glyphs.setDefaultColor(textColor);

		xPos = 0;
		xMin = 0;

		var align = handleAlign ? textAlign : Left;
		switch( align ) {
			case Center, Right, MultilineCenter, MultilineRight:
				lines = [];
				initGlyphs(text, false, false, lines);
				var max = if( align == MultilineCenter || align == MultilineRight ) calcWidth else realMaxWidth < 0 ? 0 : Std.int(realMaxWidth);
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

		var doc = try Xml.parse(text) catch( e : Dynamic ) throw "Could not parse " + text + " (" + e +")";

		var sizes = [];
		prevChar = -1;
		for( e in doc )
			buildSizes(e, sizes);

		prevChar = -1;
		for( e in doc )
			addNode(e, font, rebuild, handleAlign, sizes, lines);

		if (!handleAlign && !rebuild && lines != null) lines.push(xPos);
		if( xPos > xMax ) xMax = xPos;

		var x = xPos, y = yPos;
		calcXMin = xMin;
		calcWidth = xMax - xMin;
		calcHeight = y + font.lineHeight;
		calcSizeHeight = y + (font.baseLine > 0 ? font.baseLine : font.lineHeight);
		calcDone = true;
	}

	function buildSizes( e : Xml, sizes : Array<Int> ) {
		if( e.nodeType == Xml.Element ) {
			var len = 0, prevFont = font;
			switch( e.nodeName.toLowerCase() ) {
			case "br":
				len = -1; // break
			case "img":
				var i = loadImage(e.get("src"));
				len = (i == null ? 8 : i.width) + letterSpacing;
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
				buildSizes(child, sizes);
			font = prevFont;
		} else {
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

	function addNode( e : Xml, font : Font, rebuild : Bool, handleAlign:Bool, sizes : Array<Int>, ?lines : Array<Int> = null ) {
		sizePos++;
		var calcLines = !handleAlign && !rebuild && lines != null;
		var align = handleAlign ? textAlign : Left;
		if( e.nodeType == Xml.Element ) {
			var prevColor = null, prevGlyphs = null;
			switch( e.nodeName.toLowerCase() ) {
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
						@:privateAccess glyphs.curColor.load(prev.curColor);
						elements.push(glyphs);
					default:
					}
				}
			case "br":
				if( xPos > xMax ) xMax = xPos;
				if( calcLines ) lines.push(xPos);
				switch( align ) {
					case Left:
						xPos = 0;
					case Right, Center, MultilineCenter, MultilineRight:
						xPos = lines.shift();
						if( xPos < xMin ) xMin = xPos;
				}
				yPos += font.lineHeight + lineSpacing;
				prevChar = -1;
			case "img":
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
			if( prevGlyphs != null )
				glyphs = prevGlyphs;
			if( prevColor != null )
				@:privateAccess glyphs.curColor.load(prevColor);
		} else {
			var t = splitText(htmlToText(e.nodeValue), xPos, remainingSize(sizes));
			var dy = this.font.baseLine - font.baseLine;
			for( i in 0...t.length ) {
				var cc = t.charCodeAt(i);
				if( cc == "\n".code ) {
					if( xPos > xMax ) xMax = xPos;
					if( calcLines ) lines.push(xPos);
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