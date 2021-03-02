package hxd.fmt.tiff;
import hxd.fmt.tiff.Data;

class Writer {

	var f : haxe.io.Output;

	public function new(f) {
		this.f = f;
	}

	public function write( tif : TifFile ) {
		f.writeString("II");
		f.writeUInt16(42);
		var pos = 8;
		var offsets = [], lengths = [];
		for( d in tif.data ) {
			offsets.push(pos);
			lengths.push(d.length);
			pos += d.length;
		}
		f.writeInt32(pos);

		var tags = tif.tags.copy();
		for( d in tif.data )
			f.write(d);
		tags.push({ tag : StripOffsets, type : Long, value : VArray([for( o in offsets ) VInt(o)]) });
		tags.push({ tag : StripByteCounts, type : Long, value : VArray([for( o in lengths ) VInt(o)]) });
		tags.sort((t1,t2) -> t1.tag.toInt() - t2.tag.toInt());

		f.writeUInt16(tags.length);
		pos += 2;

		var endTags = pos + tags.length * 12 + 4;
		var tagExtraValues = [];

		for( t in tags ) {
			f.writeUInt16(t.tag.toInt());
			f.writeUInt16(t.type.toInt());
			var count = switch( t.value ) {
			case VArray(arr): arr.length;
			case VString(s): s.length;
			default: 1;
			}
			f.writeInt32(count);
			var size = count * t.type.getSize();
			if( size > 4 ) {
				f.writeInt32(endTags);
				endTags += size;
				tagExtraValues.push(t);
			} else {
				writeValue(t.type, t.value);
				while( size < 4 ) {
					f.writeByte(0);
					size++;
				}
			}
		}
		f.writeInt32(0);

		for( t in tagExtraValues )
			writeValue(t.type, t.value);

	}

	function writeValue( t : TifType, v : TifValue ) {
		switch( [t, v] ) {
		case [Byte, VInt(v)]:
			f.writeByte(v);
		case [Short,VInt(v)]:
			f.writeUInt16(v);
		case [Long,VInt(v)]:
			f.writeInt32(v);
		case [_, VArray(arr)]:
			for( v in arr )
				writeValue(t, v);
		default:
			throw "TODO:writeValue "+t+":"+v;
		}
	}


	public static function ofPixels( pix : hxd.Pixels ) {
		if( pix.format != R32F ) throw "Format not supported";
		var tif : TifFile = {
			tags : [],
			data : [],
		};
		inline function add(t,tp,v) tif.tags.push({ tag : t, type : tp, value : v });
		add(ImageWidth,Short,VInt(pix.width));
		add(ImageHeight,Short,VInt(pix.height));
		add(BitsPerSample,Short,VInt(32));
		add(Compression,Short,VInt(1));
		add(PhotometricInterpretation,Short,VInt(1));
		add(Orientation,Short,VInt(1));
		add(SamplesPerPixel,Short,VInt(1));
		add(RowsPerStrip,Short,VInt(1));
		add(PlanarConfiguration,Short,VInt(1));
		add(SampleFormat,Short,VInt(3));
		var lineSize = pix.width * 4;
		for( i in 0...pix.width )
			tif.data.push(pix.bytes.sub(pix.offset + i * lineSize, lineSize));
		return tif;
	}

}