package hxd;

@:enum abstract Direction(Int) {

	public var Up = 1;
	public var Left = 4;
	public var Right = 6;
	public var Down = 9;

	public var x(get, never) : Int;
	public var y(get, never) : Int;
	public var name(get, never) : String;

	inline function get_x() {
		return (this & 3) - 1;
	}

	inline function get_y() {
		return (this >> 2) - 1;
	}

	inline function get_name() {
		return VALUES[this];
	}

	static var VALUES = ["none", "up", null, null, "left", null, "right", null, null, "down"];
	inline function toString() {
		return name;
	}

	public static function from(x:Float, y:Float) : Direction {
		var ix = if( x < 0 ) -1 else if( x > 0 ) 1 else 0;
		var iy = if( y < 0 ) -1 else if( y > 0 ) 1 else 0;
		return cast ((ix + 1) | ((iy + 1) << 2));
	}
}
