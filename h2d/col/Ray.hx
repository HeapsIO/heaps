package h2d.col;
import hxd.Math;

/**
	A raycast from the given position in a specified direction.
**/
class Ray {

	/** X position of the ray start. **/
	public var px : Float;
	/** Y position of the ray start. **/
	public var py : Float;
	/** X normal of the ray direction. **/
	public var lx : Float;
	/** Y normal of the ray direction. **/
	public var ly : Float;

	/**
		Create a new Ray instance.
	**/
	public inline function new() {
	}

	/**
		Returns a positive value if Point `p` is on the right side of the Ray axis and negative if it's on the left.
	**/
	public inline function side( p : Point ) {
		return lx * (p.y - py) - ly * (p.x - px);
	}

	/**
		Returns a new Point containing the Ray vector with specified length.
	**/
	public inline function getPoint( distance : Float ) {
		return new Point(px + distance * lx, py + distance * ly);
	}

	/**
		Returns new Point containing Ray starting position.
	**/
	public inline function getPos() {
		return new Point(px, py);
	}

	/**
		Returns new Point containing Ray direction.
	**/
	public inline function getDir() {
		return new Point(lx, ly);
	}

	function normalize() {
		var l = lx * lx + ly * ly;
		if( l == 1. ) return;
		if( l < Math.EPSILON ) l = 0 else l = Math.invSqrt(l);
		lx *= l;
		ly *= l;
	}

	/**
		Returns a new Ray starting at Point `p1` and pointing at Point `p2`.
	**/
	public static inline function fromPoints( p1 : Point, p2 : Point ) {
		var r = new Ray();
		r.px = p1.x;
		r.py = p1.y;
		r.lx = p2.x - p1.x;
		r.ly = p2.y - p1.y;
		r.normalize();
		return r;
	}

	/**
		Returns a new Ray at given position and direction.
	**/
	public static inline function fromValues( x, y, dx, dy ) {
		var r = new Ray();
		r.px = x;
		r.py = y;
		r.lx = dx;
		r.ly = dy;
		r.normalize();
		return r;
	}

}