package hxd.fmt.bfnt;

import haxe.io.Input;

@:access(h2d.Font)
class Reader {

	var i : Input;

	public function new( i : Input ) {
		this.i = i;
	}

	public function read( resolveTile: String -> h2d.Tile ) : h2d.Font {

		if (i.readString(4) != "BFNT" || i.readByte() != 0) throw "Not a BFNT file!";

		var font : h2d.Font = null;

		switch (i.readByte()) {
			case 1:
				font = new h2d.Font(i.readString(i.readUInt16()), i.readInt16());
				font.tilePath = i.readString(i.readUInt16());
				var tile = font.tile = resolveTile(font.tilePath);
				font.lineHeight = i.readInt16();
				font.baseLine = i.readInt16();
				var defaultChar = i.readInt32();
				var id : Int;
				while ( ( id = i.readInt32() ) != 0 ) {
					var t = tile.sub(i.readUInt16(), i.readUInt16(), i.readUInt16(), i.readUInt16(), i.readInt16(), i.readInt16());
					var glyph = new h2d.Font.FontChar(t, i.readInt16());
					font.glyphs.set(id, glyph);
					if (id == defaultChar) font.defaultChar = glyph;

					var prevChar : Int;
					while ( ( prevChar = i.readInt32() ) != 0 ) {
						glyph.addKerning(prevChar, i.readInt16());
					}
				}
			case ver:
				throw "Unknown BFNT version: " + ver;
		}

		return font;
	}

	public static inline function parse(bytes : haxe.io.Bytes, resolveTile : String -> h2d.Tile ) : h2d.Font {
		return new Reader(new haxe.io.BytesInput(bytes)).read(resolveTile);
	}

}