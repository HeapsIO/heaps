package hxd;

@:enum abstract Direction(Int) {

	public var Up = 1;
	public var Left = 4;
	public var Right = 6;
	public var Down = 9;

	public var x(get, never) : Int;
	public var y(get, never) : Int;
	public var angle(get, never) : Float;
	public var name(get, never) : String;

	inline function new(v) {
		this = v;
	}

	inline function get_x() {
		return (this & 3) - 1;
	}

	inline function get_y() {
		return (this >> 2) - 1;
	}

	inline function get_name() {
		return VALUES[this];
	}

	inline function get_angle() {
		return Math.atan2(y, x);
	}

	public inline function inverse() {
		return INVERT[this];
	}

	static var VALUES = ["none", "up", null, null, "left", null, "right", null, null, "down"];
	static var INVERT = [ffrom(1, 1), Down, ffrom(1, -1), ffrom(0, 0), Right, ffrom(0, 0), Left, ffrom(0, 0), ffrom( -1, 1), Up, ffrom( -1, -1), ffrom(0, 0)];
	inline function toString() {
		return name;
	}

	public static inline function ffrom(dx:Int, dy:Int) {
		return new Direction((dx + 1) | ((dy + 1) << 2));
	}

	public static function from(x:Float, y:Float) : Direction {
		if( x != 0 && y != 0 ) {
			if( Math.abs(x) > Math.abs(y) )
				y = 0;
			else
				x = 0;
		}
		var ix = if( x < 0 ) -1 else if( x > 0 ) 1 else 0;
		var iy = if( y < 0 ) -1 else if( y > 0 ) 1 else 0;
		return cast ((ix + 1) | ((iy + 1) << 2));
	}
}
