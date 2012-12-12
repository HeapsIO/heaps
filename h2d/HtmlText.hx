package h2d;

class HtmlText extends Drawable {

	public var font(default, null) : Font;
	public var htmlText(default, set) : String;
	public var textColor(default, set) : Int;
	
	var glyphs : TileColorGroup;
	
	public function new( font : Font, ?parent ) {
		super(parent);
		this.font = font;
		glyphs = new TileColorGroup(font, this);
		shader = glyphs.shader;
		htmlText = "";
		textColor = 0xFFFFFF;
	}
	
	override function onAlloc() {
		super.onAlloc();
		if( htmlText != "" ) initGlyphs();
	}
	
	function set_htmlText(t) {
		this.htmlText = t == null ? "null" : t;
		if( allocated ) initGlyphs();
		return t;
	}
	
	function initGlyphs() {
		glyphs.reset();
		glyphs.setDefaultColor(textColor);
		var letters = font.glyphs;
		var x = 0, y = 0;
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
				for( i in 0...t.length ) {
					var cc = t.charCodeAt(i);
					var e = letters[cc];
					if( e == null ) continue;
					glyphs.add(x, y, e);
					x += e.width + 1;
				}
			}
		}
		for( e in Xml.parse(htmlText) )
			loop(e);
	}
	
	function set_textColor(c) {
		this.textColor = c;
		if( allocated && htmlText != "" ) initGlyphs();
		return c;
	}

}