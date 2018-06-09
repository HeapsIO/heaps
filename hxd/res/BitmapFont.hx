package hxd.res;

using Lambda;

class BitmapFont extends Resource {

	var loader : Loader;
	var font : h2d.Font;

	public function new(entry) {
		super(entry);
		this.loader = hxd.res.Loader.currentInstance;
	}

	@:access(h2d.Font)
	public function toFont() : h2d.Font {
		if( font != null )
			return font;
		var tile = loader.load(entry.path.substr(0, -3) + "png").toTile();
		var name = entry.path, size = 0, lineHeight = 0, glyphs = new Map();
		var lastChar = 0;
		switch( entry.getSign() ) {
		case 0x6D783F3C: // <?xml : XML file
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
				var code = c.att.code;
				lastChar = code.charCodeAt(0);
				if( StringTools.startsWith(code, "&#") )
					glyphs.set(Std.parseInt(code.substr(2,code.length-3)), fc);
				else
					glyphs.set(code.charCodeAt(0), fc);
			}
		case 0x6E6F663C:
			// support for Littera XML format (starts with <font>)
			// http://kvazars.com/littera/
			var xml = Xml.parse(entry.getBytes().toString());
			var xml = new haxe.xml.Fast(xml.firstElement());
			size = Std.parseInt(xml.node.info.att.size);
			lineHeight = Std.parseInt(xml.node.common.att.lineHeight);
			name = xml.node.info.att.face;
			var chars = xml.node.chars.elements;
			for( c in chars) {
				var t = tile.sub(Std.parseInt(c.att.x), Std.parseInt(c.att.y), Std.parseInt(c.att.width), Std.parseInt(c.att.height), Std.parseInt(c.att.xoffset), Std.parseInt(c.att.yoffset));
				var fc = new h2d.Font.FontChar(t, Std.parseInt(c.att.width) - 1);
				var kerns = xml.node.kernings.elements;
				for (k in kerns)
					if (k.att.second == c.att.id)
						fc.addKerning(Std.parseInt(k.att.first), Std.parseInt(k.att.amount));

				glyphs.set(Std.parseInt(c.att.id), fc);
			}
		case 0x6F666E69:
			// support for Hiero format
			// https://github.com/libgdx/libgdx
			entry.getBytes().toString().split('\n').iter(function(line) {
				var fields = line.split(' ');
				var name = fields.shift();
				var fieldsValue = fields.map(function(field) {
					var pair = field.split('=');
					return { name: pair[0], value: pair[1] }; 
				});
				switch(name) {
					case 'info' : fieldsValue.iter(function(field) switch(field.name) {
						case 'size' : size = Std.parseInt(field.value);
						case 'face' : name = field.value;
						default : 
					});
					case 'common' : fieldsValue.iter(function(field) switch(field.name) {
						case 'lineHeight' : lineHeight = Std.parseInt(field.value);
						default : 
					});
					case 'page' :
					case 'chars' :
					case 'char' :
						var id = 0, x = 0, y = 0, width = 0, height = 0, xoffset = 0, yoffset = 0, xadvance = 0;
						fieldsValue.iter(function(field) {
							var value = Std.parseInt(field.value);
							switch(field.name) {
								case 'id' : id = value;
								case 'x' : x = value;
								case 'y' : y = value;
								case 'width' : width = value;
								case 'height' : height = value;
								case 'xoffset' : xoffset = value;
								case 'yoffset' : yoffset = value;
								case 'xadvance' : xadvance = value;
								default : 
							}
						});

						var t = tile.sub(x, y, width, height, xoffset, yoffset);
						var fc = new h2d.Font.FontChar(t, width - 1);
						if (id != 32) glyphs.set(id, fc);
					default :
				}
			});
		case sign:
			throw "Unknown font signature " + StringTools.hex(sign, 8);
		}
		if( glyphs.get(" ".code) == null )
			glyphs.set(" ".code, new h2d.Font.FontChar(tile.sub(0, 0, 0, 0), size>>1));

		font = new h2d.Font(name, size);
		font.glyphs = glyphs;
		font.lineHeight = lineHeight;
		font.tile = tile;

		var padding = 0;
		var space = glyphs.get(" ".code);
		if( space != null )
			padding = (space.t.height >> 1);

		var a = glyphs.get("A".code);
		if( a == null )
			a = glyphs.get("a".code);
		if( a == null )
			a = glyphs.get("0".code); // numerical only
		if( a == null )
			font.baseLine = font.lineHeight - 2 - padding;
		else
			font.baseLine = a.t.dy + a.t.height - padding;

		var fallback = glyphs.get(0xFFFD); // <?>
		if( fallback == null )
			fallback = glyphs.get(0x25A1); // square
		if( fallback != null )
			font.defaultChar = fallback;

		return font;
	}

}
