package hxd.fs;

#if !macro

@:allow(hxd.fs.EmbedFileSystem)
@:access(hxd.fs.EmbedFileSystem)
private class EmbedEntry extends FileEntry {

	var fs : EmbedFileSystem;
	var relPath : String;
	#if flash
	var data : Class<flash.utils.ByteArray>;
	var bytes : flash.utils.ByteArray;
	#else
	var data : String;
	var bytes : haxe.io.Bytes;
	#end

	function new(fs, name, relPath, data) {
		this.fs = fs;
		this.name = name;
		this.relPath = relPath;
		this.data = data;
	}

	function init() {
		#if flash
		if( bytes == null )
			bytes = Type.createInstance(data, []);
		bytes.position = 0;
		#else
		if( bytes == null ) {
			bytes = haxe.Resource.getBytes(data);
			if( bytes == null ) throw "Missing resource " + data;
		}
		#end
	}

	override function getBytes() : haxe.io.Bytes {
		#if flash
		if( data == null )
			return null;
		if( bytes == null )
			init();
		return haxe.io.Bytes.ofData(bytes);
		#else
		if( bytes == null )
			init();
		return bytes;
		#end
	}

	override function readBytes( out : haxe.io.Bytes, outPos : Int, pos : Int, len : Int ) : Int {
		if( bytes == null )
			init();
		if( pos + len > bytes.length )
			len = bytes.length - pos;
		if( len < 0 ) len = 0;
		out.blit(outPos, bytes, pos, len);
		return len;
	}

	override function load( ?onReady : Void -> Void ) : Void {
		#if (flash || js)
		if( onReady != null ) haxe.Timer.delay(onReady, 1);
		#end
	}

	override function loadBitmap( onLoaded : LoadedBitmap -> Void ) : Void {
		#if flash
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) {
			throw Std.string(e) + " while loading " + relPath;
		});
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
			var content : flash.display.Bitmap = cast loader.content;
			onLoaded(new LoadedBitmap(content.bitmapData));
			loader.unload();
		});
		init();
		loader.loadBytes(bytes);
		close(); // flash will copy bytes content in loadBytes() !
		#elseif js
		// directly get the base64 encoded data from resources
		var rawData = null;
		for( res in @:privateAccess haxe.Resource.content )
			if( res.name == data ) {
				rawData = res.data;
				break;
			}
		if( rawData == null ) throw "Missing resource " + data;
		var image = new js.html.Image();
		image.onload = function(_) {
			onLoaded(new LoadedBitmap(image));
		};
		var extra = "";
		var bytes = (rawData.length * 6) >> 3;
		for( i in 0...(3-(bytes*4)%3)%3 )
			extra += "=";
		image.src = "data:image/" + extension + ";base64," + rawData + extra;
		#else
		throw "TODO";
		#end
	}

	override function get_isDirectory() {
		return fs.isDirectory(relPath);
	}

	override function get_path() {
		return relPath == "." ? "<root>" : relPath;
	}

	override function exists( name : String ) {
		return fs.exists(relPath == "." ? name : relPath + "/" + name);
	}

	override function get( name : String ) {
		return fs.get(relPath == "." ? name : relPath + "/" + name);
	}

	override function get_size() {
		#if flash
		init();
		return bytes.length;
		#else
		init();
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
		return new EmbedEntry(this,"root",".",null);
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

	function splitPath( path : String ) {
		return path == "." ? [] : path.split("/");
	}

	function  subFiles( path : String ) : Array<FileEntry> {
		var r = root;
		for( p in splitPath(path) )
			r = Reflect.field(r, p);
		if( r == null )
			throw path + " is not a directory";
		var fields = Reflect.fields(r);
		fields.sort(Reflect.compare);
		return [for( name in fields ) get(path == "." ? name : path + "/" + name)];
	}

	function isDirectory( path : String ) {
		var r : Dynamic = root;
		for( p in splitPath(path) )
			r = Reflect.field(r, p);
		return r != null && r != true;
	}

	public function exists( path : String ) {
		#if flash
		var f = open(path);
		return f != null || isDirectory(path);
		#else
		var r = root;
		for( p in splitPath(path) ) {
			r = Reflect.field(r, p);
			if( r == null ) return false;
		}
		return true;
		#end
	}

	public function get( path : String ) {
		if( !exists(path) )
			throw new NotFound(path);
		var id = #if flash open(path) #else resolve(path) #end;
		return new EmbedEntry(this, path.split("/").pop(), path, id);
	}

	#end

	#if macro
	static function makeTree( t : hxd.res.FileTree.FileTreeData ) : Dynamic {
		var o = {};
		for( d in t.dirs )
			Reflect.setField(o, d.name, makeTree(d));
		for( f in t.files )
			Reflect.setField(o, f.file, true);
		return o;
	}
	#end

	public static macro function create( ?basePath : String, ?options : hxd.res.EmbedOptions ) {
		var f = new hxd.res.FileTree(basePath);
		var data = f.embed(options);
		var sdata = haxe.Serializer.run(makeTree(data.tree));
		var types = {
			expr : haxe.macro.Expr.ExprDef.EBlock([for( t in data.types ) haxe.macro.MacroStringTools.toFieldExpr(t.split("."))]),
			pos : haxe.macro.Context.currentPos(),
		};
		return macro { $types; @:privateAccess new hxd.fs.EmbedFileSystem(haxe.Unserializer.run($v { sdata } )); };
	}

	public function dispose() {
	}

	public function dir( path : String ) : Array<FileEntry> {
		#if macro
		throw "Not Supported";
		#else
		return subFiles(path);
		#end
	}

}
