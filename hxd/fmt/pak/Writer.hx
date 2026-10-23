package hxd.fmt.pak;
import hxd.fmt.pak.Data;

class Writer {

	var o : haxe.io.Output;
	var align : Int = 0;
	var zeros : haxe.io.Bytes;

	public function new(o, ?align) {
		this.o = o;
		this.align = align;
	}

	public function writeFile( f : File ) {
		o.writeByte(f.name.length);
		o.writeString(f.name);
		var flags = 0;
		if( f.isDirectory ) flags |= 1;
		var p = Std.int(f.dataPosition);
		if( p != f.dataPosition ) flags |= 2;
		o.writeByte(flags);
		if( f.isDirectory ) {
			o.writeInt32(f.content.length);
			for( f in f.content )
				writeFile(f);
		} else {
			if( p == f.dataPosition )
				o.writeInt32(p);
			else
				o.writeDouble(f.dataPosition);
			o.writeInt32(f.dataSize);
			o.writeInt32(f.checksum);
		}
	}

	function addPadding( pos : Int ) {
		var padLen = align - pos % align;
		if( zeros == null )
			zeros = haxe.io.Bytes.alloc(align);
		o.writeFullBytes(zeros, 0, padLen);
	}

	public static function getDataSize( sizes : Array<Int>, align : Int ) {
		var size = 0;
		for( s in sizes ) {
			size += s;
			if (align > 1)
				size += align - s % align;
		}
		return size;
	}

	public function write( pak : Data, content : haxe.io.Bytes, ?arrayContent : Array<haxe.io.Bytes> ) {
		if( arrayContent != null ) {
			writeStream(pak, [for( b in arrayContent ) b.length], i -> arrayContent[i]);
			return;
		}
		pak.dataSize = content.length;
		writeHeader(pak);
		o.write(content);
	}

	public function writeStream( pak : Data, sizes : Array<Int>, getData : Int -> haxe.io.Bytes ) {
		pak.dataSize = getDataSize(sizes, align);
		writeHeader(pak);
		for( i in 0...sizes.length ) {
			var b = getData(i);
			if( b.length != sizes[i] )
				throw "Data size changed while writing the pak : " + b.length + " instead of " + sizes[i];
			o.write(b);
			if (align > 1) addPadding(b.length);
		}
	}

	public function writeHeader( pak : Data ) {
		var header = new haxe.io.BytesOutput();
		new Writer(header).writeFile(pak.root);
		var header = header.getBytes();
		pak.headerSize = header.length + 16;
		if (align > 1)
			pak.headerSize += align - pak.headerSize % align;

		o.writeString("PAK");
		o.writeByte(pak.version);
		o.writeInt32(pak.headerSize);
		o.writeInt32(pak.dataSize);
		o.write(header);
		if (align > 1) addPadding(header.length + 16); // Align for end of DATA
		o.writeString("DATA");
	}

}

