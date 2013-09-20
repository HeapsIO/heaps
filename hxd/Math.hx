package hxd;

class Math {
	
	public static inline var PI = 3.14159265358979323;
	public static inline var EPSILON = 1e-10;

	public static var POSITIVE_INFINITY(get, never) : Float;
	public static var NEGATIVE_INFINITY(get, never) : Float;
	
	static inline function get_POSITIVE_INFINITY() {
		return std.Math.POSITIVE_INFINITY;
	}

	static inline function get_NEGATIVE_INFINITY() {
		return std.Math.NEGATIVE_INFINITY;
	}
	
	// round to 4 significant digits, eliminates < 1e-10
	public static function fmt( v : Float ) {
		var neg;
		if( v < 0 ) {
			neg = -1.0;
			v = -v;
		} else
			neg = 1.0;
		if( std.Math.isNaN(v) )
			return v;
		var digits = Std.int(4 - std.Math.log(v) / std.Math.log(10));
		if( digits < 1 )
			digits = 1;
		else if( digits >= 10 )
			return 0.;
		var exp = pow(10,digits);
		return floor(v * exp + .49999) * neg / exp;
	}
	
	public static inline function floor( f : Float ) {
		return std.Math.floor(f);
	}

	public static inline function ceil( f : Float ) {
		return std.Math.ceil(f);
	}

	public static inline function round( f : Float ) {
		return std.Math.round(f);
	}
	
	public static inline function clamp( f : Float, min = 0., max = 1. ) {
		return f < min ? min : f > max ? max : f;
	}

	public static inline function pow( v : Float, p : Float ) {
		return std.Math.pow(v,p);
	}
	
	public static inline function cos( f : Float ) {
		return std.Math.cos(f);
	}

	public static inline function sin( f : Float ) {
		return std.Math.sin(f);
	}

	public static inline function tan( f : Float ) {
		return std.Math.tan(f);
	}

	public static inline function acos( f : Float ) {
		return std.Math.acos(f);
	}

	public static inline function asin( f : Float ) {
		return std.Math.asin(f);
	}

	public static inline function atan( f : Float ) {
		return std.Math.atan(f);
	}
	
	public static inline function sqrt( f : Float ) {
		return std.Math.sqrt(f);
	}

	public static inline function invSqrt( f : Float ) {
		return 1. / sqrt(f);
	}
	
	public static inline function atan2( dy : Float, dx : Float ) {
		return std.Math.atan2(dy,dx);
	}
	
	public static inline function abs( f : Float ) {
		return f < 0 ? -f : f;
	}

	public static inline function max( a : Float, b : Float ) {
		return a < b ? b : a;
	}

	public static inline function min( a : Float, b : Float ) {
		return a > b ? b : a;
	}
	
	public static inline function iabs( i : Int ) {
		return i < 0 ? -i : i;
	}

	public static inline function imax( a : Int, b : Int ) {
		return a < b ? b : a;
	}

	public static inline function imin( a : Int, b : Int ) {
		return a > b ? b : a;
	}

	public static inline function iclamp( v : Int, min : Int, max : Int ) {
		return v < min ? min : (v > max ? max : v);
	}

	/**
		Linear interpolation between two values. When k is 0 a is returned, when it's 1, b is returned.
	**/
	public inline static function lerp(a:Float, b:Float, k:Float) {
		return a * (1 - k) + b * k;
	}
	
	public inline static function bitCount(v:Int) {
		var k = 0;
		while( v != 0 ) {
			k += v & 1;
			v >>>= 1;
		}
		return k;
	}
	
	public static inline function distanceSq( dx : Float, dy : Float, dz = 0. ) {
		return dx * dx + dy * dy + dz * dz;
	}
	
	public static inline function distance( dx : Float, dy : Float, dz = 0. ) {
		return sqrt(distanceSq(dx,dy,dz));
	}
	
	/**
		Linear interpolation between two colors (ARGB).
	**/
	public static function colorLerp( c1 : Int, c2 : Int, k : Float ) {
		var a1 = c1 >>> 24;
		var r1 = (c1 >> 16) & 0xFF;
		var g1 = (c1 >> 8) & 0xFF;
		var b1 = c1 & 0xFF;
		var a2 = c2 >>> 24;
		var r2 = (c2 >> 16) & 0xFF;
		var g2 = (c2 >> 8) & 0xFF;
		var b2 = c2 & 0xFF;
		var a = Std.int(a1 * (1-k) + a2 * k);
		var r = Std.int(r1 * (1-k) + r2 * k);
		var g = Std.int(g1 * (1-k) + g2 * k);
		var b = Std.int(b1 * (1 - k) + b2 * k);
		return (a << 24) | (r << 16) | (g << 8) | b;
	}
	
	/*
		Clamp an angle into the [-PI,+PI[ range. Can be used to measure the direction between two angles : if Math.angle(A-B) < 0 go left else go right.
	*/
	public static inline function angle( da : Float ) {
		da %= PI * 2;
		if( da > PI ) da -= 2 * PI else if( da <= -PI ) da += 2 * PI;
		return da;
	}
	
	/**
		Move a towards b with a max increment. Return the new angle.
	**/
	public static inline function angleMove( a : Float, b : Float, max : Float ) {
		var da = (b - a) % (PI * 2);
		if( da > PI ) da -= 2 * PI else if( da <= -PI ) da += 2 * PI;
		return if( da > -max && da < max ) b else a + (da < 0 ? -max : max);
	}
	
}