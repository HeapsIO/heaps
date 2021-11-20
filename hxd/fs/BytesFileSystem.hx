package hxd.fs;

using haxe.io.Path;

class BytesFileEntry extends FileEntry {

	var fullPath : String;
	var bytes : haxe.io.Bytes;

	public function new(path, bytes) {
		this.fullPath = path;
		this.name = path.split("/").pop();
		this.bytes = bytes;
	}

	override function get_path() {
		return fullPath;
	}

	override function getBytes() : haxe.io.Bytes {
		return bytes;
	}

	override function readBytes( out : haxe.io.Bytes, outPos : Int, pos : Int, len : Int ) : Int {
		if( pos + len > bytes.length )
			len = bytes.length - pos;
		if( len < 0 ) len = 0;
		out.blit(outPos, bytes, pos, len);
		return len;
	}

	override function load( ?onReady : Void -> Void ) : Void {
		haxe.Timer.delay(onReady, 1);
	}

	override function loadBitmap( onLoaded : LoadedBitmap -> Void ) : Void {
		#if flash
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) {
			throw Std.string(e) + " while loading " + fullPath;
		});
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
			var content : flash.display.Bitmap = cast loader.content;
			onLoaded(new hxd.fs.LoadedBitmap(content.bitmapData));
			loader.unload();
		});
		loader.loadBytes(bytes.getData());
		#elseif js
		var mime = switch fullPath.extension().toLowerCase() {
			case 'jpg' | 'jpeg': 'image/jpeg';
			case 'png': 'image/png';
			case 'gif': 'image/gif';
			case _: throw 'Cannot determine image encoding, try adding an extension to the resource path';
		}
		var img = new js.html.Image();
		img.onload = function() onLoaded(new hxd.fs.LoadedBitmap(img));
		img.src = 'data:$mime;base64,' + haxe.crypto.Base64.encode(bytes);
		#else
		throw "Not implemented";
		#end
	}

	override function exists( name : String ) : Bool return false;
	override function get( name : String ) : FileEntry return null;

	override function iterator() : hxd.impl.ArrayIterator<FileEntry> return new hxd.impl.ArrayIterator(new Array<FileEntry>());

	override function get_size() return bytes.length;

}

class BytesFileSystem implements FileSystem {

	function new() {
	}

	public function getRoot() {
		throw "Not implemented";
		return null;
	}

	function getBytes( path : String ) : haxe.io.Bytes {
		throw "Not implemented";
		return null;
	}

	public function exists( path : String ) {
		return getBytes(path) != null;
	}

	public function get( path : String ) {
		var bytes = getBytes(path);
		if( bytes == null ) throw "Resource not found '" + path + "'";
		return new BytesFileEntry(path,bytes);
	}

	public function dispose() {
	}

	public function dir( path : String ) : Array<FileEntry> {
		throw "Not implemented";
		return null;
	}

}