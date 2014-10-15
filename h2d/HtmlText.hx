package h2d;

class HtmlText extends Text {

	var images : Array<Bitmap> = [];

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

	override function initGlyphs( text : String, rebuild = true, ?lines : Array<Int> ) {
		if( rebuild ) {
			glyphs.reset();
			for( i in images ) i.remove();
			images = [];
		}
		glyphs.setDefaultColor(textColor);
		var x = 0, y = 0, xMax = 0;
		function loop( e : Xml ) {
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
					if( x > xMax ) xMax = x;
					x = 0;
					y += font.lineHeight + lineSpacing;
				case "img":
					var i = loadImage(e.get("src"));
					if( i == null ) i = Tile.fromColor(0xFF00FF, 8, 8);
					if( rebuild ) {
						var b = new Bitmap(i, this);
						b.x = x;
						b.y = y + font.baseLine - i.height;
						images.push(b);
					}
					x += i.width + letterSpacing;
				default:
				}
				for( child in e )
					loop(child);
				if( colorChanged )
					glyphs.setDefaultColor(textColor);
			} else {
				var t = e.nodeValue;
				var prevChar = -1;
				for( i in 0...t.length ) {
					var cc = t.charCodeAt(i);
					var e = font.getChar(cc);
					x += e.getKerningOffset(prevChar);
					if( rebuild ) glyphs.add(x, y, e.t);
					x += e.width + letterSpacing;
					prevChar = cc;
				}
			}
		}
		for( e in Xml.parse(text) )
			loop(e);
		return { width : x > xMax ? x : xMax, height : x > 0 ? y + (font.lineHeight + lineSpacing) : y };
	}

	override function set_textColor(c) {
		this.textColor = c;
		rebuild();
		return c;
	}

}