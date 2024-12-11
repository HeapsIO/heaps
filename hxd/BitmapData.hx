package hxd;

#if js
typedef BitmapInnerData = js.html.CanvasRenderingContext2D;
#else
typedef BitmapInnerData = BitmapInnerDataImpl;
class BitmapInnerDataImpl {
	#if hl
	public var pixels : hl.BytesAccess<Int>;
	#else
	public var pixels : haxe.ds.Vector<Int>;
	#end
	public var width : Int;
	public var height : Int;
	public function new() {
	}
}
#end

class BitmapData {

#if js
	var ctx : js.html.CanvasRenderingContext2D;
	var lockImage : js.html.ImageData;
	var pixel : js.html.ImageData;
#else
	var data : BitmapInnerData;
#end

	public var width(get, never) : Int;
	public var height(get, never) : Int;

	public function new(width:Int, height:Int) {
		if( width == -101 && height == -102 ) {
			// no alloc
		} else {
			#if js
			var canvas = js.Browser.document.createCanvasElement();
			canvas.width = width;
			canvas.height = height;
			ctx = canvas.getContext2d();
			#else
			data = new BitmapInnerData();
			#if hl
			data.pixels = new hl.Bytes(width * height * 4);
			(data.pixels:hl.Bytes).fill(0, width * height * 4, 0);
			#else
			data.pixels = new haxe.ds.Vector(width * height);
			#end
			data.width = width;
			data.height = height;
			#end
		}
	}

	public function clear( color : Int ) {
		fill(0, 0, width, height, color);
	}

	static inline function notImplemented() {
		throw "Not implemented";
	}

	public function fill( x : Int, y : Int, width : Int, height : Int, color : Int ) {
		#if js
		ctx.fillStyle = 'rgba(${(color>>16)&0xFF}, ${(color>>8)&0xFF}, ${color&0xFF}, ${(color>>>24)/255})';
		ctx.fillRect(x, y, width, height);
		#else
		if( x < 0 ) {
			width += x;
			x = 0;
		}
		if( y < 0 ) {
			height += y;
			y = 0;
		}
		if( x + width > data.width )
			width = data.width - x;
		if( y + height > data.height )
			height = data.height - y;
		for( dy in 0...height ) {
			var p = x + (y + dy) * data.width;
			for( dx in 0...width )
				data.pixels[p++] = color;
		}
		#end
	}

	public function draw( x : Int, y : Int, src : BitmapData, srcX : Int, srcY : Int, width : Int, height : Int, ?blendMode : h2d.BlendMode ) {
		drawScaled(x,y,width,height,src,srcX,srcY,width,height,blendMode);
	}

	public function drawScaled( x : Int, y : Int, width : Int, height : Int, src : BitmapData, srcX : Int, srcY : Int, srcWidth : Int, srcHeight : Int, ?blendMode : h2d.BlendMode, smooth = true ) {
		if( blendMode == null ) blendMode = Alpha;
		#if hl
		if( blendMode != None ) throw "BitmapData.drawScaled blendMode no supported : " + blendMode;
		if( x < 0 || y < 0 || width < 0 || height < 0 || srcX < 0 || srcY < 0 || srcWidth < 0 || srcHeight < 0 ||
			x + width > this.width || y + height > this.height || srcX + srcWidth > src.width || srcY + srcHeight > src.height )
			throw "Outside bounds";
		format.hl.Native.scaleImage(
			data.pixels, (x + y * this.width) << 2, this.width<<2, width, height,
			src.data.pixels, (srcX + srcY * src.width)<<2, src.width<<2, srcWidth, srcHeight,
			smooth?1:0
		);
		#else
		notImplemented();
		#end
	}

	/* Line plotting using Yevgeny P. Kuzmin. - Bresenham's Line Generation Algorithm with Built-in Clipping. Computer Graphics Forum, 14(5):275-280, 2005.
 	 * see: https://stackoverflow.com/questions/40884680/how-to-use-bresenhams-line-drawing-algorithm-with-clipping/40902741#40902741 )
	 */
	public function line( x0 : Int, y0 : Int, x1 : Int, y1 : Int, color : Int ) {
		var dx = x1 - x0;
		var dy = y1 - y0;
		if( dx == 0 ) {
			if( y1 < y0 ) {
				var tmp = y0;
				y0 = y1;
				y1 = tmp;
			}
			if (y0<0) y0=0;
			if (y1>height-1) y1=height-1;
			for( y in y0...y1 + 1 )
				setPixel(x0, y, color);
		} else if( dy == 0 ) {
			if( x1 < x0 ) {
				var tmp = x0;
				x0 = x1;
				x1 = tmp;
			}
			if (x0<0) x0=0;
			if (x1>width-1) x1=width-1;
			for( x in x0...x1 + 1 )
				setPixel(x, y0, color);
		} else {
			var sx : Int;
			var sy : Int;
			var clip_x0 : Int;
			var clip_y0 : Int;
			var clip_x1 : Int;
			var clip_y1 : Int;

			if ( x0<x1 ) {
				if ( x0>=width || x1 <0 ) return;
				sx = 1;
				clip_x0 = 0;
				clip_x1 = width-1;
			} else {
				if ( x1>=width || x0<0 ) return;
				sx = -1;
				x1 = -x1;
				x0 = -x0;
				clip_x0 = 1-width;
				clip_x1 = 0;
			}

			if ( y0<y1 ) {
				if ( y0>=height || y1 <0 ) return;
				sy = 1;
				clip_y0 = 0;
				clip_y1 = height-1;
			} else {
				if ( y1>=width || y0<0 ) return;
				sy = -1;
				y1 = -y1;
				y0 = -y0;
				clip_y0 = 1-height;
				clip_y1 = 0;
			}

			dx = x1-x0;				// Those are always > 0 because of swappings
			dy = y1-y0;

			var d2x = dx << 1;		// double steps for bresenham
			var d2y = dy << 1;

			var x = x0;
			var y = y0;

			if ( dx >= dy ) { 		// slope in ]0;1]
				var delta = d2y - dx;
				var tracing_can_start = false;

				// Clipping on (x0;y0) side
				if ( y0 < clip_y0 ) {
					// Compute intersection (???;clip_y0) using float to avoid overflow
					var temp : Float = d2x;
					temp = temp * (clip_y0-y0) - dx;
					var xinc = temp / d2y;
					x += Std.int(xinc);

					if ( x > clip_x1 ) return;

					if ( x >= clip_x0 ) {
						temp -= xinc * d2y;
						delta -= Std.int(temp) + dx;
						y = clip_y0;

						if (temp>0) {
							x += 1;
							delta += d2y;
						}
						tracing_can_start = true;
					}
				}

				if( !tracing_can_start && x0 < clip_x0 ) {
					// Compute intersection (clip_x0;???)
					var temp : Float = d2y;
					temp *= (clip_x0 - x0);
					var yinc = temp / d2x;
					y += Std.int(yinc);
					temp %= d2x;
					if ( y > clip_y1 || ( y == clip_y1 && temp > dx ) ) return;

					x = clip_x0;
					delta += Std.int(temp);

					if ( temp >= dx ) {
						++y;
						delta -= d2x;
					}
				}
				// If we arrive here, (x;y) is the first point in view and delta was adjusted

				// clipping on (x1;y1) side
				var xend = x1;
				if ( y1 > clip_y1 ) {
					// Compute intersection (???;clip_y1)
					var temp : Float = d2x;
					temp = temp * (clip_y1-y1) + dx;
					var xinc = temp / d2y;
					xend += Std.int(xinc);

					if ( temp - xinc*d2y == 0 )
						--xend;
				}
				xend = ( xend > clip_x1 ) ? clip_x1 + 1 : xend + 1;

				// Clipping is done
				if ( sx == -1 ) {
					x = -x;
					xend = -xend;
				}
				if ( sy == -1 ) {
					y = -y;
				}

				d2x -= d2y;	// Changing d2x : delta is adjusted only once every loop

				// Bresenham
				while ( x != xend ) {
					setPixel(x, y, color);

					if ( delta >= 0 ) {
						y += sy;
						delta -= d2x;
					} else {
						delta += d2y;
					}
					x += sx;
				}
			} else {				// slope in ]1;+oo[
				var delta = d2x - dy;
				var tracing_can_start = false;

				// Clipping on (x0;y0) side
				if ( x0 < clip_x0 ) {
					var temp : Float = d2y;
					temp = temp * (clip_x0-x0) - dy;
					var yinc = (temp / d2x);
					y += Std.int(yinc);

					if ( y > clip_y1 ) return;

					if ( y >= clip_y0 ) {
						temp -= yinc * d2x;
						delta -= Std.int(temp) + dy;
						x = clip_x0;

						if (temp>0) {
							y += 1;
							delta += d2x;
						}
						tracing_can_start = true;
					}
				}

				if( !tracing_can_start && y0 < clip_y0 ) {
					var temp : Float = d2x;
					temp *= (clip_y0 - y0);
					var xinc = temp / d2y;
					x += Std.int(xinc);
					temp %= d2y;
					if ( x > clip_x1 || ( x == clip_x1 && temp > dy ) ) return;

					y = clip_y0;
					delta += Std.int(temp);

					if ( temp >= dy ) {
						++x;
						delta -= d2y;
					}
				}

				// clipping on (x1;y1) side
				var yend = y1;
				if ( x1 > clip_x1 ) {
					var temp : Float = d2y;
					temp = temp * (clip_x1-x1) + dy;
					var yinc = temp / d2x;
					yend += Std.int(yinc);

					if ( temp - yinc*d2x == 0 )
						--yend;
				}
				yend = ( yend > clip_y1 ) ? clip_y1 + 1 : yend + 1;

				// Clipping is done
				if ( sx == -1 ) {
					x = -x;
				}
				if ( sy == -1 ) {
					y = -y;
					yend = -yend;
				}

				d2y -= d2x;	// Changing d2y : delta is adjusted only once every loop

				// Bresenham
				while ( y != yend ) {
					setPixel(x, y, color);

					if ( delta >= 0 ) {
						x += sx;
						delta -= d2y;
					} else {
						delta += d2x;
					}
					y += sy;
				}
			}
		}
	}

	public inline function dispose() {
		#if js
		ctx = null;
		pixel = null;
		#else
		data = null;
		#end
	}

	public function clone() {
		return sub(0,0,width,height);
	}

	public function sub( x, y, w, h ) : BitmapData {
		#if js
		var canvas = js.Browser.document.createCanvasElement();
		canvas.width = w;
		canvas.height = h;
		var ctx = canvas.getContext2d();
		ctx.drawImage(this.ctx.canvas, x, y, w, h, 0, 0, w, h);
		return fromNative(ctx);
		#else
		if( x < 0 || y < 0 || w < 0 || h < 0 || x + w > width || y + h > height ) throw "Outside bounds";
		var b = new BitmapInnerData();
		b.width = w;
		b.height = h;
		#if hl
		b.pixels = new hl.Bytes(w * h * 4);
		for( dy in 0...h )
			b.pixels.blit(dy * w, data.pixels, x + (y + dy) * width, w);
		#else
		b.pixels = new haxe.ds.Vector(w * h);
		for( dy in 0...h )
			haxe.ds.Vector.blit(data.pixels, x + (y + dy) * width, b.pixels, dy * w, w);
		#end
		return fromNative(b);
		#end
	}

	/**
		Inform that we will perform several pixel operations on the BitmapData.
	**/
	public function lock() {
		#if js
		if( lockImage == null )
			lockImage = ctx.getImageData(0, 0, width, height);
		#end
	}

	/**
		Inform that we have finished performing pixel operations on the BitmapData.
	**/
	public function unlock() {
		#if js
		if( lockImage != null ) {
			ctx.putImageData(lockImage, 0, 0);
			lockImage = null;
		}
		#end
	}

	/**
		Access the pixel color value at the given position. Note : this function can be very slow if done many times and the BitmapData has not been locked.
	**/
	public function getPixel( x : Int, y : Int ) : Int {
		#if js
		var i = lockImage;
		var a;
		if( i != null )
			a = (x + y * i.width) << 2;
		else {
			a = 0;
			i = ctx.getImageData(x, y, 1, 1);
		}
		return (i.data[a] << 16) | (i.data[a|1] << 8) | i.data[a|2] | (i.data[a|3] << 24);
		#else
		return if( x >= 0 && y >= 0 && x < data.width && y < data.height ) data.pixels[x + y * data.width] else 0;
		#end
	}

	/**
		Modify the pixel color value at the given position. Note : this function can be very slow if done many times and the BitmapData has not been locked.
	**/
	public function setPixel( x : Int, y : Int, c : Int ) {
		#if js
		var i : js.html.ImageData = lockImage;
		if( i != null ) {
			var a = (x + y * i.width) << 2;
			i.data[a] = (c >> 16) & 0xFF;
			i.data[a|1] = (c >> 8) & 0xFF;
			i.data[a|2] = c & 0xFF;
			i.data[a|3] = (c >>> 24) & 0xFF;
			return;
		}
		var i = pixel;
		if( i == null ) {
			i = ctx.createImageData(1, 1);
			pixel = i;
		}
		i.data[0] = (c >> 16) & 0xFF;
		i.data[1] = (c >> 8) & 0xFF;
		i.data[2] = c & 0xFF;
		i.data[3] = (c >>> 24) & 0xFF;
		ctx.putImageData(i, x, y);
		#else
		if( x >= 0 && y >= 0 && x < data.width && y < data.height ) data.pixels[x + y * data.width] = c;
		#end
	}

	inline function get_width() : Int {
		#if js
		return ctx.canvas.width;
		#else
		return data.width;
		#end
	}

	inline function get_height() {
		#if js
		return ctx.canvas.height;
		#else
		return data.height;
		#end
	}

	public function getPixels() : Pixels {
		#if js
		var w = width;
		var h = height;
		var data = ctx.getImageData(0, 0, w, h).data;
		var pixels = data.buffer;
		return new Pixels(w, h, haxe.io.Bytes.ofData(pixels), RGBA);
		#else
		var out = haxe.io.Bytes.alloc(data.width * data.height * 4);
		for( i in 0...data.width*data.height )
			out.setInt32(i << 2, data.pixels[i]);
		return new Pixels(data.width, data.height, out, BGRA);
		#end
	}

	public function setPixels( pixels : Pixels ) {
		if( pixels.width != width || pixels.height != height )
			throw "Invalid pixels size";
		#if js
		var img = ctx.createImageData(pixels.width, pixels.height);
		pixels.convert(RGBA);
		for( i in 0...pixels.width*pixels.height*4 ) img.data[i] = pixels.bytes.get(i);
		ctx.putImageData(img, 0, 0);
		#else
		pixels.convert(BGRA);
		var src = pixels.bytes;
		for( i in 0...width * height )
			data.pixels[i] = src.getInt32(i<<2);
		#end
	}

	public inline function toNative() : BitmapInnerData {
		#if js
		return ctx;
		#else
		return data;
		#end
	}

	public static function fromNative( data : BitmapInnerData ) : BitmapData {
		var b = new BitmapData( -101, -102 );
		#if js
		b.ctx = data;
		#else
		b.data = data;
		#end
		return b;
	}

	public function toPNG() {
		var pixels = getPixels();
		var png = pixels.toPNG();
		pixels.dispose();
		return png;
	}

}
