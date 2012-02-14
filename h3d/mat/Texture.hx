package h3d.mat;

class Texture {
	
	public var t : flash.display3D.textures.TextureBase;
	public var isCubic(default, null) : Bool;
	
	public function new(t,c) {
		this.t = t;
		this.isCubic = c;
	}
	
	public function uploadMipMap( bmp : flash.display.BitmapData, side = 0 ) {
		upload(bmp, 0, side);
		var w = bmp.width >> 1, h = bmp.height >> 1, mip = 1;
		var m = new flash.geom.Matrix();
		while( w > 0 && h > 0 ) {
			var tmp = new flash.display.BitmapData(w, h, true);
			m.identity();
			m.scale(w / bmp.width, h / bmp.height);
			tmp.draw(bmp, m);
			upload(tmp,mip,side);
			tmp.dispose();
			mip++;
			w >>= 1;
			h >>= 1;
		}
	}
	
	public function upload( bmp : flash.display.BitmapData, mipLevel = 0, side = 0 ) {
		if( isCubic )
			flash.Lib.as(t, flash.display3D.textures.CubeTexture).uploadFromBitmapData(bmp, side, mipLevel);
		else
			flash.Lib.as(t,  flash.display3D.textures.Texture).uploadFromBitmapData(bmp, mipLevel);
	}
	
	public function dispose() {
		if( t != null ) {
			t.dispose();
			t = null;
		}
	}
	
}