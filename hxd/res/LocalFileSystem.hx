package hxd.res;

@:allow(hxd.res.LocalFileSystem)
@:access(hxd.res.LocalFileSystem)
private class LocalEntry extends FileEntry {
	
	var fs : LocalFileSystem;
	var relPath : String;
	#if air3
	var file : flash.filesystem.File;
	var fread : flash.filesystem.FileStream;
	#else
	var file : Dynamic;
	#end

	function new(fs, name, relPath, file) {
		this.name = name;
		this.relPath = relPath;
		this.file = file;
	}

	override function getBytes() : haxe.io.Bytes {
		#if air3
		var fs = new flash.filesystem.FileStream();
		fs.open(file, flash.filesystem.FileMode.READ);
		var bytes = haxe.io.Bytes.alloc(fs.bytesAvailable);
		fs.readBytes(bytes.getData());
		fs.close();
		return bytes;
		#else
		return null;
		#end
	}
	
	override function open() {
		#if air3
		if( fread != null ) fread.close();
		fread = new flash.filesystem.FileStream();
		fread.open(file, flash.filesystem.FileMode.READ);
		#end
	}
	
	override function read( out : haxe.io.Bytes, pos : Int, size : Int ) : Void {
		#if air3
		if( fread == null ) throw "File not opened";
		fread.readBytes(out.getData(), pos, size);
		#end
	}

	override function close() {
		#if air3
		if( fread != null ) {
			fread.close();
			fread = null;
		}
		#end
	}
	
	override function load( ?onReady : Void -> Void ) : Void {
		if( onReady != null ) haxe.Timer.delay(onReady, 1);
	}
	
	override function loadBitmap( onLoaded : hxd.BitmapData -> Void ) : Void {
		#if flash
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) {
			throw Std.string(e) + " while loading " + relPath;
		});
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
			var content : flash.display.Bitmap = cast loader.content;
			onLoaded(hxd.BitmapData.fromNative(content.bitmapData));
			loader.unload();
		});
		loader.load(new flash.net.URLRequest(file.url));
		#else
		#end
	}
	
	override function get_path() {
		return relPath == null ? "<root>" : relPath;
	}
	
	override function exists( name : String ) {
		return fs.exists(relPath == null ? name : relPath + "/" + name);
	}
	
	override function get( name : String ) {
		return fs.get(relPath == null ? name : relPath + "/" + name);
	}
	
	override function get_size() {
		#if air3
		return Std.int(file.size);
		#else
		return 0;
		#end
	}

	override function iterator() {
		#if air3
		var arr = new Array<FileEntry>();
		for( f in file.getDirectoryListing() )
			switch( f.name ) {
			case ".svn", ".git" if( f.isDirectory ):
				continue;
			default:
				arr.push(new LocalEntry(fs, f.name, relPath == null ? f.name : relPath + "/" + f.name, f));
			}
		return new hxd.impl.ArrayIterator(arr);
		#else
		#end
	}
	
}

class LocalFileSystem implements FileSystem {
	
	var baseDir : String;
	var root : FileEntry;
	
	public function new( baseDir : String ) {
		this.baseDir = baseDir;
		#if air3
		var froot = new flash.filesystem.File(flash.filesystem.File.applicationDirectory.nativePath + "/" + baseDir);
		if( !froot.exists ) throw "Could not find dir " + baseDir;
		this.baseDir = froot.nativePath;
		this.baseDir = this.baseDir.split("\\").join("/");
		if( !StringTools.endsWith(this.baseDir, "/") ) this.baseDir += "/";
		root = new LocalEntry(this, "root", null, froot);
		#end
	}
	
	public function getRoot() : FileEntry {
		return root;
	}

	#if air3
	function open( path : String ) {
		var f = new flash.filesystem.File(baseDir + path);
		// ensure exact case / no relative path
		if( f.nativePath.split("\\").join("/") != baseDir + path )
			return null;
		return f;
	}
	#end
	
	public function exists( path : String ) {
		#if air3
		var f = open(path);
		return f != null && f.exists;
		#else
		return false;
		#end
	}
	
	public function get( path : String ) {
		#if air3
		var f = open(path);
		if( f == null || !f.exists )
			throw "File not found " + path;
		return new LocalEntry(this, path.split("/").pop(), path, f);
		#else
		return null;
		#end
	}
	
}