package hxd.res;

class Font extends Resource {
	
	public function build( size : Int, ?options ) : h2d.Font {
		#if flash
		var fontClass : Class<flash.text.Font> = cast Type.resolveClass("hxd._res.R_" + ~/[^A-Za-z0-9_]/g.replace(entry.path, "_"));
		if( fontClass == null ) throw "Embeded font not found " + entry.path;
		var font = Type.createInstance(fontClass, []);
		return FontBuilder.getFont(font.fontName, size, options);
		#else
		throw "Not implemented for this platform";
		return null;
		#end
	}
	
}