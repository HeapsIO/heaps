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
	
	public inline function getBytes() {
		return nativeGetBytes(this);
	}

	public inline function toNative() : InnerData {
		return this;
	}
	
	public static inline function fromNative( bmp : InnerData ) : BitmapData {
		return cast bmp;
	}
	
	static function nativeGetBytes( b : InnerData ) {
		#if flash
		var bytes = haxe.io.Bytes.ofData(b.getPixels(b.rect));
		// it is necessary to swap the bytes from BE to LE
		var mem = hxd.impl.Memory.select(bytes);
		for( i in 0...b.width*b.height ) {
			var p = i << 2;
			var a = mem.b(p);
			var r = mem.b(p+1);
			var g = mem.b(p+2);
			var b = mem.b(p+3);
			mem.wb(p, b);
			mem.wb(p+1, g);
			mem.wb(p+2, r);
			mem.wb(p+3, a);
		}
		mem.end();
		return bytes;
		#else
		throw "TODO";
		return null;
		#end
	}
	
}