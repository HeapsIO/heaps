package h2d.impl;

/**
	A base common API interface for the points to validate API parity between 3D and 2D classes.

	Intended for internal usage. Use `-D apicheck` compilation flag to enable parity validation.
**/
interface GenPointApi<Point,Unit> {
	/**
		Returns a copy of the Point/
	**/
	function clone() : Point;
	/**
		Copy the position data from a given Point `p` to this Point.
	**/
	function load( p : Point ) : Void;
	/**
		Returns a new Point with the sum of this Point and a given Point `p`.
	**/
	function add( p : Point ) : Point;
	/**
		Returns a new Point with the results of a subtraction of a given Point `p` from this Point.
	**/
	function sub( p : Point ) : Point;
	/**
		Returns a new Point with the position of this Point multiplied by scalar `v`.
	**/
	function multiply( v : Unit ) : Point;

	/**
		Multiplies position of this Point by scalar `v`.
	**/
	function scale( v : Unit ) : Void;
	/**
		Returns a squared length of the Point.
	**/
	function lengthSq() : Unit;
	/**
		Return the length of the Point.
	**/
	function length() : Float;

	/**
		Returns the distance between this Point and given Point `p`.
	**/
	function distance( p : Point ) : Float;
	/**
		Returns a squared distance between this Point and given Point `p`.
	**/
	function distanceSq( p : Point ) : Unit;

	/**
		Tests if this Point position equals to the position of an `other` Point.
	**/
	function equals( other : Point ) : Bool;
	/**
		Returns a dot product between this Point and given Point `p`.
	**/
	function dot( p : Point ) : Unit;

	/**
		Returns a human-readable string representation of the Point.
	**/
	function toString() : String;

	// function set(x=0., y=0., z=0.) : Void;
	// function cross( p : Point ) : Point (3D)
	// function cross( p : Point ) : Unit (2D)

}

/**
	A common API interface for the floating-point Points to validate API parity between 3D and 2D classes.

	Intended for internal usage. Use `-D apicheck` compilation flag to enable parity validation.
**/
interface PointApi<Point,M> extends GenPointApi<Point,Float> {

	/**
		Sets this Point position to a result of linear interpolation between Points `p1` and `p2` at the interpolant position `k`.
	**/
	function lerp( p1 : Point, p2 : Point, k : Float ) : Void;

	/**
		Normalizes the Point.
	**/
	function normalize() : Void;
	/**
		Returns a new Point with the normalized values of this Point.
	**/
	function normalized() : Point;
	/**
		Applies a given Matrix `m` transformation to this Point position.
	**/
	function transform( m : M ) : Void;
	/**
		Returns a new Point with a result of applying a Matrix `m` to this Point position.
	**/
	function transformed( m : M ) : Point;
	// function transform3x3( m : Matrix ) : Void (3D)
	// function transform2x2( m : Matrix ) : Void (2D)

}

/**
	A common API interface for the integer Points to validate API parity between 3D and 2D classes.

	Intended for internal usage. Use `-D apicheck` compilation flag to enable parity validation.
**/
interface IPointApi<Point> extends GenPointApi<Point,Int> {
}