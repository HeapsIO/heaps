package hxd.fmt.pak;
import hxd.fmt.pak.Data;

class Build {

	var fs : hxd.fs.LocalFileSystem;
	var out : { bytes : Array<haxe.io.Bytes>, size : Float };
	var configuration : String;
	var nextPath : String;

	public var excludedExt : Array<String> = [];
	public var excludePath : Array<String> = [];
	public var includePath : Array<String> = [];
	public var resPath : String = "res";
	public var outPrefix : String;
	public var pakDiff = false;
	public var checkJPG = false;
	public var checkOGG = false;

	function new() {
	}

	function command( cmd : String, ?args : Array<String> ) {
		var ret = Sys.command(cmd, args);
		if( ret != 0 )
			throw cmd + " has failed with exit code " + ret;
	}

	function buildRec( path : String ) {

		if( path != "" ) {
			if( excludePath.indexOf(path) >= 0 ) return null;
		}

		var dir = resPath + (path == "" ? "" : "/" + path);
		var f = new File();
		#if !dataOnly
		hxd.System.timeoutTick();
		#end
		f.name = path.split("/").pop();
		if( sys.FileSystem.isDirectory(dir) ) {
			var prevPath = nextPath;
			nextPath = path == "" ? "<root>" : path;
			f.isDirectory = true;
			f.content = [];
			for( name in sys.FileSystem.readDirectory(dir) ) {
				var fpath = path == "" ? name : path+"/"+name;
				if( name.charCodeAt(0) == ".".code )
					continue;
				var s = buildRec(fpath);
				if( s != null ) f.content.push(s);
			}
			nextPath = prevPath;
			if( f.content.length == 0 && path != "" )
				return null;
		} else {
			var ext = path.split("/").pop().split(".").pop().toLowerCase();
			if( excludedExt.indexOf(ext) >= 0 )
				return null;

			if( includePath.length != 0 ) {
				var found = false;
				for( p in includePath )
					if( StringTools.startsWith(path,p) ) {
						found = true;
						break;
					}
				if( !found ) return null;
			}

			if( nextPath != null ) {
				Sys.println(nextPath);
				nextPath = null;
			}

			var entry = try fs.get(path) catch( e : hxd.res.NotFound ) return null;
			var filePath = fs.getAbsolutePath(entry);
			var data = sys.io.File.getBytes(filePath);

			switch( ext ) {
			case "wav", "ogg" if( checkOGG ):
				var snd = new hxd.snd.OggData(sys.io.File.getBytes(filePath));
				if( snd.samples == 0 )
					Sys.println("\t*** ERROR *** " + path + " has 0 samples");
			}

			f.dataPosition = pakDiff ? out.bytes.length : out.size;
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
		var pos = 0.;
		function writeRec(f:File) {
			if( f.isDirectory ) {
				for( c in f.content )
					writeRec(c);
			} else {
				out.push(bytes[Std.int(f.dataPosition)]);
				f.dataPosition = pos;
				pos += f.dataSize;
			}
		}
		writeRec(pak.root);
		return out;
	}

	function makePak() {

		if( !sys.FileSystem.exists(resPath) )
			throw "'" + resPath + "' resource directory was not found";

		fs = new hxd.fs.LocalFileSystem(resPath, configuration);
		fs.convert.onConvert = function(c) Sys.println("\tConverting " + c.srcPath);

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

		var outFile = outPrefix + ".pak";
		Sys.println("Writing "+outFile);
		var f = sys.io.File.write(outFile);
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
		var args = Sys.args();
		try sys.FileSystem.deleteFile("hxd.fmt.pak.Build.n") catch( e : Dynamic ) {};
		try sys.FileSystem.deleteFile("hxd.fmt.pak.Build.hl") catch( e : Dynamic ) {};
		var b = new Build();
		while( args.length > 0 ) {
			var f = args.shift();
			var pos = f.indexOf("=");
			if( pos > 0 ) {
				args.unshift(f.substr(pos + 1));
				f = f.substr(0, pos);
			}
			switch( f ) {
			case "-x" if( args.length > 0 ):
				var pakFile = args.shift();
				var fs = sys.io.File.read(pakFile);
				var pak = new hxd.fmt.pak.Reader(fs).readHeader();
				var baseDir = b.outPrefix == null ? pakFile.substr(0,-4) : b.outPrefix;
				function extractRec(f:hxd.fmt.pak.Data.File, dir) {
					#if !dataOnly
					hxd.System.timeoutTick();
					#end
					if( f.isDirectory ) {
						var dir = f.name == "" ? dir : dir+"/"+f.name;
						try sys.FileSystem.createDirectory(dir) catch( e : Dynamic ) {};
						for( c in f.content )
							extractRec(c,dir);
					} else {
						hxd.fmt.pak.FileSystem.FileSeek.seek(fs,f.dataPosition+pak.headerSize,SeekBegin);
						sys.io.File.saveBytes(dir+"/"+f.name,fs.read(f.dataSize));
					}
				}
				extractRec(pak.root, baseDir);
				Sys.exit(0);
			case "-diff":
				b.pakDiff = true;
			case "-res" if( args.length > 0 ):
				b.resPath = args.shift();
			case "-out" if( args.length > 0 ):
				b.outPrefix = args.shift();
			case "-exclude" if( args.length > 0 ):
				for( ext in args.shift().split(",") )
					b.excludedExt.push(ext);
			case "-exclude-path" if( args.length > 0 ):
				for( p in args.shift().split(",") )
					b.excludePath.push(p);
			case "-include-path" if( args.length > 0 ):
				for( p in args.shift().split(",") )
					b.includePath.push(p);
			case "-check-ogg":
				b.checkOGG = true;
			case "-config" if( args.length > 0 ):
				b.configuration = args.shift();
			default:
				throw "Unknown parameter " + f;
			}
		}
		if( b.outPrefix == null ) {
			b.outPrefix = "res";
			if( b.configuration != "default" && b.configuration != null ) b.outPrefix += "."+b.configuration;
		}
		b.makePak();
	}

}