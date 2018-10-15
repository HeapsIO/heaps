package hxd.res;
#if (haxe_ver < 4)
import haxe.xml.Fast in Access;
#else
import haxe.xml.Access;
#end

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
		// TODO: Support multiple textures per font.
		var tile = loader.load(entry.path.substr(0, -3) + "png").toTile();
		var glyphs : Map<Int, h2d.Font.FontChar> = new Map();
		var font : h2d.Font = new h2d.Font(null, 0);
		
		// Supported formats:
		// Littera formats: XML and Text
		// http://kvazars.com/littera/
		// BMFont: Binary(v3)/Text/XML
		// http://www.angelcode.com/products/bmfont/
		// FontBuilder: Divo/BMF
		// https://github.com/andryblack/fontbuilder/downloads
		
		var lastChar = 0;
		switch( entry.getSign() ) {
		case 0x6D783F3C, // <?xml : XML file
				 0x6E6F663C: // <font>
			var xml = Xml.parse(entry.getBytes().toString());
			var xml = new Access(xml.firstElement());
			if (xml.hasNode.info) {
				// support for Littera XML format (starts with <font>) and BMFont XML format (<?xml).
				font.name = xml.node.info.att.face;
				font.size = font.initSize = Std.parseInt(xml.node.info.att.size);
				font.lineHeight = Std.parseInt(xml.node.common.att.lineHeight);
				font.baseLine = Std.parseInt(xml.node.common.att.base);
				var chars = xml.node.chars.elements;
				for( c in chars) {
					var t = tile.sub(Std.parseInt(c.att.x), Std.parseInt(c.att.y), Std.parseInt(c.att.width), Std.parseInt(c.att.height), Std.parseInt(c.att.xoffset), Std.parseInt(c.att.yoffset));
					var fc = new h2d.Font.FontChar(t, Std.parseInt(c.att.xadvance));
					var kerns = xml.node.kernings.elements;
					for (k in kerns)
						if (k.att.second == c.att.id)
							fc.addKerning(Std.parseInt(k.att.first), Std.parseInt(k.att.amount));

					glyphs.set(Std.parseInt(c.att.id), fc);
				}
			} else {
				// support for the FontBuilder/Divo format
				font.name = xml.att.family;
				font.size = font.initSize = Std.parseInt(xml.att.size);
				font.lineHeight = Std.parseInt(xml.att.height);
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
			}
		case 0x6F666E69:
			// BFont text format, version 3 (starts with info ...)
			// Can be produced by Littera Text format as well
			var lines = entry.getBytes().toString().split("\n");
			
			// BMFont pads values with spaces, littera doesn't.
			var reg = ~/ *?([0-9a-zA-Z]+)=("[^"]+"|.+?)(?: |$)/;
			var idx : Int;
			
			inline function next() : Void {
				var pos = reg.matchedPos();
				idx = pos.pos + pos.len;
			}
			inline function processValue() : String {
				var v = reg.matched(2);
				if (v.charCodeAt(0) == '"'.code) return v.substring(1, v.length - 1);
				return v;
			}
			inline function extractInt() : Int {
				return Std.parseInt(processValue());
			}
			
			for ( line in lines ) {
				idx = line.indexOf(" ");
				switch(line.substr(0, idx))
				{
					case "info":
						while (idx < line.length && reg.matchSub(line, idx)) {
							switch (reg.matched(1)) {
								case "face": font.name = processValue();
								case "size": font.size = font.initSize = extractInt();
							}
							next();
						}
					case "common":
						while (idx < line.length && reg.matchSub(line, idx)) {
							switch (reg.matched(1)) {
								case "lineHeight": font.lineHeight = extractInt();
								case "base": font.baseLine = extractInt();
							}
							next();
						}
					case "char":
						var id = 0, x = 0, y = 0, width = 0, height = 0, xoffset = 0, yoffset = 0, xadvance = 0;
						while (idx < line.length && reg.matchSub(line, idx)) {
							switch (reg.matched(1)) {
								case "id": id = extractInt();
								case "x": x = extractInt();
								case "y": y = extractInt();
								case "width": width = extractInt();
								case "height": height = extractInt();
								case "xoffset": xoffset = extractInt();
								case "yoffset": yoffset = extractInt();
								case "xadvance": xadvance = extractInt();
							}
							next();
						}
						var t = tile.sub(x, y, width, height, xoffset, yoffset);
						var fc = new h2d.Font.FontChar(t, xadvance);
						glyphs.set(id, fc);
					case "kerning":
						var first = 0, second = 0, advance = 0;
						while (idx < line.length && reg.matchSub(line, idx)) {
							switch (reg.matched(1)) {
								case "first": first = extractInt();
								case "second": second = extractInt();
								case "amount": advance = extractInt();
							}
							next();
						}
						var fc = glyphs.get(second);
						if (fc != null)
							fc.addKerning(first, advance);
				}
			}
		case 0x03464D42: // BMF[0x03]
			// BMFont binary format, version 3.
			var bytes = new haxe.io.BytesInput(entry.getBytes());
			bytes.position += 4; // Signature
			
			while ( bytes.position < bytes.length ) {
				var id = bytes.readByte();
				var length = bytes.readInt32();
				var pos = bytes.position;
				
				switch (id) {
					case 1: // info
						font.size = font.initSize = bytes.readInt16();
						// skip bitField (1), charSet (1), stretchH (2), aa (1), padding (4), spacing (2) and outline (1)
						bytes.position += 12;
						font.name = bytes.readUntil(0);
					case 2: // common
						font.lineHeight = bytes.readUInt16();
						font.baseLine = bytes.readUInt16();
						// skip scaleW (2), scaleH (2), pages (2), bitField (1), channels (4)
					case 3: // pages
						// Ignored.
					case 4: // chars
						var count : Int = Std.int(length / 20);
						while ( count > 0 ) {
							var cid = bytes.readInt32();
							var t = tile.sub(bytes.readUInt16(), bytes.readUInt16(), bytes.readUInt16(), bytes.readUInt16(), bytes.readInt16(), bytes.readInt16());
							var fc = new h2d.Font.FontChar(t, bytes.readInt16());
							glyphs.set(cid, fc);
							bytes.position += 2; // skip page and channel
							count--;
						}
					case 5: // kerning
						var count : Int = Std.int(length / 10);
						while ( count > 0 ) {
							var first = bytes.readInt32();
							var fc = glyphs.get(bytes.readInt32());
							if (fc != null)
								fc.addKerning(first, bytes.readInt16());
							else
								bytes.position += 2;
							count--;
						}
				}
				
				bytes.position = pos + length;
			}
			
		case sign:
			throw "Unknown font signature " + StringTools.hex(sign, 8);
		}
		if( glyphs.get(" ".code) == null )
			glyphs.set(" ".code, new h2d.Font.FontChar(tile.sub(0, 0, 0, 0), font.size>>1));

		font.glyphs = glyphs;
		font.tile = tile;

		if ( font.baseLine == 0 ) {
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
		}

		var fallback = glyphs.get(0xFFFD); // <?>
		if( fallback == null )
			fallback = glyphs.get(0x25A1); // square
		if( fallback != null )
			font.defaultChar = fallback;

		return font;
	}

}
