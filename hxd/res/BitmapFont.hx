package hxd.res;

class BitmapFont extends Resource {
	
	var loader : Loader;
	var font : h2d.Font;
	
	public function new(loader, entry) {
		super(entry);
		this.loader = loader;
	}
	
	@:access(h2d.Font)
	public function toFont() : h2d.Font {
		if( font != null )
			return font;
		var tile = loader.load(entry.path.substr(0, -3) + "png").toTile();
		var name = entry.path, size = 0, lineHeight = 0, glyphs = new Map();
		switch( entry.getSign() ) {
		case 0x6D783F3C: // <?xm : XML file
			var xml = Xml.parse(entry.getBytes().toString());
			// support only the FontBuilder/Divo format
			// export with FontBuilder https://github.com/andryblack/fontbuilder/downloads
			var xml = new haxe.xml.Fast(xml.firstElement());
			size = Std.parseInt(xml.att.size);
			lineHeight = Std.parseInt(xml.att.height);
			name = xml.att.family;
			for( c in xml.elements ) {
				var r = c.att.rect.split(" ");
				var o = c.att.offset.split(" ");
				var t = tile.sub(Std.parseInt(r[0]), Std.parseInt(r[1]), Std.parseInt(r[2]), Std.parseInt(r[3]), Std.parseInt(o[0]), Std.parseInt(o[1]));
				var fc = new h2d.Font.FontChar(t, Std.parseInt(c.att.width) - 1);
				for( k in c.elements )
					fc.addKerning(k.att.id.charCodeAt(0), Std.parseInt(k.att.advance));
				glyphs.set(c.att.code.charCodeAt(0), fc);
			}
		case sign:
			throw "Unknown font signature " + StringTools.hex(sign, 8);
		}
		if( glyphs.get(" ".code) == null )
			glyphs.set(" ".code, new h2d.Font.FontChar(tile.sub(0, 0, 0, 0), size>>1));
		
		font = new h2d.Font(name, size);
		font.glyphs = glyphs;
		font.lineHeight = lineHeight;
		font.tile = tile;
		return font;
	}
	
}