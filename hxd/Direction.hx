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

	public static function from(x, y) {
		if( x < 0 ) x = -1;
		if( x > 0 ) x = 1;
		if( y < 0 ) y = -1;
		if( y > 0 ) y = 1;
		return (x + 1) | ((y + 1) << 2);
	}
}
