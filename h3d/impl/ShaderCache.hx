package h3d.impl;

enum abstract ShaderCacheMode(Int) from Int to Int {
	var Base64 = 0;
	var Binary = 1;
}

class ShaderCache {

	var file : String;
	var outputFile : String;
	var data : Map<String, haxe.io.Bytes>;
	var sources : Map<String, String>;
	var sourceFile : String;
	public var keepSource : Bool;
	var mode : ShaderCacheMode;
	var dirty = false;
	var canSave = true;
	public var allowSave = true;
	var newKeys : Array<String>;
	var rewriteLocal : Bool;

	public static var VERSION_KEY_WORD = "VERSION";
	public static var VERSION = 1;
	public static var MODE_KEY_WORD = "MODE";

	public function new( file : String, ?outputFile : String, mode = Base64) {
		this.file = file;
		this.outputFile = outputFile ?? file;
		this.mode = mode;
		sourceFile = file + ".source";
	}

	@:deprecated("use allowSave = false")
	public function disableSave() {
		allowSave = false;
	}

	public function initEmpty() {
		data = [];
		sources = [];
		newKeys = [];
		rewriteLocal = true;
	}

	public function load() {
		initEmpty();
		try loadFile(file) catch( e : Dynamic ) {};
		if( outputFile != file ) {
			var ok = try loadFile(outputFile) catch( e : Dynamic ) false;
			rewriteLocal = !ok;
		}
		if( keepSource ) try loadSources() catch( e : Dynamic ) {};
	}

	function loadFile( file : String ) : Bool {
		#if !(sys || nodejs)
		throw "Cannot load shader cache with this platform";
		#else
		if( !sys.FileSystem.exists(file) )
			return false;
		var cache = new haxe.io.BytesInput(sys.io.File.getBytes(file));

		var curPos = 0;
		var hasVersion = cache.readString(VERSION_KEY_WORD.length) == VERSION_KEY_WORD;
		if ( !hasVersion )
			cache.position = 0;
		else {
			var version = cache.readInt32();
			if(version != VERSION) {
				trace('Shader cache version $version, expected $VERSION, skipping');
				return false;
			}
			curPos = cache.position;
		}

		var hasMode = cache.readString(MODE_KEY_WORD.length) == MODE_KEY_WORD;
		var mode = Base64;
		if ( hasMode )
			mode = cache.readInt32();
		else
			cache.position = curPos;

		var ok = switch( mode ) {
		case Base64: loadCache(cache);
		case Binary: loadBinaryCache(cache);
		}
		return ok && mode == this.mode;
		#end
	}

	#if (sys || nodejs)
	function loadCache(cache : haxe.io.BytesInput) {
		while( cache.position < cache.length ) {
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) return false;
			var key = cache.readString(len);
			if( key == "" ) return false;
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) return false;
			var str = cache.readString(len);
			data.set(key,haxe.crypto.Base64.decode(str));
			cache.readByte(); // newline
		}
		return true;
	}

	function loadBinaryCache(cache : haxe.io.BytesInput) {
		while( cache.position < cache.length ) {
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) return false;
			var key = cache.readString(len);
			if( key == "" ) return false;
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) return false;
			var buf = cache.read(len);
			data.set(key, buf);
		}
		return true;
	}
	#end

	function loadSources() {
		#if !(sys || nodejs)
		throw "Cannot load shader cache with this platform";
		#else
		sources = new Map();
		if( !sys.FileSystem.exists(sourceFile) )
			return;
		var cache = new haxe.io.BytesInput(sys.io.File.getBytes(sourceFile));
		while( cache.position < cache.length ) {
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) break;
			var key = cache.readString(len);
			if( key == "" ) break;
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) break;
			var str = cache.readString(len);
			sources.set(key, str);
			cache.readByte(); // newline
			cache.readByte(); // newline
		}
		#end
	}

	#if heaps_mt_hxsl_cache
	var mutex = new sys.thread.Mutex();
	#end
	inline function lock() {
		#if heaps_mt_hxsl_cache
		mutex.acquire();
		#end
	}
	inline function unlock() {
		#if heaps_mt_hxsl_cache
		mutex.release();
		#end
	}

	public function resolveShaderBinary( source : String, ?configurationKey = "" ) {
		var encodedSource = haxe.crypto.Md5.encode(source);
		var key = configurationKey + encodedSource;
		lock();
		if( data == null ) load();
		var bytes = data.get(key);
		unlock();
		return bytes;
	}

	var saveTimer : haxe.Timer;
	public function saveCompiledShader( source : String, bytes : haxe.io.Bytes, ?configurationKey = "", ?saveToFile = true ) {
		var key = configurationKey + haxe.crypto.Md5.encode(source);
		lock();
		if( data == null ) load();
		if( data.get(key) == bytes && (!keepSource || sources.get(key) == source) ) {
			unlock();
			return;
		}
		dirty = true;
		data.set(key, bytes);
		if( outputFile != file )
			newKeys.push(key);
		if( keepSource )
			sources.set(key, source);
		unlock();

		if( !allowSave )
			return;

		#if heaps_mt_hxsl_cache
		// Do save on main thread only
		if( sys.thread.Thread.current() != sys.thread.Thread.main() ) {
			haxe.EventLoop.main.run(() -> scheduleSave(saveToFile));
			return;
		}
		#end
		scheduleSave(saveToFile);
	}

	function scheduleSave( saveToFile : Bool ) {
		if(saveTimer != null)
			saveTimer.stop();
		saveTimer = haxe.Timer.delay(function() {
			if( saveToFile )
				save();
			if( keepSource )
				saveSources();
			saveTimer = null;
		}, 100);
	}

	public function save() {
		lock();
		if( !dirty || !canSave ) {
			unlock();
			return;
		}
		dirty = false;
		var out = new haxe.io.BytesOutput();
		var append = outputFile != file && !rewriteLocal;
		var keys = newKeys;
		newKeys = [];
		rewriteLocal = false;
		if( !append ) {
			keys = Lambda.array({ iterator : data.keys });
			keys.sort(Reflect.compare);
			out.writeString(VERSION_KEY_WORD);
			out.writeInt32(VERSION);
			out.writeString(MODE_KEY_WORD);
			out.writeInt32(mode);
		}
		switch ( mode ) {
		case Base64: writeCache(keys, out);
		case Binary: writeBinaryCache(keys, out);
		}
		unlock();
		if( append && keys.length == 0 )
			return;
		#if (sys || nodejs)
		try {
			if( append ) {
				var f = sys.io.File.append(outputFile);
				try f.write(out.getBytes()) catch( e : Dynamic ) {
					f.close();
					throw e;
				}
				f.close();
			} else
				sys.io.File.saveBytes(outputFile, out.getBytes());
		} catch( e : Dynamic ) {
			trace("Error: " + e);
			if( append ) {
				dirty = true;
				rewriteLocal = true;
			} else
				canSave = false;
		};
		#end
	}

	function writeCache(keys : Array<String>, out : haxe.io.BytesOutput) {

		for( key in keys ) {
			out.writeInt32(key.length);
			out.writeString(key);
			var b64 = haxe.crypto.Base64.encode(data.get(key));
			out.writeInt32(b64.length);
			out.writeString(b64);
			out.writeByte('\n'.code);
		}
	}

	function writeBinaryCache(keys : Array<String>, out : haxe.io.BytesOutput) {
		for( key in keys ) {
			out.writeInt32(key.length);
			out.writeString(key);
			var bytes = data.get(key);
			out.writeInt32(bytes.length);
			out.writeBytes(bytes, 0, bytes.length);
		}
	}

	function saveSources() {
		var out = new haxe.io.BytesOutput();
		lock();
		var keys = Lambda.array({ iterator : sources.keys });
		keys.sort(Reflect.compare);
		for( key in keys ) {
			out.writeInt32(key.length);
			out.writeString(key);
			var src = sources.get(key);
			out.writeInt32(src.length);
			out.writeString(src);
			out.writeByte('\n'.code);
			out.writeByte('\n'.code);
		}
		unlock();
		#if (sys || nodejs)
		try sys.io.File.saveBytes(sourceFile, out.getBytes()) catch( e : Dynamic ) {};
		#end
	}
}