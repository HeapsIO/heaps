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
	
	public function getTexture() {
		if( innerTex == null || innerTex.isDisposed() )
			return Tools.getCoreObjects().getEmptyTexture();
		return innerTex;
	}
	
	public function hasTexture() {
		return innerTex != null && !innerTex.isDisposed();
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
	
	public function setPos(x, y) {
		this.x = x;
		this.y = y;
		var tex = innerTex;
		if( tex != null ) {
			u = x / tex.width;
			v = y / tex.height;
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
	
	
	public function split( frames : Int ) {
		var tl = [];
		var stride = Std.int(width / frames);
		for( i in 0...frames )
			tl.push(sub(i * stride, 0, stride, height));
		return tl;
	}
	
	public function toString() {
		return "Tile(" + x + "," + y + "," + width + "x" + height + (dx != 0 || dy != 0 ? "," + dx + ":" + dy:"") + ")";
	}

	function upload(bmp:flash.display.BitmapData) {
		var w = innerTex.width;
		var h = innerTex.height;
		if( w != bmp.width || h != bmp.height ) {
			var bmp2 = new flash.display.BitmapData(w, h, true, 0);
			var p0 = new flash.geom.Point(0, 0);
			bmp2.copyPixels(bmp, bmp.rect, p0, bmp, p0, true);
			innerTex.upload(bmp2);
			bmp2.dispose();
		} else
			innerTex.upload(bmp);
	}
	

	static var COLOR_CACHE = new Map<Int,h2d.Tile>();
	public static function fromColor( color : Int, ?allocPos : h3d.impl.AllocPos ) {
		var t = COLOR_CACHE.get(color);
		if( t != null && t.hasTexture() )
			return t;
		var tex = h3d.Engine.getCurrent().mem.allocTexture(1, 1, allocPos);
		var bmp = haxe.io.Bytes.alloc(4);
		bmp.set(0, color & 0xFF);
		bmp.set(1, (color >> 8) & 0xFF);
		bmp.set(2, (color >> 16) & 0xFF);
		bmp.set(3, color >>> 24);
		tex.uploadBytes(bmp);
		tex.onContextLost = function() {
			tex.uploadBytes(bmp);
		};
		var t = new Tile(tex, 0, 0, 1, 1);
		COLOR_CACHE.set(color, t);
		return t;
	}
	
	public static function fromBitmap( bmp : flash.display.BitmapData, ?allocPos : h3d.impl.AllocPos ) {
		var w = 1, h = 1;
		while( w < bmp.width )
			w <<= 1;
		while( h < bmp.height )
			h <<= 1;
		var tex = h3d.Engine.getCurrent().mem.allocTexture(w, h, allocPos);
		var t = new Tile(tex, 0, 0, bmp.width, bmp.height);
		t.upload(bmp);
		return t;
	}

	public static function autoCut( bmp : flash.display.BitmapData, width : Int, ?height : Int, ?allocPos : h3d.impl.AllocPos ) {
		if( height == null ) height = width;
		var colorBG = bmp.getPixel32(bmp.width - 1, bmp.height - 1);
		var tl = new Array();
		var w = 1, h = 1;
		while( w < bmp.width )
			w <<= 1;
		while( h < bmp.height )
			h <<= 1;
		var tex = h3d.Engine.getCurrent().mem.allocTexture(w, h, allocPos);
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
		var main = fromBitmap(bmp,allocPos);
		var tiles = [];
		for( t in tmp )
			tiles.push(main.sub(t.x, 0, t.w, t.h, t.dx, t.dy));
		return tiles;
	}
	
	static function isEmpty( b : flash.display.BitmapData, px, py, width, height, bg : UInt ) {
		var empty = true;
		var xmin = width, ymin = height, xmax = 0, ymax = 0;
		for( x in 0...width )
			for( y in 0...height ) {
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