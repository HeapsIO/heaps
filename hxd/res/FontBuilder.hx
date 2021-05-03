package hxd.res;

typedef FontBuildOptions = {
	?antiAliasing : Bool,
	?chars : String,
	?kerning : Bool,
};

/**
	FontBuilder allows to dynamicaly create a Bitmap font from a vector font.
	Depending on the platform this might require the font to be available as part of the resources,
	or it can be embedded manually with hxd.res.Embed.embedFont
**/
@:access(h2d.Font)
@:access(h2d.Tile)
class FontBuilder {

	var font : h2d.Font;
	var options : FontBuildOptions;
	var innerTex : h3d.mat.Texture;

	function new(name, size, opt) {
		this.font = new h2d.Font(name, size);
		this.options = opt == null ? { } : opt;
		if( options.antiAliasing == null ) options.antiAliasing = true;
		if( options.chars == null ) options.chars = hxd.Charset.DEFAULT_CHARS;
	}

	#if flash

	function build() : h2d.Font {
		font.lineHeight = 0;
		var tf = new flash.text.TextField();
		var fmt = tf.defaultTextFormat;
		fmt.font = font.name;
		fmt.size = font.size;
		fmt.color = 0xFFFFFF;
		tf.defaultTextFormat = fmt;
		for( f in flash.text.Font.enumerateFonts() )
			if( f.fontName == font.name ) {
				tf.embedFonts = true;
				break;
			}
		if( options.antiAliasing ) {
			tf.gridFitType = flash.text.GridFitType.PIXEL;
			tf.antiAliasType = flash.text.AntiAliasType.ADVANCED;
		}
		var surf = 0;
		var sizes = [];
		for( i in 0...options.chars.length ) {
			tf.text = options.chars.charAt(i);
			var w = Math.ceil(tf.textWidth) + 1;
			if( w == 1 ) continue;
			var h = Math.ceil(tf.textHeight) + 1;
			surf += (w + 1) * (h + 1);
			if( h > font.lineHeight )
				font.lineHeight = h;
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
			bmp.lock();
			font.glyphs = new Map();
			all = [];
			var m = new flash.geom.Matrix();
			var x = 0, y = 0, lineH = 0;
			for( i in 0...options.chars.length ) {
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
				tf.text = options.chars.charAt(i);
				bmp.fillRect(new flash.geom.Rectangle(x, y, w, h), 0);
				bmp.draw(tf, m);
				var t = new h2d.Tile(innerTex, x, y, w - 1, h - 1);
				all.push(t);
				font.glyphs.set(options.chars.charCodeAt(i), new h2d.Font.FontChar(t,w-1));
				// next element
				if( h > lineH ) lineH = h;
				x += w + 1;
			}
		} while( bmp == null );

		var pixels = hxd.BitmapData.fromNative(bmp).getPixels();
		bmp.dispose();

		// let's remove alpha premult (all pixels should be white with alpha)
		pixels.convert(BGRA);
		flash.Memory.select(pixels.bytes.getData());
		for( i in 0...pixels.width * pixels.height ) {
			var p = i << 2;
			var b = flash.Memory.getByte(p+3);
			if( b > 0 ) {
				flash.Memory.setByte(p, 0xFF);
				flash.Memory.setByte(p + 1, 0xFF);
				flash.Memory.setByte(p + 2, 0xFF);
				flash.Memory.setByte(p + 3, b);
			}
		}

		if( innerTex == null ) {
			innerTex = h3d.mat.Texture.fromPixels(pixels, h3d.mat.Texture.nativeFormat);
			font.tile = h2d.Tile.fromTexture(innerTex);
			for( t in all )
				t.setTexture(innerTex);
			innerTex.realloc = build;
		} else
			innerTex.uploadPixels(pixels);
		pixels.dispose();
		return font;
	}

	#elseif js

	function build() : h2d.Font {
		var bmp = js.Browser.document.createCanvasElement();
		var ctx = bmp.getContext2d();
		ctx.font = '${this.font.size}px ${this.font.name}';
		ctx.textAlign = 'left';
		// bottom textBaseline is the baseline with least difference between browsers
		ctx.textBaseline = 'bottom'; // important!

		font.lineHeight = 0;
		var surf = 0;
		var sizes = [];
		// get approx height of font including descent
		var h = getFontHeight(this.font, 'MgO0pj');
		// arbritrary safety margin used to ensure that char doesn't get scrambled, probably due to messed up text metrics
		var xMarg = 10;
		for( i in 0...options.chars.length ) {
			var textChar = options.chars.charAt(i);
			var w = Math.ceil(ctx.measureText(textChar).width) + 1;
			if( w == 1 ) continue;
			surf += (w + 1 + xMarg) * (h + 1);
			if( h > font.lineHeight )
				font.lineHeight = h;
			sizes[i] = { w:w, h:h };
		}
		var side = Math.ceil( Math.sqrt(surf) );
		var width = 1;
		while( side > width )
			width <<= 1;
		var height = width;
		while( width * height >> 1 > surf )
			height >>= 1;

		if( innerTex != null ) {
			width = innerTex.width;
			height = innerTex.height;
		}

		var all, done;
		do {
			done = true;
			// this will reset the content and stats
			bmp.width = width;
			bmp.height = height;
			ctx.font = '${this.font.size}px ${this.font.name}';
			ctx.textAlign = 'left';
			ctx.textBaseline = 'bottom'; // important!
			ctx.fillStyle = 'red';
			font.glyphs = new Map();
			all = [];
			var x = 0, y = 0, lineH = 0;
			for( i in 0...options.chars.length ) {
				var size = sizes[i];
				if( size == null ) continue;
				var w = size.w + xMarg;
				var h = size.h;
				if( h > lineH ) lineH = h;
				// Whatever the first character is it will always have x and y value 0
				if( x + w > width || i == 0) {
					x = 0;
					y += lineH + 1;
				}
				// no space, resize
				if( y + h > height ) {
					done = false;
					height <<= 1;
					break;
				}
				ctx.fillStyle = 'black';
				ctx.globalAlpha = 0.0;
				ctx.fillRect(x, y, w, h);
				ctx.globalAlpha = 1.0;
				ctx.fillStyle = 'white';
				ctx.fillText(options.chars.charAt(i), x, y);
				// Since we're using bottom textBaseline we need to subtract the height from the y position
				var t = new h2d.Tile(innerTex, x, y-h, w - 1, h - 1);
				all.push(t);
				font.glyphs.set(options.chars.charCodeAt(i), new h2d.Font.FontChar(t,w - (1 + xMarg)));
				// next element
				x += w + 1;
			}
		} while ( !done );

		var rbmp = hxd.BitmapData.fromNative(ctx);
		if( innerTex == null ) {
			innerTex = h3d.mat.Texture.fromBitmap( rbmp );
			font.tile = h2d.Tile.fromTexture(innerTex);
			for( t in all )
				t.setTexture(innerTex);
			innerTex.realloc = build;
		} else {
			innerTex.uploadBitmap(rbmp);
		}
		return font;
	}

	function getFontHeight(font:h2d.Font, chars:String) {
		var body = js.Browser.document.body;
		var dummy = js.Browser.document.createElement('div');
		var dummyText = js.Browser.document.createTextNode(chars);
		dummy.appendChild(dummyText);
		dummy.style.fontSize = font.size + 'px';
		dummy.style.fontFamily = font.name;
		body.appendChild(dummy);
		var result = dummy.offsetHeight;
		body.removeChild(dummy);
		return result;
	}

	#else

	function build() {
		throw "Font building not supported on this platform";
		return null;
	}

	#end

	public static function getFont( name : String, size : Int, ?options : FontBuildOptions ) {
		var key = name + "#" + size;
		var f = FONTS.get(key);
		if( f != null && f.tile.innerTex != null )
			return f;
		f = new FontBuilder(name, size, options).build();
		FONTS.set(key, f);
		return f;
	}

	public static function dispose() {
		for( f in FONTS )
			f.dispose();
		FONTS = new Map();
	}

	static var FONTS = new Map<String,h2d.Font>();

}
