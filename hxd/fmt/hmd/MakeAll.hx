package hxd.fmt.hmd;

class MakeAll {

	static var INVALID_CHARS = ~/[^A-Za-z0-9_]/g;

	static function loop( dir : String ) {
		for( f in sys.FileSystem.readDirectory(dir) ) {
			var path = dir + "/" + f;
			if( sys.FileSystem.isDirectory(path) ) {
				loop(path);
				continue;
			}
			if( !StringTools.endsWith(f.toLowerCase(), ".fbx") )
				continue;
			var relPath = path.substr(4);
			var target = "res/.tmp/R_" + INVALID_CHARS.replace(relPath, "_") + ".hmd";
			if( sys.FileSystem.exists(target) && sys.FileSystem.stat(target).mtime.getTime() >= sys.FileSystem.stat(path).mtime.getTime() )
				continue;
			Sys.println(relPath);
			var fbx = null;
			try fbx = hxd.fmt.fbx.Parser.parse(sys.io.File.getContent(path)) catch( e : Dynamic ) throw Std.string(e) + " in " + relPath;
			var hmdout = new hxd.fmt.fbx.HMDOut();
			hmdout.load(fbx);
			var hmd = hmdout.toHMD(null, !(StringTools.startsWith(f, "Anim_") || f.indexOf("_anim_") != -1));
			var out = new haxe.io.BytesOutput();
			new hxd.fmt.hmd.Writer(out).write(hmd);
			var bytes = out.getBytes();
			sys.io.File.saveBytes(target, bytes);
		}
	}

	static function main() {
		try sys.FileSystem.deleteFile("hxd.fmt.hmd.MakeAll.n") catch( e : Dynamic ) {}
		if( !sys.FileSystem.exists("res") ) {
			Sys.println("res directory not found");
			Sys.exit(1);
		}
		loop("res");
	}

}