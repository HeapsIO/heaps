package h2d.col;
/**
	A simple triangle collider.
**/
class Triangle implements Collider {

	static inline var UNDEF = 1.1315e-17;

	/**
		The triangle first corner.
	**/
	public var a : Point;
	/**
		The triangle second corner.
	**/
	public var b : Point;
	/**
		The triangle third corner.
	**/
	public var c : Point;
	var area : Float;
	var invArea : Float;

	/**
		Create a new Triangle collider.
		@param a The first triangle corner.
		@param b The second triangle corner.
		@param c The third triangle corner.
	**/
	public inline function new( a : Point, b : Point, c : Point ) {
		this.a = a;
		this.b = b;
		this.c = c;
		area = UNDEF;
	}

	/**
		Returns a centroid of the Triangle.
	**/
	public inline function getCenter() {
		return new Point((a.x + b.x + c.x) / 3, (a.y + b.y + c.y) / 3);
	}

	/**
		Calculates and returns the triangle area.

		Result is cached between `getArea` and `getInvArea` on first call and altering `a`, `b`, or `c` afterwards will lead to incorrect value.
	**/
	public inline function getArea() {
		if( area == UNDEF ) {
			area = ((a.y * b.x - a.x * b.y) + (b.y * c.x - b.x * c.y) + (c.y * a.x - c.x * a.y)) * -0.5;
			invArea = 1 / area;
		}
		return area;
	}

	/**
		Calculates and returns the triangle area inverse.

		Result is cached between `getArea` and `getInvArea` on first call and altering `a`, `b`, or `c` afterwards will lead to incorrect value.
	**/
	public inline function getInvArea() {
		getArea();
		return invArea;
	}

	/**
		Calculate barycentric coordinates for the point `p`
	**/
	public inline function barycentric( p : Point ) {
		var area = getInvArea() * 0.5;
		var s = area * (a.y * c.x - a.x * c.y + (c.y - a.y) * p.x + (a.x - c.x) * p.y);
		var t = area * (a.x * b.y - a.y * b.x + (a.y - b.y) * p.x + (b.x - a.x) * p.y);
		return new h3d.col.Point(1 - s - t, s, t);
	}

	/**
		Tests if Point `p` is inside this Triangle.
	**/
	public function contains( p : Point ) {
		var area = getInvArea() * 0.5;
		var s = area * (a.y * c.x - a.x * c.y + (c.y - a.y) * p.x + (a.x - c.x) * p.y);
		var t = area * (a.x * b.y - a.y * b.x + (a.y - b.y) * p.x + (b.x - a.x) * p.y);
		return s >= 0 && t >= 0 && s + t < 1;
	}

}