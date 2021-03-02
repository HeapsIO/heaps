package h2d.col;
import hxd.Math;

/**
	A 2D line segment.
	@see `h2d.Segments`
**/
class Segment {

	/**
		X starting position of the Segment.

		Please use `Segment.setPoints` to modify this value.
	**/
	public var x : Float;
	/**
		Y starting position of the Segment.

		Please use `Segment.setPoints` to modify this value.
	**/
	public var y : Float;
	/**
		The delta-value of X end position of the Segment relative to starting position.

		Please use `Segment.setPoints` to modify this value.
	**/
	public var dx : Float;
	/**
		The delta-value of Y end position of the Segment relative to starting position.

		Please use `Segment.setPoints` to modify this value.
	**/
	public var dy : Float;
	/**
		Squared length of the segment.

		Please use `Segment.setPoints` to modify this value.
	**/
	public var lenSq : Float;
	/**
		Inverse of the Segments squared length.

		Please use `Segment.setPoints` to modify this value.
	**/
	public var invLenSq : Float;

	/**
		Create a new Segment starting from Point `p1` and ending at Point `p2`.
	**/
	public inline function new( p1 : Point, p2 : Point ) {
		setPoints(p1, p2);
	}

	/**
		Sets Segment starting position at Point `p1` and ending position at Point `p2`.
	**/
	public inline function setPoints( p1 : Point, p2 : Point ) {
		x = p1.x;
		y = p1.y;
		dx = p2.x - x;
		dy = p2.y - y;
		lenSq = dx * dx + dy * dy;
		invLenSq = 1 / lenSq;
	}

	/**
		Returns a positive value if Point `p` is on the right side of the Segment axis and negative if it's on the left.
	**/
	public inline function side( p : Point ) {
		return dx * (p.y - y) - dy * (p.x - x);
	}

	/**
		Returns squared distance to the Segment as an infinite line to the Point `p`.
	**/
	public inline function distanceSq( p : Point ) {
		var px = p.x - x;
		var py = p.y - y;
		var t = px * dx + py * dy;
		return if( t < 0 )
			px * px + py * py
		else if( t > lenSq ) {
			var kx = p.x - (x + dx);
			var ky = p.y - (y + dy);
			kx * kx + ky * ky;
		} else {
			var tl2 = t * invLenSq;
			var pdx = x + tl2 * dx - p.x;
			var pdy = y + tl2 * dy - p.y;
			pdx * pdx + pdy * pdy;
		}
	}

	/**
		Returns distance from the Segment as an infinite line to the Point `p`.
	**/
	public inline function distance( p : Point ) {
		return Math.sqrt(distanceSq(p));
	}

	/**
		Projects Point `p` onto Segment. Returns position of intersection between Segment and line perpendicular to it going through Point `p`.
	**/
	public inline function project( p : Point ) : Point {
		var px = p.x - x;
		var py = p.y - y;
		var t = px * dx + py * dy;
		return if( t < 0 )
			new Point(x, y);
		else if( t > lenSq )
			new Point(x + dx, y + dy);
		else {
			var tl2 = t * invLenSq;
			new Point(x + tl2 * dx, y + tl2 * dy);
		}
	}

	/**
		Tests if Segments intersects given Ray `r`.
		@param pt Optional Point instance to which intersection point is written. If not provided, returns new Point instance.
		@returns A `Point` with intersection position or `null` if Segment and Ray do not intersect.
	**/
	public inline function lineIntersection( r : h2d.col.Ray, ?pt : Point ) {
		if( r.side(new Point(x, y)) * r.side(new Point(x + dx, y + dy)) > 0 )
			return null;

		var u = ( r.lx * (y - r.py) - r.ly * (x - r.px) ) / ( r.ly * dx - r.lx * dy );
		if( u < 0 || u > 1 ) return null;

		if( pt == null ) pt = new Point();
		pt.x = x + u * dx;
		pt.y = y + u * dy;

		return pt;
	}

}