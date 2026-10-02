package hxd;

#if (!macro && !heaps_disable_res_completion)
@:build(hxd.res.FileTree.build())
#end
class Res {

	#if !macro
	public static function load(name:String) {
		return loader.load(name);
	}
	
	#if heaps_disable_res_completion
	public static var loader( get, set ): hxd.res.Loader;
	static function get_loader() {
		var l = hxd.res.Loader.currentInstance;
		if( l == null ) throw "Resource loader not initialized: call to hxd.Res.initXXX() required";
		return l;
	}
	static function set_loader(l) {
		return hxd.res.Loader.currentInstance = l;
	}
	#end
	
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
