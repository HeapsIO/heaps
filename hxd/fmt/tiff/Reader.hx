package hxd.fmt.tiff;

import hxd.fmt.tiff.Data;
#if sys
import sys.io.FileInput;
#else
import hxd.fmt.pak.FileSystem.FileInput;
#end


class Reader {

	var f : FileInput;

	public function new(f:FileInput) {
		this.f = f;
	}

	public function read() {
		var order = f.readString(2);
		f.bigEndian = order == "MM";
		var id = f.readUInt16();
		if( (order != "II" && order != "MM") || id != 42 ) throw "Invalid TIF file";
		var offset = f.readInt32();

		var tags = [];
		while( offset != 0 ) {
			f.seek(offset, SeekBegin);
			var count = f.readUInt16();
			for( i in 0...count ) {
				var tag = new TifTag(f.readUInt16());
				var type = new TifType(f.readUInt16());
				var count = f.readInt32();
				var next = f.tell();
				if( count * type.getSize() > 4 ) {
					var offset = f.readInt32();
					f.seek(offset, SeekBegin);
				}
				var value = if( count == 1 || type == Ascii ) readValue(type) else VArray([for( i in 0...count ) readValue(type)]);
				f.seek(next + 4, SeekBegin);
				tags.push({ tag : tag, type : type, value : value });
			}
			offset = f.readInt32();
		}

		var tif : TifFile = {
			tags : tags,
			data : [],
		};

		var offsets = Utils.get(tif, StripOffsets);
		var bytes = Utils.get(tif, StripByteCounts);
		if( offsets == null || bytes == null ) throw "Missing image data";

		for( t in tags.copy() )
			if( t.tag == StripOffsets || t.tag == StripByteCounts )
				tags.remove(t);

		switch( [offsets,bytes] ) {
		case [VArray(offsets), VArray(bytes)] if( offsets.length == bytes.length ):
			for( i in 0...offsets.length )
				switch( [offsets[i],bytes[i]] ) {
				case [VInt(offset), VInt(len)]:
					f.seek(offset, SeekBegin);
					tif.data.push(f.read(len));
				default: throw "assert";
				}
		default: throw "Invalid image data";
		}

		return tif;
	}

	function readValue( t : TifType ) : TifValue {
		return switch( t ) {
		case Byte: VInt(f.readByte());
		case Ascii:
			var b = new StringBuf();
			while( true ) {
				var c = f.readByte();
				if( c == 0 ) break;
				b.addChar(c);
			}
			VString(b.toString());
		case Short: VInt(f.readUInt16());
		case Long: VInt(f.readInt32());
		case Float: VFloat(f.readFloat());
		case Double: VFloat(f.readDouble());
		default: throw "Unsupported type "+t;
		}
	}

	public static function decode( f : TifFile ) : hxd.Pixels {
		var bpp = Utils.getInt(f, BitsPerSample);
		var channels = Utils.getInt(f, SamplesPerPixel);

		if( Utils.getInt(f, Compression) != 1 ) throw "Unsupported compression";

		var width = Utils.getInt(f, ImageWidth);
		var height = Utils.getInt(f, ImageHeight);

		switch( [bpp, channels] ) {
		case [32, 1]:
			var b = new haxe.io.BytesBuffer();
			for( i in 0...width ) {
				b.add(f.data[i]);
			}
			return new hxd.Pixels(width, height, b.getBytes(), R32F);
		default: throw "Unsupported tif format";
		}
	}

}