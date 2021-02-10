package hxd.fs;

/**
	An implementation of haxe Input with `FileEntry` as its base.
**/
class FileInput extends haxe.io.Input {

	var f : FileEntry;

	/**
		Create a new FileInput instance with the given FileEntry `f`.
	**/
	public function new(f) {
		this.f = f;
		f.open();
	}

	/**
		Skip the given `nbytes` bytes in the data stream.
	**/
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
