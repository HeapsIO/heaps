package h2d;

@:allow(h2d)
class Tile {

	var innerTex : h3d.mat.Texture;

	var u : Float;
	var v : Float;
	var u2 : Float;
	var v2 : Float;

	public var dx : Float;
	public var dy : Float;
	public var x(default,null) : Float;
	public var y(default,null) : Float;
	public var width(default,null) : Float;
	public var height(default,null) : Float;

	public var ix(get,never) : Int;
	inline function get_ix() return Math.floor(x);

	public var iy(get,never) : Int;
	inline function get_iy() return Math.floor(y);

	public var iwidth(get,never) : Int;
	inline function get_iwidth() return Math.ceil(width + x) - ix;

	public var iheight(get,never) : Int;
	inline function get_iheight() return Math.ceil(height + y) - iy;

	function new(tex : h3d.mat.Texture, x : Float, y : Float, w : Float, h : Float, dx : Float=0, dy : Float=0) {
		this.innerTex = tex;
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
		this.dx = dx;
		this.dy = dy;
		if( tex != null ) setTexture(tex);
	}

	public inline function getTexture():h3d.mat.Texture {
		return innerTex;
	}

	public function isDisposed() {
		return innerTex == null || innerTex.isDisposed();
	}

	function setTexture(tex : h3d.mat.Texture) {
		this.innerTex = tex;
		if( tex != null ) {
			this.u = x / tex.width;
			this.v = y / tex.height;
			this.u2 = (x + width) / tex.width;
			this.v2 = (y + height) / tex.height;
		}
	}

	public inline function switchTexture( t : Tile ) {
		setTexture(t.innerTex);
	}

	public function sub( x : Float, y : Float, w : Float, h : Float, dx = 0., dy = 0. ) : Tile {
		return new Tile(innerTex, this.x + x, this.y + y, w, h, dx, dy);
	}

	public function center():Tile {
		return sub(0, 0, width, height, -(width * .5), -(height * .5));
	}

	public inline function setCenterRatio(?px:Float=0.5, ?py:Float=0.5) : Void {
		dx = -(px*width);
		dy = -(py*height);
	}

	public function flipX() : Void {
		var tmp = u; u = u2; u2 = tmp;
		dx = -dx - width;
	}

	public function flipY() : Void {
		var tmp = v; v = v2; v2 = tmp;
		dy = -dy - height;
	}

	public function setPosition(x : Float, y : Float) : Void {
		this.x = x;
		this.y = y;
		var tex = innerTex;
		if( tex != null ) {
			u = x / tex.width;
			v = y / tex.height;
			u2 = (x + width) / tex.width;
			v2 = (y + height) / tex.height;
		}
	}

	public function setSize(w : Float, h : Float) : Void {
		this.width = w;
		this.height = h;
		var tex = innerTex;
		if( tex != null ) {
			u2 = (x + w) / tex.width;
			v2 = (y + h) / tex.height;
		}
	}

	public function scaleToSize( w : Float, h : Float ) : Void {
		this.width = w;
		this.height = h;
	}

	public function scrollDiscrete( dx : Float, dy : Float ) : Void {
		var tex = innerTex;
		u += dx / tex.width;
		v -= dy / tex.height;
		u2 += dx / tex.width;
		v2 -= dy / tex.height;
		x = u * tex.width;
		y = v * tex.height;
	}

	public function dispose() : Void {
		if( innerTex != null ) innerTex.dispose();
		innerTex = null;
	}

	public function clone() : Tile {
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
	public function split( frames : Int = 0, vertical = false, subpixel = false ) : Array<Tile> {
		var tl = [];
		if( vertical ) {
			if( frames == 0 )
				frames = Std.int(height / width);
			var stride = subpixel ? height / frames : Std.int(height / frames);
			for( i in 0...frames )
				tl.push(sub(0, i * stride, width, stride));
		} else {
			if( frames == 0 )
				frames = Std.int(width / height);
			var stride = subpixel ? width / frames : Std.int(width / frames);
			for( i in 0...frames )
				tl.push(sub(i * stride, 0, stride, height));
		}
		return tl;
	}

	/**
		Split the tile into a list of tiles of Size x Size pixels.
		Unlike grid which is X/Y ordered, gridFlatten returns a single dimensional array ordered in Y/X.
	**/
	public function gridFlatten( size : Float, dx = 0., dy = 0. ) : Array<Tile> {
		return [for( y in 0...Std.int(height / size) ) for( x in 0...Std.int(width / size) ) sub(x * size, y * size, size, size, dx, dy)];
	}

	/**
		Split the tile into a list of tiles of Size x Size pixels.
	**/
	public function grid( size : Float, dx = 0., dy = 0. ) : Array<Array<Tile>> {
		return [for( x in 0...Std.int(width / size) ) [for( y in 0...Std.int(height / size) ) sub(x * size, y * size, size, size, dx, dy)]];
	}

	public function toString() : String {
		return "Tile(" + x + "," + y + "," + width + "x" + height + (dx != 0 || dy != 0 ? "," + dx + ":" + dy:"") + ")";
	}

	function upload( bmp:hxd.BitmapData ) : Void {
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


	public static function fromColor( color : Int, ?width = 1., ?height = 1., ?alpha = 1., ?allocPos : h3d.impl.AllocPos ) : Tile {
		var t = new Tile(h3d.mat.Texture.fromColor(color,alpha,allocPos),0,0,1,1);
		// scale to size
		t.width = width;
		t.height = height;
		return t;
	}

	public static function fromBitmap( bmp : hxd.BitmapData, ?allocPos : h3d.impl.AllocPos ) : Tile {
		var tex = h3d.mat.Texture.fromBitmap(bmp, allocPos);
		return new Tile(tex, 0, 0, bmp.width, bmp.height);
	}

	public static function autoCut( bmp : hxd.BitmapData, width : Int, ?height : Int, ?allocPos : h3d.impl.AllocPos ) {
		#if js
		bmp.lock();
		#end
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
		#if js
		bmp.unlock();
		#end
		var main = new Tile(tex, 0, 0, bmp.width, bmp.height);
		main.upload(bmp);
		return { main : main, tiles : tl };
	}

	public static function fromTexture( t : h3d.mat.Texture ) : Tile {
		return new Tile(t, 0, 0, t.width, t.height);
	}

	public static function fromPixels( pixels : hxd.Pixels, ?allocPos : h3d.impl.AllocPos ) : Tile {
		var pix2 = pixels.makeSquare(true);
		var t = h3d.mat.Texture.fromPixels(pix2);
		if( pix2 != pixels ) pix2.dispose();
		return new Tile(t, 0, 0, pixels.width, pixels.height);
	}

	static function isEmpty( b : hxd.BitmapData, px : Int, py : Int, width : Int, height : Int, bg : Int ) {
		var empty = true;
		var xmin = width, ymin = height, xmax = 0, ymax = 0;
		for( x in 0...width )
			for( y in 0...height ) {
				var color : Int = b.getPixel(x + px, y + py);
				if( color & 0xFF000000 == 0 ) {
					if( color != 0 ) b.setPixel(x + px, y + py, 0);
					continue;
				}
				if( color != bg ) {
					empty = false;
					if( x < xmin ) xmin = x;
					if( y < ymin ) ymin = y;
					if( x > xmax ) xmax = x;
					if( y > ymax ) ymax = y;
				}
				if( color == bg && color != 0 )
					b.setPixel(x + px, y + py, 0);
			}
		return empty ? null : { dx : xmin, dy : ymin, w : xmax - xmin + 1, h : ymax - ymin + 1 };
	}

}
