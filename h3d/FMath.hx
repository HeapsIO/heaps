package h3d;

class FMath {
	
	public static inline var EPSILON = 1e-10;

	// round to 4 significant digits, eliminates <1e-10
	public static function fmt( v : Float ) {
		var neg;
		if( v < 0 ) {
			neg = -1.0;
			v = -v;
		} else
			neg = 1.0;
		if( Math.isNaN(v) )
			return v;
		var digits = Std.int(4 - Math.log(v) / Math.log(10));
		if( digits < 1 )
			digits = 1;
		else if( digits >= 10 )
			return 0.;
		var exp = Math.pow(10,digits);
		return Math.floor(v * exp + .49999) * neg / exp;
	}
	
	public static inline function clamp( f : Float, min = 0., max = 1. ) {
		return f < min ? min : f > max ? max : f;
	}
	
	public static inline function cos( f : Float ) {
		return Math.cos(f);
	}

	public static inline function sin( f : Float ) {
		return Math.sin(f);
	}
	
	public static inline function sqrt( f : Float ) {
		return Math.sqrt(f);
	}

	public static inline function isqrt( f : Float ) {
		return 1. / sqrt(f);
	}
	
	public static inline function atan2( dy : Float, dx : Float ) {
		return Math.atan2(dy,dx);
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
	
}