package h3d.impl;

class ShaderCache {

	var file : String;
	var outputFile : String;
	var data : Map<String, haxe.io.Bytes>;
	var sources : Map<String, String>;
	var sourceFile : String;
	public var keepSource : Bool;

	public function new( file : String, ?outputFile : String ) {
		this.file = file;
		this.outputFile = outputFile ?? file;
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
		if( !sys.FileSystem.exists(file) )
			return;
		var cache = new haxe.io.BytesInput(sys.io.File.getBytes(file));
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

	function loadSources() {
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
	}

	public function resolveShaderBinary( source : String, ?configurationKey = "" ) {
		if( data == null ) load();
		return data.get(configurationKey + haxe.crypto.Md5.encode(source));
	}

	public function saveCompiledShader( source : String, bytes : haxe.io.Bytes, ?configurationKey = "" ) {
		if( outputFile == null )
			return;
		if( data == null ) load();
		var key = configurationKey + haxe.crypto.Md5.encode(source);
		if( data.get(key) == bytes && (!keepSource || sources.get(key) == source) )
			return;
		data.set(key, bytes);
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
		for( key in keys ) {
			out.writeInt32(key.length);
			out.writeString(key);
			var b64 = haxe.crypto.Base64.encode(data.get(key));
			out.writeInt32(b64.length);
			out.writeString(b64);
			out.writeByte('\n'.code);
		}
		try sys.io.File.saveBytes(outputFile, out.getBytes()) catch( e : Dynamic ) {};
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
		try sys.io.File.saveBytes(sourceFile, out.getBytes()) catch( e : Dynamic ) {};
	}
}