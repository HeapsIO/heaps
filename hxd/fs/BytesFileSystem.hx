package hxd.fs;

class BytesFileEntry extends FileEntry {

	var fullPath : String;
	var bytes : haxe.io.Bytes;
	var pos : Int;

	public function new(path, bytes) {
		this.fullPath = path;
		this.name = path.split("/").pop();
		this.bytes = bytes;
	}

	override function get_path() {
		return fullPath;
	}

	override function getSign() : Int {
		return bytes.get(0) | (bytes.get(1) << 8) | (bytes.get(2) << 16) | (bytes.get(3) << 24);
	}

	override function getBytes() : haxe.io.Bytes {
		return bytes;
	}

	override function open() {
		pos = 0;
	}

	override function skip( nbytes : Int ) {
		pos += nbytes;
	}
	override function readByte() : Int {
		return bytes.get(pos++);
	}

	override function read( out : haxe.io.Bytes, pos : Int, size : Int ) {
		out.blit(pos, bytes, this.pos, size);
		this.pos += size;
	}

	override function close() {
	}

	override function load( ?onReady : Void -> Void ) : Void {
		haxe.Timer.delay(onReady, 1);
	}

	override function loadBitmap( onLoaded : LoadedBitmap -> Void ) : Void {
		throw "TODO";
	}

	override function exists( name : String ) : Bool return false;
	override function get( name : String ) : FileEntry return null;

	override function iterator() : hxd.impl.ArrayIterator<FileEntry> return new hxd.impl.ArrayIterator([]);

	override function get_size() return bytes.length;

}

class BytesFileSystem implements FileSystem {

	function new() {
	}

	public function getRoot() {
		throw "Not implemented";
		return null;
	}

	function getBytes( path : String ) : haxe.io.Bytes {
		throw "Not implemented";
		return null;
	}

	public function exists( path : String ) {
		return getBytes(path) != null;
	}

	public function get( path : String ) {
		var bytes = getBytes(path);
		if( bytes == null ) throw "Resource not found '" + path + "'";
		return new BytesFileEntry(path,bytes);
	}

	public function dispose() {
	}

}