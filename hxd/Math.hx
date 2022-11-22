package hxd;

class Math {

	public static inline var PI = 3.14159265358979323;
	public static inline var EPSILON = 1e-10;

	public static var POSITIVE_INFINITY(get, never) : Float;
	public static var NEGATIVE_INFINITY(get, never) : Float;
	public static var NaN(get, never) : Float;

	static inline function get_POSITIVE_INFINITY() {
		return std.Math.POSITIVE_INFINITY;
	}

	static inline function get_NEGATIVE_INFINITY() {
		return std.Math.NEGATIVE_INFINITY;
	}

	static inline function get_NaN() {
		return std.Math.NaN;
	}

	public static inline function isNaN(v:Float) {
		return std.Math.isNaN(v);
	}

	// round to 4 significant digits, eliminates < 1e-10
	public static function fmt( v : Float ) {
		var neg;
		if( v < 0 ) {
			neg = -1.0;
			v = -v;
		} else
			neg = 1.0;
		if( std.Math.isNaN(v) || !std.Math.isFinite(v) )
			return v;
		var digits = Std.int(4 - std.Math.log(v) / std.Math.log(10));
		if( digits < 1 )
			digits = 1;
		else if( digits >= 10 )
			return 0.;
		var exp = pow(10,digits);
		return std.Math.ffloor(v * exp + .49999) * neg / exp;
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
		return a + k * (b - a);
	}

	/**
	 	Similar to linear interpolation (k is between [0,1]), but can be controled with easing parameter. When easing is 0 it's linear.
	**/
	public inline static function ease(a:Float, b:Float, k:Float, easing:Float) {
		return lerp(a, b, easeFactor(k, easing));
	}

	/**
		ease = lerp(a,b,easeFactor(k,easing))
	**/
	public inline static function easeFactor( k : Float, easing : Float ) {
		var p = Math.pow(k, 1 + easing);
		return p / (p + Math.pow(1 - k, easing + 1));
	}

	/**
		Same as lerp but is scaled based on current FPS, using current elapsed time in seconds.
	**/
	public inline static function lerpTime(a:Float, b:Float, k:Float, dt:Float) {
		return lerp(a, b, 1 - Math.pow(1 - k, dt * hxd.Timer.wantedFPS));
	}

	public inline static function bitCount(v:Int) {
		v = v - ((v >> 1) & 0x55555555);
		v = (v & 0x33333333) + ((v >> 2) & 0x33333333);
		return (((v + (v >> 4)) & 0x0F0F0F0F) * 0x01010101) >> 24;
	}

	public static inline function isPOT(v : Int) : Bool {
		return (v & (v - 1)) == 0;
	}

	public static inline function nextPOT(v : Int) : Int {
		--v;
		v |= v >> 1;
		v |= v >> 2;
		v |= v >> 4;
		v |= v >> 8;
		v |= v >> 16;
		return ++v;
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

	public static inline function angleLerp( a : Float, b : Float, k : Float ) {
		return a + angle(b - a) * k;
	}

	/**
		Move angle a towards angle b with a max increment. Return the new angle.
	**/
	public static inline function angleMove( a : Float, b : Float, max : Float ) {
		var da = angle(b - a);
		return if( da > -max && da < max ) b else a + (da < 0 ? -max : max);
	}

	/**
		Move a value towards the given target using the max increment. Return the new value.
	**/
	public static inline function valueMove( v : Float, target : Float, max : Float ) {
		if( v < target ) {
			v += max;
			if( v > target ) v = target;
		} else if( v > target ) {
			v -= max;
			if( v < target ) v = target;
		}
		return v;
	}

	public static inline function shuffle<T>( a : Array<T> ) {
		var len = a.length;
		for( i in 0...len ) {
			var x = Std.random(len);
			var y = Std.random(len);
			var tmp = a[x];
			a[x] = a[y];
			a[y] = tmp;
		}
	}

	public inline static function random( max = 1.0 ) {
		return std.Math.random() * max;
	}

	/**
		Returns a signed random between -max and max (both included).
	**/
	public static function srand( max = 1.0 ) {
		return (std.Math.random() - 0.5) * (max * 2);
	}


	/**
	 * takes an int , masks it and devide so that it safely maps 0...255 to 0...1.0
	 * @paramv an int between 0 and 255 will be masked
	 * @return a float between( 0 and 1)
	 */
	public static inline function b2f( v:Int ) :Float {
		return (v&0xFF) * 0.0039215686274509803921568627451;
	}

	/**
	 * takes a float , clamps it and multipy so that it safely maps 0...1 to 0...255.0
	 * @param	f a float
	 * @return an int [0...255]
	 */
	public static inline function f2b( v:Float ) : Int {
		return Std.int(clamp(v) * 255.0);
	}

	/**
	 * returns the modulo but always positive
	 */
	public static inline function umod( value : Int, modulo : Int ) {
		var r = value % modulo;
		return r >= 0 ? r : r + modulo;
	}

	/**
	 * returns the modulo but always positive
	 */
	public static inline function ufmod( value : Float, modulo : Float ) {
		var r = value % modulo;
		return r >= 0 ? r : r + modulo;
	}

	/**
	 * Convert degrees to radians
	**/
	public static inline function degToRad( deg : Float) {
		return deg * PI / 180.0;
	}

	/**
	 * Convert radians to degrees
	 */
	public static inline function radToDeg( rad : Float) {
		return rad * 180.0 / PI;
	}
}