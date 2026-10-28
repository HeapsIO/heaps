package hxd.fmt.pak;
import hxd.fmt.pak.Data;

typedef BuildFileEntry = { path : String, size : Int, checksum : Int };

class Build {

	var fs : hxd.fs.LocalFileSystem;
	var out : { entries : Array<BuildFileEntry>, size : Float };
	var dedupEntries : Map<String, { path : String, pos : Float }>;
	var dedupSize : Float;
	var configuration : String;
	var nextPath : String;

	public var excludedExt : Array<String> = [];
	public var excludedNames : Array<String> = [];
	public var excludePath : Array<String> = [];
	public var includePath : Array<String> = [];
	public var specialPath : Array<String> = [".baked"]; // file & directory starting with "." are ignored
	public var resPath : String = "res";
	public var outPrefix : String;
	public var align : Int = 0;
	public var pakDiff = false;
	public var dedup = false;
	public var checkJPG = false;
	public var checkOGG = false;
	public var whitelist = true;
	public var infoDepth = -1;

	function new() {
	}

	function command( cmd : String, ?args : Array<String> ) {
		var ret = Sys.command(cmd, args);
		if( ret != 0 )
			throw cmd + " has failed with exit code " + ret;
	}

	// taking the modulos once per block : 3800 bytes keep a2 below 2^31
	static function fastAdler32( b : haxe.io.Bytes ) : Int {
		var a1 = 1, a2 = 0, p = 0, len = b.length;
		#if hl
		var b : hl.Bytes = @:privateAccess b.b;
		#end
		while( p < len ) {
			var end = p + 3800;
			if( end > len ) end = len;
			while( p < end ) {
				a1 += #if hl b[p++] #else b.get(p++) #end;
				a2 += a1;
			}
			a1 %= 65521;
			a2 %= 65521;
		}
		return (a2 << 16) | a1;
	}

	function buildRec( path : String ) {

		if( path != "" ) {
			if( whitelist && excludePath.indexOf(path) >= 0 ) return null;
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
				if( excludedNames.indexOf(name)>=0 )
					continue;
				var fpath = path == "" ? name : path+"/"+name;
				if( name.charCodeAt(0) == ".".code && specialPath.indexOf(name) < 0 )
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

			var included = false;
			for( p in includePath )
				if( StringTools.startsWith(path,p) ) {
					included = true;
					break;
				}
			if( !included ) {
				if( whitelist ) {
					if( includePath.length > 0 )
						return null;
				} else {
					for( p in excludePath )
						if( StringTools.startsWith(path,p) )
							return null;
				}
			}

			if( nextPath != null ) {
				Sys.println(nextPath);
				nextPath = null;
			}

			var entry = try fs.get(path) catch( e : hxd.res.NotFound ) return null;
			var filePath = fs.getAbsolutePath(entry);
			var data = sys.io.File.getBytes(filePath);

			if( checkOGG && (ext == "wav" || ext == "ogg") && new hxd.snd.OggData(data).samples == 0 ) {
				Sys.println("\t*** ERROR *** " + path + " has 0 samples");
			}

			f.dataSize = data.length;
			f.checksum = fastAdler32(data);
			if( dedup && !pakDiff ) {
				var key = f.checksum + "_" + f.dataSize;
				var prev = dedupEntries.get(key);
				if( prev == null )
					dedupEntries.set(key, { path : filePath, pos : out.size });
				else if( sys.io.File.getBytes(prev.path).compare(data) == 0 ) {
					f.dataPosition = prev.pos;
					dedupSize += f.dataSize;
					return f;
				}
			}
			f.dataPosition = pakDiff ? out.entries.length : out.size;
			out.entries.push({ path : filePath, size : f.dataSize, checksum : f.checksum });
			out.size += data.length;
			if (align > 1)
				out.size += align - data.length % align;
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

	public static function rebuild( pak : Data, entries : Array<BuildFileEntry> ) : Array<BuildFileEntry> {
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
				out.push(entries[Std.int(f.dataPosition)]);
				f.dataPosition = pos;
				pos += f.dataSize;
			}
		}
		writeRec(pak.root);
		return out;
	}

	public static function printSize( pak : Data, maxDepth = 0 ) {
		function fmtSize(b:Float) {
			if( b >= 1024*1024*1024 ) return Std.string(Math.round(b*10/(1024*1024*1024))/10)+"Gb";
			if( b >= 1024*1024 ) return Std.string(Math.round(b*10/(1024*1024))/10)+"Mb";
			return Std.string(Math.round(b*10/1024)/10)+"Kb";
		}
		function calcRec(f:File):Float {
			if( !f.isDirectory ) return f.dataSize;
			var total = 0.;
			for( c in f.content ) total += calcRec(c);
			return total;
		}
		function printRec(f:File, depth:Int, indent = "") {
			var size = calcRec(f);
			var label = f.name == "" ? "<root>" : f.name;
			Sys.println(indent + (f.isDirectory ? "> " : "") + label + " " + fmtSize(size));
			if( (maxDepth == 0 || depth < maxDepth) && f.isDirectory) {
				for( c in f.content )
					if(f.isDirectory) printRec(c, depth + 1, indent + "    ");
				for( c in f.content )
					if(!f.isDirectory) printRec(c, depth + 1, indent + "    ");
			}
		}
		printRec(pak.root, 0, "");
	}

	// The pak already has this exact header : same files, sizes and checksums, and its length shows the data is complete.
	// Opened without sys.FileSystem.exists, which fails on files over 2GB with HashLink
	function isUpToDate( file : String, pak : Data ) {
		pak.dataSize = Writer.getDataSize([for( e in out.entries ) e.size], align);
		var expected = new haxe.io.BytesOutput();
		new Writer(expected, align).writeHeader(pak);
		var expected = expected.getBytes();
		var i = try sys.io.File.read(file) catch( e : Dynamic ) return false;
		var upToDate = false;
		try {
			var current = i.read(expected.length);
			if( current.compare(expected) == 0 ) {
				FileSystem.FileSeek.seek(i, 0, SeekEnd);
				upToDate = FileSystem.FileSeek.tell(i) == expected.length + out.size;
			}
		} catch( e : Dynamic ) {}
		i.close();
		return upToDate;
	}

	public static dynamic function onInit( b : Build ) {}

	function makePak() {

		if( !sys.FileSystem.exists(resPath) )
			throw "'" + resPath + "' resource directory was not found";

		fs = new hxd.fs.LocalFileSystem(resPath, configuration);
		fs.convert.onConvert = function(c) Sys.println("\tConverting " + c.srcPath);
		onInit(this);

		var pak = new Data();
		out = { entries : [], size : 0 };
		dedupEntries = [];
		dedupSize = 0;
		pak.version = 0;
		pak.root = buildRec("");
		if( dedupSize > 0 )
			Sys.println("Deduplicated " + Math.round(dedupSize / (1024 * 1024)) + "Mb");

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
			out.entries = rebuild(pak, out.entries);
		}

		var outFile = outPrefix + ".pak";
		if( !pakDiff && isUpToDate(outFile, pak) ) {
			Sys.println(outFile + " is up to date");
			printSize(pak, infoDepth < 0 ? 1 : infoDepth);
			return;
		}
		Sys.println("Writing "+outFile);
		var tmpFile = outFile + ".tmp";
		var f = sys.io.File.write(tmpFile);
		try {
			new Writer(f, align).writeStream(pak, [for( e in out.entries ) e.size], function(i) {
				#if !dataOnly
				hxd.System.timeoutTick();
				#end
				var e = out.entries[i];
				var data = sys.io.File.getBytes(e.path);
				if( data.length != e.size || fastAdler32(data) != e.checksum )
					throw e.path + " changed while building the pak";
				return data;
			});
		} catch( err : Dynamic ) {
			f.close();
			try sys.FileSystem.deleteFile(tmpFile) catch( e : Dynamic ) {}
			throw err;
		}
		f.close();
		try sys.FileSystem.deleteFile(outFile) catch( e : Dynamic ) {}
		sys.FileSystem.rename(tmpFile, outFile);
		printSize(pak, infoDepth < 0 ? 1 : infoDepth);
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
			inline function parseParams( params : String, output : Array<String> ) {
				for( p in params.split(",") )
					output.push(p);
			}
			switch( f ) {
			case "-info" if( args.length > 0 ):
				var pakFile = args.shift();
				var fs = sys.io.File.read(pakFile);
				var pak = new hxd.fmt.pak.Reader(fs).readHeader();
				fs.close();
				printSize(pak, b.infoDepth < 0 ? 3 : b.infoDepth);
				Sys.exit(0);
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
			case "-align" if( args.length > 0 ):
				b.align = Std.parseInt(args.shift());
			case "-diff":
				b.pakDiff = true;
			case "-dedup":
				b.dedup = true;
			case "-res" if( args.length > 0 ):
				b.resPath = args.shift();
			case "-out" if( args.length > 0 ):
				b.outPrefix = args.shift();
			case "-exclude" if( args.length > 0 ):
				parseParams(args.shift(), b.excludedExt);
			case "-exclude-names" if( args.length > 0 ):
				parseParams(args.shift(), b.excludedNames);
			case "-exclude-path" if( args.length > 0 ):
				parseParams(args.shift(), b.excludePath);
			case "-include-path" if( args.length > 0 ):
				parseParams(args.shift(), b.includePath);
			case "-special-path" if( args.length > 0 ):
				parseParams(args.shift(), b.specialPath);
			case "-include-ignore-exclude":
				b.whitelist = false;
			case "-check-ogg":
				b.checkOGG = true;
			case "-config" if( args.length > 0 ):
				b.configuration = args.shift();
			case "-info-depth":
				b.infoDepth = Std.parseInt(args.shift());
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