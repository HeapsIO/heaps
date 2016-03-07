package hxd.impl;

enum FileSeek {
	SeekBegin;
	SeekCur;
	SeekEnd;
}

#if air3

typedef File = Air3File;

class FileInput extends haxe.io.Input {

	var fs : flash.filesystem.FileStream;
	var avail : Int;
	var maxSize : Int;

	public function new(file) {
		fs = new flash.filesystem.FileStream();
		fs.open(file, flash.filesystem.FileMode.READ);
		maxSize = avail = fs.bytesAvailable;
	}

	override function close() {
		if( fs != null ) {
			fs.close();
			fs = null;
		}
	}

	public function seek( p : Int, pos : FileSeek ) {
		switch( pos ) {
		case SeekBegin:
			if( p < 0 ) p = 0;
			if( p > maxSize ) p = maxSize;
			fs.position = p;
			avail = maxSize;
		case SeekCur:
			if( p < 0 && p < -fs.position ) p = -Std.int(fs.position) else if( p > avail ) p = avail;
			fs.position += p;
			avail -= p;
		case SeekEnd:
			if( p > maxSize ) p = maxSize;
			fs.position = maxSize - p;
			avail = p;
		}
	}

	public function tell() : Int {
		return Std.int(fs.position);
	}

	public function eof() {
		return avail <= 0;
	}

	override function readByte() {
		if( avail <= 0 ) throw new haxe.io.Eof();
		var b = fs.readUnsignedByte();
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