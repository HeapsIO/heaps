package hxd;

private typedef InnerData = #if flash flash.display.BitmapData #elseif js js.html.ImageData #else Int #end;

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

	public inline function toNative() : InnerData {
		return this;
	}
	
	public static inline function fromNative( bmp : InnerData ) : BitmapData {
		return cast bmp;
	}
	
}