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
		return macro hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create(null,$options));
	}

	public static macro function initLocal() {
		var dir = haxe.macro.Context.definedValue("resourcesPath");
		if( dir == null ) dir = "res";
		return macro hxd.Res.loader = new hxd.res.Loader(new hxd.res.LocalFileSystem($v{dir}));
	}

	public static macro function initPak() {
		var dir = haxe.macro.Context.definedValue("resourcesPath");
		if( dir == null ) dir = "res";
		return macro hxd.Res.loader = new hxd.res.Loader(new hxd.fmt.pak.FileSystem($v{dir}+".pak"));
	}

}
