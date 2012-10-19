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
			tex = engine.mem.allocTexture(bmp.width, bmp.height);
			tex.upload(bmp);
		}
		return tex;
	}
	
	public static function fromBitmap( bmp : flash.display.BitmapData ) {
		var tl = new Tiles();
		var w = 1, h = 1;
		while( w < bmp.width )
			w <<= 1;
		while( h < bmp.height )
			h <<= 1;
		if( w != bmp.width || h != bmp.height ) {
			var bmp2 = new flash.display.BitmapData(w, h, true, 0);
			var p0 = new flash.geom.Point(0, 0);
			bmp2.copyPixels(bmp, bmp.rect, p0, bmp, p0, true);
			tl.bmp = bmp2;
			bmp.dispose();
		} else
			tl.bmp = bmp;
		tl.elements.push([new TilePos(tl, 0, 0, tl.width, tl.height)]);
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
				a.push(new TilePos(tl, x*size+sz.dx, y*size+sz.dy, sz.w, sz.h, sz.dx, sz.dy));
			}
		}
		return tl;
	}
	
	public static function fromSprites( sprites : Array<flash.display.Sprite> ) {
		var tl = new Tiles();
		tl.elements[0] = [];
		var tmp = [];
		var width = 0;
		var height = 0;
		for( s in sprites ) {
			var g = s.getBounds(s);
			var dx = Math.floor(g.left);
			var dy = Math.floor(g.top);
			var w = Math.ceil(g.right) - dx;
			var h = Math.ceil(g.bottom) - dy;
			tmp.push( { s : s, x : width, dx : dx, dy : dy, w : w, h : h } );
			width += w;
			if( height < h ) height = h;
		}
		var rw = 1, rh = 1;
		while( rw < width )
			rw <<= 1;
		while( rh < height )
			rh <<= 1;
		var bmp = new flash.display.BitmapData(rw, rh, true, 0);
		tl.bmp = bmp;
		var m = new flash.geom.Matrix();
		for( t in tmp ) {
			m.tx = t.x-t.dx;
			m.ty = -t.dy;
			bmp.draw(t.s, m);
			tl.elements[0].push(new TilePos(tl, t.x, 0, t.w, t.h, t.dx, t.dy));
		}
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