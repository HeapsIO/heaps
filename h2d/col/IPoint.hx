package h2d.col;
import hxd.Math;

/**
	An integer-based point.
	@see `h2d.col.Point`
**/
class IPoint #if apicheck implements h2d.impl.PointApi.IPointApi<IPoint> #end {

	/**
		Horizontal position of the point.
	**/
	public var x : Int;
	/**
		Vertical position of the point.
	**/
	public var y : Int;

	// -- gen api

	/**
		Create a new integer Point instance.
		@param x Horizontal position of the point.
		@param y Vertical position of the point.
	**/
	public inline function new(x = 0, y = 0) {
		this.x = x;
		this.y = y;
	}

	/**
		Copy the position from the give point `p` into this IPoint.
	**/
	public inline function load( p : IPoint ) {
		this.x = p.x;
		this.y = p.y;
	}

	/**
		Multiplies the position of this IPoint by a given scalar `v`. Modifies this instance.
	**/
	public inline function scale( v : Int ) {
		x *= v;
		y *= v;
	}

	/**
		Returns a new IPoint with the position of this IPoint multiplied by a given scalar `v`.
	**/
	public inline function multiply( v : Int ) {
		return new IPoint(x * v, y * v);
	}

	/**
		Returns squared distance between this IPoint and given IPoint `p`.
	**/
	public inline function distanceSq( p : IPoint ) : Int {
		var dx = x - p.x;
		var dy = y - p.y;
		return dx * dx + dy * dy;
	}

	/**
		Returns a distance between this IPoint and given IPoint `p`.
	**/
	public inline function distance( p : IPoint ) : Float {
		return Math.sqrt(distanceSq(p));
	}

	@:dox(hide)
	public function toString() : String {
		return "{" + x + "," + y + "}";
	}

	/**
		Subtracts IPoint `p` from this IPoint and returns new Point with the result.
	**/
	public inline function sub( p : IPoint ) : IPoint {
		return new IPoint(x - p.x, y - p.y);
	}

	/**
		Adds IPoint `p` to this IPoint and returns new Point with the result.
	**/
	public inline function add( p : IPoint ) : IPoint {
		return new IPoint(x + p.x, y + p.y);
	}

	/**
		Tests if this IPoint position equals to `other` IPoint position.
	**/
	public inline function equals( other : IPoint ) : Bool {
		return x == other.x && y == other.y;
	}

	/**
		Returns a dot product between this IPoint and given IPoint `p`.
	**/
	public inline function dot( p : IPoint ) : Int {
		return x * p.x + y * p.y;
	}

	/**
		Returns squared length of this IPoint.
	**/
	public inline function lengthSq() : Int {
		return x * x + y * y;
	}

	/**
		Returns length (distance to `0,0`) of this IPoint.
	**/
	public inline function length() : Float {
		return Math.sqrt(lengthSq());
	}

	/**
		Sets the IPoint `x, y` with given values.
	**/
	public inline function set(x=0,y=0) {
		this.x = x;
		this.y = y;
	}

	/**
		Returns a copy of this IPoint.
	**/
	public inline function clone() : IPoint {
		return new IPoint(x, y);
	}

	/**
		Returns a cross product between this IPoint and a given IPoint `p`.
	**/
	public inline function cross( p : IPoint ) {
		return x * p.y - y * p.x;
	}

	// -- end gen api

	/**
		Converts this IPoint to floating point-based `Point` scaled by provided scalar `scale`.
	**/
	public inline function toPoint( scale = 1. ) {
		return new Point(x * scale, y * scale);
	}

}