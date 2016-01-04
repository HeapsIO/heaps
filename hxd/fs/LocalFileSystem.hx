package hxd.fs;

#if (air3 || sys)

@:allow(hxd.fs.LocalFileSystem)
@:access(hxd.fs.LocalFileSystem)
private class LocalEntry extends FileEntry {

	var fs : LocalFileSystem;
	var relPath : String;
	#if air3
	var file : flash.filesystem.File;
	var fread : flash.filesystem.FileStream;
	var checkExists : Bool;
	#else
	var file : String;
	var fread : sys.io.FileInput;
	#end

	function new(fs, name, relPath, file) {
		this.fs = fs;
		this.name = name;
		this.relPath = relPath;
		this.file = file;
		if( fs.createHMD && extension == "fbx" )
			convertToHMD();
		if( fs.createMP3 && extension == "wav" )
			convertToMP3();
		if( fs.createOGG && extension == "wav" )
			convertToOGG();
	}

	static var INVALID_CHARS = ~/[^A-Za-z0-9_]/g;

	function convertToHMD() {
		function getHMD() {
			var fbx = null;
			var content = getBytes();
			try fbx = hxd.fmt.fbx.Parser.parse(content.toString()) catch( e : Dynamic ) throw Std.string(e) + " in " + relPath;
			var hmdout = new hxd.fmt.fbx.HMDOut();
			hmdout.load(fbx);
			var hmd = hmdout.toHMD(null, !StringTools.startsWith(name, "Anim_"));
			var out = new haxe.io.BytesOutput();
			new hxd.fmt.hmd.Writer(out).write(hmd);
			return out.getBytes();
		}
		var target = fs.tmpDir + "R_" + INVALID_CHARS.replace(relPath,"_") + ".hmd";
		#if air3
		var target = new flash.filesystem.File(target);
		if( !target.exists || target.modificationDate.getTime() < file.modificationDate.getTime() ) {
			var hmd = getHMD();
			var out = new flash.filesystem.FileStream();
			out.open(target, flash.filesystem.FileMode.WRITE);
			out.writeBytes(hmd.getData());
			out.close();
			checkExists = true;
		}
		#else
		var ttime = try sys.FileSystem.stat(target) catch( e : Dynamic ) null;
		if( ttime == null || ttime.mtime.getTime() < sys.FileSystem.stat(file).mtime.getTime() ) {
			var hmd = getHMD();
			sys.io.File.saveBytes(target, hmd);
		}
		#end
		file = target;
	}

	function convertToMP3() {
		var target = fs.tmpDir + "R_" + INVALID_CHARS.replace(relPath,"_") + ".mp3";
		#if air3
		var target = new flash.filesystem.File(target);
		if( !target.exists || target.modificationDate.getTime() < file.modificationDate.getTime() ) {
			hxd.snd.Convert.toMP3(file.nativePath, target.nativePath);
			checkExists = true;
		}
		#else
		var ttime = try sys.FileSystem.stat(target) catch( e : Dynamic ) null;
		if( ttime == null || ttime.mtime.getTime() < sys.FileSystem.stat(file).mtime.getTime() )
			hxd.snd.Convert.toMP3(file, target);
		#end
		file = target;
	}

	function convertToOGG() {
		var target = fs.tmpDir + "R_" + INVALID_CHARS.replace(relPath,"_") + ".ogg";
		#if air3
		var target = new flash.filesystem.File(target);
		if( !target.exists || target.modificationDate.getTime() < file.modificationDate.getTime() ) {
			hxd.snd.Convert.toOGG(file.nativePath, target.nativePath);
			checkExists = true;
		}
		#else
		var ttime = try sys.FileSystem.stat(target) catch( e : Dynamic ) null;
		if( ttime == null || ttime.mtime.getTime() < sys.FileSystem.stat(file).mtime.getTime() )
			hxd.snd.Convert.toOGG(file, target);
		#end
		file = target;
	}

	override function getSign() : Int {
		#if air3
		var old = fread == null ? -1 : fread.position;
		open();
		fread.endian = flash.utils.Endian.LITTLE_ENDIAN;
		var i = fread.readUnsignedInt();
		if( old < 0 ) close() else fread.position = old;
		return i;
		#else
		var old = if( fread == null ) -1 else fread.tell();
		open();
		var i = fread.readInt32();
		if( old < 0 ) close() else fread.seek(old, SeekBegin);
		return i;
		#end
	}

	override function getTmpBytes() {
		#if air3
		if( checkExists && !file.exists )
			return haxe.io.Bytes.alloc(0);
		var fs = new flash.filesystem.FileStream();
		fs.open(file, flash.filesystem.FileMode.READ);
		var bytes = hxd.impl.Tmp.getBytes(fs.bytesAvailable);
		fs.readBytes(bytes.getData());
		fs.close();
		return bytes;
		#else
		return sys.io.File.getBytes(file);
		#end
	}

	override function getBytes() : haxe.io.Bytes {
		#if air3
		if( checkExists && !file.exists )
			return haxe.io.Bytes.alloc(0);
		var fs = new flash.filesystem.FileStream();
		fs.open(file, flash.filesystem.FileMode.READ);
		var bytes = haxe.io.Bytes.alloc(fs.bytesAvailable);
		fs.readBytes(bytes.getData());
		fs.close();
		return bytes;
		#else
		return sys.io.File.getBytes(file);
		#end
	}

	override function open() {
		#if air3
		if( fread != null )
			fread.position = 0;
		else {
			fread = new flash.filesystem.FileStream();
			fread.open(file, flash.filesystem.FileMode.READ);
		}
		#else
		if( fread != null )
			fread.seek(0, SeekBegin);
		else
			fread = sys.io.File.read(file);
		#end
	}

	override function skip(nbytes:Int) {
		#if air3
		fread.position += nbytes;
		#else
		fread.seek(nbytes, SeekCur);
		#end
	}

	override function readByte() {
		#if air3
		return fread.readUnsignedByte();
		#else
		return fread.readByte();
		#end
	}

	override function read( out : haxe.io.Bytes, pos : Int, size : Int ) : Void {
		#if air3
		fread.readBytes(out.getData(), pos, size);
		#else
		fread.readFullBytes(out, pos, size);
		#end
	}

	override function close() {
		#if air3
		if( fread != null ) {
			fread.close();
			fread = null;
		}
		#else
		if( fread != null ) {
			fread.close();
			fread = null;
		}
		#end
	}

	override function get_isDirectory() {
		#if air3
		return file.isDirectory;
		#else
		throw "TODO";
		return false;
		#end
	}

	override function load( ?onReady : Void -> Void ) : Void {
		#if air3
		if( onReady != null ) haxe.Timer.delay(onReady, 1);
		#else
		throw "TODO";
		#end
	}

	override function loadBitmap( onLoaded : hxd.fs.LoadedBitmap -> Void ) : Void {
		#if flash
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) {
			throw Std.string(e) + " while loading " + relPath;
		});
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
			var content : flash.display.Bitmap = cast loader.content;
			onLoaded(new hxd.fs.LoadedBitmap(content.bitmapData));
			loader.unload();
		});
		loader.load(new flash.net.URLRequest(file.url));
		#else
		throw "TODO";
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
		return sys.FileSystem.stat(file).size;
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
		var arr = new Array<FileEntry>();
		for( f in sys.FileSystem.readDirectory(file) ) {
			switch( f ) {
			case ".svn", ".git" if( sys.FileSystem.isDirectory(file+"/"+f) ):
				continue;
			default:
				arr.push(new LocalEntry(fs, f, relPath == null ? f : relPath + "/" + f, file+"/"+f));
			}
		}
		return new hxd.impl.ArrayIterator(arr);
		#end
	}

	#if air3

	var watchCallback : Void -> Void;
	var watchTime : Float;
	static var WATCH_INDEX = 0;
	static var WATCH_LIST : Array<LocalEntry> = null;

	static function checkFiles(_) {
		var w = WATCH_LIST[WATCH_INDEX++];
		if( w == null ) {
			WATCH_INDEX = 0;
			return;
		}
		var t = try w.file.modificationDate.getTime() catch( e : Dynamic ) -1;
		if( t != w.watchTime ) {
			// check we can write (might be deleted/renamed/currently writing)
			try {
				var f = new flash.filesystem.FileStream();
				f.open(w.file, flash.filesystem.FileMode.READ);
				f.close();
				f.open(w.file, flash.filesystem.FileMode.APPEND);
				f.close();
			} catch( e : Dynamic ) return;
			w.watchTime = t;
			w.watchCallback();
		}
	}

	override function watch( onChanged : Null < Void -> Void > ) {
		if( onChanged == null ) {
			if( watchCallback != null ) {
				WATCH_LIST.remove(this);
				watchCallback = null;
			}
			return;
		}
		if( watchCallback == null ) {
			if( WATCH_LIST == null ) {
				WATCH_LIST = [];
				flash.Lib.current.stage.addEventListener(flash.events.Event.ENTER_FRAME, checkFiles);
			}
			var path = path;
			for( w in WATCH_LIST )
				if( w.path == path ) {
					w.watchCallback = null;
					WATCH_LIST.remove(w);
				}
			WATCH_LIST.push(this);
		}
		watchTime = file.modificationDate.getTime();
		watchCallback = onChanged;
		return;
	}

	#end

}

class LocalFileSystem implements FileSystem {

	var root : FileEntry;
	#if air3
	var fileCache = new Map<String,{r:flash.filesystem.File}>();
	#end
	public var baseDir(default,null) : String;
	var createHMD : Bool = true;
	public var createMP3 : Bool;
	public var createOGG : Bool;
	public var tmpDir : String;

	public function new( dir : String ) {
		baseDir = dir;
		#if air3
		var froot = new flash.filesystem.File(flash.filesystem.File.applicationDirectory.nativePath + "/" + baseDir);
		if( !froot.exists ) throw "Could not find dir " + dir;
		baseDir = froot.nativePath;
		baseDir = baseDir.split("\\").join("/");
		if( !StringTools.endsWith(baseDir, "/") ) baseDir += "/";
		root = new LocalEntry(this, "root", null, froot);
		#else
		var exePath = Sys.executablePath().split("\\").join("/").split("/");
		exePath.pop();
		var froot = sys.FileSystem.fullPath(exePath.join("/") + "/" + baseDir);
		if( !sys.FileSystem.isDirectory(froot) ) {
			froot = sys.FileSystem.fullPath(baseDir);
			if( !sys.FileSystem.isDirectory(froot) )
				throw "Could not find dir " + dir;
		}
		baseDir = froot.split("\\").join("/");
		if( !StringTools.endsWith(baseDir, "/") ) baseDir += "/";
		root = new LocalEntry(this, "root", null, baseDir);
		#end
		tmpDir = baseDir + ".tmp/";
	}

	public function getRoot() : FileEntry {
		return root;
	}

	function open( path : String ) {
		#if air3
		var r = fileCache.get(path);
		if( r != null )
			return r.r;
		var f = new flash.filesystem.File(baseDir + path);
		// ensure exact case / no relative path
		f.canonicalize();
		if( !f.exists || f.nativePath.split("\\").join("/") != baseDir + path )
			f = null;
		fileCache.set(path, { r:f } );
		return f;
		#else
		var f = sys.FileSystem.fullPath(baseDir + path).split("\\").join("/");
		if( f != baseDir + path )
			return null;
		return f;
		#end
	}

	public function exists( path : String ) {
		#if air3
		var f = open(path);
		return f != null;
		#else
		var f = open(path);
		return f != null && sys.FileSystem.exists(f);
		#end
	}

	public function get( path : String ) {
		#if air3
		var f = open(path);
		if( f == null || !f.exists )
			throw new NotFound(path);
		return new LocalEntry(this, path.split("/").pop(), path, f);
		#else
		var f = open(path);
		if( f == null ||!sys.FileSystem.exists(f) )
			throw new NotFound(path);
		return new LocalEntry(this, path.split("/").pop(), path, f);
		#end
	}

	public function dispose() {
		#if air3
		fileCache = new Map();
		#end
	}

}

#else

class LocalFileSystem implements FileSystem {

	public var baseDir(default,null) : String;

	public function new( dir : String ) {
		#if flash
		if( flash.system.Capabilities.playerType == "Desktop" )
			throw "Please compile with -lib air3";
		#end
		throw "Local file system is not supported for this platform";
	}

	public function exists(path:String) {
		return false;
	}

	public function get(path:String) : FileEntry {
		return null;
	}

	public function getRoot() : FileEntry {
		return null;
	}

	public function dispose() {
	}

}

#end