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

	#if lime
	public static macro function initLime() {
		return macro hxd.Res.loader = new hxd.res.Loader(new hxd.fs.LimeFileSystem());
	}
	#end

	public static macro function initLocal() {
		var dir = haxe.macro.Context.definedValue("resourcesPath");
		if( dir == null ) dir = "res";
		return macro hxd.Res.loader = new hxd.res.Loader(new hxd.fs.LocalFileSystem($v{dir}));
	}

	public static macro function initPak() {
		var dir = haxe.macro.Context.definedValue("resourcesPath");
		if( dir == null ) dir = "res";
		return macro {
			var dir = $v{dir};
			#if usesys
			dir = haxe.System.dataPathPrefix + dir;
			#end
			var pak = new hxd.fmt.pak.FileSystem();
			pak.loadPak(dir + ".pak");
			var i = 1;
			while( true ) {
				if( !hxd.File.exists(dir + i + ".pak") ) break;
				pak.loadPak(dir + i + ".pak");
				i++;
			}
			hxd.Res.loader = new hxd.res.Loader(pak);
		}
	}

}
