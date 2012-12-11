package h2d;

@:allow(h2d)
class Tile {
	
	static inline var EPSILON_PIXEL = 0.00001;
	
	var innerTex : h3d.mat.Texture;
	
	var u : Float;
	var v : Float;
	var u2 : Float;
	var v2 : Float;
	
	public var dx : Int;
	public var dy : Int;
	public var x(default,null) : Int;
	public var y(default,null) : Int;
	public var width(default,null) : Int;
	public var height(default,null) : Int;
	
	function new(tex, x, y, w, h, dx=0, dy=0) {
		this.innerTex = tex;
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
		this.dx = dx;
		this.dy = dy;
		if( tex != null ) setTexture(tex);
	}
	
	function getTexture() {
		if( innerTex == null || innerTex.isDisposed() )
			return Tools.getCoreObjects().getEmptyTexture();
		return innerTex;
	}
		
	function setTexture(tex) {
		this.innerTex = tex;
		if( tex != null ) {
			this.u = x / tex.width;
			this.v = y / tex.height;
			this.u2 = (x + width - EPSILON_PIXEL) / tex.width;
			this.v2 = (y + height - EPSILON_PIXEL) / tex.height;
		}
	}
	
	public inline function switchTexture( t : Tile ) {
		setTexture(t.innerTex);
	}
	
	public function sub( x, y, w, h, dx = 0, dy = 0 ) {
		return new Tile(innerTex, this.x + x, this.y + y, w, h, dx, dy);
	}
	
	public function nextX() {
		return sub(width, 0, width, height, dx, dy);
	}

	public function nextY() {
		return sub(0, height, width, height, dx, dy);
	}
	
	public function setSize(w, h) {
		this.width = w;
		this.height = h;
		var tex = innerTex;
		if( tex != null ) {
			u2 = (w + x) / tex.width;
			v2 = (h + y) / tex.height;
		}
	}
	
	public function scaleToSize( w, h ) {
		this.width = w;
		this.height = h;
	}
	
	public function scrollDiscrete( dx : Float, dy : Float ) {
		var tex = innerTex;
		u += dx / tex.width;
		v -= dy / tex.height;
		u2 += dx / tex.width;
		v2 -= dy / tex.height;
		x = Std.int(u * tex.width);
		v = Std.int(v * tex.height);
	}
	
	public function dispose() {
		if( innerTex != null ) innerTex.dispose();
		innerTex = null;
	}
	
	public static function fromBitmap( bmp : flash.display.BitmapData ) {
		var w = 1, h = 1;
		while( w < bmp.width )
			w <<= 1;
		while( h < bmp.height )
			h <<= 1;
		var tex = h3d.Engine.getCurrent().mem.allocTexture(w, h);
		if( w != bmp.width || h != bmp.height ) {
			var bmp2 = new flash.display.BitmapData(w, h, true, 0);
			var p0 = new flash.geom.Point(0, 0);
			bmp2.copyPixels(bmp, bmp.rect, p0, bmp, p0, true);
			tex.upload(bmp2);
			bmp2.dispose();
		} else
			tex.upload(bmp);
		return new Tile(tex, 0, 0, bmp.width, bmp.height);
	}

	public static function autoCut( bmp : flash.display.BitmapData, size : Int ) {
		var colorBG = bmp.getPixel32(bmp.width - 1, bmp.height - 1);
		var tl = new Array();
		var w = 1, h = 1;
		while( w < bmp.width )
			w <<= 1;
		while( h < bmp.height )
			h <<= 1;
		var tex = h3d.Engine.getCurrent().mem.allocTexture(w, h);
		for( y in 0...Std.int(bmp.height / size) ) {
			var a = [];
			tl[y] = a;
			for( x in 0...Std.int(bmp.width / size) ) {
				var sz = isEmpty(bmp, x * size, y * size, size, colorBG);
				if( sz == null )
					break;
				a.push(new Tile(tex,x*size+sz.dx, y*size+sz.dy, sz.w, sz.h, sz.dx, sz.dy));
			}
		}
		if( w != bmp.width || h != bmp.height ) {
			var bmp2 = new flash.display.BitmapData(w, h, true, 0);
			var p0 = new flash.geom.Point(0, 0);
			bmp2.copyPixels(bmp, bmp.rect, p0, bmp, p0, true);
			tex.upload(bmp2);
			bmp2.dispose();
		} else
			tex.upload(bmp);
		var main = new Tile(tex, 0, 0, bmp.width, bmp.height);
		return { main : main, tiles : tl };
	}
	
	public static function fromTexture( t : h3d.mat.Texture ) {
		return new Tile(t, 0, 0, t.width, t.height);
	}
	
	public static function fromSprites( sprites : Array<flash.display.Sprite> ) {
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
		var m = new flash.geom.Matrix();
		for( t in tmp ) {
			m.tx = t.x-t.dx;
			m.ty = -t.dy;
			bmp.draw(t.s, m);
		}
		var main = fromBitmap(bmp);
		var tiles = [];
		for( t in tmp )
			tiles.push(main.sub(t.x, 0, t.w, t.h, t.dx, t.dy));
		return tiles;
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
				if( color == bg )
					b.setPixel32(x+px, y+py, 0);
			}
		return empty ? null : { dx : xmin, dy : ymin, w : xmax - xmin + 1, h : ymax - ymin + 1 };
	}
	
}