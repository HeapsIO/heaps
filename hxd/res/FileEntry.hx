package hxd.res;

class FileEntry {
	
	public var name(default, null) : String;
	public var path(get, never) : String;
	public var size(get, never) : Int;
	public var isDirectory(get, never) : Bool;
	public var isAvailable(get, never) : Bool;
	
	public function getBytes() : haxe.io.Bytes return null;
	
	public function open() { }
	public function readByte() : Int return 0;
	public function read( out : haxe.io.Bytes, pos : Int, size : Int ) {}
	public function close() {}
	
	public function load( ?onReady : Void -> Void ) : Void {}
	public function loadBitmap( onLoaded : hxd.BitmapData -> Void ) : Void {}

	public function exists( name : String ) : Bool return false;
	public function get( name : String ) : FileEntry return null;
	
	public function iterator() : hxd.impl.ArrayIterator<FileEntry> return null;
	
	function get_isAvailable() return true;
	function get_isDirectory() return false;
	function get_size() return 0;
	function get_path() return name;
	
}
