package hxd;

enum Flags {
	ReadOnly;
	AlphaPremultiplied;
	FlipY;
}

@:forward(bytes, width, height, offset, flags, clear, dispose, toPNG, clone, toVector)
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

@:noDebug
class Pixels {
	public var bytes : haxe.io.Bytes;
	public var format(default,set) : PixelFormat;
	public var width : Int;
	public var height : Int;
	public var offset : Int;
	public var flags: haxe.EnumFlags<Flags>;
	var bpp : Int;

	public function new(width : Int, height : Int, bytes : haxe.io.Bytes, format : hxd.PixelFormat, offset = 0) {
		this.width = width;
		this.height = height;
		this.bytes = bytes;
		this.format = format;
		this.offset = offset;
	}

	public static inline function switchEndian(v) {
		return (v >>> 24) | ((v >> 8) & 0xFF00) | ((v << 8) & 0xFF0000) | (v << 24);
	}

	public static inline function switchBR(v) {
		return (v & 0xFF00FF00) | ((v << 16) & 0xFF0000) | ((v >> 16) & 0xFF);
	}

	function set_format(fmt) {
		this.format = fmt;
		bpp = bytesPerPixel(fmt);
		return fmt;
	}

	function invalidFormat() {
		throw "Unsupported format for this operation : " + format;
	}

	public function clear( color : Int ) {
		if( color == 0 ) {
			bytes.fill(offset, width * height * bytesPerPixel(format), 0);
			return;
		}
		switch( format ) {
		case BGRA:
		case RGBA:
			color = switchBR(color);
		case ARGB:
			color = switchEndian(color);
		default:
			invalidFormat();
		}
		var p = offset;
		for( i in 0...width * height ) {
			bytes.setInt32(p, color);
			p += 4;
		}
	}

	public function toVector() : haxe.ds.Vector<Int> {
		var vec = new haxe.ds.Vector<Int>(width * height);
		var idx = 0;
		var p = offset;
		var dl = 0;
		var bpp = bytesPerPixel(format);
		if( flags.has(FlipY) ) {
			p += ((height - 1) * width) * bpp;
			dl = -width * 2 * bpp;
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
		var out = hxd.impl.Tmp.getBytes(tw * th * 4);
		var p = 0, b = offset;
		for( y in 0...h ) {
			out.blit(p, bytes, b, w * 4);
			p += w * 4;
			b += w * 4;
			for( i in 0...tw - w ) {
				out.setInt32(p, 0);
				p += 4;
			}
		}
		for( i in 0...(th - h) * tw ) {
			out.setInt32(p, 0);
			p += 4;
		}
		if( copy )
			return new Pixels(tw, th, out, format);
		if( !flags.has(ReadOnly) ) hxd.impl.Tmp.saveBytes(bytes);
		bytes = out;
		width = tw;
		height = th;
		return this;
	}

	function copyInner() {
		var old = bytes;
		bytes = hxd.impl.Tmp.getBytes(width * height * 4);
		bytes.blit(0, old, offset, width * height * 4);
		offset = 0;
		flags.unset(ReadOnly);
	}

	public function setFlip( b : Bool ) {
		#if js if( b == null ) b = false; #end
		if( flags.has(FlipY) == b ) return;
		if( flags.has(ReadOnly) ) copyInner();
		if( b ) flags.set(FlipY) else flags.unset(FlipY);
		var stride = width * bpp;
		for( y in 0...height >> 1 ) {
			var p1 = y * stride;
			var p2 = (height - 1 - y) * stride;
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
		if( format == target )
			return;
		if( flags.has(ReadOnly) )
			copyInner();
		switch( [format, target] ) {
		case [BGRA, ARGB], [ARGB, BGRA]:
			// reverse bytes
			var mem = hxd.impl.Memory.select(bytes);
			for( i in 0...width*height ) {
				var p = (i << 2) + offset;
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
		case [BGRA, RGBA], [RGBA,BGRA]:
			var mem = hxd.impl.Memory.select(bytes);
			for( i in 0...width*height ) {
				var p = (i << 2) + offset;
				var b = mem.b(p);
				var r = mem.b(p+2);
				mem.wb(p, r);
				mem.wb(p+2, b);
			}
			mem.end();

		case [ARGB, RGBA]: {
			var mem = hxd.impl.Memory.select(bytes);
			for ( i in 0...width * height ) {
				var p = (i << 2) + offset;
				var a = (mem.b(p));

				mem.wb(p, mem.b(p + 1));
				mem.wb(p + 1, mem.b(p + 2));
				mem.wb(p + 2, mem.b(p + 3));
				mem.wb(p + 3, a);
			}
			mem.end();
		}

		default:
			throw "Cannot convert from " + format + " to " + target;
		}
		format = target;
	}

	public function getPixel(x, y) : Int {
		if( flags.has(FlipY) ) y = height - 1 - y;
		var p = ((x + y * width) * bpp) + offset;
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
		if( flags.has(FlipY) ) y = height - 1 - y;
		var p = ((x + y * width) * bpp) + offset;
		switch(format) {
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

	public function dispose() {
		if( bytes != null ) {
			if( !flags.has(ReadOnly) ) hxd.impl.Tmp.saveBytes(bytes);
			bytes = null;
		}
	}

	public function toPNG() {
		var png;
		switch( format ) {
		case ARGB:
			png = std.format.png.Tools.build32ARGB(width, height, bytes);
		default:
			convert(BGRA);
			png = std.format.png.Tools.build32BGRA(width, height, bytes);
		}
		var o = new haxe.io.BytesOutput();
		new format.png.Writer(o).write(png);
		return o.getBytes();
	}

	public function clone() {
		var p = new Pixels(width, height, null, format);
		p.flags = flags;
		p.flags.unset(ReadOnly);
		if( bytes != null ) {
			var size = width * height * bytesPerPixel(format);
			p.bytes = hxd.impl.Tmp.getBytes(size);
			p.bytes.blit(0, bytes, offset, size);
		}
		return p;
	}

	public static function bytesPerPixel( format : PixelFormat ) {
		return switch( format ) {
		case ARGB, BGRA, RGBA: 4;
		case RGBA16F: 8;
		case RGBA32F: 16;
		}
	}

	public static function alloc( width, height, format : PixelFormat ) {
		return new Pixels(width, height, hxd.impl.Tmp.getBytes(width * height * bytesPerPixel(format)), format);
	}

}
