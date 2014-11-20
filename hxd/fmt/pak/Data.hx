package hxd.fmt.pak;

class File {
	public var name : String;
	public var isDirectory : Bool;
	public var content : Array<File>;
	public var dataPosition : Int;
	public var dataSize : Int;
	public var checksum : Int;
	public function new() {
	}
}

class Data {
	public var version : Int;
	public var root : File;
	public var headerSize : Int;
	public var dataSize : Int;
	public function new() {
	}
}