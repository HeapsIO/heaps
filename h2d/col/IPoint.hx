package h2d.col;
import hxd.Math;

/**
	`h2d.col.IPoint` is an `Int`-based version of `h2d.col.Point`.
**/
class IPoint {

	public var x : Int;
	public var y : Int;

	public inline function new(x = 0, y = 0) {
		this.x = x;
		this.y = y;
	}

	/**
		Converts this IPoint to `Float` point scaled by provided scalar `scale`.
	**/
	public inline function toPoint( scale = 1. ) : Point {
		return new Point(x * scale, y * scale);
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
		Sets the IPoint `x,y` with given values.
	**/
	public inline function set( x : Int, y : Int ) {
		this.x = x;
		this.y = y;
	}

	/**
		Returns a copy of this Point.
	**/
	public inline function clone() : IPoint {
		return new IPoint(x, y);
	}

}