class All {
	static function main() {
		var cwd = Sys.getCwd();
		var errored = [];
		for( f in sys.FileSystem.readDirectory(".") ) {
			if( !sys.FileSystem.isDirectory(f) )
				continue;
			var dir = cwd+"/"+f;
			Sys.setCwd(dir);
			for( d in sys.FileSystem.readDirectory(dir) ) {
				if( !StringTools.endsWith(d,".hxml") ) continue;
				var name = d.substr(0,-5);
				if( f != name ) name = f+"/"+name;
				var pass = false;
				Sys.println(name);
				try {
					if( Sys.command("haxe "+d) == 0 ) pass = true;
				} catch( e : Dynamic ) {
					Sys.println(e);
				}
				if( !pass ) errored.push(name);
			}
			Sys.setCwd(cwd);
		}
		if( errored.length > 0 ) {
			Sys.println(errored.length+" ERRORED : "+errored);
			Sys.exit(1);
		}
		Sys.println("DONE");
	}
}