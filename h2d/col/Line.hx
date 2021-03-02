package h2d.col;

/**
	An infinite 2D line going through two specified Points.
**/
class Line {
	/**
		The first line point.
	**/
	public var p1 : Point;
	/**
		The second line point.
	**/
	public var p2 : Point;

	/**
		Create a new Line instance.
		@param p1 The first line point.
		@param p2 The second line point.
	**/
	public inline function new(p1,p2) {
		this.p1 = p1;
		this.p2 = p2;
	}

	/**
		Returns a positive value if Point `p` is on the right side of the Line axis and negative if it's on the left.
	**/
	public inline function side( p : Point ) {
		return (p2.x - p1.x) * (p.y - p1.y) - (p2.y - p1.y) * (p.x - p1.x);
	}

	/**
		Projects Point `p` onto the Line axis and return new Point instance with a result.
	**/
	public inline function project( p : Point ) {
		var dx = p2.x - p1.x;
		var dy = p2.y - p1.y;
		var k = ((p.x - p1.x) * dx + (p.y - p1.y) * dy) / (dx * dx + dy * dy);
		return new Point(dx * k + p1.x, dy * k + p1.y);
	}

	/**
		Returns an intersection Point between given Line `l` and this Line with both treated as infinite lines.
		Returns `null` if lines are almost colinear (less than epsilon value difference)
	**/
	public inline function intersect( l : Line ) {
		var d = (p1.x - p2.x) * (l.p1.y - l.p2.y) - (p1.y - p2.y) * (l.p1.x - l.p2.x);
		if( hxd.Math.abs(d) < hxd.Math.EPSILON )
			return null;
		var a = p1.x*p2.y - p1.y * p2.x;
		var b = l.p1.x*l.p2.y - l.p1.y*l.p2.x;
		return new Point( (a * (l.p1.x - l.p2.x) - (p1.x - p2.x) * b) / d, (a * (l.p1.y - l.p2.y) - (p1.y - p2.y) * b) / d );
	}

	/**
		Tests for intersection between given Line `l` and this Line with both treated as infinite lines.
		Returns `false` if lines are almost colinear (less than epsilon value difference).
		Otherwise returns `true`, and fill Point `pt` with intersection point.
	**/
	public inline function intersectWith( l : Line, pt : Point ) {
		var d = (p1.x - p2.x) * (l.p1.y - l.p2.y) - (p1.y - p2.y) * (l.p1.x - l.p2.x);
		if( hxd.Math.abs(d) < hxd.Math.EPSILON )
			return false;
		var a = p1.x*p2.y - p1.y * p2.x;
		var b = l.p1.x*l.p2.y - l.p1.y*l.p2.x;
		pt.x = (a * (l.p1.x - l.p2.x) - (p1.x - p2.x) * b) / d;
		pt.y = (a * (l.p1.y - l.p2.y) - (p1.y - p2.y) * b) / d;
		return true;
	}

	/**
		Returns a squared distance from Line axis to Point `p`.
		Cheaper to calculate than `distance` and can be used for more optimal comparison operations.
	**/
	public inline function distanceSq( p : Point ) {
		var dx = p2.x - p1.x;
		var dy = p2.y - p1.y;
		var k = ((p.x - p1.x) * dx + (p.y - p1.y) * dy) / (dx * dx + dy * dy);
		var mx = dx * k + p1.x - p.x;
		var my = dy * k + p1.y - p.y;
		return mx * mx + my * my;
	}

	/**
		Returns a distance from Line axis to Point `p`.
	**/
	public inline function distance( p : Point ) {
		return hxd.Math.sqrt(distanceSq(p));
	}

	/**
	 * The angle between a line and the x-axis
	 */
	public inline function angle():Float {
		var dx = p2.x - p1.x;
		var dy = p2.y - p1.y;
		return hxd.Math.atan2(dy, dx);
	}

	/**
		The distance between Line starting Point `p1` and ending Point `p2`.
	**/
	public inline function length():Float {
		var dx = p2.x - p1.x;
		var dy = p2.y - p1.y;
		return hxd.Math.distance(dx, dy);
	}

}