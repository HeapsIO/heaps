package hxd.fmt.bfnt;

import haxe.xml.Access;

class FontParser {

	@:access(h2d.Font)
	public static function parse(bytes : haxe.io.Bytes, path : String, resolveTile: String -> h2d.Tile ) : h2d.Font {

		// TODO: Support multiple textures per font.

		var tile : h2d.Tile = null;
		var pages : Array<h2d.Tile> = [];
		var font : h2d.Font = new h2d.Font(null, 0);
		var glyphs = font.glyphs;

		inline function resolveTileSameName() : h2d.Tile {
			font.tilePath = new haxe.io.Path(path).file + ".png";
			tile = resolveTile(haxe.io.Path.withExtension(path, "png"));
			return tile;
		}

		inline function resolveTileWithFallback( tilePath : String ) : h2d.Tile {
			var t : h2d.Tile = null;
			try {
				font.tilePath = tilePath;
				t = resolveTile(haxe.io.Path.join([haxe.io.Path.directory(path), tilePath]));
			} catch ( e : Dynamic ) {
				trace('Warning: Could not find referenced font texture at "${tilePath}", trying to resolve same name as fnt!');
				t = resolveTileSameName();
			}
			if ( tile == null ) tile = t;
			return t;
		}

		inline function getPageTile( pageId : Int ) : h2d.Tile {
			if ( pages != null && pageId >= 0 && pageId < pages.length && pages[pageId] != null )
				return pages[pageId];
			return tile;
		}

		// Supported formats:
		// Littera formats: XML and Text
		// http://kvazars.com/littera/
		// BMFont: Binary(v3)/Text/XML
		// http://www.angelcode.com/products/bmfont/
		// FontBuilder: Divo/BMF
		// https://github.com/andryblack/fontbuilder/downloads
		// Hiero from LibGDX is BMF Text format and supported as well.
		// https://github.com/libgdx/libgdx

		font.baseLine = 0;

		switch( bytes.getInt32(0) ) {
		case 0x544E4642: // Internal BFNT
			return hxd.fmt.bfnt.Reader.parse(bytes, function( tp : String ) { return resolveTileWithFallback(tp); });

		case 0x6D783F3C, // <?xml : XML file
				 0x6E6F663C: // <font>
			var xml = Xml.parse(bytes.toString());
			var xml = new Access(xml.firstElement());
			if (xml.hasNode.info) {
				// support for Littera XML format (starts with <font>) and BMFont XML format (<?xml).
				font.name = xml.node.info.att.face;
				font.size = font.initSize = Std.parseInt(xml.node.info.att.size);
				font.lineHeight = Std.parseInt(xml.node.common.att.lineHeight);
				font.baseLine = Std.parseInt(xml.node.common.att.base);

				for ( p in xml.node.pages.elements ) {
					var pid = Std.parseInt(p.att.id);
					var pt = resolveTileWithFallback(p.att.file);
					pages[pid] = pt;
					if ( pid == 0 || tile == null ) tile = pt;
				}

				var chars = xml.node.chars.elements;
				for( c in chars) {
					var pageId = c.has.page ? Std.parseInt(c.att.page) : 0;
					var curTile = getPageTile(pageId);
					var t = curTile.sub(Std.parseInt(c.att.x), Std.parseInt(c.att.y), Std.parseInt(c.att.width), Std.parseInt(c.att.height), Std.parseInt(c.att.xoffset), Std.parseInt(c.att.yoffset));
					var fc = new h2d.Font.FontChar(t, Std.parseInt(c.att.xadvance));
					glyphs.set(Std.parseInt(c.att.id), fc);
				}

				if ( xml.hasNode.kernings ) {
					for (k in xml.node.kernings.elements) {
						var second = Std.parseInt(k.att.second);
						var fc = glyphs.get(second);
						if (fc != null)
							fc.addKerning(Std.parseInt(k.att.first), Std.parseInt(k.att.amount));
					}
				}
			} else {
				// support for the FontBuilder/Divo format
				resolveTileSameName();

				font.name = xml.att.family;
				font.size = font.initSize = Std.parseInt(xml.att.size);
				font.lineHeight = Std.parseInt(xml.att.height);
				inline function parseCode( code : String ) : Int {
					return StringTools.startsWith(code, "&#") ? Std.parseInt(code.substr(2,code.length-3)) : code.charCodeAt(0);
				}
				var kernings = [];
				for( c in xml.elements ) {
					var r = c.att.rect.split(" ");
					var o = c.att.offset.split(" ");
					var t = tile.sub(Std.parseInt(r[0]), Std.parseInt(r[1]), Std.parseInt(r[2]), Std.parseInt(r[3]), Std.parseInt(o[0]), Std.parseInt(o[1]));
					var fc = new h2d.Font.FontChar(t, Std.parseInt(c.att.width));
					var code = parseCode(c.att.code);
					for( k in c.elements ){
						var next = parseCode(k.att.id);
						var adv = Std.parseInt(k.att.advance);
						if( glyphs.exists(next) )
							glyphs.get(next).addKerning(code, adv);
						else
							kernings.push({prev: code, next: next, adv: adv});
					}
					glyphs.set(code, fc);
				}
				for( k in kernings ){
					var g = glyphs.get(k.next);
					if( g == null ) continue;
					g.addKerning(k.prev, k.adv);
				}
			}
		case 0x6F666E69:
			// BFont text format, version 3 (starts with info ...)
			// Can be produced by Littera Text format as well
			var lines = bytes.toString().split("\n");

			// BMFont pads values with spaces, littera doesn't.
			var reg = ~/ *?([0-9a-zA-Z]+)=("[^"]+"|.+?)(?:[ \r]|$)/;
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

			var pageCount = 0;

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
								case "pages":
									pageCount = extractInt();
							}
							next();
						}
					case "page":
						var pageId = 0;
						while (idx < line.length && reg.matchSub(line, idx)) {
							switch (reg.matched(1)) {
								case "id": pageId = extractInt();
								case "file":
									var pt = resolveTileWithFallback(processValue());
									pages[pageId] = pt;
									if ( pageId == 0 || tile == null ) tile = pt;
							}
							next();
						}
					case "char":
						var id = 0, x = 0, y = 0, width = 0, height = 0, xoffset = 0, yoffset = 0, xadvance = 0, page = 0;
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
								case "page": page = extractInt();
							}
							next();
						}
						var curTile = getPageTile(page);
						var t = curTile.sub(x, y, width, height, xoffset, yoffset);
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
			var bytes = new haxe.io.BytesInput(bytes);
			bytes.position += 4; // Signature
			var pageCount : Int = 0;

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
						// skip scaleW (2), scaleH (2)
						bytes.position += 4;
						pageCount = bytes.readUInt16();
						// skip bitField (1), channels (4)
					case 3: // pages
						while ( bytes.position < pos + length ) {
							var name : String = bytes.readUntil(0);
							if ( name.length > 0 ) {
								var pt = resolveTileWithFallback(name);
								pages.push(pt);
								if ( tile == null ) tile = pt;
							}
						}
					case 4: // chars
						var count : Int = Std.int(length / 20);
						while ( count > 0 ) {
							var cid = bytes.readInt32();
							var cx = bytes.readUInt16();
							var cy = bytes.readUInt16();
							var cw = bytes.readUInt16();
							var ch = bytes.readUInt16();
							var cdx = bytes.readInt16();
							var cdy = bytes.readInt16();
							var cadv = bytes.readInt16();
							var pageId = bytes.readByte();
							var chnl = bytes.readByte();
							var curTile = getPageTile(pageId);
							var t = curTile.sub(cx, cy, cw, ch, cdx, cdy);
							var fc = new h2d.Font.FontChar(t, cadv);
							glyphs.set(cid, fc);
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
			glyphs.set(" ".code, new h2d.Font.FontChar((tile != null ? tile : h2d.Tile.fromColor(0, 0, 0, 0)).sub(0, 0, 0, 0), font.size>>1));

		if ( pages.length > 0 ) {
			font.tiles = pages;
			if ( tile == null ) tile = pages[0];
		}
		font.tile = tile;

		if( font.baseLine == 0 )
			font.baseLine = font.calcBaseLine();

		var fallback = glyphs.get(0xFFFD); // <?>
		if( fallback == null )
			fallback = glyphs.get(0x25A1); // square
		if( fallback == null )
			fallback = glyphs.get("?".code);
		if( fallback != null )
			font.defaultChar = fallback;

		return font;
	}

}
