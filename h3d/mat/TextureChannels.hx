package h3d.mat;
import h3d.mat.Data;

class TextureChannels extends Texture {

	var pixels : hxd.Pixels;
	var channels : Array<{ r : hxd.res.Image, c : hxd.Pixels.Channel }> = [];
	public var allowAsync : Bool = true;

	public function new(w, h, ?flags : Array<TextureFlags>, ?format : TextureFormat ) {
		if( flags == null ) flags = [];
		flags.push(NoAlloc);
		super(w, h, flags, format);
		pixels = new hxd.Pixels(w, h, haxe.io.Bytes.alloc(w * h * 4), Texture.nativeFormat);
		realloc = restore;
	}

	function restore() {
		uploadPixels(pixels);
	}

	function reset() {
		@:privateAccess if( t != null ) mem.deleteTexture(this);
	}

	function setPixels( c : hxd.Pixels.Channel, src : hxd.Pixels, srcChannel : hxd.Pixels.Channel ) {
		reset();
		channels[c.toInt()] = { r : null, c : srcChannel };
		setPixelsInner(c, src, srcChannel);
	}

	@:noDebug
	function setPixelsInner( c : hxd.Pixels.Channel, src : hxd.Pixels, srcChannel : hxd.Pixels.Channel ) {
		if( src.width != width || src.height != height )
			throw "Size mismatch : " + src.width + "x" + src.height + " should be " + width + "x" + height;
		var bpp = @:privateAccess pixels.bytesPerPixel;
		var off = hxd.Pixels.getChannelOffset(pixels.format, c);
		var srcBpp = @:privateAccess src.bytesPerPixel;
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
		if( !allowAsync || !res.getFormat().useAsyncDecode )
			setPixelsInner(c, res.getPixels(), srcChannel);
		else {
			res.entry.loadBitmap(function(bmp) {
				var bmp = bmp.toBitmap();
				var pix = bmp.getPixels();
				bmp.dispose();
				setPixelsInner(c, pix, srcChannel);
			});
		}
		channels[c.toInt()] = { r : res, c : srcChannel };
		res.watch(function() if( t != null ) setResource(c, res, srcChannel));
	}

}