package h2d;

class HtmlText extends Text {

	var elements : Array<Sprite> = [];
	var xPos : Int;
	var yPos : Int;
	var xMax : Int;
	var sizePos : Int;
	var dropMatrix : h3d.shader.ColorMatrix;

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
		yPos = 0;
		xMax = 0;
		sizePos = 0;
		calcYMin = 0;
		var doc = try Xml.parse(text) catch( e : Dynamic ) throw "Could not parse " + text + " (" + e +")";
		var sizes = [];
		for( e in doc )
			buildSizes(e,sizes);
		for( e in doc )
			addNode(e, font, rebuild, sizes);

		var x = xPos, y = yPos;
		calcWidth = x > xMax ? x : xMax;
		calcHeight = y > 0 && x == 0 ? y - lineSpacing : y + font.lineHeight;
		calcSizeHeight = y > 0 && x == 0 ? y + (font.baseLine - font.lineHeight - lineSpacing) : y + font.baseLine;
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
			var prevChar = -1;
			var xPos = 0;
			for( i in 0...text.length ) {
				var cc = text.charCodeAt(i);
				var stop = false;
				var e = font.getChar(cc);
				var sz = e.getKerningOffset(prevChar) + e.width;
				if( cc == "\n".code || font.charset.isBreakChar(cc) ) {
					if( cc != "\n".code && !font.charset.isSpace(cc) )
						xPos += sz;
					sizes.push( -(xPos + 1));
					return;
				}
				xPos += sz + letterSpacing;
			}
			sizes.push(xPos);
		}
	}

	function htmlToText( t : hxd.UString )  {
		t = ~/[\r\n\t ]+/g.replace(t, " ");
		t = ~/&([A-Za-z]+);/g.map(t, function(r) {
			switch( r.matched(1).toLowerCase() ) {
			case "lt": return "<";
			case "gt": return ">";
			case "nbsp": return String.fromCharCode(0xA0);
			default: return r.matched(0);
			}
		});
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

	function addNode( e : Xml, font : Font, rebuild : Bool, sizes : Array<Int> ) {
		sizePos++;
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
				xPos = 0;
				yPos += font.lineHeight + lineSpacing;
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
				addNode(child, font, rebuild, sizes);
			if( prevGlyphs != null )
				glyphs = prevGlyphs;
			if( prevColor != null )
				@:privateAccess glyphs.curColor.load(prevColor);
		} else {
			var t = splitText(htmlToText(e.nodeValue), xPos, remainingSize(sizes));
			var prevChar = -1;
			var dy = this.font.baseLine - font.baseLine;
			for( i in 0...t.length ) {
				var cc = t.charCodeAt(i);
				if( cc == "\n".code ) {
					if( xPos > xMax ) xMax = xPos;
					xPos = 0;
					yPos += font.lineHeight + lineSpacing;
					prevChar = -1;
					continue;
				}
				var e = font.getChar(cc);
				xPos += e.getKerningOffset(prevChar);
				if( rebuild ) glyphs.add(xPos, yPos + dy, e.t);
				if( yPos == 0 && e.t.dy+dy < calcYMin ) calcYMin = e.t.dy + dy;
				xPos += e.width + letterSpacing;
				prevChar = cc;
			}
		}
	}

	override function set_textColor(c) {
		if( this.textColor == c ) return c;
		this.textColor = c;
		rebuild();
		return c;
	}

	override function getBoundsRec( relativeTo : Sprite, out : h2d.col.Bounds, forSize : Bool ) {
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