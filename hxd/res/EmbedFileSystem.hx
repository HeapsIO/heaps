package hxd.res;

#if !macro

@:allow(hxd.res.EmbedFileSystem)
@:access(hxd.res.EmbedFileSystem)
private class EmbedEntry extends FileEntry {
	
	var fs : EmbedFileSystem;
	var relPath : String;
	#if flash
	var data : Class<flash.utils.ByteArray>;
	var bytes : flash.utils.ByteArray;
	#else
	var data : String;
	var bytes : haxe.io.Bytes;
	var readPos : Int;
	#end

	function new(fs, name, relPath, data) {
		this.fs = fs;
		this.name = name;
		this.relPath = relPath;
		this.data = data;
	}

	override function getSign() : Int {
		#if flash
		var old = bytes == null ? 0 : bytes.position;
		open();
		bytes.endian = flash.utils.Endian.LITTLE_ENDIAN;
		var v = bytes.readUnsignedInt();
		bytes.position = old;
		return v;
		#else
		var old = readPos;
		open();
		readPos = old;
		return bytes.get(0) | (bytes.get(1) << 8) | (bytes.get(2) << 16) | (bytes.get(3) << 24);
		#end
	}
	
	override function getBytes() : haxe.io.Bytes {
		#if flash
		if( bytes == null )
			open();
		return haxe.io.Bytes.ofData(bytes);
		#else
		if( bytes == null )
			open();
		return bytes;
		#end
	}
	
	override function open() {
		#if flash
		if( bytes == null )
			bytes = Type.createInstance(data, []);
		bytes.position = 0;
		#else
		if( bytes == null ) {
			bytes = haxe.Resource.getBytes(data);
			if( bytes == null ) throw "Missing resource " + data;
		}
		readPos = 0;
		#end
	}
	
	override function skip( nbytes : Int ) {
		#if flash
		bytes.position += nbytes;
		#else
		readPos += nbytes;
		#end
	}
	
	override function readByte() : Int {
		#if flash
		return bytes.readUnsignedByte();
		#else
		return bytes.get(readPos++);
		#end
	}
	
	override function read( out : haxe.io.Bytes, pos : Int, size : Int ) : Void {
		#if flash
		bytes.readBytes(out.getData(), pos, size);
		#else
		out.blit(pos, bytes, readPos, size);
		readPos += size;
		#end
	}

	override function close() {
		#if flash
		bytes = null;
		#else
		bytes = null;
		readPos = 0;
		#end
	}
	
	override function load( ?onReady : Void -> Void ) : Void {
		#if (flash || js)
		if( onReady != null ) haxe.Timer.delay(onReady, 1);
		#end
	}
	
	override function loadBitmap( onLoaded : hxd.BitmapData -> Void ) : Void {
		#if flash
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) {
			throw Std.string(e) + " while loading " + relPath;
		});
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
			close();
			var content : flash.display.Bitmap = cast loader.content;
			onLoaded(hxd.BitmapData.fromNative(content.bitmapData));
			loader.unload();
		});
		open();
		loader.loadBytes(bytes);
		#else
		throw "TODO";
		#end
	}
	
	override function get_isDirectory() {
		return fs.isDirectory(relPath);
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
		open();
		return bytes.length;
		#else
		open();
		return bytes.length;
		#end
	}

	override function iterator() {
		return new hxd.impl.ArrayIterator(fs.subFiles(relPath));
	}	
}

#end

class EmbedFileSystem #if !macro implements FileSystem #end {
	
	#if !macro
	
	var root : Dynamic;
	
	function new(root) {
		this.root = root;
	}
	
	public function getRoot() : FileEntry {
		return new EmbedEntry(this,"root",null,null);
	}

	static var invalidChars = ~/[^A-Za-z0-9_]/g;
	static function resolve( path : String ) {
		#if flash
		return "_R_" + invalidChars.replace(path, "_");
		#else
		return "R_" + invalidChars.replace(path, "_");
		#end
	}
	
	#if flash
	function open( path : String ) : Class<flash.utils.ByteArray> {
		var name = resolve(path);
		var cl = null;
		try {
			cl = flash.system.ApplicationDomain.currentDomain.getDefinition(name);
		} catch( e : Dynamic ) {
		}
		return cl;
	}
	
	#end

	function subFiles( path : String ) : Array<FileEntry> {
		var r = root;
		for( p in path.split("/") )
			r = Reflect.field(r, p);
		if( r == null )
			throw path + " is not a directory";
		return [for( name in Reflect.fields(r) ) get(path + "/" + name)];
	}
	
	function isDirectory( path : String ) {
		var r = root;
		for( p in path.split("/") )
			r = Reflect.field(r, p);
		return r != null;
	}

	public function exists( path : String ) {
		#if flash
		var f = open(path);
		return f != null;
		#else
		var r = root;
		for( p in path.split("/") ) {
			r = Reflect.field(r, p);
			if( r == null ) return false;
		}
		return true;
		#end
	}
	
	public function get( path : String ) {
		#if flash
		var f = open(path);
		if( f == null && !isDirectory(path) )
			throw "File not found " + path;
		return new EmbedEntry(this, path.split("/").pop(), path, f);
		#else
		if( !exists(path) )
			throw "File not found " + path;
		var id = resolve(path);
		return new EmbedEntry(this, path.split("/").pop(), path, id);
		#end
	}
	
	#end
	
	public static macro function init() {
		return macro hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
	}
	
	public static macro function create( ?basePath : String, ?options : EmbedOptions ) {
		var f = new FileTree(basePath);
		var data = f.embed(options);
		var sdata = haxe.Serializer.run(data.tree);
		var types = {
			expr : haxe.macro.Expr.ExprDef.EBlock([for( t in data.types ) haxe.macro.MacroStringTools.toFieldExpr(t.split("."))]),
			pos : haxe.macro.Context.currentPos(),
		};
		return macro { $types; @:privateFields new hxd.res.EmbedFileSystem(haxe.Unserializer.run($v { sdata } )); };
	}
	
}