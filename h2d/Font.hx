package h2d;

class Font extends Tile {

	static var DEFAULT_CHARS = " !\"#$%&'()*+,-./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzéèêëÉÈÊËàâäáÀÂÄÁùûüúÙÛÜÚîïíÎÏÍôóöõÔÓÖæÆœŒçÇñÑ¡¿ß";

	public var glyphs : Array<Tile>;
	public var lineHeight : Int;
	
	public function new( name : String, size : Int, aa = true, ?chars ) {
		super(null, 0, 0, 0, 0);
		if( chars == null )
			chars = DEFAULT_CHARS;
		var tf = new flash.text.TextField();
		var fmt = tf.defaultTextFormat;
		fmt.font = name;
		fmt.size = size;
		fmt.color = 0xFFFFFF;
		tf.defaultTextFormat = fmt;
		for( f in flash.text.Font.enumerateFonts() )
			if( f.fontName == name ) {
				tf.embedFonts = true;
				break;
			}
		if( !aa ) {
			tf.sharpness = 400;
			tf.gridFitType = flash.text.GridFitType.PIXEL;
			tf.antiAliasType = flash.text.AntiAliasType.ADVANCED;
		}
		var surf = 0;
		var sizes = [];
		for( i in 0...chars.length ) {
			tf.text = chars.charAt(i);
			var w = Math.ceil(tf.textWidth);
			if( w == 0 ) continue;
			var h = Math.ceil(tf.textHeight);
			surf += (w + 1) * (h + 1);
			if( h > lineHeight )
				lineHeight = h;
			sizes[i] = { w:w, h:h };
		}
		var side = Math.ceil( Math.sqrt(surf) );
		var width = 1;
		while( side > width )
			width <<= 1;
		var height = width;
		while( width * height >> 1 > surf )
			height >>= 1;
		var all, bmp;
		do {
			bmp = new flash.display.BitmapData(width, height, true, 0);
			glyphs = [];
			all = [];
			var m = new flash.geom.Matrix();
			var x = 0, y = 0, lineH = 0;
			for( i in 0...chars.length ) {
				var size = sizes[i];
				if( size == null ) continue;
				var w = size.w;
				var h = size.h;
				if( x + w > width ) {
					x = 0;
					y += lineH + 1;
				}
				// no space, resize
				if( y + h > height ) {
					bmp.dispose();
					bmp = null;
					height <<= 1;
					break;
				}
				m.tx = x - 2;
				m.ty = y - 2;
				tf.text = chars.charAt(i);
				bmp.draw(tf, m);
				var t = sub(x, y, w, h, 2, 2);
				all.push(t);
				glyphs[chars.charCodeAt(i)] = t;
				// next element
				if( h > lineH ) lineH = h;
				x += w + 1;
			}
		} while( bmp == null );
		setTexture(Tile.fromBitmap(bmp).getTexture());
		for( t in all )
			t.setTexture(innerTex);
	}
	
}