package hxd.res;

class Embed {
	
	public static macro function getFileContent( file : String ) {
		var file = haxe.macro.Context.resolvePath(file);
		var m = haxe.macro.Context.getLocalClass().get().module;
		haxe.macro.Context.registerModuleDependency(m, file);
		return macro $v{sys.io.File.getContent(file)};
	}
	
}