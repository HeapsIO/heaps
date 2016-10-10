package hxd.res;

class DefaultFont {

	static var fnt : h2d.Font = null;
	static var DESC = hxd.res.Embed.getResource("hxd/res/defaultFont.fnt");
	static var BYTES = hxd.res.Embed.getResource("hxd/res/defaultFont.png");

	public static function get() : h2d.Font {
		if( fnt == null ) {
			fnt = new BitmapFont(@:privateAccess BYTES.loader, DESC.entry).toFont();
			DESC = null;
			BYTES = null;
		}
		return fnt;
	}

}