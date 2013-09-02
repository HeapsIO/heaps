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
	var data : Dynamic;
	#end

	function new(fs, name, relPath, data) {
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
		return 0;
		#end
	}
	
	override function getBytes() : haxe.io.Bytes {
		#if flash
		if( bytes == null )
			open();
		return haxe.io.Bytes.ofData(bytes);
		#else
		return null;
		#end
	}
	
	override function open() {
		#if flash
		if( bytes == null )
			bytes = Type.createInstance(data, []);
		bytes.position = 0;
		#end
	}
	
	override function skip( nbytes : Int ) {
		#if flash
		bytes.position += nbytes;
		#end
	}
	
	override function readByte() : Int {
		#if flash
		return bytes.readUnsignedByte();
		#else
		return 0;
		#end
	}
	
	override function read( out : haxe.io.Bytes, pos : Int, size : Int ) : Void {
		#if flash
		bytes.readBytes(out.getData(), pos, size);
		#end
	}

	override function close() {
		#if flash
		bytes = null;
		#end
	}
	
	override function load( ?onReady : Void -> Void ) : Void {
		#if flash
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
		#end
	}
	
	override function get_isDirectory() {
		#if flash
		return fs.isDirectory(relPath);
		#else
		return false;
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
		open();
		return bytes.length;
		#else
		return 0;
		#end
	}

	override function iterator() {
		#if flash
		return new hxd.impl.ArrayIterator(fs.subFiles(relPath));
		#else
		#end
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

	#if flash
	static var invalidChars = ~/[^A-Za-z0-9_]/g;
	static function resolve( path : String ) {
		return "hxd._res.R_"+invalidChars.replace(path,"_");
	}
	#end
	
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
	#end
	
	public function exists( path : String ) {
		#if flash
		var f = open(path);
		return f != null;
		#else
		return false;
		#end
	}
	
	public function get( path : String ) {
		#if flash
		var f = open(path);
		if( f == null )
			throw "File not found " + path;
		return new EmbedEntry(this, path.split("/").pop(), path, f);
		#else
		return null;
		#end
	}
	
	#end
	
	public static macro function create( ?basePath : String, ?options : EmbedOptions ) {
		var f = new FileTree(basePath);
		var data = f.embed(options);
		var sdata = haxe.Serializer.run(data);
		return macro @:privateFields new hxd.res.EmbedFileSystem(haxe.Unserializer.run($v { sdata } ));
	}
	
}