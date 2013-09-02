package hxd.clipper;

class Point {
	public var x : Int;
	public var y : Int;
	public inline function new(x=0, y=0) {
		this.x = x;
		this.y = y;
	}
	public inline function clone() {
		return new Point(x, y);
	}
	function toString() {
		return "{" + x + "," + y + "}";
	}
}