package h2d.col;

class Triangle {

	static inline var UNDEF = 1.1315e-17;

	public var a : Point;
	public var b : Point;
	public var c : Point;
	var area : Float;
	var invArea : Float;

	public inline function new( a : Point, b : Point, c : Point ) {
		this.a = a;
		this.b = b;
		this.c = c;
		area = UNDEF;
	}

	public inline function getCenter() {
		return new Point((a.x + b.x + c.x) / 3, (a.y + b.y + c.y) / 3);
	}

	public function getArea() {
		if( area == UNDEF ) {
			area = ((a.y * b.x - a.x * b.y) + (b.y * c.x - b.x * c.y) + (c.y * a.x - c.x * a.y)) * -0.5;
			invArea = 1 / area;
		}
		return area;
	}

	public inline function getInvArea() {
		getArea();
		return invArea;
	}

	/**
		Calculate barycentric coordinates for the point p
	**/
	public inline function barycentric( p : Point ) {
		var area = getInvArea() * 0.5;
		var s = area * (a.y * c.x - a.x * c.y + (c.y - a.y) * p.x + (a.x - c.x) * p.y);
		var t = area * (a.x * b.y - a.y * b.x + (a.y - b.y) * p.x + (b.x - a.x) * p.y);
		return new h3d.col.Point(1 - s - t, s, t);
	}

}