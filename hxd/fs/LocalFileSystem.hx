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
			var hmd = hmdout.toHMD(null, !(StringTools.startsWith(name, "Anim_") || name.toLowerCase().indexOf("_anim_") > 0));
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

	var isDirCached : Null<Bool>;
	override function get_isDirectory() : Bool {
		if( isDirCached != null ) return isDirCached;
		#if air3
		return isDirCached = file.isDirectory;
		#else
		return isDirCached = sys.FileSystem.isDirectory(file);
		#end
	}

	override function load( ?onReady : Void -> Void ) : Void {
		if( onReady != null ) haxe.Timer.delay(onReady, 1);
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
		var ctx = new flash.system.LoaderContext();
		ctx.imageDecodingPolicy = ON_LOAD;
		loader.load(new flash.net.URLRequest(file.url), ctx);
		#else
		var bmp = new hxd.res.Image(this).toBitmap();
		onLoaded(new hxd.fs.LoadedBitmap(bmp));
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
			case ".tmp" if( this == fs.root ):
				continue;
			default:
				arr.push(fs.open(relPath == null ? f.name : relPath + "/" + f.name,false));
			}
		return new hxd.impl.ArrayIterator(arr);
		#else
		var arr = new Array<FileEntry>();
		for( f in sys.FileSystem.readDirectory(file) ) {
			switch( f ) {
			case ".svn", ".git" if( sys.FileSystem.isDirectory(file+"/"+f) ):
				continue;
			case ".tmp" if( this == fs.root ):
				continue;
			default:
				arr.push(fs.open(relPath == null ? f : relPath + "/" + f,false));
			}
		}
		return new hxd.impl.ArrayIterator(arr);
		#end
	}

	var watchCallback : Void -> Void;
	var watchTime : Float;
	static var WATCH_INDEX = 0;
	static var WATCH_LIST : Array<LocalEntry> = null;

	inline function getModifTime(){
		#if air3
		return file.modificationDate.getTime();
		#else
		return sys.FileSystem.stat(file).mtime.getTime();
		#end
	}

	static function checkFiles() {
		var w = WATCH_LIST[WATCH_INDEX++];
		if( w == null ) {
			WATCH_INDEX = 0;
			return;
		}
		var t = try w.getModifTime() catch( e : Dynamic ) -1;
		if( t != w.watchTime ) {
			#if air3
			// check we can write (might be deleted/renamed/currently writing)
			if( !w.isDirectory )
			try {
				var f = new flash.filesystem.FileStream();
				f.open(w.file, flash.filesystem.FileMode.READ);
				f.close();
				f.open(w.file, flash.filesystem.FileMode.APPEND);
				f.close();
			} catch( e : Dynamic ) return;
			#elseif sys
			if( !w.isDirectory )
			try {
				var fp = sys.io.File.append(w.file);
				fp.close();
			}catch( e : Dynamic ) return;
			#end
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
				#if air3
				flash.Lib.current.stage.addEventListener(flash.events.Event.ENTER_FRAME, function(_) checkFiles());
				#else
				haxe.MainLoop.add(checkFiles);
				#end
			}
			var path = path;
			for( w in WATCH_LIST )
				if( w.path == path ) {
					w.watchCallback = null;
					WATCH_LIST.remove(w);
				}
			WATCH_LIST.push(this);
		}
		watchTime = getModifTime();
		watchCallback = onChanged;
	}

}

class LocalFileSystem implements FileSystem {

	var root : FileEntry;
	var fileCache = new Map<String,{r:LocalEntry}>();
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
		#if (haxe_ver >= 3.3)
		var exePath = Sys.programPath().split("\\").join("/").split("/");
		#else
		var exePath = Sys.executablePath().split("\\").join("/").split("/");
		#end
		exePath.pop();
		var froot = sys.FileSystem.fullPath(exePath.join("/") + "/" + baseDir);
		if( froot == null || !sys.FileSystem.isDirectory(froot) ) {
			froot = sys.FileSystem.fullPath(baseDir);
			if( froot == null || !sys.FileSystem.isDirectory(froot) )
				throw "Could not find dir " + dir;
		}
		baseDir = froot.split("\\").join("/");
		if( !StringTools.endsWith(baseDir, "/") ) baseDir += "/";
		root = new LocalEntry(this, "root", null, baseDir);
		#end
		tmpDir = baseDir + ".tmp/";
		#if sys
		try sys.FileSystem.createDirectory(tmpDir) catch( e : Dynamic ) {};
		#end
	}

	public function getRoot() : FileEntry {
		return root;
	}

	function open( path : String, check = true ) {
		var r = fileCache.get(path);
		if( r != null )
			return r.r;
		var e = null;
		#if air3
		var f = new flash.filesystem.File(baseDir + path);
		// ensure exact case / no relative path
		if( check ) f.canonicalize();
		if( !check || (f.exists && f.nativePath.split("\\").join("/") == baseDir + path) )
			e = new LocalEntry(this, path.split("/").pop(), path, f);
		#else
		var f = sys.FileSystem.fullPath(baseDir + path);
		if( f == null )
			return null;
		f = f.split("\\").join("/");
		if( !check || (f == baseDir + path && sys.FileSystem.exists(f)) )
			e = new LocalEntry(this, path.split("/").pop(), path, f);
		#end
		fileCache.set(path, {r:e});
		return e;
	}

	public function exists( path : String ) {
		var f = open(path);
		return f != null;
	}

	public function get( path : String ) {
		var f = open(path);
		if( f == null )
			throw new NotFound(path);
		return f;
	}

	public function dispose() {
		fileCache = new Map();
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