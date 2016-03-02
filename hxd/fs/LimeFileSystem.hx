package hxd.fs;

#if !macro

@:allow(hxd.fs.LimeFileSystem)
@:access(hxd.fs.LimeFileSystem)
private class LimeEntry extends FileEntry {

	var fs : LimeFileSystem;
	var relPath : String;
	
	#if flash
	var bytes : flash.utils.ByteArray;
	#else
	var bytes : haxe.io.Bytes;
	var readPos : Int;
	#end

	var isReady:Bool = false;
	override function get_isAvailable() return isReady;
	
	function new(fs, name, relPath) {
		this.fs = fs;
		this.name = name;
		this.relPath = relPath;
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
		if(lime.Assets.isLocal(name)) {
			var inBytes = lime.Assets.getBytes(name);
			if( inBytes == null ) throw "Missing resource " + name;
			#if flash
			bytes = inBytes.getData();
			bytes.position = 0;
			#else
			bytes = inBytes;
			readPos = 0;
			#end
			isReady = true;
		} else {
			//#if flash
			//	throw "Non embeded files are not supported on flash platform with Lime";
			//#else
			lime.Assets.loadBytes(name).onComplete(function(inBytes) {
				#if flash
				bytes = inBytes.getData();
				bytes.position = 0;
				#else
				bytes = inBytes;
				readPos = 0;
				#end
				isReady = true;
			});
			//#end
		}
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
		bytes = null;
		#if !flash
		readPos = 0;
		#end
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
		open();
		loader.loadBytes(bytes);
		close(); // flash will copy bytes content in loadBytes() !
		#else
		onLoaded( new LoadedBitmap(lime.graphics.Image.fromBytes(bytes)) );
		close();
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
		open();
		return bytes.length;
	}

	override function iterator() {
		return new hxd.impl.ArrayIterator(fs.subFiles(relPath));
	}
}

#end

class LimeFileSystem #if !macro implements FileSystem #end {

	#if !macro
	
	public function new() {
	}

	public function getRoot() : FileEntry {
		return new LimeEntry(this,"root",".");
	}
	
	function splitPath( path : String ) {
		return path == "." ? [] : path.split("/");
	}

	function subFiles( path : String ) : Array<FileEntry> {
		var out:Array<FileEntry> = [];
		var all = lime.Assets.list();
		for( f in all )
		{
			if( f != path && StringTools.startsWith(f, path) )
				out.push(get(f));
		}
		return out;
	}

	function isDirectory( path : String ) {
		return subFiles(path).length > 0;
	}

	public function exists( path : String ) {
		return lime.Assets.exists(path);
	}

	public function get( path : String ) {
		if( !exists(path) )
			throw new NotFound(path);
		return new LimeEntry(this, path.split("/").pop(), path);
	}
	#end
	
	public function dispose() {
	}

}
