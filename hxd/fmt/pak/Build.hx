package hxd.fmt.pak;
import hxd.fmt.pak.Data;

class Build {

	static function buildRec( dir : String, path : String, out : { bytes : Array<haxe.io.Bytes>, size : Int } ) {
		var f = new File();
		f.name = path.split("/").pop();
		if( sys.FileSystem.isDirectory(dir) ) {
			Sys.println(path == "" ? "<root>" : path);
			f.isDirectory = true;
			f.content = [];
			for( name in sys.FileSystem.readDirectory(dir) ) {

				if( name.charCodeAt(0) == ".".code ) continue;

				var s = buildRec(dir+"/"+name,path == "" ? name : path+"/"+name,out);
				if( s != null ) f.content.push(s);
			}
		} else {
			switch( path.split("/").pop().split(".").pop().toLowerCase() ) {
			case "fbx":
				if( sys.FileSystem.exists(dir.substr(0,-3)+"xtra") )
					return null;
				dir = getTemp(dir,path,"hmd");
			case "xtra":
				dir = getTemp(dir,path,"hmd");
			case "wav":
				dir = getTemp(dir,path,"mp3");
			default:
			}
			var data = sys.io.File.getBytes(dir);
			f.dataPosition = out.size;
			f.dataSize = data.length;
			f.checksum = haxe.crypto.Adler32.make(data);
			out.bytes.push(data);
			out.size += data.length;
		}
		return f;
	}

	static var invalidChars = ~/[^A-Za-z0-9_]/g;
	static function getTemp( dir : String, path : String, ext : String ) {
		var name = "R_" + invalidChars.replace(path, "_");
		var f = dir.substr(0, dir.length - path.length)+".tmp/"+name+"."+ext;
		if( !sys.FileSystem.exists(f) ) {
			if( ext == "mp3" )
				Sys.command("lame",["--resample","44100","--silent","-h",dir,f]);
			else
				throw 'Missing \'$f\' required by \'$dir\'';
		}
		return f;
	}

	public static function make( dir = "res" ) {
		var pak = new Data();
		var out = { bytes : [], size : 0 };
		pak.version = 0;
		pak.root = buildRec(dir,"",out);
		var bytes = haxe.io.Bytes.alloc(out.size);
		var pos = 0;
		for( b in out.bytes ) {
			bytes.blit(pos, b, 0, b.length);
			pos += b.length;
		}
		var f = sys.io.File.write(dir+".pak");
		new Writer(f).write(pak,bytes);
		f.close();
	}

	static function main() {
		try sys.FileSystem.deleteFile("hxd.fmt.pak.Build.n") catch( e : Dynamic ) {};
		make();
	}

}