package hxd.res;
import haxe.macro.Context;

class Embed {

	#if macro
	static function locateFont( file : String ) {
		try {
			return Context.resolvePath(file);
		} catch( e : Dynamic ) {
		}
		if( Sys.systemName() == "Windows" ) {
			var path = Sys.getEnv("SystemRoot") + "\\Fonts\\" + file;
			if( sys.FileSystem.exists(path) )
				return path;
		}
		return null;
	}
	
	public static function doEmbedFont( name : String, file : String, chars : String ) {
		if( Context.defined("flash") ) {
			if( chars == null ) // convert char list to char range
				chars = Charset.DEFAULT_CHARS.split("-").join("\\-");
			var pos = Context.currentPos();
			haxe.macro.Context.defineType({
				pack : ["hxd","_res"],
				name : name,
				meta : [
					{ name : ":native", pos : pos, params : [macro $v { "_"+name } ] },
					{ name : ":font", pos : pos, params : [macro $v { file }, macro $v { chars } ] },
					{ name : ":keep", pos : pos, params : [] }
				],
				kind : TDClass({ pack : ["flash","text"], name : "Font", params : [] }),
				params : [],
				pos : pos,
				isExtern : false,
				fields : [],
			});
		} else
			throw "Font embedding not available for this platform";
		var m = Context.getLocalClass().get().module;
		Context.registerModuleDependency(m, file);
	}
	
	#end
	
	public static macro function getFileContent( file : String ) {
		var file = Context.resolvePath(file);
		var m = Context.getLocalClass().get().module;
		Context.registerModuleDependency(m, file);
		return macro $v{sys.io.File.getContent(file)};
	}
	
	public macro static function embedFont( file : String, ?chars : String, ?skipErrors : Bool ) {
		var ok = true;
		var path = locateFont(file);
		if( path == null ) {
			if( !skipErrors ) Context.error("Font file not found " + file,Context.currentPos());
			return macro null;
		}
		var safeName = "R_"+~/[^A-Za-z0-9_]+/g.replace(file, "_");
		doEmbedFont(safeName, path, chars);
		return macro new hxd._res.$safeName().fontName;
	}

}