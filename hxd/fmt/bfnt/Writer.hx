package hxd.fmt.bfnt;

import haxe.io.Output;

@:access(h2d.Font)
class Writer {

	static inline var VERSION : Int = 1;
	// V1 format:
	// [BFNT][0x00][0x01]
	// [name_len:u2][name:name_len][size:i2][tile_len:u2][tile_path:tile_len][lineHeight:i2][baseLine:i2]
	// [defaultChar:i4] or [useNullChar:0x00000000]
	// [glyph]
	//   [id:i4][x:u2][y:u2][width:u2][height:u2][xoffset:i2][yoffset:i2][xadvance:i2]
	//   [kerning]
	//     [prevChar:i4][advance:i2]
	//   [kerning-terminator:0x00000000] or [kerning]
	// [glyph-terminator:0x00000000] or [glyph]

	var out : Output;

	public function new( out : Output ) {
		this.out = out;
	}

	public function write( font : h2d.Font ) {
		out.writeString("BFNT");
		out.writeByte(0);
		out.writeByte(VERSION);
		writeString(font.name);
		out.writeInt16(font.size);
		writeString(font.tilePath);
		out.writeInt16(Std.int(font.lineHeight));
		out.writeInt16(Std.int(font.baseLine));
		if (font.defaultChar != font.nullChar) {
			var found = false;
			for ( k in font.glyphs.keys() ) {
				if ( font.glyphs.get(k) == font.defaultChar ) {
					out.writeInt32(k);
					found = true;
					break;
				}
			}
			if (!found) out.writeInt32(0);
		} else {
			out.writeInt32(0);
		}

		for ( id in font.glyphs.keys() ) {

			if (id == 0) continue; // Safety measure if for some reason there's actually a character with ID 0.

			var glyph = font.glyphs.get(id);
			var t = glyph.t;
			out.writeInt32(id);
			out.writeUInt16(Std.int(t.x));
			out.writeUInt16(Std.int(t.y));
			out.writeUInt16(Std.int(t.width));
			out.writeUInt16(Std.int(t.height));
			out.writeInt16(Std.int(t.dx));
			out.writeInt16(Std.int(t.dy));
			out.writeInt16(Std.int(glyph.width));
			var kern = @:privateAccess glyph.kerning;
			while ( kern != null ) {
				if (kern.prevChar != 0) {
					out.writeInt32(kern.prevChar);
					out.writeInt16(Std.int(kern.offset));
				}
				kern = kern.next;
			}
			out.writeInt32(0);
		}
		out.writeInt32(0);
	}

	inline function writeString( s : String ) {
		if ( s == null ) s = "";
		var bytes = haxe.io.Bytes.ofString(s);
		if ( bytes.length > 0xFFFF )
			throw "Invalid string: Size over 0xFFFF";
		out.writeUInt16(bytes.length);
		out.write(bytes);
	}

}