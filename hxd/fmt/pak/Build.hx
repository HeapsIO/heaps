package hxd.fmt.pak;
import hxd.fmt.pak.Data;

class Build {

	var fs : hxd.fs.LocalFileSystem;
	var out : { bytes : Array<haxe.io.Bytes>, size : Int };

	public var excludedExt : Array<String> = [];
	public var resPath : String = "res";
	public var outPrefix : String = "res";
	public var pakDiff = false;
	public var compressSounds = true;
	public var compressMP3 = false;

	function new() {
	}

	function buildRec( path : String ) {
		var dir = resPath + (path == "" ? "" : "/" + path);
		var f = new File();
		f.name = path.split("/").pop();
		if( sys.FileSystem.isDirectory(dir) ) {
			Sys.println(path == "" ? "<root>" : path);
			f.isDirectory = true;
			f.content = [];
			for( name in sys.FileSystem.readDirectory(dir) ) {
				var fpath = path == "" ? name : path+"/"+name;
				if( name.charCodeAt(0) == ".".code || (name.charCodeAt(0) == "_".code && sys.FileSystem.isDirectory(fpath)) )
					continue;
				var s = buildRec(fpath);
				if( s != null ) f.content.push(s);
			}
		} else {
			var ext = path.split("/").pop().split(".").pop().toLowerCase();
			if( excludedExt.indexOf(ext) >= 0 )
				return null;
			var filePath = fs.getAbsolutePath(fs.get(path));
			var data = sys.io.File.getBytes(filePath);
			f.dataPosition = #if pakDiff out.bytes.length #else out.size #end;
			f.dataSize = data.length;
			f.checksum = haxe.crypto.Adler32.make(data);
			out.bytes.push(data);
			out.size += data.length;
		}
		return f;
	}

	function filter( root : File, old : File ) {
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

	function makePak() {

		if( resPath == null ) resPath = "res";
		if( outPrefix == null ) outPrefix = "res";

		if( !sys.FileSystem.exists(resPath) )
			throw "'" + resPath + "' resource directory was not found";

		fs = new hxd.fs.LocalFileSystem(resPath);
		if( compressSounds && compressMP3 )
			fs.addConvert(new hxd.fs.Convert.ConvertWAV2MP3());
		else if( compressSounds )
			fs.addConvert(new hxd.fs.Convert.ConvertWAV2OGG());
		fs.onConvert = function(f) Sys.println("\tConverting " + f.path);

		var pak = new Data();
		out = { bytes : [], size : 0 };
		pak.version = 0;
		pak.root = buildRec("");

		if( pakDiff ) {
			var id = 0;
			while( true ) {
				var name = outPrefix + (id == 0 ? "" : "" + id) + ".pak";
				if( !sys.FileSystem.exists(name) ) break;
				var oldPak = new Reader(sys.io.File.read(name)).readHeader();
				filter(pak.root, oldPak.root);
				id++;
			}
			if( id > 0 ) {
				outPrefix += id;
				if( pak.root.content.length == 0 ) {
					Sys.println("No changes in resources");
					return;
				}
			}
			out.bytes = rebuild(pak, out.bytes);
		}

		var f = sys.io.File.write(outPrefix + ".pak");
		new Writer(f).write(pak, null, out.bytes);
		f.close();
	}

	public static function make( dir = "res", out = "res", ?pakDiff ) {
		var b = new Build();
		b.resPath = dir;
		b.outPrefix = out;
		b.pakDiff = pakDiff;
		b.makePak();
	}

	static function main() {
		try sys.FileSystem.deleteFile("hxd.fmt.pak.Build.n") catch( e : Dynamic ) {};
		try sys.FileSystem.deleteFile("hxd.fmt.pak.Build.hl") catch( e : Dynamic ) {};
		var ext = haxe.macro.Compiler.getDefine("excludeExt");
		var b = new Build();
		b.excludedExt = ext == null ? [] : ext.split(",");
		b.resPath = haxe.macro.Compiler.getDefine("resourcesPath");
		b.compressSounds = true;
		b.outPrefix = haxe.macro.Compiler.getDefine("outPrefix");
		#if pakDiff
		b.pakDiff = true;
		#end
		#if !stb_ogg_sound
		b.compressMP3 = true;
		#end
		b.makePak();
	}

}