package h3d;
#if macro
import haxe.macro.Context;
#end

class Tween {

	public static inline var PI = 3.14159265;

	public static inline function lerp( v1 : Float, v2 : Float, k : Float ) {
		return v1 * (1 - k) + v2 * k;
	}
	
	public static macro function moveTo( cur, target, speed : haxe.macro.Expr.ExprOf<Float> ) {
		var t = Context.typeof(cur);
		switch( t ) {
		default:
			// assume 3D
			return macro {
				var _max = $speed;
				var _cur = $cur;
				var _dst = $target;
				var dx = _dst.x - _cur.x;
				var dy = _dst.y - _cur.y;
				var dz = _dst.z - _cur.z;
				var d = dx * dx + dy * dy + dz * dz;
				if( d < _max * _max ) {
					_cur.x = _dst.x;
					_cur.y = _dst.y;
					_cur.z = _dst.z;
					true;
				} else {
					d = _max / Math.sqrt(d);
					_cur.x += dx * d;
					_cur.y += dy * d;
					_cur.z += dz * d;
					false;
				}
			}
		}
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
	
	public static inline function angleDist( da : Float ) {
		da %= PI * 2;
		if( da > PI ) da -= 2 * PI else if( da <= -PI ) da += 2 * PI;
		return da;
	}

	public static function angleLerpPow( a1 : Float, a2 : Float, k : Float ) {
		return a1 + angleDist(a2 - a1) * k;
	}

	public static function angleLerp( a1 : Float, a2 : Float, max : Float ) {
		var da = (a2 - a1) % (PI * 2);
		if( da > PI ) da -= 2 * PI else if( da <= -PI ) da += 2 * PI;
		return if( da > -max && da < max ) a2 else a1 + (da < 0 ? -max : max);
	}
	
	public inline static function clamp( v : Float, min : Float, max : Float ) {
		return v < min ? min : v > max ? max : v;
	}
	
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
	
}