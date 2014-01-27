package h3d.mat;

import h3d.mat.Data;

@:allow(h3d)
class Texture {

	static var UID = 0;
	
	var t : h3d.impl.Driver.Texture;
	var mem : h3d.impl.MemoryManager;
	#if debug
	var allocPos : h3d.impl.AllocPos;
	#end
	public var id(default, null) : Int;
	public var name(default, null) : String;
	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var isCubic(default, null) : Bool;
	public var isTarget(default, null) : Bool;
	public var mipLevels(default, null) : Int;
	public var format(default, null) : TextureFormat;
	
	var bits : Int;
	public var mipMap(default,set) : MipMap;
	public var filter(default,set) : Filter;
	public var wrap(default,set) : Wrap;

	/**
		If this callback is set, the texture is re-allocated when the 3D context has been lost and the callback is called
		so it can perform the necessary operations to restore the texture in its initial state
	**/
	public var onContextLost : Void -> Void;
	
	function new(m, fmt, w, h, c, ta, mm) {
		this.id = ++UID;
		this.format = fmt;
		this.mem = m;
		this.isTarget = ta;
		this.width = w;
		this.height = h;
		this.isCubic = c;
		this.mipLevels = mm;
		this.mipMap = mm > 0 ? Nearest : None;
		this.filter = Linear;
		this.wrap = Clamp;
		bits &= 0x7FFF;
	}
	
	function toString() {
		return name+" "+width+"x"+height;
	}
	
	public function setName(n) {
		name = n;
	}

	function set_mipMap(m:MipMap) {
		bits |= 0x80000;
		bits = (bits & ~(3 << 0)) | (Type.enumIndex(m) << 0);
		return mipMap = m;
	}

	function set_filter(f:Filter) {
		bits |= 0x80000;
		bits = (bits & ~(3 << 3)) | (Type.enumIndex(f) << 3);
		return filter = f;
	}
	
	function set_wrap(w:Wrap) {
		bits |= 0x80000;
		bits = (bits & ~(3 << 6)) | (Type.enumIndex(w) << 6);
		return wrap = w;
	}
	
	inline function hasDefaultFlags() {
		return bits & 0x80000 == 0;
	}

	public function isDisposed() {
		return t == null;
	}
	
	public function resize(width, height) {
		mem.resizeTexture(this, width, height);
	}

	/*
	public function uploadMipMap( bmp : hxd.BitmapData, smoothing = false, side = 0 ) {
		upload(bmp, 0, side);
		var w = bmp.width >> 1, h = bmp.height >> 1, mip = 1;
		var m = new flash.geom.Matrix();
		var draw : flash.display.IBitmapDrawable = bmp;
		if( smoothing ) draw = new flash.display.Bitmap(bmp, flash.display.PixelSnapping.ALWAYS, true);
		while( w > 0 && h > 0 ) {
			var tmp = new flash.display.BitmapData(w, h, true, 0);
			m.identity();
			m.scale(w / bmp.width, h / bmp.height);
			tmp.draw(draw, m);
			upload(tmp,mip,side);
			tmp.dispose();
			mip++;
			w >>= 1;
			h >>= 1;
		}
	}
	*/
	
	public function clear( color : Int ) {
		var p = hxd.Pixels.alloc(width, height, BGRA);
		var k = 0;
		var b = color & 0xFF, g = (color >> 8) & 0xFF, r = (color >> 16) & 0xFF, a = color >>> 24;
		for( i in 0...width * height ) {
			p.bytes.set(k++,b);
			p.bytes.set(k++,g);
			p.bytes.set(k++,r);
			p.bytes.set(k++,a);
		}
		uploadPixels(p);
		p.dispose();
	}
	
	public function uploadBitmap( bmp : hxd.BitmapData, mipLevel = 0, side = 0 ) {
		mem.driver.uploadTextureBitmap(this, bmp, mipLevel, side);
	}

	public function uploadPixels( pixels : hxd.Pixels, mipLevel = 0, side = 0 ) {
		mem.driver.uploadTexturePixels(this, pixels, mipLevel, side);
	}

	public function dispose() {
		if( t != null )
			mem.deleteTexture(this);
	}
	
	public static function fromBitmap( bmp : hxd.BitmapData, ?allocPos : h3d.impl.AllocPos ) {
		var mem = h3d.Engine.getCurrent().mem;
		var t = mem.allocTexture(bmp.width, bmp.height, false, allocPos);
		t.uploadBitmap(bmp);
		return t;
	}
	
	public static function fromPixels( pixels : hxd.Pixels, ?allocPos : h3d.impl.AllocPos ) {
		var mem = h3d.Engine.getCurrent().mem;
		var t = mem.allocTexture(pixels.width, pixels.height, false, allocPos);
		t.uploadPixels(pixels);
		return t;
	}
	
	static var tmpPixels : hxd.Pixels = null;
	/**
		Creates a 1x1 texture using the ARGB color passed as parameter.
	**/
	public static function fromColor( color : Int, ?allocPos : h3d.impl.AllocPos ) {
		var mem = h3d.Engine.getCurrent().mem;
		var t = mem.allocTexture(1, 1, false, allocPos);
		if( tmpPixels == null ) tmpPixels = new hxd.Pixels(1, 1, haxe.io.Bytes.alloc(4), BGRA);
		tmpPixels.format = BGRA;
		tmpPixels.bytes.set(0, color & 0xFF);
		tmpPixels.bytes.set(1, (color>>8) & 0xFF);
		tmpPixels.bytes.set(2, (color>>16) & 0xFF);
		tmpPixels.bytes.set(3, color>>>24);
		t.uploadPixels(tmpPixels);
		return t;
	}
	
	public static function alloc( width : Int, height : Int, isTarget = false, ?allocPos : h3d.impl.AllocPos ) {
		var engine = h3d.Engine.getCurrent();
		return isTarget ? engine.mem.allocTargetTexture(width, height, allocPos) : engine.mem.allocTexture(width, height, null, allocPos);
	}

}