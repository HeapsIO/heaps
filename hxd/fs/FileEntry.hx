package hxd.fs;

/**
	The base class representing a single file in the FileSystem.

	Should not be instantiated directly, as specific implementation lies on the FileSystem type used.
**/
class FileEntry {
	/**
		The name of the file.
	**/
	public var name(default, null) : String;
	/**
		The local path of the file from the resource root.
		
		For instance `/myproject/res/ui/background/image.png` will have a path of `ui/background/image.png`
	**/
	public var path(get, never) : String;
	/**
		The directory path the file is placed in.
		
		For instance `/myproject/res/ui/background/image.png` will have a path of directory of `ui/background`
	**/
	public var directory(get, never) : String;
	/**
		Lowercase file extension of the file without the dot (i.e. `png`).
	**/
	public var extension(get, never) : String;
	/**
		The size of the file in bytes.
	**/
	public var size(get, never) : Int;
	/**
		Whether this entry is a directory.

		Depending on FileSystem used, it may contain directory entries.
		In that case they can be iterated over, but should not be accessed as files.
	**/
	public var isDirectory(get, never) : Bool;
	/**
		Whether this entry is loaded and its contents can be accessed. Otherwise `FileEntry.load` have to be called.

		Depending on FileSystem, some files cannot be accessed immediately and have to be loaded first.
		In that case `isAvailable` is `false` until file is loaded.
	**/
	public var isAvailable(get, never) : Bool;

	/**
		Returns the first four bytes of the file which usually is a file signature.
	**/
	public function getSign() : Int return 0;

	/**
		Returns the contents of the file as Bytes.
	**/
	public function getBytes() : haxe.io.Bytes return null;

	/**
		Returns the contents of the file as a String.
	**/
	public function getText() return getBytes().toString();

	/**
		Prepares file to be read from the start or moves the reading position to the beginning if its already opened.

		This is an alternative way to read file data without storing its entirety in the RAM.
		Note that depending on FileSystem used, they always load entire file into RAM, such as EmbedFileSystem or BytesFileSystem.
		However for LocalFileSystem this is a preferred method of reading files when entirety of the file is not required in the RAM.

		Required to be called before `FileEntry.skip`, `FileEntry.readByte` and `FileEntry.read` can be called.
		`FileEntry.close` should be called after the file reading is complete.
	**/
	public function open() { }
	/**
		Moves the reading position of the file by `nbytes`.

		File have to be opened first via `FileEntry.open`.
	**/
	public function skip( nbytes : Int ) { }
	/**
		Reads a single byte from the file.

		File have to be opened first via `FileEntry.open`.
	**/
	public function readByte() : Int return 0;
	/**
		Reads the bytes from the file into the output Bytes.

		File have to be opened first via `FileEntry.open`.

		@param out The output Bytes instance file data is written into.
		@param pos The position in `out` starting from which the data is written.
		@param size The amount of bytes to read.
	**/
	public function read( out : haxe.io.Bytes, pos : Int, size : Int ) {}
	/**
		Closes the file previously opened file via `FileEntry.open`.
	**/
	public function close() {}

	/**
		Loads the file, preparing it to be accessed. `FileEntry.isAvailable` can be used to determine is file is loaded/ready to be accessed.

		This is an asynchronous operation and may be delayed for at least one frame.
		
		@param onReady The callback that is invoked after the file is loaded.
	**/
	public function load( ?onReady : Void -> Void ) : Void { if( !isAvailable ) throw "load() not implemented"; else if( onReady != null ) onReady(); }
	/**
		Loads the file as platform-specific Bitmap. Will throw an exception for anything except JS target.
		For FileSystem-independent bitmap loading use `hxd.res.Image` Resource.

		This is an asynchronous operation and delayed for at least one frame.

		@param onLoaded The callback that is invoked after the bitmap is loaded.
	**/
	public function loadBitmap( onLoaded : LoadedBitmap -> Void ) : Void { throw "loadBitmap() not implemented"; }
	/**
		Register a function that will be called if the file changes. This might only be supported on file based filesystems.

		Only one callback can be set at a time.

		@param onChanged The callback that is invoked when the file is changed. Pass `null` to stop monitoring the file for changes.
	**/
	public function watch( onChanged : Null<Void -> Void> ) { }
	/**
		Checks whether the file under the given name exists inside this file entry.
		Usually a shortcut to `FileSystem.exists` this entry belongs to with combined path of this file and given name.

		Can be used only for directory entries.
	**/
	public function exists( name : String ) : Bool return false;
	/**
		Returns the FileEntry instance of the file under given name inside this file entry.
		Usually a shortcut to `FileSystem.get` this entry belongs to with combined path of this file and given name.

		Can be used only for directory entries.

		@throws NotFound if the file under given path does not exist.
	**/
	public function get( name : String ) : FileEntry return null;

	/**
		Returns an iterator of FileEntries contained in this directory entry.

		Can be used only for directory entries.
	**/
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
