package hxd.impl;

typedef File = Air3File;

enum FileSeek {
	SeekBegin;
	SeekCur;
	SeekEnd;
}

#if air3
class FileInput extends haxe.io.Input {

	var fs : flash.filesystem.FileStream;
	var avail : Int;

	public function new(file) {
		fs = new flash.filesystem.FileStream();
		fs.open(file, flash.filesystem.FileMode.READ);
		avail = fs.bytesAvailable;
	}

	public function seek( p : Int, pos : FileSeek ) {
		switch( pos ) {
		case SeekBegin:
			var end = Std.int(fs.position) + avail;
			if( p > end ) p = end;
			fs.position = p;
			avail = fs.bytesAvailable;
		case SeekCur:
			if( p > avail ) p = avail;
			fs.position += p;
			avail -= p;
		case SeekEnd:
			var end = Std.int(fs.position) + avail;
			if( p > end ) p = end;
			fs.position = end - p;
			avail = fs.bytesAvailable;
		}
	}

	public function tell() : Int {
		return Std.int(fs.position);
	}

	public function eof() {
		return avail <= 0;
	}

	override function readByte() {
		var b;
		try b = fs.readUnsignedByte() catch( e : Dynamic ) throw new haxe.io.Eof();
		avail--;
		return b;
	}

	override function readBytes( bytes : haxe.io.Bytes, pos : Int, len : Int ) : Int {
		if( len > avail ) len = avail;
		if( len > 0 ) fs.readBytes(bytes.getData(), pos, len);
		avail -= len;
		return len;
	}
}

class Air3File {

	static function getRelPath( path : String ) {
		try {
			return new flash.filesystem.File(path);
		}  catch( e : Dynamic ) {
			var app = flash.filesystem.File.applicationDirectory;
			var dir = app.nativePath;
			if( dir == "" )
				return app.resolvePath(path);
			return new flash.filesystem.File(dir + "/" + path);
		}
	}

	public static function read( path : String, binary = true ) {
		if( !binary ) throw "text mode not supported";
		var f = getRelPath(path);
		if( !f.exists ) throw path + " does not exists";
		return new FileInput(f);
	}

}
#end