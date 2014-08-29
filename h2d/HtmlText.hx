package h2d;

class HtmlText extends Text {

	override function initGlyphs( text : String, rebuild = true, ?lines : Array<Int> ) {
		if( rebuild ) glyphs.reset();
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
					y += font.lineHeight;
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
		return { width : x > xMax ? x : xMax, height : x > 0 ? y + font.lineHeight : y };
	}

}