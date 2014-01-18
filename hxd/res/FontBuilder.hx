package hxd.res;

typedef FontBuildOptions = {
	?antiAliasing : Bool,
	?chars : String,
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

	function build() {
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
				var t = new h2d.Tile(null, x, y, w - 1, h - 1);
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
		var r = hxd.impl.Memory.select(pixels.bytes);
		for( i in 0...pixels.width * pixels.height ) {
			var p = i << 2;
			var b = r.b(p+3);
			if( b > 0 ) {
				r.wb(p, 0xFF);
				r.wb(p + 1, 0xFF);
				r.wb(p + 2, 0xFF);
				r.wb(p + 3, b);
			}
		}
		r.end();
		
		if( innerTex == null ) {
			innerTex = h3d.mat.Texture.fromPixels(pixels);
			font.tile = h2d.Tile.fromTexture(innerTex);
			for( t in all )
				t.setTexture(innerTex);
			innerTex.onContextLost = build;
		} else
			innerTex.uploadPixels(pixels);
		pixels.dispose();
		return font;
	}
	
	#elseif js
	
	function build() {
		var bmp = js.Browser.document.createCanvasElement();
		var ctx = bmp.getContext2d();
		ctx.font = '${this.font.size}px ${this.font.name}';
		ctx.textAlign = 'left';
		ctx.textBaseline = 'top'; // important!

		font.lineHeight = 0;
		var surf = 0;
		var sizes = [];
		for( i in 0...options.chars.length ) {
			var textChar = options.chars.charAt(i);
			var w = Math.ceil(ctx.measureText(textChar).width) + 1;
			if( w == 1 ) continue;
			var h = this.font.size + 2;
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
		
		var all, done;
		do {
			done = true;
			// this will reset the content and stats
			bmp.width = width;
			bmp.height = height;
			ctx.font = '${this.font.size}px ${this.font.name}';
			ctx.textAlign = 'left';
			ctx.textBaseline = 'top'; // important!
			ctx.fillStyle = 'red';
			font.glyphs = new Map();
			all = [];
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
				var t = new h2d.Tile(null, x, y, w - 1, h - 1);
				all.push(t);
				font.glyphs.set(options.chars.charCodeAt(i), new h2d.Font.FontChar(t,w-1));
				// next element
				if( h > lineH ) lineH = h;
				x += w + 1;
			}
		} while ( !done );
		
		
		var rbmp = hxd.BitmapData.fromNative(ctx);
		
		if( innerTex == null ) {
			innerTex = h3d.mat.Texture.fromBitmap( rbmp );
			font.tile = h2d.Tile.fromTexture(innerTex);
			for( t in all )
				t.setTexture(innerTex);
			innerTex.onContextLost = build;
		} else {
			innerTex.uploadBitmap(rbmp);
		}
		return font;
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
		if( f != null && f.tile.innerTex != null && !f.tile.innerTex.isDisposed() )
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
