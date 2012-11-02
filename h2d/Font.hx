package h2d;

class Font extends Tiles {

	static var DEFAULT_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ?!,()-/'\"éèêëÉÈÊËàâäáÀÂÄÁùûüúÙÛÜÚîïíÎÏÍôóöõÔÓÖæÆœŒçÇñÑ";
	
	public function new( name : String, size : Int, aa = true, ?chars ) {
		super();
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
		for( i in 0...chars.length ) {
			tf.text = chars.charAt(i);
			var w = Math.ceil(tf.textWidth);
			if( w == 0 ) continue;
			var h = Math.ceil(tf.textHeight);
			surf += (w + 1) * (h + 1);
		}
		var side = Math.ceil( Math.sqrt(surf) );
		var width = 1;
		while( side > width )
			width <<= 1;
		var height = width;
		while( width * height >> 1 > surf )
			height >>= 1;
		var letters;
		do {
			bmp = new flash.display.BitmapData(width, height, true, 0);
			letters = [];
			var m = new flash.geom.Matrix();
			var x = 0, y = 0, lineH = 0;
			for( i in 0...chars.length ) {
				tf.text = chars.charAt(i);
				var w = Math.ceil(tf.textWidth);
				if( w == 0 ) continue;
				var h = Math.ceil(tf.textHeight);
				if( x + w > width ) {
					x = 0;
					y += lineH + 1;
				}
				// no space
				if( y + h > height ) {
					bmp.dispose();
					bmp = null;
					height <<= 1;
					break;
				}
				m.tx = x - 2;
				m.ty = y - 2;
				bmp.draw(tf, m);
				letters[chars.charCodeAt(i)] = create(x, y, w, h, 2, 2);
				// next element
				if( h > lineH ) lineH = h;
				x += w + 1;
			}
		} while( bmp == null );
		elements[0] = letters;
	}
	
}