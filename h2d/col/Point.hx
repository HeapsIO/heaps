package h2d.col;

class Point {
	
	public var x : Float;
	public var y : Float;
	
	public inline function new(x = 0., y = 0.) {
		this.x = x;
		this.y = y;
	}
	
	public function toString() {
		return "{" + h3d.FMath.fmt(x) + "," + h3d.FMath.fmt(y) + "}";
	}
	
}