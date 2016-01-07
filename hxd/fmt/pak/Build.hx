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
				dir = getTemp(dir,path,"hmd");
			case "wav":
				dir = getTemp(dir,path,#if stb_ogg_sound "ogg" #else "mp3" #end);
			default:
			}
			var data = sys.io.File.getBytes(dir);
			f.dataPosition = #if pakDiff out.bytes.length #else out.size #end;
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
			switch( ext ) {
			case "mp3":
				hxd.snd.Convert.toMP3(dir, f);
			default:
				throw 'Missing \'$f\' required by \'$dir\'';
			}
		}
		return f;
	}

	static function filter( root : File, old : File ) {
		if( root.isDirectory != old.isDirectory )
			throw "Conflict : new " + root.name+" is a directory while old " + old.name+" is not";
		if( root.isDirectory ) {
			var changed = false;
			for( f in root.content.copy() ) {
				var f2 = null;
				for( ff in old.content )
					if( ff.name == f.name ) {
						f2 = ff;
						break;
					}
				if( f2 == null )
					changed = true;
				else if( filter(f, f2) )
					root.content.remove(f);
				else
					changed = true;
			}
			return !changed;
		}
		return root.checksum == old.checksum;
	}

	public static function rebuild( pak : Data, bytes : Array<haxe.io.Bytes> ) {
		var size = 0;
		function calcRec(f:File) {
			if( f.isDirectory ) {
				for( c in f.content )
					calcRec(c);
			} else
				size += f.dataSize;
		}
		calcRec(pak.root);
		var out = [];
		var pos = 0;
		function writeRec(f:File) {
			if( f.isDirectory ) {
				for( c in f.content )
					writeRec(c);
			} else {
				out.push(bytes[f.dataPosition]);
				f.dataPosition = pos;
				pos += f.dataSize;
			}
		}
		writeRec(pak.root);
		return out;
	}

	public static function make( dir = "res", out = "res", ?pakDiff ) {
		var pak = new Data();
		var outBytes = { bytes : [], size : 0 };
		pak.version = 0;
		pak.root = buildRec(dir,"",outBytes);

		if( pakDiff ) {
			var id = 0;
			while( true ) {
				var name = out + (id == 0 ? "" : "" + id) + ".pak";
				if( !sys.FileSystem.exists(name) ) break;
				var oldPak = new Reader(sys.io.File.read(name)).readHeader();
				filter(pak.root, oldPak.root);
				id++;
			}
			if( id > 0 ) {
				out += id;
				if( pak.root.content.length == 0 ) {
					Sys.println("No changes in resources");
					return;
				}
			}
			outBytes.bytes = rebuild(pak, outBytes.bytes);
		}

		var f = sys.io.File.write(out + ".pak");
		new Writer(f).write(pak, null, outBytes.bytes);
		f.close();
	}

	static function main() {
		try sys.FileSystem.deleteFile("hxd.fmt.pak.Build.n") catch( e : Dynamic ) {};
		make(haxe.macro.Compiler.getDefine("resourcesPath"),null #if pakDiff, true #end);
	}

}