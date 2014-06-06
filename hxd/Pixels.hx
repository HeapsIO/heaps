package hxd;

enum Flags {
	ReadOnly;
	AlphaPremultiplied;
}

class Pixels {
	public var bytes : haxe.io.Bytes;
	public var format : PixelFormat;
	public var width : Int;
	public var height : Int;
	public var offset : Int;
	public var flags: haxe.EnumFlags<Flags>;
	
	public function new(width : Int, height : Int, bytes : haxe.io.Bytes, format : hxd.PixelFormat, offset = 0) {
		this.width = width;
		this.height = height;
		this.bytes = bytes;
		this.format = format;
		this.offset = offset;
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
		case [BGRA, RGBA]:
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
		var p = 4 * (y * width + x) + offset;
		switch(format) {
		case BGRA:
			var u = 0;
			u |= bytes.get( p	);
			u |= bytes.get( p+1 )<<8;
			u |= bytes.get( p+2 )<<16;
			u |= bytes.get( p+3 )<<24;
			return u;
		case RGBA:
			var u = 0;
			u |= bytes.get( p	)<<16;
			u |= bytes.get( p+1 )<<8;
			u |= bytes.get( p+2 );
			u |= bytes.get( p+3 )<<24;
			return u;
		case ARGB:
			var u = 0;
			u |= bytes.get( p	)<<24;
			u |= bytes.get( p+1 )<<16;
			u |= bytes.get( p+2 )<<8;
			u |= bytes.get( p+3 );
			return u;
		}		
	}
	
	public function dispose() {
		if( bytes != null ) {
			if( !flags.has(ReadOnly) ) hxd.impl.Tmp.saveBytes(bytes);
			bytes = null;
		}
	}
	
	public static function bytesPerPixel( format : PixelFormat ) {
		return switch( format ) {
		case ARGB, BGRA, RGBA: 4;
		}
	}
	
	public static function alloc( width, height, format ) {
		return new Pixels(width, height, hxd.impl.Tmp.getBytes(width * height * bytesPerPixel(format)), format);
	}
	
}
