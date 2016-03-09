package h2d;

class HtmlText extends Text {

	var images : Array<Bitmap> = [];
	var xPos : Int;
	var yPos : Int;
	var xMax : Int;

	override function draw(ctx:RenderContext) {
		if( dropShadow != null ) {
			var oldX = absX, oldY = absY;
			absX += dropShadow.dx * matA + dropShadow.dy * matC;
			absY += dropShadow.dx * matB + dropShadow.dy * matD;
			var old = this.colorMatrix;
			this.colorMatrix = new h3d.Matrix();
			this.colorMatrix.zero();
			this.colorMatrix._41 = ((dropShadow.color >> 16) & 0xFF) / 255;
			this.colorMatrix._42 = ((dropShadow.color >> 8) & 0xFF) / 255;
			this.colorMatrix._43 = (dropShadow.color & 0xFF) / 255;
			this.colorMatrix._44 = dropShadow.alpha;
			glyphs.drawWith(ctx, this);
			this.colorMatrix = old;
			absX = oldX;
			absY = oldY;
			calcAbsPos();
		}
		glyphs.drawWith(ctx,this);
	}

	public dynamic function loadImage( url : String ) : Tile {
		return null;
	}

	override function initGlyphs( text : String, rebuild = true, handleAlign = true, ?lines : Array<Int> ) {
		if( rebuild ) {
			glyphs.clear();
			for( i in images ) i.remove();
			images = [];
		}
		glyphs.setDefaultColor(textColor);
		xPos = 0;
		yPos = 0;
		xMax = 0;
		calcYMin = 0;
		var doc = try Xml.parse(text) catch( e : Dynamic ) throw "Could not parse " + text + " (" + e +")";
		for( e in doc )
			addNode(e, rebuild);

		var x = xPos, y = yPos;
		calcWidth = x > xMax ? x : xMax;
		calcHeight = y > 0 && x == 0 ? y - lineSpacing : y + font.lineHeight;
		calcSizeHeight = y > 0 && x == 0 ? y + (font.baseLine - font.lineHeight - lineSpacing) : y + font.baseLine;
		calcDone = true;
	}

	function addNode( e : Xml, rebuild : Bool ) {
		if( e.nodeType == Xml.Element ) {
			var colorChanged = false;
			switch( e.nodeName.toLowerCase() ) {
			case "font":
				for( a in e.attributes() ) {
					var v = e.get(a);
					switch( a.toLowerCase() ) {
					case "color":
						colorChanged = true;
						glyphs.setDefaultColor(Std.parseInt("0x" + v.substr(1)));
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
				if( maxWidth != null && xPos + i.width > maxWidth && xPos > 0 ) {
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
					images.push(b);
				}
				xPos += i.width + letterSpacing;
			default:
			}
			for( child in e )
				addNode(child, rebuild);
			if( colorChanged )
				glyphs.setDefaultColor(textColor);
		} else {
			var t = splitText(e.nodeValue.split("\n").join(" "), xPos);
			var prevChar = -1;
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
				if( rebuild ) glyphs.add(xPos, yPos, e.t);
				if( yPos == 0 && e.t.dy < calcYMin ) calcYMin = e.t.dy;
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

}