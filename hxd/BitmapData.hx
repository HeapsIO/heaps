package hxd;

private typedef InnerData = #if flash flash.display.BitmapData #elseif js js.html.ImageData #elseif cpp flash.display.BitmapData #else Int #end;

abstract BitmapData(InnerData) {

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
	
	public inline function dispose() {
		#if flash
		this.dispose();
		#end
	}
	
	public inline function getPixel( x : Int, y : Int ) {
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