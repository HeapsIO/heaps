package hxd;

private typedef InnerData =
#if (flash||openfl)
	flash.display.BitmapData
#elseif js
	js.html.CanvasRenderingContext2D
#elseif nme
	nme.display.BitmapData
#else
	Int
#end;

abstract BitmapData(InnerData) {

	#if (flash || nme || openfl)
	static var tmpRect = new flash.geom.Rectangle();
	static var tmpPoint = new flash.geom.Point();
	static var tmpMatrix = new flash.geom.Matrix();
	#end

	public var width(get, never) : Int;
	public var height(get, never) : Int;

	public inline function new(width:Int, height:Int) {
		#if (flash||openfl||nme)
		this = new flash.display.BitmapData(width, height, true, 0);
		#else
		var canvas = js.Browser.document.createCanvasElement();
		canvas.width = width;
		canvas.height = height;
		this = canvas.getContext2d();
		#end
	}

	public inline function clear( color : Int ) {
		#if (flash||openfl)
		this.fillRect(this.rect, color);
		#else
		fill(0, 0, width, height, color);
		#end
	}

	public function fill( x : Int, y : Int, width : Int, height : Int, color : Int ) {
		#if (flash || openfl || nme)
		var r = tmpRect;
		r.x = x;
		r.y = y;
		r.width = width;
		r.height = height;
		this.fillRect(r, color);
		#else
		this.fillStyle = 'rgba(${(color>>16)&0xFF}, ${(color>>8)&0xFF}, ${color&0xFF}, ${(color>>>24)/255})';
		this.fillRect(x, y, width, height);
		#end
	}

	public function draw( x : Int, y : Int, src : BitmapData, srcX : Int, srcY : Int, width : Int, height : Int, ?blendMode : h2d.BlendMode ) {
		#if flash
		if( blendMode == null ) blendMode = Alpha;
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
		case Alpha:
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
		case Screen:
			var m = tmpMatrix;
			m.tx = x - srcX;
			m.ty = y - srcY;
			r.x = x;
			r.y = y;
			this.draw(src.toNative(), m, null, flash.display.BlendMode.SCREEN, r, false);
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
		#if (flash||openfl)
		this.dispose();
		#end
	}

	public function clone() {
		return sub(0,0,width,height);
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

	/**
		Inform that we will perform several pixel operations on the BitmapData.
	**/
	public inline function lock() {
		#if flash
		this.lock();
		#elseif js
		canvasLock(this, true);
		#end
	}

	/**
		Inform that we have finished performing pixel operations on the BitmapData.
	**/
	public inline function unlock() {
		#if flash
		this.unlock();
		#elseif js
		canvasLock(this, false);
		#end
	}

	/**
		Access the pixel color value at the given position. Note : this function can be very slow if done many times and the BitmapData has not been locked.
	**/
	public inline function getPixel( x : Int, y : Int ) : Int {
		#if ( flash || openfl )
		return this.getPixel32(x, y);
		#elseif js
		return canvasGetPixel(this, x, y);
		#else
		throw "TODO";
		return 0;
		#end
	}

	/**
		Modify the pixel color value at the given position. Note : this function can be very slow if done many times and the BitmapData has not been locked.
	**/
	public inline function setPixel( x : Int, y : Int, c : Int ) {
		#if (flash||openfl)
		this.setPixel32(x, y, c);
		#elseif js
		canvasSetPixel(this, x, y, c);
		#else
		throw "TODO";
		#end
	}

	inline function get_width() : Int {
		#if js
		return this.canvas.width;
		#else
		return this.width;
		#end
	}

	inline function get_height() {
		#if js
		return this.canvas.height;
		#else
		return this.height;
		#end
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
		var p = new Pixels(b.width, b.height, haxe.io.Bytes.ofData(b.getPixels(b.rect)), ARGB);
		p.flags.set(AlphaPremultiplied);
		return p;
		#elseif js
		var pixels = [];
		var w = b.canvas.width;
		var h = b.canvas.height;
		var data = b.getImageData(0, 0, w, h).data;
		for( i in 0...w * h * 4 )
			pixels.push(data[i]);
		return new Pixels(b.canvas.width, b.canvas.height, haxe.io.Bytes.ofData(pixels), RGBA);
		#elseif openfl
		var bRect = b.rect;
		var bPixels : haxe.io.Bytes = hxd.ByteConversions.byteArrayToBytes(b.getPixels(b.rect));
		var p = new Pixels(b.width, b.height, bPixels, ARGB);
		p.flags.set(AlphaPremultiplied);
		return p;
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
		#elseif js
		var img = b.createImageData(pixels.width, pixels.height);
		pixels.convert(RGBA);
		for( i in 0...pixels.width*pixels.height*4 ) img.data[i] = pixels.bytes.get(i);
		b.putImageData(img, 0, 0);
		#elseif cpp
		b.setPixels(b.rect, flash.utils.ByteArray.fromBytes(pixels.bytes));
		#else
		throw "TODO";
		#end
	}

	#if js

	static function canvasLock( b : InnerData, lock : Bool ) untyped {
		if( lock ) {
			if( b.lockImage == null )
				b.lockImage = b.getImageData(0, 0, b.canvas.width, b.canvas.height);
		} else {
			if( b.lockImage != null ) {
				b.putImageData(b.lockImage, 0, 0);
				b.lockImage = null;
			}
		}
	}

	static function canvasGetPixel( b : InnerData, x : Int, y : Int ) {
		var i : js.html.ImageData = untyped b.lockImage;
		var a;
		if( i != null )
			a = (x + y * i.width) << 2;
		else {
			a = 0;
			i = b.getImageData(x, y, 1, 1);
		}
		return (i.data[a] << 16) | (i.data[a|1] << 8) | i.data[a|2] | (i.data[a|3] << 24);
	}

	static function canvasSetPixel( b : InnerData, x : Int, y : Int, c : Int ) {
		var i : js.html.ImageData = untyped b.lockImage;
		if( i != null ) {
			var a = (x + y * i.width) << 2;
			i.data[a] = (c >> 16) & 0xFF;
			i.data[a|1] = (c >> 8) & 0xFF;
			i.data[a|2] = c & 0xFF;
			i.data[a|3] = (c >>> 24) & 0xFF;
			return;
		}
		var i = untyped b.pixel;
		if( i == null ) {
			i = b.createImageData(1, 1);
			untyped b.pixel = i;
		}
		i.data[0] = (c >> 16) & 0xFF;
		i.data[1] = (c >> 8) & 0xFF;
		i.data[2] = c & 0xFF;
		i.data[3] = (c >>> 24) & 0xFF;
		b.putImageData(i, x, y);
	}
	#end
}