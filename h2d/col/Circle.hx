package h2d.col;
import hxd.Math;

/**
	The circular hitbox implementation of a 2D Collider.
**/
class Circle implements Collider {

	/**
		Horizontal position of the Circle center.
	**/
	public var x : Float;
	/**
		Vertical position of the Circle center.
	**/
	public var y : Float;
	/**
		Radius of the circle.
	**/
	public var ray : Float;

	/**
		Create new Circle collider.
		@param x X position of the Circle center.
		@param y Y position of the Circle center.
		@param ray Radius of the circle.
	**/
	public inline function new( x : Float, y : Float, ray : Float ) {
		this.x = x;
		this.y = y;
		this.ray = ray;
	}

	/**
		Returns a squared distance between the Circle center and the given Point `p`.
	**/
	public inline function distanceSq( p : Point ) : Float {
		var dx = p.x - x;
		var dy = p.y - y;
		var d = dx * dx + dy * dy - ray * ray;
		return d < 0 ? 0 : d;
	}

	/**
		Returns a squared distance between the Circle border and the given Point `p`.
	**/
	public inline function side( p : Point ) : Float {
		var dx = p.x - x;
		var dy = p.y - y;
		return ray * ray - (dx * dx + dy * dy);
	}

	/**
		Tests if this Circle collides with the given Circle `c`.
	**/
	public inline function collideCircle( c : Circle ) : Bool {
		var dx = x - c.x;
		var dy = y - c.y;
		return dx * dx + dy * dy < (ray + c.ray) * (ray + c.ray);
	}

	/**
		Test if this Circle collides with the given Bounds `b`.
	**/
	public inline function collideBounds( b : Bounds ) : Bool {
		if( x < b.xMin - ray ) return false;
		if( x > b.xMax + ray ) return false;
		if( y < b.yMin - ray ) return false;
		if( y > b.yMax + ray ) return false;
		if( x < b.xMin && y < b.yMin && Math.distanceSq(x - b.xMin, y - b.yMin) > ray*ray ) return false;
		if( x > b.xMax && y < b.yMin && Math.distanceSq(x - b.xMax, y - b.yMin) > ray*ray ) return false;
		if( x < b.xMin && y > b.yMax && Math.distanceSq(x - b.xMin, y - b.yMax) > ray*ray ) return false;
		if( x > b.xMax && y > b.yMax && Math.distanceSq(x - b.xMax, y - b.yMax) > ray*ray ) return false;
		return true;
	}

	/**
		Tests if this Circle intersects with a line segment from Point `p1` to Point `p2`.
		@returns An array of Points with intersection coordinates.
		Contains 1 Point if line intersects only once or 2 points if line enters and exits the circle.
		If no intersection is found, returns `null`.
	**/
	public inline function lineIntersect(p1 : h2d.col.Point, p2:h2d.col.Point) : Array<Point> {
		var dx = p2.x - p1.x;
		var dy = p2.y - p1.y;
		var a = dx * dx + dy * dy;
		if (a < 1e-8) return null;
		var b = 2 * (dx * (p1.x - x) + dy * (p1.y - y));
		var c = hxd.Math.distanceSq(p1.x - x, p1.y - y) - ray * ray;
		var d = b * b - 4 * a * c;

		if(d < 0) return null;
		if(d == 0) {
			var t = -b / (2 * a);
			return [new h2d.col.Point(p1.x + t * dx, p1.y + t * dy)];
		}

		var t1 = (-b - Math.sqrt(d)) / (2 * a);
		var t2 = (-b + Math.sqrt(d)) / (2 * a);
		return [new h2d.col.Point(p1.x + t1 * dx, p1.y + t1 * dy), new h2d.col.Point(p1.x + t2 * dx, p1.y + t2 * dy)];
	}

	@:dox(hide)
	public function toString() {
		return '{${Math.fmt(x)},${Math.fmt(y)},${Math.fmt(ray)}}';
	}

	/**
		Tests if Point `p` is inside this Circle.
	**/
	public function contains( p : Point ) : Bool {
		return distanceSq(p) == 0;
	}

}