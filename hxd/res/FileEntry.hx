package hxd.res;

class FileEntry {

	public var name(default, null) : String;
	public var path(get, never) : String;
	public var extension(get, never) : String;
	public var size(get, never) : Int;
	public var isDirectory(get, never) : Bool;
	public var isAvailable(get, never) : Bool;

	// first four bytes of the file
	public function getSign() : Int return 0;

	public function getBytes() : haxe.io.Bytes return null;

	public function open() { }
	public function skip( nbytes : Int ) { }
	public function readByte() : Int return 0;
	public function read( out : haxe.io.Bytes, pos : Int, size : Int ) {}
	public function close() {}

	public function load( ?onReady : Void -> Void ) : Void {}
	public function loadBitmap( onLoaded : LoadedBitmap -> Void ) : Void {}
	public function watch( onChanged : Null<Void -> Void> ) { }
	public function exists( name : String ) : Bool return false;
	public function get( name : String ) : FileEntry return null;

	public function iterator() : hxd.impl.ArrayIterator<FileEntry> return null;

	function get_isAvailable() return true;
	function get_isDirectory() return false;
	function get_size() return 0;
	function get_path() return name;
	function get_extension() {
		var np = name.split(".");
		return np.length == 1 ? "" : np.pop().toLowerCase();
	}
}
