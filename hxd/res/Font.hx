package hxd.res;

/**
	Allows to build a font bitmap to be used by h2d.Text. Only some platforms support such runtime Font building
	and the result in terms of font quality, antialiasing, etc might vary depending on the platform.
	It is recommended to use offline BitmapFont instead, read https://heaps.io/documentation/text.html
**/
class Font extends Resource {

	public function build( size : Int, ?options ) : h2d.Font {
		#if flash
		var fontClass : Class<flash.text.Font> = cast Type.resolveClass("_R_" + ~/[^A-Za-z0-9_]/g.replace(entry.path, "_"));
		if( fontClass == null ) throw "Embeded font not found " + entry.path;
		var font = Type.createInstance(fontClass, []);
		return FontBuilder.getFont(font.fontName, size, options);
		#elseif js
		var name = "R_" + ~/[^A-Za-z0-9_]/g.replace(entry.path, "_");
		return FontBuilder.getFont(name, size, options);
		#else
		throw "Not implemented for this platform";
		return null;
		#end
	}

}
