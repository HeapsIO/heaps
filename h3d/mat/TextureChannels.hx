package h3d.mat;
import h3d.mat.Data;

class TextureChannels extends Texture {

	var pixels : hxd.Pixels;

	public function new(w, h, ?flags : Array<TextureFlags>, ?format : TextureFormat, ?allocPos : h3d.impl.AllocPos ) {
		if( flags == null ) flags = [];
		flags.push(NoAlloc);
		super(w, h, flags, format, allocPos);
		pixels = new hxd.Pixels(w, h, haxe.io.Bytes.alloc(w * h * 4), Texture.nativeFormat);
		realloc = restore;
	}

	function restore() {
		uploadPixels(pixels);
	}

	function reset() {
		@:privateAccess if( t != null ) mem.deleteTexture(this);
	}

	@:noDebug
	function setPixels( c : hxd.Pixels.Channel, src : hxd.Pixels, srcChannel : hxd.Pixels.Channel ) {
		reset();
		if( src.width != width || src.height != height )
			throw "Size mismatch : " + src.width + "x" + src.height + " should be " + width + "x" + height;
		var bpp = hxd.Pixels.bytesPerPixel(pixels.format);
		var off = hxd.Pixels.getChannelOffset(pixels.format, c);
		var srcBpp = hxd.Pixels.bytesPerPixel(src.format);
		var srcOff = hxd.Pixels.getChannelOffset(src.format, srcChannel);
		for( y in 0...height ) {
			var r = (y * src.width * srcBpp) + srcOff;
			var w = (y * width * bpp) + off;
			for( x in 0...width ) {
				pixels.bytes.set(w, src.bytes.get(r));
				w += bpp;
				r += srcBpp;
			}
		}
	}

	public function setResource( c : hxd.Pixels.Channel, res : hxd.res.Image, ?srcChannel : hxd.Pixels.Channel ) {
		if( srcChannel == null ) srcChannel = c;
		switch( res.getFormat() ) {
		case Png, Gif:
			setPixels(c, res.getPixels(), srcChannel);
		case Jpg:
			res.entry.loadBitmap(function(bmp) {
				var bmp = bmp.toBitmap();
				var pix = bmp.getPixels();
				bmp.dispose();
				setPixels(c, pix, srcChannel);
			});
		}
		res.watch(function() if( t != null ) setResource(c, res, srcChannel));
	}

}