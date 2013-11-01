package hxd;

class Pixels {
	public var bytes : haxe.io.Bytes;
	public var format : PixelFormat;
	public var width : Int;
	public var height : Int;
	
	public function new(width, height, bytes, format) {
		this.width = width;
		this.height = height;
		this.bytes = bytes;
		this.format = format;
	}
		
	public function makeSquare() {
		var w = width, h = height;
		var tw = w == 0 ? 0 : 1, th = h == 0 ? 0 : 1;
		while( tw < w ) tw <<= 1;
		while( th < h ) th <<= 1;
		if( w == tw && h == th ) return;
		var out = hxd.impl.Tmp.getBytes(tw * th * 4);
		var p = 0, b = 0;
		for( y in 0...h ) {
			out.blit(p, bytes, b, w * 4);
			p += w * 4;
			b += w * 4;
			for( i in 0...(tw - w) * 4 )
				out.set(p++, 0);
		}
		for( i in 0...(th - h) * tw * 4 )
			out.set(p++, 0);
		hxd.impl.Tmp.saveBytes(bytes);
		bytes = out;
		width = tw;
		height = th;
	}
	
	public function convert( target : PixelFormat ) {
		if( format == target )
			return;
		switch( [format, target] ) {
		case [BGRA, ARGB], [ARGB, BGRA]:
			// reverse bytes
			var mem = hxd.impl.Memory.select(bytes);
			for( i in 0...width*height ) {
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
		case [BGRA, RGBA]:
			var mem = hxd.impl.Memory.select(bytes);
			for( i in 0...width*height ) {
				var p = i << 2;
				var b = mem.b(p);
				var r = mem.b(p+2);
				mem.wb(p, r);
				mem.wb(p+2, b);
			}
			mem.end();
		default:
			throw "Cannot convert from " + format + " to " + target;
		}
		format = target;
	}
	
	public function dispose() {
		if( bytes != null ) {
			hxd.impl.Tmp.saveBytes(bytes);
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