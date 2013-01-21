package h3d;

class Tween {

	public static inline var PI = 3.14159265;

	public static inline function lerp( v1 : Float, v2 : Float, k : Float ) {
		return v1 * (1 - k) + v2 * k;
	}
	
	public static inline function moveTo( v1 : Float, v2 : Float, max : Float ) {
		var d = v2 - v1;
		return if( d > -max && d < max ) v2 else v1 + (d < 0 ? -max : max);
	}
	
	public static inline function powTo( v1 : Float, v2 : Float, p : Float, min = 0.1 ) {
		var d = v2 - v1;
		return if( d > -min && d < min ) v2 else v1 + d * p;
	}
	
	public static inline function squareDist( dx : Float, dy : Float, dz = 0. ) {
		return dx * dx + dy * dy + dz * dz;
	}
	
	public static inline function dist( dx : Float, dy : Float, dz = 0. ) {
		return Math.sqrt(dx * dx + dy * dy + dz * dz);
	}

	public static function angleLerpPow( a1 : Float, a2 : Float, k : Float ) {
		var da = (a2 - a1) % (PI * 2);
		if( da > PI ) da -= 2 * PI else if( da <= -PI ) da += 2 * PI;
		return a1 + da * k;
	}

	public static function angleLerp( a1 : Float, a2 : Float, max : Float ) {
		var da = (a2 - a1) % (PI * 2);
		if( da > PI ) da -= 2 * PI else if( da <= -PI ) da += 2 * PI;
		return if( da > -max && da < max ) a2 else a1 + (da < 0 ? -max : max);
	}
	
}