package hxd.fs;

class FileInput extends haxe.io.Input {

	var f : FileEntry;

	public function new(f) {
		this.f = f;
		f.open();
	}

	public function skip( nbytes : Int ) {
		f.skip(nbytes);
	}

	override function readByte() {
		return f.readByte();
	}

	override function readBytes( b : haxe.io.Bytes, pos : Int, len : Int ) {
		f.read(b, pos, len);
		return len;
	}

	override function close() {
		f.close();
	}

}
