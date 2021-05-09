package hxd;

enum Flags {
	ReadOnly;
	AlphaPremultiplied;
	FlipY;
}

@:forward(bytes, format, width, height, offset, flags, clear, dispose, toPNG, clone, sub, blit)
abstract PixelsARGB(Pixels) to Pixels {


	public inline function getPixel(x, y) {
		return Pixels.switchEndian( this.bytes.getInt32(((x + y * this.width) << 2) + this.offset) );
	}

	public inline function setPixel(x, y, v) {
		this.bytes.setInt32(((x + y * this.width) << 2) + this.offset, Pixels.switchEndian(v));
	}

	@:from public static function fromPixels(p:Pixels) : PixelsARGB {
		p.convert(ARGB);
		p.setFlip(false);
		return cast p;
	}
}

@:forward(bytes, format, width, height, offset, flags, clear, dispose, toPNG, clone, sub, blit)
@:access(hxd.Pixels)
abstract PixelsFloat(Pixels) to Pixels {

	public inline function getPixelF(x, y, ?v:h3d.Vector) {
		if( v == null )
			v = new h3d.Vector();
		var pix = ((x + y * this.width) << 2) + this.offset;
		v.x = this.bytes.getFloat(pix);
		return v;
	}

	public inline function setPixelF(x, y, v:h3d.Vector) {
		var pix = ((x + y * this.width) << 2) + this.offset;
		this.bytes.setFloat(pix, v.x);
	}

	@:from public static function fromPixels(p:Pixels) : PixelsFloat {
		p.setFlip(false);
		p.convert(R32F);
		return cast p;
	}

}

@:forward(bytes, format, width, height, offset, flags, clear, dispose, toPNG, clone, sub, blit)
@:access(hxd.Pixels)
abstract PixelsFloatRGBA(Pixels) to Pixels {

	public inline function getPixelF(x, y, ?v:h3d.Vector) {
		if( v == null )
			v = new h3d.Vector();
		var pix = ((x + y * this.width) << 4) + this.offset;
		v.x = this.bytes.getFloat(pix);
		v.y = this.bytes.getFloat(pix+4);
		v.z = this.bytes.getFloat(pix+8);
		v.w = this.bytes.getFloat(pix+12);
		return v;
	}

	public inline function setPixelF(x, y, v:h3d.Vector) {
		var pix = ((x + y * this.width) << 4) + this.offset;
		this.bytes.setFloat(pix, v.x);
		this.bytes.setFloat(pix+4, v.y);
		this.bytes.setFloat(pix+8, v.z);
		this.bytes.setFloat(pix+12, v.w);
	}

	@:from public static function fromPixels(p:Pixels) : PixelsFloatRGBA {
		p.setFlip(false);
		p.convert(RGBA32F);
		return cast p;
	}

}

@:enum abstract Channel(Int) {
	public var R = 0;
	public var G = 1;
	public var B = 2;
	public var A = 3;
	public inline function toInt() return this;
	public static inline function fromInt( v : Int ) : Channel return cast v;
}

@:noDebug
class Pixels {
	public var bytes : haxe.io.Bytes;
	public var format(get,never) : PixelFormat;
	public var width(default,null) : Int;
	public var height(default,null) : Int;
	public var dataSize(default,null) : Int;
	public var offset : Int;
	public var flags: haxe.EnumFlags<Flags>;

	var stride : Int;
	var bytesPerPixel : Int;
	var innerFormat(default, set) : PixelFormat;

	public function new(width : Int, height : Int, bytes : haxe.io.Bytes, format : hxd.PixelFormat, offset = 0) {
		this.width = width;
		this.height = height;
		this.bytes = bytes;
		this.innerFormat = format;
		this.offset = offset;
		flags = haxe.EnumFlags.ofInt(0);
	}

	public static inline function switchEndian(v) {
		return (v >>> 24) | ((v >> 8) & 0xFF00) | ((v << 8) & 0xFF0000) | (v << 24);
	}

	public static inline function switchBR(v) {
		return (v & 0xFF00FF00) | ((v << 16) & 0xFF0000) | ((v >> 16) & 0xFF);
	}

	inline function get_format() return innerFormat;

	function set_innerFormat(fmt) {
		this.innerFormat = fmt;
		stride = calcStride(width,fmt);
		dataSize = calcDataSize(width, height, fmt);
		bytesPerPixel = calcStride(1,fmt);
		return fmt;
	}

	function invalidFormat() {
		throw "Unsupported format for this operation : " + format;
	}

	public function sub( x : Int, y : Int, width : Int, height : Int ) {
		if( x < 0 || y < 0 || x + width > this.width || y + height > this.height )
			throw "Pixels.sub() outside bounds";
		var out = haxe.io.Bytes.alloc(height * stride);
		var stride = calcStride(width, format);
		var outP = 0;
		for( dy in 0...height ) {
			var p = (x + yflip(y + dy) * this.width) * bytesPerPixel + offset;
			out.blit(outP, this.bytes, p, stride);
			outP += stride;
		}
		return new hxd.Pixels(width, height, out, format);
	}

	inline function yflip(y:Int) {
		return if( flags.has(FlipY) ) this.height - 1 - y else y;
	}

	public function blit( x : Int, y : Int, src : hxd.Pixels, srcX : Int, srcY : Int, width : Int, height : Int ) {
		if( x < 0 || y < 0 || x + width > this.width || y + height > this.height )
			throw "Pixels.blit() outside bounds";
		if( srcX < 0 || srcX < 0 || srcX + width > src.width || srcY + height > src.height )
			throw "Pixels.blit() outside src bounds";
		willChange();
		src.convert(format);
		var bpp = bytesPerPixel;
		if( bpp == 0 )
			throw "assert";
		var stride = calcStride(width, format);
		for( dy in 0...height ) {
			var srcP = (srcX + src.yflip(dy + srcY) * src.width) * bpp + src.offset;
			var dstP = (x + yflip(dy + y) * this.width) * bpp + offset;
			bytes.blit(dstP, src.bytes, srcP, stride);
		}
	}

	public function clear( color : Int, preserveMask = 0 ) {
		var mask = preserveMask;
		willChange();
		if( (color&0xFF) == ((color>>8)&0xFF) && (color & 0xFFFF) == (color >>> 16) && mask == 0 ) {
			bytes.fill(offset, width * height * bytesPerPixel, color&0xFF);
			return;
		}
		switch( format ) {
		case BGRA:
		case RGBA:
			color = switchBR(color);
			mask = switchBR(mask);
		case ARGB:
			color = switchEndian(color);
			mask = switchEndian(mask);
		default:
			invalidFormat();
		}
		var p = offset;
		if( mask == 0 ) {
			#if hl
			var bytes = @:privateAccess bytes.b;
			for( i in 0...width * height ) {
				bytes.setI32(p, color);
				p += 4;
			}
			#else
			for( i in 0...width * height ) {
				bytes.setInt32(p, color);
				p += 4;
			}
			#end
		} else {
			#if hl
			var bytes = @:privateAccess bytes.b;
			for( i in 0...width * height ) {
				bytes.setI32(p, color | (bytes.getI32(p) & mask));
				p += 4;
			}
			#else
			for( i in 0...width * height ) {
				bytes.setInt32(p, color | (bytes.getInt32(p) & mask));
				p += 4;
			}
			#end
		}
	}

	public function toVector() : haxe.ds.Vector<Int> {
		var vec = new haxe.ds.Vector<Int>(width * height);
		var idx = 0;
		var p = offset;
		var dl = 0;
		if( flags.has(FlipY) ) {
			p += ((height - 1) * width) * bytesPerPixel;
			dl = -width * 2 * bytesPerPixel;
		}
		switch(format) {
		case BGRA:
			for( y in 0...height ) {
				for( x in 0...width ) {
					vec[idx++] = bytes.getInt32(p);
					p += 4;
				}
				p += dl;
			}
		case RGBA:
			for( y in 0...height ) {
				for( x in 0...width ) {
					var v = bytes.getInt32(p);
					vec[idx++] = switchBR(v);
					p += 4;
				}
				p += dl;
			}
		case ARGB:
			for( y in 0...height ) {
				for( x in 0...width ) {
					var v = bytes.getInt32(p);
					vec[idx++] = switchEndian(v);
					p += 4;
				}
				p += dl;
			}
		default:
			invalidFormat();
		}
		return vec;
	}

	public function makeSquare( ?copy : Bool ) {
		var w = width, h = height;
		var tw = w == 0 ? 0 : 1, th = h == 0 ? 0 : 1;
		while( tw < w ) tw <<= 1;
		while( th < h ) th <<= 1;
		if( w == tw && h == th ) return this;
		var bpp = bytesPerPixel;
		var out = haxe.io.Bytes.alloc(tw * th * bpp);
		var p = 0, b = offset;
		for( y in 0...h ) {
			out.blit(p, bytes, b, w * bpp);
			p += w * bpp;
			b += w * bpp;
			for( i in 0...((tw - w) * bpp) >> 2 ) {
				out.setInt32(p, 0);
				p += 4;
			}
		}
		for( i in 0...((th - h) * tw * bpp) >> 2 ) {
			out.setInt32(p, 0);
			p += 4;
		}
		if( copy )
			return new Pixels(tw, th, out, format);
		bytes = out;
		width = tw;
		height = th;
		return this;
	}

	function copyInner() {
		var old = bytes;
		bytes = haxe.io.Bytes.alloc(dataSize);
		bytes.blit(0, old, offset, dataSize);
		offset = 0;
		flags.unset(ReadOnly);
	}

	inline function willChange() {
		if( flags.has(ReadOnly) ) copyInner();
	}

	public function setFlip( b : Bool ) {
		#if js if( b == null ) b = false; #end
		if( flags.has(FlipY) == b ) return;
		willChange();
		if( b ) flags.set(FlipY) else flags.unset(FlipY);
		if( stride%4 != 0 ) invalidFormat();
		for( y in 0...height >> 1 ) {
			var p1 = y * stride + offset;
			var p2 = (height - 1 - y) * stride + offset;
			for( x in 0...stride>>2 ) {
				var a = bytes.getInt32(p1);
				var b = bytes.getInt32(p2);
				bytes.setInt32(p1, b);
				bytes.setInt32(p2, a);
				p1 += 4;
				p2 += 4;
			}
		}
	}

	public function convert( target : PixelFormat ) {
		if( format == target || format.equals(target) )
			return;
		willChange();
		var bytes : hxd.impl.UncheckedBytes = bytes;
		switch( [format, target] ) {
		case [BGRA, ARGB], [ARGB, BGRA]:
			// reverse bytes
			for( i in 0...width*height ) {
				var p = (i << 2) + offset;
				var a = bytes[p];
				var r = bytes[p+1];
				var g = bytes[p+2];
				var b = bytes[p+3];
				bytes[p++] = b;
				bytes[p++] = g;
				bytes[p++] = r;
				bytes[p] = a;
			}
		case [BGRA, RGBA], [RGBA,BGRA]:
			for( i in 0...width*height ) {
				var p = (i << 2) + offset;
				var b = bytes[p];
				var r = bytes[p+2];
				bytes[p] = r;
				bytes[p+2] = b;
			}

		case [ARGB, RGBA]:
			for ( i in 0...width * height ) {
				var p = (i << 2) + offset;
				var a = bytes[p];
				bytes[p] = bytes[p+1];
				bytes[p+1] = bytes[p+2];
				bytes[p+2] = bytes[p+3];
				bytes[p+3] = a;
			}

		case [RGBA, ARGB]:
			for ( i in 0...width * height ) {
				var p = (i << 2) + offset;
				var a = bytes[p+3];
				bytes[p+3] = bytes[p+2];
				bytes[p+2] = bytes[p+1];
				bytes[p+1] = bytes[p];
				bytes[p] = a;
			}
		case [RGBA, R8]:
			var nbytes = haxe.io.Bytes.alloc(width * height);
			var out : hxd.impl.UncheckedBytes = nbytes;
			for( i in 0...width*height )
				out[i] = bytes[i << 2];
			this.bytes = nbytes;

		case [R32F, RGBA|BGRA]:
			var fbytes = this.bytes;
			var p = 0;
			for( i in 0...width*height ) {
				var v = Std.int(fbytes.getFloat(p)*255);
				if( v < 0 ) v = 0 else if( v > 255 ) v = 255;
				bytes[p++] = v;
				bytes[p++] = v;
				bytes[p++] = v;
				bytes[p++] = 0xFF;
			}

		case [R16U, R32F]:
			var nbytes = haxe.io.Bytes.alloc(width * height * 4);
			var fbytes = this.bytes;
			for( i in 0...width*height ) {
				var nv = fbytes.getUInt16(i << 1);
				nbytes.setFloat(i << 2, nv / 65535.0);
			}
			this.bytes = nbytes;

		case [RGBA32F, R32F]:
			var nbytes = haxe.io.Bytes.alloc(this.height * this.width * 4);
			var out : hxd.impl.UncheckedBytes = nbytes;
			for( i in 0 ... this.width * this.height )
				nbytes.setFloat(i << 2, this.bytes.getFloat(i << 4));
			this.bytes = nbytes;

		case [S3TC(a),S3TC(b)] if( a == b ):
			// nothing

		#if (hl && hl_ver >= "1.10")
		case [S3TC(ver),_]:
			if( (width|height)&3 != 0 ) throw "Texture size should be 4x4 multiple";
			var out = haxe.io.Bytes.alloc(width * height * 4);
			if( !hl.Format.decodeDXT((this.bytes:hl.Bytes).offset(this.offset), out, width, height, ver) )
				throw "Failed to decode DDS";
			offset = 0;
			this.bytes = out;
			innerFormat = RGBA;
			convert(target);
			return;
		#end

		default:
			throw "Cannot convert from " + format + " to " + target;
		}

		innerFormat = target;
	}

	public function getPixel(x, y) : Int {
		var p = ((x + yflip(y) * width) * bytesPerPixel) + offset;
		switch(format) {
		case BGRA:
			return bytes.getInt32(p);
		case RGBA:
			return switchBR(bytes.getInt32(p));
		case ARGB:
			return switchEndian(bytes.getInt32(p));
		default:
			invalidFormat();
			return 0;
		}
	}

	public function setPixel(x, y, color) : Void {
		var p = ((x + yflip(y) * width) * bytesPerPixel) + offset;
		willChange();
		switch(format) {
		case R8:
			bytes.set(p, color);
		case BGRA:
			bytes.setInt32(p, color);
		case RGBA:
			bytes.setInt32(p, switchBR(color));
		case ARGB:
			bytes.setInt32(p, switchEndian(color));
		default:
			invalidFormat();
		}
	}

	public function getPixelF(x, y, ?v:h3d.Vector) {
		if( v == null )
			v = new h3d.Vector();
		var p = ((x + yflip(y) * width) * bytesPerPixel) + offset;
		switch( format ) {
		case R32F:
			v.set(bytes.getFloat(p),0,0,0);
			return v;
		case RG32F:
			v.set(bytes.getFloat(p), bytes.getFloat(p+4),0,0);
			return v;
		case RGBA32F:
			v.set(bytes.getFloat(p), bytes.getFloat(p+4), bytes.getFloat(p+8), bytes.getFloat(p+12));
			return v;
		default:
			v.setColor(getPixel(x,y));
			return v;
		}
	}

	public function setPixelF(x, y, v:h3d.Vector) {
		willChange();
		var p = ((x + yflip(y) * width) * bytesPerPixel) + offset;
		switch( format ) {
		case R32F:
			bytes.setFloat(p, v.x);
		case RGBA32F:
			bytes.setFloat(p, v.x);
			bytes.setFloat(p + 4, v.y);
			bytes.setFloat(p + 8, v.z);
			bytes.setFloat(p + 12, v.w);
		default:
			setPixel(x,y,v.toColor());
		}
	}

	public function dispose() {
		bytes = null;
	}

	public function toString() {
		return 'Pixels(${width}x${height} ${format})';
	}

	public function toPNG( ?level = 9 ) {
		var png;
		setFlip(false);
		switch( format ) {
		case ARGB:
			png = std.format.png.Tools.build32ARGB(width, height, bytes #if (format >= "3.3") , level #end);
		default:
			convert(BGRA);
			png = std.format.png.Tools.build32BGRA(width, height, bytes #if (format >= "3.3") , level #end);
		}
		var o = new haxe.io.BytesOutput();
		new format.png.Writer(o).write(png);
		return o.getBytes();
	}

	public function toDDS() {
		return Pixels.toDDSLayers([this]);
	}

	public function clone() {
		var p = new Pixels(width, height, null, format);
		p.flags = flags;
		p.flags.unset(ReadOnly);
		if( bytes != null ) {
			p.bytes = haxe.io.Bytes.alloc(dataSize);
			p.bytes.blit(0, bytes, offset, dataSize);
		}
		return p;
	}

	public static function calcDataSize( width : Int, height : Int, format : PixelFormat ) {
		return switch( format ) {
		case S3TC(_):
			(((height + 3) >> 2) << 2) * calcStride(width, format);
		default:
			height * calcStride(width, format);
		}
	}

	public static function calcStride( width : Int, format : PixelFormat ) {
		return width * switch( format ) {
		case ARGB, BGRA, RGBA, SRGB, SRGB_ALPHA: 4;
		case RGBA16U, RGBA16F: 8;
		case RGBA32F: 16;
		case R8: 1;
		case R16U, R16F: 2;
		case R32F: 4;
		case RG8: 2;
		case RG16F: 4;
		case RG32F: 8;
		case RGB8: 3;
		case RGB16U, RGB16F: 6;
		case RGB32F: 12;
		case RGB10A2: 4;
		case RG11B10UF: 4;
		case S3TC(n):
			var blocks = (width + 3) >> 2;
			if( n == 1 || n == 4 )
				return blocks << 1;
			return blocks << 2;
		}
	}

	public static function isFloatFormat( format : PixelFormat ) {
		return switch( format ) {
		case R16F, RG16F, RGB16F, RGBA16F: true;
		case R32F, RG32F, RGB32F, RGBA32F: true;
		case S3TC(6): true;
		default: false;
		}
	}

	/**
		Returns the byte offset for the requested channel (0=R,1=G,2=B,3=A)
		Returns -1 if the channel is not found
	**/
	public static function getChannelOffset( format : PixelFormat, channel : Channel ) {
		return switch( format ) {
		case R8, R16F, R32F, R16U:
			if( channel == R ) 0 else -1;
		case RG8, RG16F, RG32F:
			var p = calcStride(1,format);
			[0, p, -1, -1][channel.toInt()];
		case RGB8, RGB16F, RGB32F, RGB16U:
			var p = calcStride(1,format);
			[0, p, p<<1, -1][channel.toInt()];
		case ARGB:
			[1, 2, 3, 0][channel.toInt()];
		case BGRA:
			[2, 1, 0, 3][channel.toInt()];
		case RGBA, SRGB, SRGB_ALPHA:
			channel.toInt();
		case RGBA16F, RGBA16U:
			channel.toInt() * 2;
		case RGBA32F:
			channel.toInt() * 4;
		case RGB10A2, RG11B10UF:
			throw "Bit packed format";
		case S3TC(_):
			throw "Not supported";
		}
	}

	public static function alloc( width, height, format : PixelFormat ) {
		return new Pixels(width, height, haxe.io.Bytes.alloc(calcDataSize(width, height, format)), format);
	}

	/**
		Build DDS texture bytes from an array of pixels :
		- can contain a single image
		- can contain multiple layers (set isCubeMap = true if it's a cubemap)
		- can contain single or multiple layers with mipmaps (auto detected with diffences in size)
	**/
	public static function toDDSLayers( pixels : Array<Pixels>, isCubeMap = false ) {
		if( pixels.length == 0 )
			throw "Must contain at least one image";
		var ref = pixels[0];
		var fmt = ref.format;
		var levels : Array<Array<Pixels>> = [];
		var outSize = 0;
		for( p in pixels ) {
			if( p.format != fmt ) throw "All images must be of the same pixel format";
			outSize += p.dataSize;
			var found = false;
			for( sz in levels ) {
				if( sz[0].width == p.width && sz[0].height == p.height ) {
					sz.push(p);
					found = true;
					break;
				}
			}
			if( !found )
				levels.push([p]);
		}
		levels.sort(function(a1,a2) return a2[0].width * a2[0].height - a1[0].width*a1[0].height);
		var layerCount = levels[0].length;
		var width = levels[0][0].width;
		var height = levels[0][0].height;
		for( i in 1...levels.length ) {
			var level = levels[i];
			if( level.length != layerCount ) throw 'Invalid number of mipmaps at level $i: ${level.length} should be $layerCount';
			var w = width >> i; if( w == 0 ) w = 1;
			var h = height >> i; if( h == 0 ) h = 1;
			var lw = level[0].width;
			var lh = level[0].height;
			if( lw != w || lh != h ) throw 'Invalid mip level size $i: ${lw}x${lh} should be ${w}x${h}';
		}

		outSize += 128; // header
		var ddsOut = haxe.io.Bytes.alloc(outSize);
		var outPos = 0;
		inline function write(v) { ddsOut.setInt32(outPos,v); outPos += 4; }
		write(0x20534444); // 'DDS '
		write(124);
		write(0x1 | 0x2 | 0x4 | 0x8 | 0x1000 | 0x20000);
		write(width);
		write(height);
		write(ref.stride);
		write(1);
		write(levels.length);
		for( i in 0...11 ) write(0);
		// pixel format
		write(32);

		switch( fmt ) {
		case ARGB, BGRA, RGBA:
			write( 0x1 | 0x40 );
			write(0); // FOURCC
			write(32);
			inline function writeMask(c) {
				var byte = getChannelOffset(fmt,c);
				write(0xFF << (byte*8));
			}
			writeMask(R);
			writeMask(G);
			writeMask(B);
			writeMask(A);
		default:
			var alpha = getChannelOffset(fmt, A) >= 0;
			write( 0x4 );
			write(switch( fmt ) {
			case R16F: 111;
			case RG16F: 112;
			case RGBA16F: 113;
			case R32F: 114;
			case RG32F: 115;
			case RGBA32F: 116;
			default: throw "Unsupported format "+fmt;
			});
			write(0);
			write(0);
			write(0);
			write(0);
			write(0);
		}

		//
		write((pixels.length == 1 ? 0 : 0x8) | 0x1000 | (levels.length == 1 ? 0 : 0x400000));
		var cubebits = 0x200 | 0x400 | (layerCount > 1 ? 0x800 : 0) | (layerCount > 2 ? 0x1000 : 0) | (layerCount > 3 ? 0x2000 : 0) | (layerCount > 4 ? 0x4000 : 0) | (layerCount > 5 ? 0x8000 : 0);
		write( isCubeMap ? cubebits : 0 );
		write(0);
		write(0);
		write(0);
		// add image data
		for( i in 0...layerCount )
			for( l in 0...levels.length ) {
				var p = levels[l][i];
				ddsOut.blit(outPos, p.bytes, p.offset, p.dataSize);
				outPos += p.dataSize;
			}
		return ddsOut;
	}

}
