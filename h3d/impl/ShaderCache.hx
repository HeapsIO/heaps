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

	inline static var VERSION_KEY_WORD = "VERSION";
	inline static var VERSION = 1;
	inline static var MODE_KEY_WORD = "MODE";

	public function new( file : String, ?outputFile : String, mode = Base64) {
		this.file = file;
		this.outputFile = outputFile ?? file;
		this.mode = mode;
		sourceFile = file + ".source";
	}

	public function disableSave() {
		outputFile = null;
	}

	public function initEmpty() {
		data = [];
		sources = [];
	}

	function load() {
		data = new Map();
		try loadFile(file) catch( e : Dynamic ) {};
		if( outputFile != file ) try loadFile(outputFile) catch( e : Dynamic ) {};
		if( keepSource ) try loadSources() catch( e : Dynamic ) {};
	}

	function loadFile( file : String ) {
		#if !sys
		throw "Cannot load shader cache with this platform";
		#else
		if( !sys.FileSystem.exists(file) )
			return;
		var cache = new haxe.io.BytesInput(sys.io.File.getBytes(file));

		var hasVersion = cache.readString(VERSION_KEY_WORD.length) == VERSION_KEY_WORD;
		var curPos = cache.position;
		if ( !hasVersion )
			cache.position = curPos = 0;

		var hasMode = cache.readString(MODE_KEY_WORD.length) == MODE_KEY_WORD;
		var mode = Base64;
		if ( hasMode )
			mode = cache.readInt32();
		else
			cache.position = curPos;

		switch( mode ) {
		case Base64: loadCache(cache);
		case Binary: loadBinaryCache(cache);
		}
		#end
	}

	#if sys
	function loadCache(cache : haxe.io.BytesInput) {
		while( cache.position < cache.length ) {
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) break;
			var key = cache.readString(len);
			if( key == "" ) break;
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) break;
			var str = cache.readString(len);
			data.set(key,haxe.crypto.Base64.decode(str));
			cache.readByte(); // newline
		}
	}

	function loadBinaryCache(cache : haxe.io.BytesInput) {
		while( cache.position < cache.length ) {
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) break;
			var key = cache.readString(len);
			if( key == "" ) break;
			var len = cache.readInt32();
			if( len < 0 || len > 4<<20 ) break;
			var buf = haxe.io.Bytes.alloc(len);
			cache.readBytes(buf, 0, len);
			data.set(key, buf);
		}
	}
	#end

	function loadSources() {
		#if !sys
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

	public function resolveShaderBinary( source : String, ?configurationKey = "" ) {
		if( data == null ) load();
		return data.get(configurationKey + haxe.crypto.Md5.encode(source));
	}

	public function saveCompiledShader( source : String, bytes : haxe.io.Bytes, ?configurationKey = "", ?saveToFile = true ) {
		if( outputFile == null )
			return;
		if( data == null ) load();
		var key = configurationKey + haxe.crypto.Md5.encode(source);
		if( data.get(key) == bytes && (!keepSource || sources.get(key) == source) )
			return;
		data.set(key, bytes);
		if( saveToFile )
			save();
		if( keepSource ) {
			sources.set(key, source);
			saveSources();
		}
	}

	function save() {
		var out = new haxe.io.BytesOutput();
		var keys = Lambda.array({ iterator : data.keys });
		keys.sort(Reflect.compare);
		out.writeString(VERSION_KEY_WORD);
		out.writeInt32(VERSION);
		out.writeString(MODE_KEY_WORD);
		out.writeInt32(mode);
		switch ( mode ) {
		case Base64: writeCache(keys, out);
		case Binary: writeBinaryCache(keys, out);
		}
		#if sys
		try sys.io.File.saveBytes(outputFile, out.getBytes()) catch( e : Dynamic ) {};
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
		#if sys
		try sys.io.File.saveBytes(sourceFile, out.getBytes()) catch( e : Dynamic ) {};
		#end
	}
}