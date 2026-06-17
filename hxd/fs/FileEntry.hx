package hxd.fs;

class FileEntry {

	public var name(default, null) : String;
	public var path(get, never) : String;
	public var directory(get, never) : String;
	public var extension(get, never) : String;
	public var size(get, never) : Int;
	public var isDirectory(get, never) : Bool;
	public var isAvailable(get, never) : Bool;

	public function getBytes() : haxe.io.Bytes return null;
	public function readBytes( out : haxe.io.Bytes, outPos : Int, pos : Int, len : Int ) : Int { throw "readBytes() not implemented"; }


	#if heaps_mt_loader
	static var TMP_BYTES(get,set) : haxe.io.Bytes;
	static var bytesValue = new sys.thread.Tls<haxe.io.Bytes>();
	static function get_TMP_BYTES() return bytesValue.value;
	static function set_TMP_BYTES(v) return bytesValue.value = v;
	#else
	static var TMP_BYTES : haxe.io.Bytes = null;
	#end
	/**
		Similar to readBytes except :
		a) a temporary buffer is reused, meaning a single fetchBytes must occur at a single time
		b) it will throw an Eof exception if the data is not available
	**/
	public function fetchBytes( pos, len ) : haxe.io.Bytes {
		var bytes = TMP_BYTES;
		if( bytes == null || bytes.length < len ) {
			var allocSize = (len + 65535) & 0xFFFF0000;
			bytes = haxe.io.Bytes.alloc(allocSize);
			TMP_BYTES = bytes;
		}
		readFull(bytes,pos,len);
		return bytes;
	}

	public function readFull( bytes, pos, len ) {
		if( readBytes(bytes,0,pos,len) < len )
			throw new haxe.io.Eof();
	}

	/**
		Read first 4 bytes of the file.
	**/
	public function getSign() : Int {
		var bytes = fetchBytes(0, 4);
		return bytes.get(0) | (bytes.get(1) << 8) | (bytes.get(2) << 16) | (bytes.get(3) << 24);
	}

	public function getText() return getBytes().toString();
	public function open() return @:privateAccess new FileInput(this);

	public function load( ?onReady : Void -> Void ) : Void { if( !isAvailable ) throw "load() not implemented"; else if( onReady != null ) onReady(); }
	public function loadBitmap( onLoaded : LoadedBitmap -> Void ) : Void { throw "loadBitmap() not implemented"; }
	public function watch( onChanged : Null<Void -> Void> ) { }
	#if multidriver
	public function unwatch( id : Int ) { }
	#end
	public function exists( name : String ) : Bool return false;
	public function get( name : String ) : FileEntry return null;

	public function iterator() : hxd.impl.ArrayIterator<FileEntry> return null;

	function get_isAvailable() return true;
	function get_isDirectory() return false;
	function get_size() return 0;
	function get_path() : String { throw "path() not implemented"; return null; };

	function get_directory() {
		var idx = path.lastIndexOf("/");
		if (idx < 0) return "";
		return path.substr(0, idx);
	}

	function get_extension() {
		var idx = name.lastIndexOf(".");
		if (idx < 0) return "";
		return name.substr(idx+1).toLowerCase();
	}
}
