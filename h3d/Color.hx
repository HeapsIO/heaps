package h3d;
import h3d.impl.Tools;

class Color {

	public var r : Float;
	public var g : Float;
	public var b : Float;
	public var a : Float;

	public function new(r=0.,g=0.,b=0.,a=1.) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	public function loadInt( rgb : Int, alpha = 1.0 ) {
		r = ((rgb>>16)&0xFF)/255.0;
		g = ((rgb>>8)&0xFF)/255.0;
		b = (rgb&0xFF)/255.0;
		a = alpha;
	}

	public function toInt() {
		var r = Std.int(r*255);
		var g = Std.int(g*255);
		var b = Std.int(b*255);
		var a = Std.int(a*255);
		if( r < 0 ) r = 0 else if( r > 255 ) r = 255;
		if( g < 0 ) g = 0 else if( g > 255 ) g = 255;
		if( b < 0 ) b = 0 else if( b > 255 ) b = 255;
		if( a < 0 ) a = 0 else if( a > 255 ) a = 255;
		return (a << 24) | (r << 16) | (g << 8) | b;
	}
	
	public function toVector() {
		return new Vector(r, g, b, a);
	}

	public inline function clone() {
		return new Color(r,g,b,a);
	}

	public function toString() {
		return "{"+Tools.f(r)+","+Tools.f(g)+","+Tools.f(b)+","+Tools.f(a)+"}";
	}

	public static function fromInt( rgb : Int, alpha = 1.0 ) {
		return new Color(((rgb>>16)&0xFF)/255.0,((rgb>>8)&0xFF)/255.0,(rgb&0xFF)/255.0,alpha);
	}

}