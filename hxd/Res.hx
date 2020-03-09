package hxd;

#if !macro
@:build(hxd.res.FileTree.build())
#end
class Res {

	#if !macro
	public static function load(name:String) {
		return loader.load(name);
	}
	#end

	public static macro function initEmbed(?options:haxe.macro.Expr.ExprOf<hxd.res.EmbedOptions>) {
		return macro hxd.Res.loader = new hxd.res.Loader(hxd.fs.EmbedFileSystem.create(null,$options));
	}

	public static macro function initLocal( ?configuration : String ) {
		var dir = haxe.macro.Context.definedValue("resourcesPath");
		if( dir == null ) dir = "res";
		dir = haxe.macro.Context.resolvePath(dir);
		return macro hxd.Res.loader = new hxd.res.Loader(new hxd.fs.LocalFileSystem($v{dir},$v{configuration}));
	}

	public static macro function initPak( ?file : String ) {
		if( file == null )
			file = haxe.macro.Context.definedValue("resourcesPath");
		if( file == null )
			file = "res";
		return macro {
			var file = $v{file};
			var pak = new hxd.fmt.pak.FileSystem();
			pak.loadPak(file + ".pak");
			var i = 1;
			while( true ) {
				if( !hxd.File.exists(file + i + ".pak") ) break;
				pak.loadPak(file + i + ".pak");
				i++;
			}
			hxd.Res.loader = new hxd.res.Loader(pak);
		}
	}

}
