package hxd.fs;

#if (sys || nodejs)

class FileConverter {

	var baseDir : String;
	var tmpDir : String;
	var converts : Map<String, hxd.fs.Convert> = new Map();

	public function new(baseDir) {
		this.baseDir = baseDir;

		tmpDir = baseDir + ".tmp/";
		try sys.FileSystem.createDirectory(tmpDir) catch( e : Dynamic ) {};

		add(new Convert.ConvertFBX2HMD());
		add(new Convert.ConvertTGA2PNG());
		add(new Convert.ConvertFNT2BFNT());

		#if macro
		// In macro context just resolve classes.
		for ( p in Convert.converts ) {
			add(Type.createInstance(Type.resolveClass(p), []));
		}
		#else
		@:privateAccess Convert.getConverts();
		#end
	}

	public function add( c : Convert ) {
		converts.set(c.sourceExt, c);
	}

	public dynamic function onConvert( e : FileEntry ) {
	}

	var times : Map<String,Int>;
	var hashes : Dynamic;
	var addedPaths = new Map<String,Bool>();

	function getFileTime( filePath : String ) : Float {
		return sys.FileSystem.stat(filePath).mtime.getTime();
	}

	public function run( e : LocalFileSystem.LocalEntry, ?reloading : Bool ) {
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

}

#end
