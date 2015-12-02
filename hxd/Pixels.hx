package hxd;

enum Flags {
	ReadOnly;
	AlphaPremultiplied;
	FlipY;
}

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

	function set_format(fmt) {
		this.format = fmt;
		bpp = bytesPerPixel(fmt);
		return fmt;
	}

	function invalidFormat() {
		throw "Unsupported format for this operation : " + format;
	}

	public function clear( color : Int ) {
		var a, b, c, d;
		switch( format ) {
		case RGBA:
			a = color >> 16;
			b = color >> 8;
			c = color;
			d = color >>> 24;
		case ARGB:
			a = color >>> 24;
			b = color >> 16;
			c = color >> 8;
			d = color;
		case BGRA:
			a = color;
			b = color >> 8;
			c = color >> 16;
			d = color >>> 24;
		default:
			invalidFormat();
			a = b = c = d = 0;
		}
		a &= 0xFF;
		b &= 0xFF;
		c &= 0xFF;
		d &= 0xFF;
		var p = 0;
		for( i in 0...width * height ) {
			bytes.set(p++, a);
			bytes.set(p++, b);
			bytes.set(p++, c);
			bytes.set(p++, d);
		}
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
			for( i in 0...(tw - w) * 4 )
				out.set(p++, 0);
		}
		for( i in 0...(th - h) * tw * 4 )
			out.set(p++, 0);
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
			for( x in 0...stride ) {
				var a = bytes.get(p1);
				var b = bytes.get(p2);
				bytes.set(p1++, b);
				bytes.set(p2++, a);
			}
		}
	}

	@:noDebug
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
			return bytes.get(p) | (bytes.get( p+1 )<<8) | (bytes.get( p+2 )<<16) | (bytes.get( p+3 )<<24);
		case RGBA:
			return (bytes.get(p)<<16) | (bytes.get( p+1 )<<8) | bytes.get( p+2 ) | (bytes.get( p+3 )<<24);
		case ARGB:
			return (bytes.get(p) << 24) | (bytes.get( p + 1 ) << 16) | (bytes.get( p + 2 ) << 8) | bytes.get( p + 3 );
		default:
			invalidFormat();
			return 0;
		}
	}

	public function setPixel(x, y, color) : Void {
		if( flags.has(FlipY) ) y = height - 1 - y;
		var p = ((x + y * width) * bpp) + offset;
		var a = color >>> 24;
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
		switch(format) {
		case BGRA:
			bytes.set(p++, b);
			bytes.set(p++, g);
			bytes.set(p++, r);
			bytes.set(p++, a);
		case RGBA:
			bytes.set(p++, r);
			bytes.set(p++, g);
			bytes.set(p++, b);
			bytes.set(p++, a);
		case ARGB:
			bytes.set(p++, a);
			bytes.set(p++, r);
			bytes.set(p++, g);
			bytes.set(p++, b);
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
