package hxd.fs;

class SourceLoader {

	static var RELOAD_LFS : Array<hxd.fs.FileSystem> = [];
	#if sys
	public static function addLivePath( path : String ) {
		RELOAD_LFS.push(new hxd.fs.LocalFileSystem(path,""));
	}
	public static function addLivePathHaxelib( libs : Array<String> ) {
		var p = new sys.io.Process("haxelib",["path"].concat(libs));
		var out = p.stdout.readAll().toString().split("\r\n").join("\n").split("\n");
		p.exitCode();
		for( line in out ) {
			if( line.charCodeAt(0) == "-".code ) continue;
			addLivePath(line);
		}
	}
	public static function initLivePaths() {
		addLivePath(".");
		addLivePathHaxelib(["heaps" #if hide,"hide"#end]);
	}
	#end

	public static function isActive() {
		return RELOAD_LFS.length > 0;
	}

	public static function resolve( path : String ) {
		for( fs in RELOAD_LFS )
			try return fs.get(path) catch( e : hxd.res.NotFound ) {};
		return null;
	}

}