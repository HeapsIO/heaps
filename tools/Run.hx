class Run {

	public static function main() {	
		var args = Sys.args();
		var currentDir = args.pop(); // current directory
		switch( args[0] ) {
		case null:
		case "pak":
			var res = args[1];
			if( res == null ) res = "res";
			hxd.fmt.pak.Build.make(currentDir + res, currentDir + "res");
		case cmd:
			Sys.println("Don't know how to run '"+cmd+"'");
		}
	}

}