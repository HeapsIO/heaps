package h2d.col;
import hxd.Math;

/**
	`h2d.col.Ray` represents a raycast from given position in a specified direction.
**/
class Ray {
	/** X position of the ray start. **/
	public var x : Float;
	/** Y position of the ray start. **/
	public var y : Float;
	/** X normal of the ray direction. **/
	public var dx : Float;
	/** Y normal of the ray direction. **/
	public var dy : Float;

	/**
		Create a new Ray starting from Point `p1` and pointing in direction of Point `p2`.
	**/
	public inline function new( p1 : Point, p2 : Point ) {
		setPoints(p1, p2);
	}

	/**
		Sets ray starting position from Point `p1` and direction towards Point `p2`.
	**/
	public inline function setPoints( p1 : Point, p2 : Point ) {
		x = p1.x;
		y = p1.y;
		dx = p2.x - x;
		dy = p2.y - y;
	}

	/**
		Returns a positive value if Point `p` is on the right side of the Ray axis and negative if it's on the left.
	**/
	public inline function side( p : Point ) {
		return dx * (p.y - y) - dy * (p.x - x);
	}

	/**
		Returns new Point containing Ray starting position.
	**/
	public inline function getPos() {
		return new Point(x, y);
	}
	
	/**
		Returns new Point containing Ray direction.
	**/
	public inline function getDir() {
		return new Point(dx, dy);
	}
}