package hxd.fmt.bfnt;

import hxd.fmt.bfnt.Data;
import haxe.io.Input;

#if !macro
@:access(h2d.Font)
#end
class Reader {
	
	var i : Input;
	
	public function new( i : Input ) {
		this.i = i;
	}
	
	public function read( tile: TileReference ) : FontDescriptor {
		
		if (i.readString(4) != "BFNT" || i.readByte() != 0) throw "Not a BFNT file!";
		
		var font : FontDescriptor = null;
		
		switch (i.readByte()) {
			case 1:
				font = new FontDescriptor(i.readString(i.readUInt16()), i.readInt16());
				font.tile = tile;
				font.lineHeight = i.readInt16();
				font.baseLine = i.readInt16();
				var defaultChar = i.readInt32();
				var id : Int;
				while ( ( id = i.readInt32() ) != 0 ) {
					var t = tile.sub(i.readUInt16(), i.readUInt16(), i.readUInt16(), i.readUInt16(), i.readInt16(), i.readInt16());
					var glyph = new FontCharDescriptor(t, i.readInt16());
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
	
	public static inline function parse(bytes : haxe.io.Bytes, tile : TileReference ) : FontDescriptor {
		return new Reader(new haxe.io.BytesInput(bytes)).read(tile);
	}

}