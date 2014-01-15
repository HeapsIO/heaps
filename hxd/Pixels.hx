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
	
	public function setPixel( x : Int, y : Int, color : Int ) {
		switch( format ) {
		case BGRA:
			var addr = (x + y * width) << 2;
			bytes.set(addr++, color & 0xFF);
			bytes.set(addr++, (color>>8) & 0xFF);
			bytes.set(addr++, (color>>16) & 0xFF);
			bytes.set(addr++, color >>> 24);
		case ARGB:
			var addr = (x + y * width) << 2;
			bytes.set(addr++, color >>> 24);
			bytes.set(addr++, (color>>16) & 0xFF);
			bytes.set(addr++, (color>>8) & 0xFF);
			bytes.set(addr++, color & 0xFF);
		case RGBA:
			var addr = (x + y * width) << 2;
			bytes.set(addr++, (color>>16) & 0xFF);
			bytes.set(addr++, (color>>8) & 0xFF);
			bytes.set(addr++, color & 0xFF);
			bytes.set(addr++, color >>> 24);
		}
	}

	public function getPixel( x : Int, y : Int ) {
		var r, g, b, a;
		switch( format ) {
		case BGRA:
			var addr = (x + y * width) << 2;
			b = bytes.get(addr++);
			g = bytes.get(addr++);
			r = bytes.get(addr++);
			a = bytes.get(addr++);
		case ARGB:
			var addr = (x + y * width) << 2;
			a = bytes.get(addr++);
			r = bytes.get(addr++);
			g = bytes.get(addr++);
			b = bytes.get(addr++);
		case RGBA:
			var addr = (x + y * width) << 2;
			r = bytes.get(addr++);
			g = bytes.get(addr++);
			b = bytes.get(addr++);
			a = bytes.get(addr++);
		}
		return (a << 24) | (r << 16) | (g << 8) | b;
	}

	public function makeSquare( ?copy : Bool ) {
		var w = width, h = height;
		var tw = w == 0 ? 0 : 1, th = h == 0 ? 0 : 1;
		while( tw < w ) tw <<= 1;
		while( th < h ) th <<= 1;
		if( w == tw && h == th ) return this;
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
		if( copy )
			return new Pixels(tw, th, out, format);
		hxd.impl.Tmp.saveBytes(bytes);
		bytes = out;
		width = tw;
		height = th;
		return this;
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
			
		case [ARGB, RGBA]: {
			var mem = hxd.impl.Memory.select(bytes);
			for ( i in 0...width * height ) {
				var p = i << 2;
				var a = (mem.b(p));
				
				mem.wb(p, mem.b(p + 1));
				mem.wb(p + 1, mem.b(p + 2));
				mem.wb(p + 2, mem.b(p + 3));
				mem.wb(p+3, a);
			}
			mem.end();
		}
		
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
	
	public static function alloc( width, height, ?format : PixelFormat ) {
		if( format == null ) format = RGBA;
		return new Pixels(width, height, hxd.impl.Tmp.getBytes(width * height * bytesPerPixel(format)), format);
	}
	
}
