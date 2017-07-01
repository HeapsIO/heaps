package hxd.res;

class DefaultFont {

	public static function get() : h2d.Font {
		var engine = h3d.Engine.getCurrent();
		var fnt : h2d.Font = engine.resCache.get(DefaultFont);
		if( fnt == null ) {
			var BYTES = hxd.res.Embed.getResource("hxd/res/defaultFont.png");
			var DESC = hxd.res.Embed.getResource("hxd/res/defaultFont.fnt");
			fnt = new BitmapFont(@:privateAccess BYTES.loader, DESC.entry).toFont();
			engine.resCache.set(DefaultFont, fnt);
		}
		return fnt;
	}

}