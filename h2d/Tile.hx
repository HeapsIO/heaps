package h2d;

@:allow(h2d)
class Tile {
	
	static inline var EPSILON_PIXEL = 0.001;
	
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
	
	public function getTexture() {
		return innerTex;
	}
	
	public function isDisposed() {
		return innerTex == null || innerTex.isDisposed();
	}
		
	function setTexture(tex) {
		this.innerTex = tex;
		if( tex != null ) {
			this.u = (x + EPSILON_PIXEL) / tex.width;
			this.v = (y + EPSILON_PIXEL) / tex.height;
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
	
	public function center(dx, dy) {
		return sub(0, 0, width, height, -dx, -dy);
	}
	
	public function setPos(x, y) {
		this.x = x;
		this.y = y;
		var tex = innerTex;
		if( tex != null ) {
			u = (x + EPSILON_PIXEL) / tex.width;
			v = (y + EPSILON_PIXEL) / tex.height;
			u2 = (width + x - EPSILON_PIXEL) / tex.width;
			v2 = (height + y - EPSILON_PIXEL) / tex.height;
		}
	}
	
	public function setSize(w, h) {
		this.width = w;
		this.height = h;
		var tex = innerTex;
		if( tex != null ) {
			u2 = (w + x - EPSILON_PIXEL) / tex.width;
			v2 = (h + y - EPSILON_PIXEL) / tex.height;
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
		y = Std.int(v * tex.height);
	}
	
	public function dispose() {
		if( innerTex != null ) innerTex.dispose();
		innerTex = null;
	}
	
	public function clone() {
		var t = new Tile(null, x, y, width, height, dx, dy);
		t.innerTex = innerTex;
		t.u = u;
		t.u2 = u2;
		t.v = v;
		t.v2 = v2;
		return t;
	}
	
	/**
		Split horizontaly or verticaly the number of given frames
	**/
	public function split( frames : Int, vertical = false ) {
		var tl = [];
		if( vertical ) {
			var stride = Std.int(height / frames);
			for( i in 0...frames )
				tl.push(sub(0, i * stride, width, stride));
		} else {
			var stride = Std.int(width / frames);
			for( i in 0...frames )
				tl.push(sub(i * stride, 0, stride, height));
		}
		return tl;
	}

	/**
		Split the tile into a list of tiles of Size x Size pixels.
	**/
	public function grid( size : Int, dx = 0, dy = 0 ) {
		return [for( y in 0...Std.int(height / size) ) for( x in 0...Std.int(width / size) ) sub(x * size, y * size, size, size, dx, dy)];
	}
	
	public function toString() {
		return "Tile(" + x + "," + y + "," + width + "x" + height + (dx != 0 || dy != 0 ? "," + dx + ":" + dy:"") + ")";
	}

	function upload( bmp:hxd.BitmapData ) {
		var w = innerTex.width;
		var h = innerTex.height;
		#if flash
		if( w != bmp.width || h != bmp.height ) {
			var bmp2 = new flash.display.BitmapData(w, h, true, 0);
			var p0 = new flash.geom.Point(0, 0);
			var bmp = bmp.toNative();
			bmp2.copyPixels(bmp, bmp.rect, p0, bmp, p0, true);
			innerTex.uploadBitmap(hxd.BitmapData.fromNative(bmp2));
			bmp2.dispose();
		} else
		#end
			innerTex.uploadBitmap(bmp);
	}
	

	public static function fromColor( color : Int, ?width = 1, ?height = 1, ?allocPos : h3d.impl.AllocPos ) {
		var t = new Tile(h3d.mat.Texture.fromColor(color,allocPos),0,0,1,1);
		// scale to size
		t.width = width;
		t.height = height;
		return t;
	}
	
	public static function fromBitmap( bmp : hxd.BitmapData, ?allocPos : h3d.impl.AllocPos ) {
		var w = 1, h = 1;
		while( w < bmp.width )
			w <<= 1;
		while( h < bmp.height )
			h <<= 1;
		var tex = new h3d.mat.Texture(w, h, allocPos);
		var t = new Tile(tex, 0, 0, bmp.width, bmp.height);
		t.upload(bmp);
		return t;
	}

	public static function autoCut( bmp : hxd.BitmapData, width : Int, ?height : Int, ?allocPos : h3d.impl.AllocPos ) {
		if( height == null ) height = width;
		var colorBG = bmp.getPixel(bmp.width - 1, bmp.height - 1);
		var tl = new Array();
		var w = 1, h = 1;
		while( w < bmp.width )
			w <<= 1;
		while( h < bmp.height )
			h <<= 1;
		var tex = new h3d.mat.Texture(w, h, allocPos);
		for( y in 0...Std.int(bmp.height / height) ) {
			var a = [];
			tl[y] = a;
			for( x in 0...Std.int(bmp.width / width) ) {
				var sz = isEmpty(bmp, x * width, y * height, width, height, colorBG);
				if( sz == null )
					break;
				a.push(new Tile(tex,x*width+sz.dx, y*height+sz.dy, sz.w, sz.h, sz.dx, sz.dy));
			}
		}
		var main = new Tile(tex, 0, 0, bmp.width, bmp.height);
		main.upload(bmp);
		return { main : main, tiles : tl };
	}
	
	public static function fromTexture( t : h3d.mat.Texture ) {
		return new Tile(t, 0, 0, t.width, t.height);
	}
	
	public static function fromPixels( pixels : hxd.Pixels, ?allocPos : h3d.impl.AllocPos ) {
		var pix2 = pixels.makeSquare(true);
		var t = h3d.mat.Texture.fromPixels(pix2);
		if( pix2 != pixels ) pix2.dispose();
		return new Tile(t, 0, 0, pixels.width, pixels.height);
	}
	
	#if flash
	public static function fromSprites( sprites : Array<flash.display.Sprite>, ?allocPos : h3d.impl.AllocPos ) {
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
		var main = fromBitmap(hxd.BitmapData.fromNative(bmp), allocPos);
		bmp.dispose();
		var tiles = [];
		for( t in tmp )
			tiles.push(main.sub(t.x, 0, t.w, t.h, t.dx, t.dy));
		return tiles;
	}
	#end
	
	static function isEmpty( b : hxd.BitmapData, px, py, width, height, bg : Int ) {
		var empty = true;
		var xmin = width, ymin = height, xmax = 0, ymax = 0;
		for( x in 0...width )
			for( y in 0...height ) {
				var color : Int = b.getPixel(x+px, y+py);
				if( color != bg ) {
					empty = false;
					if( x < xmin ) xmin = x;
					if( y < ymin ) ymin = y;
					if( x > xmax ) xmax = x;
					if( y > ymax ) ymax = y;
				}
				if( color == bg )
					b.setPixel(x+px, y+py, 0);
			}
		return empty ? null : { dx : xmin, dy : ymin, w : xmax - xmin + 1, h : ymax - ymin + 1 };
	}
	
}