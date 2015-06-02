package hxd.fmt.pak;
import hxd.fmt.pak.Data;

class Writer {

	var o : haxe.io.Output;

	public function new(o) {
		this.o = o;
	}

	public function writeFile( f : File ) {
		o.writeByte(f.name.length);
		o.writeString(f.name);
		var flags = 0;
		if( f.isDirectory ) flags |= 1;
		o.writeByte(flags);
		if( f.isDirectory ) {
			o.writeInt32(f.content.length);
			for( f in f.content )
				writeFile(f);
		} else {
			o.writeInt32(f.dataPosition);
			o.writeInt32(f.dataSize);
			o.writeInt32(f.checksum);
		}
	}

	public function write( pak : Data, content : haxe.io.Bytes, ?arrayContent : Array<haxe.io.Bytes> ) {

		if( arrayContent != null ) {
			pak.dataSize = 0;
			for( b in arrayContent )
				pak.dataSize += b.length;
		} else
			pak.dataSize = content.length;

		var header = new haxe.io.BytesOutput();
		new Writer(header).writeFile(pak.root);
		var header = header.getBytes();
		pak.headerSize = header.length + 16;

		o.writeString("PAK");
		o.writeByte(pak.version);
		o.writeInt32(pak.headerSize);
		o.writeInt32(pak.dataSize);
		o.write(header);
		o.writeString("DATA");
		if( arrayContent != null ) {
			for( b in arrayContent )
				o.write(b);
		} else
			o.write(content);
	}

}

