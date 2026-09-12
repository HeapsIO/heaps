package hxd.res;

private class DefaultChineseFont {}

class DefaultFont {

	/**
		Returns the built-in Chinese pixel font (12px dot-matrix font covering 4,400+ Chinese characters and symbols).
	**/
	public static function getChinese() : h2d.Font {
		var engine = h3d.Engine.getCurrent();
		var fnt : h2d.Font = engine.resCache.get(DefaultChineseFont);
		if( fnt == null ) {
			var BYTES = hxd.res.Embed.getResource("hxd/res/defaultFontChinese.png");
			var DESC = hxd.res.Embed.getResource("hxd/res/defaultFontChinese.fnt");
			var bmp = new BitmapFont(DESC.entry);
			@:privateAccess bmp.loader = BYTES.loader;
			fnt = bmp.toFont();
			engine.resCache.set(DefaultChineseFont, fnt);
		}
		return fnt;
	}

	/**
		Returns the default font (ASCII Pixel Operator 12px) with automatic Chinese pixel font fallback.
		English text uses the default font, and Chinese characters seamlessly render using the pixel font!
	**/
	public static function get() : h2d.Font {
		var engine = h3d.Engine.getCurrent();
		var fnt : h2d.Font = engine.resCache.get(DefaultFont);
		if( fnt == null ) {
			var BYTES = hxd.res.Embed.getResource("hxd/res/defaultFont.png");
			var DESC = hxd.res.Embed.getResource("hxd/res/defaultFont.fnt");
			var bmp = new BitmapFont(DESC.entry);
			@:privateAccess bmp.loader = BYTES.loader;
			fnt = bmp.toFont();
			fnt.fallback = getChinese();
			engine.resCache.set(DefaultFont, fnt);
		}
		return fnt;
	}

}