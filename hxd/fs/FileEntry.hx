package hxd.fs;

class FileEntry {

	public var name(default, null) : String;
	public var path(get, never) : String;
	public var directory(get, never) : String;
	/**
		Real extension of file referenced by FileEntry in lowercase.
	**/
	public var extension(get, never) : String;
	/**
		Full extension chain of file referenced by FileEntry in lowercase.  
		For `file.extra.ext` it will return full extension chain - `extra.ext` while `extension` property will return only `ext`.
	**/
	public var fullExtension(get, never) : String;
	public var size(get, never) : Int;
	public var isDirectory(get, never) : Bool;
	public var isAvailable(get, never) : Bool;

	// first four bytes of the file
	public function getSign() : Int return 0;

	public function getBytes() : haxe.io.Bytes return null;

	public function getText() return getBytes().toString();

	public function open() { }
	public function skip( nbytes : Int ) { }
	public function readByte() : Int return 0;
	public function read( out : haxe.io.Bytes, pos : Int, size : Int ) {}
	public function close() {}

	public function load( ?onReady : Void -> Void ) : Void { if( !isAvailable ) throw "load() not implemented"; else if( onReady != null ) onReady(); }
	public function loadBitmap( onLoaded : LoadedBitmap -> Void ) : Void { throw "loadBitmap() not implemented"; }
	public function watch( onChanged : Null<Void -> Void> ) { }
	public function exists( name : String ) : Bool return false;
	public function get( name : String ) : FileEntry return null;

	public function iterator() : hxd.impl.ArrayIterator<FileEntry> return null;

	function get_isAvailable() return true;
	function get_isDirectory() return false;
	function get_size() return 0;
	function get_path() : String { throw "path() not implemented"; return null; };

	function get_directory() {
		var idx = path.lastIndexOf("/");
		return idx == -1 ? "" : path.substr(0, idx);
	}

	function get_extension() {
		var idx = name.lastIndexOf(".");
		return idx == -1 ? "" : name.substr(idx+1).toLowerCase();
	}

	function get_fullExtension() {
		var idx = name.indexOf(".");
		return idx == -1 ? "" : name.substr(idx+1).toLowerCase();
	}
}
