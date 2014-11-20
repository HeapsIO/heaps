package hxd.fmt.pak;
import hxd.fmt.pak.Data;

class Reader {

	var i : haxe.io.Input;

	public function new(i) {
		this.i = i;
	}

	public function readHeader() : Data {
		if( i.readString(3) != "PAK" ) throw "Invalid PAK file";
		var pak = new Data();
		pak.version = i.readByte();
		pak.headerSize = i.readInt32();
		pak.dataSize = i.readInt32();
		// single read header
		var old = i;
		i = new haxe.io.BytesInput(i.read(pak.headerSize - 16));
		pak.root = readFile();
		i = old;
		if( i.readString(4) != "DATA" ) throw "Corrupted PAK header";
		return pak;
	}

	function readFile() : File {
		var f = new File();
		f.name = i.readString(i.readByte());
		var flags = i.readByte();
		if( flags & 1 != 0 ) {
			f.isDirectory = true;
			f.content = [];
			for( i in 0...i.readInt32() )
				f.content.push(readFile());
		} else {
			f.dataPosition = i.readInt32();
			f.dataSize = i.readInt32();
			f.checksum = i.readInt32();
		}
		return f;
	}

}