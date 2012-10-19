package h2d;

class Tiles {
	
	var bmp : flash.display.BitmapData;
	var tex : h3d.mat.Texture;
	public var width(get_width, null) : Int;
	public var height(get_height, null) : Int;
	public var elements : Array<Array<TilePos>>;
	
	public function new() {
		elements = [];
	}
	
	function get_width() {
		return tex == null ? bmp.width : tex.width;
	}

	function get_height() {
		return tex == null ? bmp.height : tex.height;
	}
	
	public function get( id : Int ) {
		var e = elements[0][id];
		if( e == null )
			throw "Invalid tile #" + id;
		return e;
	}
	
	public function getBitmap() {
		return bmp;
	}
	
	public function dispose() {
		if( bmp != null ) {
			bmp.dispose();
			bmp = null;
		}
		if( tex != null ) {
			tex.dispose();
			tex = null;
		}
	}
	
	public function getTexture( engine : h3d.Engine ) {
		if( tex == null ) {
			tex = engine.mem.makeTexture(bmp);
			bmp = null;
		}
		return tex;
	}
	
	static inline var EPSILON_PIXEL = 0.00001;
	
	public static function fromBitmap( bmp : flash.display.BitmapData ) {
		var tl = new Tiles();
		var w = 1, h = 1;
		while( w < bmp.width )
			w <<= 1;
		while( h < bmp.height )
			h <<= 1;
		tl.elements.push([new TilePos(tl, 0, 0, (bmp.width - EPSILON_PIXEL) / w, (bmp.height - EPSILON_PIXEL) / h, 0, 0, bmp.width, bmp.height)]);
		if( w != bmp.width || h != bmp.height ) {
			var bmp2 = new flash.display.BitmapData(w, h, true, 0);
			var p0 = new flash.geom.Point(0, 0);
			bmp2.copyPixels(bmp, bmp.rect, p0, bmp, p0, true);
			tl.bmp = bmp2;
			bmp.dispose();
		} else
			tl.bmp = bmp;
		return tl;
	}

	public static function autoCut( bmp : flash.display.BitmapData, size : Int ) {
		var colorBG = bmp.getPixel32(bmp.width - 1, bmp.height - 1);
		var tl = new Tiles();
		tl.bmp = bmp;
		for( y in 0...Std.int(bmp.height / size) ) {
			var a = [];
			tl.elements[y] = a;
			for( x in 0...Std.int(bmp.width / size) ) {
				var sz = isEmpty(bmp, x * size, y * size, size, colorBG);
				if( sz == null )
					break;
				a.push(new TilePos(tl,(x*size+sz.dx)/bmp.width,(y*size+sz.dy)/bmp.height,(x*size+sz.dx+sz.w - EPSILON_PIXEL)/bmp.width,(y*size+sz.dy+sz.h - EPSILON_PIXEL)/bmp.height,sz.dx,sz.dy,sz.w,sz.h));
			}
		}
		return tl;
	}
	
	public static function fromSprites( sprites : Array<flash.display.Sprite> ) {
		var tl = new Tiles();
		tl.elements[0] = [];
		var width = 0;
		var height = 0;
		for( s in sprites ) {
			var g = s.getBounds(s);
			var dx = Math.floor(g.left);
			var dy = Math.floor(g.top);
			var w = Math.ceil(g.right) - dx;
			var h = Math.ceil(g.bottom) - dy;
			var t = new TilePos(tl, width, 0, width + w, h, dx, dy, w, h);
			tl.elements[0].push(t);
			width += w;
			if( height < h ) height = h;
		}
		var rw = 1, rh = 1;
		while( rw < width )
			rw <<= 1;
		while( rh < height )
			rh <<= 1;
		var bmp = new flash.display.BitmapData(rw, rh, true, 0);
		var m = new flash.geom.Matrix();
		for( i in 0...sprites.length ) {
			var s = sprites[i];
			var t = tl.get(i);
			m.tx = t.u;
			m.ty = t.v;
			bmp.draw(s, m);
			t.u /= rw;
			t.v /= rh;
			t.u2 /= rw;
			t.v2 /= rh;
		}
		tl.bmp = bmp;
		return tl;
	}
	
	static function isEmpty( b : flash.display.BitmapData, px, py, size, bg : UInt ) {
		var empty = true;
		var xmin = size, ymin = size, xmax = 0, ymax = 0;
		for( x in 0...size )
			for( y in 0...size ) {
				var color = b.getPixel32(x+px, y+py);
				if( color != bg ) {
					empty = false;
					if( x < xmin ) xmin = x;
					if( y < ymin ) ymin = y;
					if( x > xmax ) xmax = x;
					if( y > ymax ) ymax = y;
				}
				if( Std.int(color) == 0xFFFF00FF )
					b.setPixel32(x+px, y+py, 0);
			}
		return empty ? null : { dx : xmin, dy : ymin, w : xmax - xmin + 1, h : ymax - ymin + 1 };
	}
	
}