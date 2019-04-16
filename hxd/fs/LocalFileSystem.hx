package hxd.fs;

#if (air3 || sys || nodejs)

@:allow(hxd.fs.LocalFileSystem)
@:access(hxd.fs.LocalFileSystem)
private class LocalEntry extends FileEntry {

	var fs : LocalFileSystem;
	var relPath : String;
	#if (flash && air3)
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
	}

	override function getSign() : Int {
		#if flash
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

	override function getBytes() : haxe.io.Bytes {
		#if flash
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
		#if flash
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
		#if flash
		fread.position += nbytes;
		#else
		fread.seek(nbytes, SeekCur);
		#end
	}

	override function readByte() {
		#if flash
		return fread.readUnsignedByte();
		#else
		return fread.readByte();
		#end
	}

	override function read( out : haxe.io.Bytes, pos : Int, size : Int ) : Void {
		#if flash
		fread.readBytes(out.getData(), pos, size);
		#else
		fread.readFullBytes(out, pos, size);
		#end
	}

	override function close() {
		#if flash
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
		#if flash
		return isDirCached = file.isDirectory;
		#else
		return isDirCached = sys.FileSystem.isDirectory(file);
		#end
	}

	override function load( ?onReady : Void -> Void ) : Void {
		#if macro
		onReady();
		#else
		if( onReady != null ) haxe.Timer.delay(onReady, 1);
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
		var ctx = new flash.system.LoaderContext();
		ctx.imageDecodingPolicy = ON_LOAD;
		loader.load(new flash.net.URLRequest(file.url), ctx);
		#elseif js
		var image = new js.html.Image();
		image.onload = function(_) {
			onLoaded(new LoadedBitmap(image));
		};
		image.src = "file://"+file;
		#elseif (macro || dataOnly)
		throw "Not implemented";
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
		#if flash
		return Std.int(file.size);
		#else
		return sys.FileSystem.stat(file).size;
		#end
	}

	override function iterator() {
		#if flash
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
	#if (flash && air3)
	var convertedFile : flash.filesystem.File;
	#else
	var convertedFile : String;
	#end
	static var WATCH_INDEX = 0;
	static var WATCH_LIST : Array<LocalEntry> = null;
	static var tmpDir : String = null;

	inline function getModifTime(){
		#if flash
		if (convertedFile != null) {
			return convertedFile.modificationDate.getTime();
		}
		return file.modificationDate.getTime();
		#else
		if (convertedFile != null) {
			return sys.FileSystem.stat(convertedFile).mtime.getTime();
		}
		return sys.FileSystem.stat(file).mtime.getTime();
		#end
	}

	static function checkFiles() {
		var w = WATCH_LIST[WATCH_INDEX++];
		if( w == null ) {
			WATCH_INDEX = 0;
			return;
		}
		var t = try w.getModifTime() catch( e : Dynamic ) -1.;
		if( t == w.watchTime ) return;

		#if flash
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
			if( tmpDir == null ) {
				tmpDir = Sys.getEnv("TEMP");
				if( tmpDir == null ) tmpDir = Sys.getEnv("TMPDIR");
				if( tmpDir == null ) tmpDir = Sys.getEnv("TMP");
			}
			var lockFile = tmpDir+"/"+w.file.split("/").pop()+".lock";
			if( sys.FileSystem.exists(lockFile) ) return;
			if( !w.isDirectory )
			try {
				var fp = sys.io.File.append(w.file);
				fp.close();
			}catch( e : Dynamic ) return;
		#end
		w.watchTime = t;
		w.watchCallback();
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
				#if (flash && air3)
				flash.Lib.current.stage.addEventListener(flash.events.Event.ENTER_FRAME, function(_) checkFiles());
				#elseif !macro
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
		watchCallback = function() { fs.convert(this); onChanged(); }
	}

}

class LocalFileSystem implements FileSystem {

	var root : FileEntry;
	var fileCache = new Map<String,{r:LocalEntry}>();
	var converts : Map<String, hxd.fs.Convert>;
	public var baseDir(default,null) : String;
	public var tmpDir : String;

	public function new( dir : String ) {
		baseDir = dir;
		converts = new Map();
		addConvert(new Convert.ConvertFBX2HMD());
		addConvert(new Convert.ConvertTGA2PNG());
		addConvert(new Convert.ConvertFNT2BFNT());
		#if macro
		// In macro context just resolve classes.
		for ( p in Convert.converts ) {
			addConvert(Type.createInstance(Type.resolveClass(p), []));
		}
		#else
		@:privateAccess Convert.getConverts();
		#end
		#if flash
		var froot = new flash.filesystem.File(flash.filesystem.File.applicationDirectory.nativePath + "/" + baseDir);
		if( !froot.exists ) throw "Could not find dir " + dir;
		baseDir = froot.nativePath;
		baseDir = baseDir.split("\\").join("/");
		if( !StringTools.endsWith(baseDir, "/") ) baseDir += "/";
		root = new LocalEntry(this, "root", null, froot);
		#else
		#if (macro && haxe_ver >= 4.0)
		var exePath = null;
		#elseif (haxe_ver >= 3.3)
		var pr = Sys.programPath();
		var exePath = pr == null ? null : pr.split("\\").join("/").split("/");
		#else
		var exePath = Sys.executablePath().split("\\").join("/").split("/");
		#end
		if( exePath != null ) exePath.pop();
		var froot = exePath == null ? baseDir : sys.FileSystem.fullPath(exePath.join("/") + "/" + baseDir);
		if( froot == null || !sys.FileSystem.exists(froot) || !sys.FileSystem.isDirectory(froot) ) {
			froot = sys.FileSystem.fullPath(baseDir);
			if( froot == null || !sys.FileSystem.exists(froot) || !sys.FileSystem.isDirectory(froot) )
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

	public function addConvert( c : hxd.fs.Convert ) {
		converts.set(c.sourceExt, c);
	}

	public dynamic function onConvert( f : hxd.fs.FileEntry ) {
	}

	public function getAbsolutePath( f : FileEntry ) : String {
		var f = cast(f, LocalEntry);
		#if flash
		return f.file.nativePath;
		#else
		return f.file;
		#end
	}

	public function getRoot() : FileEntry {
		return root;
	}

	#if (sys || nodejs)
	var directoryCache : Map<String,Map<String,Bool>> = new Map();
	#end

	function checkPath( path : String ) {
		#if (sys || nodejs)
		// make sure the file is loaded with correct case !
		var baseDir = new haxe.io.Path(path).dir;
		var c = directoryCache.get(baseDir);
		var isNew = false;
		if( c == null ) {
			isNew = true;
			c = new Map();
			for( f in try sys.FileSystem.readDirectory(baseDir) catch( e : Dynamic ) [] )
				c.set(f, true);
			directoryCache.set(baseDir, c);
		}
		if( !c.exists(path.substr(baseDir.length+1)) ) {
			// added since then?
			if( !isNew ) {
				directoryCache.remove(baseDir);
				return checkPath(path);
			}
			return false;
		}
		#end
		return true;
	}

	function open( path : String, check = true ) {
		var r = fileCache.get(path);
		if( r != null )
			return r.r;
		var e = null;
		#if flash
		var f = new flash.filesystem.File(baseDir + path);
		// ensure exact case / no relative path
		if( check ) f.canonicalize();
		if( !check || (f.exists && f.nativePath.split("\\").join("/") == baseDir + path) ) {
			e = new LocalEntry(this, path.split("/").pop(), path, f);
			convert(e);
		}
		#else
		var f = sys.FileSystem.fullPath(baseDir + path);
		if( f == null )
			return null;
		f = f.split("\\").join("/");
		if( !check || (f == baseDir + path && sys.FileSystem.exists(f) && checkPath(f)) ) {
			e = new LocalEntry(this, path.split("/").pop(), path, f);
			convert(e);
		}
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

	var times : Map<String,Int>;
	var hashes : Dynamic;
	var addedPaths = new Map<String,Bool>();

	function getFileTime( filePath : String ) : Float {
		#if (sys || nodejs)
		return sys.FileSystem.stat(filePath).mtime.getTime();
		#elseif flash
		return new flash.filesystem.File(filePath).modificationDate.getTime();
		#else
		throw "getFileTime not implemented";
		#end
	}

	function convert( e : LocalEntry ) {
		var ext = e.extension;
		var conv = converts.get(ext);
		if( conv == null )
			return;
		if (e.convertedFile == null) {
			e.convertedFile = e.file;
		}

		var path = e.path;
		var tmpFile = tmpDir + path.substr(0, -ext.length) + conv.destExt;

		#if flash
		e.file = new flash.filesystem.File(tmpFile);
		#else
		e.file = tmpFile;
		#end

		if( times == null ) {
			times = try haxe.Unserializer.run(hxd.File.getBytes(tmpDir + "times.dat").toString()) catch( e : Dynamic ) new Map<String,Int>();
		}
		var realFile = baseDir + path;
		if( !hxd.File.exists(realFile) ) {
			return;
		}
		var time = std.Math.floor(getFileTime(realFile) / 1000);
		if( hxd.File.exists(tmpFile) && time == times.get(path) )
			return;
		if( hashes == null ) {
			hashes = try haxe.Json.parse(hxd.File.getBytes(tmpDir + "hashes.json").toString()) catch( e : Dynamic ) {};
		}
		var root : Dynamic = hashes;
		var topDir = new haxe.io.Path(path).dir;
		if( topDir != null ) {
			for( p in topDir.split("/") ) {
				var f = Reflect.field(root, p);
				if( f == null ) {
					f = {};
					Reflect.setField(root, p, f);
				}
				root = f;
			}
		}
		var content = hxd.File.getBytes(realFile);
		var hash = haxe.crypto.Sha1.make(content).toHex();
		function updateTime() {
			times.set(path, time);
			hxd.File.saveBytes(tmpDir + "times.dat", haxe.io.Bytes.ofString(haxe.Serializer.run(times)));
		}

		if( hxd.File.exists(tmpFile) && hash == Reflect.field(root, e.name) ) {
			updateTime();
			return;
		}

		Reflect.setField(root, e.name, hash);

		var skipConvert = false;

		#if (sys || nodejs)
		// prepare output dir
		var parts = path.split("/");
		parts.pop();
		for( i in 0...parts.length ) {
			var path = parts.slice(0, i + 1).join("/");
			sys.FileSystem.createDirectory(tmpDir + path);
		}

		// previous repo compatibility
		if( !sys.FileSystem.exists(tmpFile) ) {
			var oldPath = tmpDir + "R_" + ~/[^A-Za-z0-9_]/g.replace(path, "_") + "." + conv.destExt;
			if( sys.FileSystem.exists(oldPath) && sys.FileSystem.exists(".svn") ) {
				oldPath = sys.FileSystem.fullPath(oldPath).split("\\").join("/"); // was wrong case !
				var cwd = Sys.getCwd();
				inline function command(cmd) {
					Sys.println("> "+cmd);
					var code = Sys.command(cmd);
					if( code != 0 )
						throw "Command '" + cmd + "' failed with exit code " + code;
				}
				var parts = path.split("/");
				parts.pop();
				for( i in 0...parts.length ) {
					var path = parts.slice(0, i + 1).join("/");
					if( addedPaths.exists(path) ) continue;
					addedPaths.set(path, true);
					try command("svn add " + tmpDir.substr(cwd.length) + path) catch( e : Dynamic ) {};
				}
				command("svn move " + oldPath.substr(cwd.length) + " " + tmpFile.substr(cwd.length));
				skipConvert = true;
			}
		}
		#end

		if( !skipConvert ) {
			onConvert(e);
			conv.srcPath = realFile;
			conv.dstPath = tmpFile;
			conv.srcBytes = content;
			conv.srcFilename = e.name;
			conv.convert();
			conv.srcPath = null;
			conv.dstPath = null;
			conv.srcBytes = null;
			conv.srcFilename = null;
			#if !macro
			hxd.System.timeoutTick();
			#end
		}

		hxd.File.saveBytes(tmpDir + "hashes.json", haxe.io.Bytes.ofString(haxe.Json.stringify(hashes, "\t")));
		updateTime();
	}

	public function dir( path : String ) : Array<FileEntry> {
		#if (sys || nodejs)
		if( !sys.FileSystem.exists(baseDir + path) || !sys.FileSystem.isDirectory(baseDir + path) )
			throw new NotFound(baseDir + path);
		var files = sys.FileSystem.readDirectory(baseDir + path);
		var r : Array<FileEntry> = [];
		for(f in files)
			r.push(new LocalEntry(this, f, path + "/" + f, baseDir + path + "/" + f));
		return r;
		#else
		throw "Not Supported";
		return null;
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

	public function dir( path : String ) : Array<FileEntry> {
		return null;
	}
}

#end