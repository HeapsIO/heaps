package hxd.fs;

/**
	The `MultiFileSystem` file entry.
**/
private class MultiFileEntry extends FileEntry {

	var fs : MultiFileSystem;
	var el : Array<FileEntry>;

	public function new(fs, el) {
		this.fs = fs;
		this.el = el;
		name = el[0].name;
	}

	override function getSign() : Int return el[0].getSign();

	override function getBytes() : haxe.io.Bytes return el[0].getBytes();

	override function open() el[0].open();
	override function skip( nbytes : Int ) el[0].skip(nbytes);

	override function readByte() : Int return el[0].readByte();
	override function read( out : haxe.io.Bytes, pos : Int, size : Int ) return el[0].read(out, pos, size);
	override function close() el[0].close();

	override function load( ?onReady : Void -> Void ) : Void return el[0].load(onReady);
	override function loadBitmap( onLoaded : LoadedBitmap -> Void ) : Void return el[0].loadBitmap(onLoaded);
	override function watch( onChanged : Null < Void -> Void > ) {
		for( e in el )
			e.watch(onChanged);
	}
	override function exists( name : String ) : Bool {
		for( e in el )
			if( e.exists(name) )
				return true;
		return false;
	}
	override function get( name : String ) : FileEntry {
		return fs.get(path + "/" + name);
	}

	override function iterator() : hxd.impl.ArrayIterator<FileEntry> {
		var names = new Map();
		var all : Array<FileEntry> = [];
		for( e in el )
			for( i in e.iterator() )
				if( !names.exists(i.name) ) {
					names.set(i.name, true);
					all.push(get(i.name));
				}
		return new hxd.impl.ArrayIterator(all);
	}

	override function get_isAvailable() return el[0].isAvailable;
	override function get_isDirectory() return el[0].isDirectory;
	override function get_size() return el[0].size;
	override function get_path() : String return el[0].path;

}

/**
	A container for multiple FileSystems that can be accessed as a singular FS.

	The order of the file systems is important, as they are processed in first-come-first-serve manner, meaning that if file
	exists in multiple instances, the first one that was found will be served.

	Enables for usage of multiple different `FileSystem` instances to provide easy implementation of things like modding or 
	partial asset embedding (by using `EmbedFileSystem` to store assets used while primary assets are loaded for another FS type).
**/
class MultiFileSystem implements FileSystem {

	var cache : Map<String, MultiFileEntry>;
	var root : MultiFileEntry;
	/**
		The list of FS instances used in the MultiFS.
	**/
	public var fs : Array<FileSystem>;

	/**
		Create a new MultiFileSystem instance.
		@param fs The list of the FileSystem instances that are combined.
	**/
	public function new(fs) {
		this.fs = fs;
		cache = new Map();
		root = new MultiFileEntry(this,[for( f in fs ) f.getRoot()]);
	}

	/**
		Returns the root FileEntry directory of the FileSystem.
	**/
	public function getRoot() {
		return root;
	}

	/**
		Returns the FileEntry instance under the given `path`.

		@throws `NotFound` if the file under given path does not exist.
	**/
	public function get( path : String ) : FileEntry {
		var f = cache.get(path);
		if( f != null )
			return f;
		var el = [];
		for( f in fs ) {
			try {
				var e = f.get(path);
				el.push(e);
				if( !e.isDirectory )
					break;
			} catch( e : NotFound ) {
			}
		}
		if( el.length == 0 )
			throw new NotFound(path);
		var f = new MultiFileEntry(this,el);
		cache.set(path, f);
		return f;
	}

	/**
		Checks whether the file under given `path` exists or not.
	**/
	public function exists( path : String ) : Bool {
		for( f in fs )
			if( f.exists(path) )
				return true;
		return false;
	}

	/**
		Disposes of the file system and all underlying file system instances.
	**/
	public function dispose() {
		for( f in fs )
			f.dispose();
	}

	/**
		Not supported and throws an error.
	**/
	public function dir( path : String ) : Array<FileEntry> {
		throw "Not Supported";
	}

}