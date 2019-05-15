package hxd.fs;

#if (sys || nodejs)

@:allow(hxd.fs.LocalFileSystem)
@:access(hxd.fs.LocalFileSystem)
private class LocalEntry extends FileEntry {

	var fs : LocalFileSystem;
	var relPath : String;
	var file : String;
	var originalFile : String;
	var fread : sys.io.FileInput;

	function new(fs, name, relPath, file) {
		this.fs = fs;
		this.name = name;
		this.relPath = relPath;
		this.file = file;
	}

	override function getSign() : Int {
		var old = if( fread == null ) -1 else fread.tell();
		open();
		var i = fread.readInt32();
		if( old < 0 ) close() else fread.seek(old, SeekBegin);
		return i;
	}

	override function getBytes() : haxe.io.Bytes {
		return sys.io.File.getBytes(file);
	}

	override function open() {
		if( fread != null )
			fread.seek(0, SeekBegin);
		else
			fread = sys.io.File.read(file);
	}

	override function skip(nbytes:Int) {
		fread.seek(nbytes, SeekCur);
	}

	override function readByte() {
		return fread.readByte();
	}

	override function read( out : haxe.io.Bytes, pos : Int, size : Int ) : Void {
		fread.readFullBytes(out, pos, size);
	}

	override function close() {
		if( fread != null ) {
			fread.close();
			fread = null;
		}
	}

	var isDirCached : Null<Bool>;
	override function get_isDirectory() : Bool {
		if( isDirCached != null ) return isDirCached;
		return isDirCached = sys.FileSystem.isDirectory(file);
	}

	override function load( ?onReady : Void -> Void ) : Void {
		#if macro
		onReady();
		#else
		if( onReady != null ) haxe.Timer.delay(onReady, 1);
		#end
	}

	override function loadBitmap( onLoaded : hxd.fs.LoadedBitmap -> Void ) : Void {
		#if js
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
		return sys.FileSystem.stat(file).size;
	}

	override function iterator() {
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
	}

	var watchCallback : Void -> Void;
	var watchTime : Float;

	static var WATCH_INDEX = 0;
	static var WATCH_LIST : Array<LocalEntry> = null;
	static var tmpDir : String = null;

	inline function getModifTime(){
		return sys.FileSystem.stat(originalFile != null ? originalFile : file).mtime.getTime();
	}

	static function checkFiles() {
		var w = WATCH_LIST[WATCH_INDEX++];
		if( w == null ) {
			WATCH_INDEX = 0;
			return;
		}
		var t = try w.getModifTime() catch( e : Dynamic ) -1.;
		if( t == w.watchTime ) return;

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
				#if !macro
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
		watchCallback = function() { fs.convert(this, true); onChanged(); }
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

		tmpDir = baseDir + ".tmp/";
		try sys.FileSystem.createDirectory(tmpDir) catch( e : Dynamic ) {};
	}

	public function addConvert( c : hxd.fs.Convert ) {
		converts.set(c.sourceExt, c);
	}

	public dynamic function onConvert( f : hxd.fs.FileEntry ) {
	}

	public function getAbsolutePath( f : FileEntry ) : String {
		var f = cast(f, LocalEntry);
		return f.file;
	}

	public function getRoot() : FileEntry {
		return root;
	}

	var directoryCache : Map<String,Map<String,Bool>> = new Map();

	function checkPath( path : String ) {
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
		return true;
	}

	function open( path : String, check = true ) {
		var r = fileCache.get(path);
		if( r != null )
			return r.r;
		var e = null;
		var f = sys.FileSystem.fullPath(baseDir + path);
		if( f == null )
			return null;
		f = f.split("\\").join("/");
		if( !check || (f == baseDir + path && sys.FileSystem.exists(f) && checkPath(f)) ) {
			e = new LocalEntry(this, path.split("/").pop(), path, f);
			convert(e);
		}
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
		return sys.FileSystem.stat(filePath).mtime.getTime();
	}

	function convert( e : LocalEntry, ?reloading : Bool ) {
		var ext = e.extension;
		var conv = converts.get(ext);
		if( conv == null )
			return;
		if( e.originalFile == null )
			e.originalFile = e.file;

		var path = e.path;
		var tmpFile = tmpDir + path.substr(0, -ext.length) + conv.destExt;

		e.file = tmpFile;

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

		var conversionFailed = false;

		if( !skipConvert ) {
			onConvert(e);
			conv.srcPath = realFile;
			conv.dstPath = tmpFile;
			conv.srcBytes = content;
			conv.srcFilename = e.name;
			if (reloading) {
				try {
					conv.convert();
				} catch (e : Dynamic) {
					trace("File conversion failed: " + realFile);
					conversionFailed = true;
				}
			} else {
				conv.convert();
			}
			conv.srcPath = null;
			conv.dstPath = null;
			conv.srcBytes = null;
			conv.srcFilename = null;
			#if !macro
			hxd.System.timeoutTick();
			#end
		}

		if (!conversionFailed) {
			hxd.File.saveBytes(tmpDir + "hashes.json", haxe.io.Bytes.ofString(haxe.Json.stringify(hashes, "\t")));
			updateTime();
		}

	}

	public function dir( path : String ) : Array<FileEntry> {
		if( !sys.FileSystem.exists(baseDir + path) || !sys.FileSystem.isDirectory(baseDir + path) )
			throw new NotFound(baseDir + path);
		var files = sys.FileSystem.readDirectory(baseDir + path);
		var r : Array<FileEntry> = [];
		for(f in files)
			r.push(open(path + "/" + f, false));
		return r;
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