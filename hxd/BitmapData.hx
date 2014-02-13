package hxd;

private typedef InnerData = #if flash flash.display.BitmapData #elseif js js.html.ImageData #elseif cpp flash.display.BitmapData #else Int #end;

abstract BitmapData(InnerData) {

	#if flash
	static var tmpRect = new flash.geom.Rectangle();
	static var tmpPoint = new flash.geom.Point();
	static var tmpMatrix = new flash.geom.Matrix();
	#end
	
	public var width(get, never) : Int;
	public var height(get, never) : Int;
	
	public inline function new(width:Int, height:Int) {
		#if flash
		this = new flash.display.BitmapData(width, height, true, 0);
		#else
		throw "TODO";
		#end
	}
	
	public inline function clear( color : Int ) {
		#if flash
		this.fillRect(this.rect, color);
		#else
		throw "TODO";
		#end
	}
	
	public function fill( x : Int, y : Int, width : Int, height : Int, color : Int ) {
		#if flash
		var r = tmpRect;
		r.x = x;
		r.y = y;
		r.width = width;
		r.height = height;
		this.fillRect(r, color);
		#else
		throw "TODO";
		#end
	}
	
	public function draw( x : Int, y : Int, src : BitmapData, srcX : Int, srcY : Int, width : Int, height : Int, ?blendMode : h2d.BlendMode ) {
		#if flash
		if( blendMode == null ) blendMode = Normal;
		var r = tmpRect;
		r.x = srcX;
		r.y = srcY;
		r.width = width;
		r.height = height;
		switch( blendMode ) {
		case None:
			var p = tmpPoint;
			p.x = x;
			p.y = y;
			this.copyPixels(src.toNative(), r, p);
		case Normal:
			var p = tmpPoint;
			p.x = x;
			p.y = y;
			this.copyPixels(src.toNative(), r, p, src.toNative(), null, true);
		case Add:
			var m = tmpMatrix;
			m.tx = x - srcX;
			m.ty = y - srcY;
			r.x = x;
			r.y = y;
			this.draw(src.toNative(), m, null, flash.display.BlendMode.ADD, r, false);
		case Erase:
			var m = tmpMatrix;
			m.tx = x - srcX;
			m.ty = y - srcY;
			r.x = x;
			r.y = y;
			this.draw(src.toNative(), m, null, flash.display.BlendMode.ERASE, r, false);
		case Multiply:
			var m = tmpMatrix;
			m.tx = x - srcX;
			m.ty = y - srcY;
			r.x = x;
			r.y = y;
			this.draw(src.toNative(), m, null, flash.display.BlendMode.MULTIPLY, r, false);
		case SoftAdd:
			throw "BlendMode not supported";
		}
		#else
		throw "TODO";
		#end
	}

	public function line( x0 : Int, y0 : Int, x1 : Int, y1 : Int, color : Int ) {
		var dx = x1 - x0;
		var dy = y1 - y0;
		if( dx == 0 ) {
			if( y1 < y0 ) {
				var tmp = y0;
				y0 = y1;
				y1 = tmp;
			}
			for( y in y0...y1 + 1 )
				setPixel(x0, y, color);
		} else if( dy == 0 ) {
			if( x1 < x0 ) {
				var tmp = x0;
				x0 = x1;
				x1 = tmp;
			}
			for( x in x0...x1 + 1 )
				setPixel(x, y0, color);
		} else {
			throw "TODO";
		}
	}
	
	public inline function dispose() {
		#if flash
		this.dispose();
		#end
	}
	
	public function sub( x, y, w, h ) : BitmapData {
		#if flash
		var b = new flash.display.BitmapData(w, h);
		b.copyPixels(this, new flash.geom.Rectangle(x, y, w, h), new flash.geom.Point(0, 0));
		return fromNative(b);
		#else
		throw "TODO";
		return null;
		#end
	}
	
	public inline function getPixel( x : Int, y : Int ) : Int {
		#if flash
		return this.getPixel32(x, y);
		#else
		throw "TODO";
		return 0;
		#end
	}

	public inline function setPixel( x : Int, y : Int, c : Int ) {
		#if flash
		this.setPixel32(x, y, c);
		#else
		throw "TODO";
		#end
	}
	
	inline function get_width() {
		return this.width;
	}

	inline function get_height() {
		return this.height;
	}
	
	public inline function getPixels() : Pixels {
		return nativeGetPixels(this);
	}

	public inline function setPixels( pixels : Pixels ) {
		nativeSetPixels(this, pixels);
	}
	
	public inline function toNative() : InnerData {
		return this;
	}
	
	public static inline function fromNative( bmp : InnerData ) : BitmapData {
		return cast bmp;
	}
	
	static function nativeGetPixels( b : InnerData ) {
		#if flash
		return new Pixels(b.width, b.height, haxe.io.Bytes.ofData(b.getPixels(b.rect)), ARGB);
		#else
		throw "TODO";
		return null;
		#end
	}
	
	static function nativeSetPixels( b : InnerData, pixels : Pixels ) {
		#if flash
		var bytes = pixels.bytes.getData();
		bytes.position = 0;
		switch( pixels.format ) {
		case BGRA:
			bytes.endian = flash.utils.Endian.LITTLE_ENDIAN;
		case ARGB:
			bytes.endian = flash.utils.Endian.BIG_ENDIAN;
		case RGBA:
			pixels.convert(BGRA);
			bytes.endian = flash.utils.Endian.LITTLE_ENDIAN;
		}
		b.setPixels(b.rect, bytes);
		#else
		throw "TODO";
		return null;
		#end
	}
}