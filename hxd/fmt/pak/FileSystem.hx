package hxd.fmt.pak;
import hxd.fs.FileEntry;
#if air3
import hxd.impl.Air3File;
#elseif sys
import sys.io.File;
import sys.io.FileInput;
#else
enum FileSeek {
	SeekBegin;
	SeekEnd;
	SeedCurrent;
}
class FileInput extends haxe.io.BytesInput {
	public function seek( pos : Int, seekMode : FileSeek ) {
		switch( seekMode ) {
		case SeekBegin:
			this.position = pos;
		case SeekEnd:
			this.position = this.length - pos;
		case SeedCurrent:
			this.position += pos;
		}
	}
}
#end

@:allow(hxd.fmt.pak.FileSystem)
private class PakEntry extends FileEntry {

	var parent : PakEntry;
	var file : Data.File;
	var pak : FileInput;
	var subs : Array<PakEntry>;

	var openedBytes : haxe.io.Bytes;
	var bytesPosition : Int;

	public function new(parent, f, p) {
		this.file = f;
		this.pak = p;
		this.parent = parent;
		name = file.name;
		if( f.isDirectory ) subs = [];
	}

	override function get_path() {
		return parent == null ? "<root>" : (parent.parent == null ? name : parent.path + "/" + name);
	}

	override function get_size() {
		return file.dataSize;
	}

	override function get_isDirectory() {
		return file.isDirectory;
	}

	override function getSign() {
		pak.seek(file.dataPosition, SeekBegin);
		return pak.readInt32();
	}

	override function getBytes() {
		pak.seek(file.dataPosition, SeekBegin);
		return pak.read(file.dataSize);
	}

	override function getTmpBytes() {
		pak.seek(file.dataPosition, SeekBegin);
		var tmp = hxd.impl.Tmp.getBytes(file.dataSize);
		pak.readFullBytes(tmp, 0, file.dataSize);
		return tmp;
	}

	override function open() {
		if( openedBytes == null ) {
			openedBytes = hxd.impl.Tmp.getBytes(file.dataSize);
			pak.seek(file.dataPosition, SeekBegin);
			pak.readBytes(openedBytes, 0, file.dataSize);
		}
		bytesPosition = 0;
	}

	override function close() {
		if( openedBytes != null ) {
			hxd.impl.Tmp.saveBytes(openedBytes);
			openedBytes = null;
		}
	}

	override function skip( nbytes ) {
		if( nbytes < 0 || bytesPosition + nbytes > file.dataSize ) throw "Invalid skip";
		bytesPosition += nbytes;
	}

	override function readByte() {
		return openedBytes.get(bytesPosition++);
	}

	override function read( out : haxe.io.Bytes, pos : Int, len : Int ) {
		out.blit(pos, openedBytes, bytesPosition, len);
		bytesPosition += len;
	}

	override function exists( name : String ) {
		if( subs != null )
			for( c in subs )
				if( c.name == name )
					return true;
		return false;
	}

	override function get( name : String ) : FileEntry {
		if( subs != null )
			for( c in subs )
				if( c.name == name )
					return c;
		return null;
	}

	override function iterator() {
		return new hxd.impl.ArrayIterator<FileEntry>(cast subs);
	}

	override function loadBitmap( onLoaded ) {
		#if flash
		if( openedBytes != null ) throw "Must close() before loadBitmap";
		open();
		var old = openedBytes;
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(e:flash.events.IOErrorEvent) {
			throw Std.string(e) + " while loading " + path;
		});
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function(_) {
			if( openedBytes == null ) {
				openedBytes = old;
				close();
			}
			var content : flash.display.Bitmap = cast loader.content;
			onLoaded(new hxd.fs.LoadedBitmap(content.bitmapData));
			loader.unload();
		});
		loader.loadBytes(openedBytes.getData());
		openedBytes = null;
		#else
		super.loadBitmap(onLoaded);
		#end
	}

}

class FileSystem implements hxd.fs.FileSystem {

	var root : PakEntry;
	var dict : Map<String,PakEntry>;
	var files : Array<FileInput>;

	public function new() {
		dict = new Map();
		var f = new Data.File();
		f.name = "<root>";
		f.isDirectory = true;
		f.content = [];
		files = [];
		root = new PakEntry(null, f, null);
	}

	public function loadPak( file : String ) {
		#if (air3 || sys)
		addPak(File.read(file));
		#else
		throw "TODO";
		#end
	}

	public function addPak( s : FileInput ) {
		var pak = new Reader(s).readHeader();
		if( pak.root.isDirectory ) {
			for( f in pak.root.content )
				addRec(root, f.name, f, s, pak.headerSize);
		} else
			addRec(root, pak.root.name, pak.root, s, pak.headerSize);
		files.push(s);
	}

	public function dispose() {
		for( f in files )
			f.close();
		files = [];
	}

	function addRec( parent : PakEntry, path : String, f : Data.File, pak : FileInput, delta : Int ) {
		var ent = dict.get(path);
		if( ent != null ) {
			ent.file = f;
			ent.pak = pak;
		} else {
			ent = new PakEntry(parent, f, pak);
			dict.set(path, ent);
			parent.subs.push(ent);
		}
		if( f.isDirectory ) {
			for( sub in f.content )
				addRec(ent, path + "/" + sub.name, sub, pak, delta);
		} else
			f.dataPosition += delta;
	}

	public function getRoot() : FileEntry {
		return root;
	}

	public function get( path : String ) : FileEntry {
		var f = dict.get(path);
		if( f == null ) throw new hxd.res.NotFound(path);
		return f;
	}

	public function exists( path : String ) {
		return dict.exists(path);
	}

}