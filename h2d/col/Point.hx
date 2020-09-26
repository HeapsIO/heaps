package h2d.col;
import hxd.Math;

/**
	A simple 2D position/vector container.
	@see `h2d.col.IPoint`
**/
class Point {
	/**
		The horizontal position of the point.
	**/
	public var x : Float;
	/**
		The vertical position of the point.
	**/
	public var y : Float;

	/**
		Create a new Point instance.
		@param x The horizontal position of the point.
		@param y The vertical position of the point.
	**/
	public inline function new(x = 0., y = 0.) {
		this.x = x;
		this.y = y;
	}

	/**
		Converts this point to integer point scaled by provided scalar `scale` (rounded).
	**/
	public inline function toIPoint( scale = 1. ) : IPoint {
		return new IPoint(Math.round(x * scale), Math.round(y * scale));
	}

	/**
		Returns squared distance between this Point and given Point `p`.
	**/
	public inline function distanceSq( p : Point ) : Float {
		var dx = x - p.x;
		var dy = y - p.y;
		return dx * dx + dy * dy;
	}

	/**
		Returns a distance between this Point and given Point `p`.
	**/
	public inline function distance( p : Point ) : Float {
		return Math.sqrt(distanceSq(p));
	}

	@:dox(hide)
	public function toString() : String {
		return "{" + Math.fmt(x) + "," + Math.fmt(y) + "}";
	}

	/**
		Substracts Point `p` from this Point and returns new Point with the result.
	**/
	public inline function sub( p : Point ) : Point {
		return new Point(x - p.x, y - p.y);
	}

	/**
		Adds Point `p` to this Point and returns new Point with the result.
	**/
	public inline function add( p : Point ) : Point {
		return new Point(x + p.x, y + p.y);
	}

	/**
		Tests if this Point position equals to `other` Point position.
	**/
	public inline function equals( other : Point ) : Bool {
		return x == other.x && y == other.y;
	}

	/**
		Returns a dot product between this Point and given Point `p`.
	**/
	public inline function dot( p : Point ) : Float {
		return x * p.x + y * p.y;
	}

	/**
		Rotates this Point around `0,0` by given `angle`.
	**/
	public inline function rotate( angle : Float ) {
		var c = Math.cos(angle);
		var s = Math.sin(angle);
		var x2 = x * c - y * s;
		var y2 = x * s + y * c;
		x = x2;
		y = y2;
	}

	/**
		Returns squared length of this Point.
	**/
	public inline function lengthSq() : Float {
		return x * x + y * y;
	}

	/**
		Returns length (distance to `0,0`) of this Point.
	**/
	public inline function length() : Float {
		return Math.sqrt(lengthSq());
	}

	/**
		Normalizes the Point.
	**/
	public function normalize() {
		var k = lengthSq();
		if( k < Math.EPSILON ) k = 0 else k = Math.invSqrt(k);
		x *= k;
		y *= k;
	}

	/**
		Normalizes the Point.
		Compared to `normalize` does not account for extremely small Point length edge case.
	**/
	public inline function normalizeFast() {
		var k = lengthSq();
		k = Math.invSqrt(k);
		x *= k;
		y *= k;
	}

	/**
		Sets the Point `x,y` with given values.
	**/
	public inline function set( x : Float, y : Float ) {
		this.x = x;
		this.y = y;
	}

	/**
		Copies `x,y` from given Point `p` to this Point.
	**/
	public inline function load( p : h2d.col.Point ) {
		this.x = p.x;
		this.y = p.y;
	}

	/**
		Multiplies `x,y` by scalar `f` and returns this Point.
	**/
	public inline function scale( f : Float ) : Point {
		x *= f;
		y *= f;
		return this;
	}

	/**
		Returns a copy of this Point.
	**/
	public inline function clone() : Point {
		return new Point(x, y);
	}

}