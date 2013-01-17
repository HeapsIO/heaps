package h3d.mat;

@:allow(h3d)
class Texture {

	var t : flash.display3D.textures.TextureBase;
	var mem : h3d.impl.MemoryManager;
	#if debug
	var allocPos : h3d.impl.AllocPos;
	#end
	public var width(default, null) : Int;
	public var height(default, null) : Int;
	public var isCubic(default, null) : Bool;

	function new(m, t, w, h, c) {
		this.mem = m;
		this.t = t;
		this.width = w;
		this.height = h;
		this.isCubic = c;
	}

	public function isDisposed() {
		return t == null;
	}

	public function uploadMipMap( bmp : flash.display.BitmapData, smoothing = false, side = 0 ) {
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

	public function upload( bmp : flash.display.BitmapData, mipLevel = 0, side = 0 ) {
		if( isCubic ) {
			var t = flash.Lib.as(t, flash.display3D.textures.CubeTexture);
			t.uploadFromBitmapData(bmp, side, mipLevel);
		}
		else {
			var t = flash.Lib.as(t,  flash.display3D.textures.Texture);
			t.uploadFromBitmapData(bmp, mipLevel);
		}
	}

	public function uploadBytes( bmp : haxe.io.Bytes, mipLevel = 0, side = 0 ) {
		if( isCubic ) {
			var t = flash.Lib.as(t, flash.display3D.textures.CubeTexture);
			t.uploadFromByteArray(bmp.getData(), 0, side, mipLevel);
		}
		else {
			var t = flash.Lib.as(t,  flash.display3D.textures.Texture);
			t.uploadFromByteArray(bmp.getData(), 0, mipLevel);
		}
	}

	public function dispose() {
		if( t != null )
			mem.deleteTexture(this);
	}
	
	public static function fromBitmap( bmp : flash.display.BitmapData, ?allocPos : h3d.impl.AllocPos ) {
		return h3d.Engine.getCurrent().mem.makeTexture(bmp,allocPos);
	}

}