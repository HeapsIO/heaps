package h2d.impl;

interface GenPointApi<Point,Unit> {

	function clone() : Point;
	function load( p : Point ) : Void;
	function add( p : Point ) : Point;
	function sub( p : Point ) : Point;
	function multiply( v : Unit ) : Point;

	function scale( v : Unit ) : Void;
	function lengthSq() : Unit;
	function length() : Float;

	function distance( p : Point ) : Float;
	function distanceSq( p : Point ) : Unit;

	function equals( other : Point ) : Bool;
	function dot( p : Point ) : Unit;

	function toString() : String;

	// function set(x=0., y=0., z=0.) : Void;
	// function cross( p : Point ) : Point (3D)
	// function cross( p : Point ) : Unit (2D)

}

interface PointApi<Point,M> extends GenPointApi<Point,Float> {

	function lerp( p1 : Point, p2 : Point, k : Float ) : Void;

	function normalize() : Void;
	function normalized() : Point;
	function transform( m : M ) : Void;
	function transformed( m : M ) : Point;
	// function transform3x3( m : Matrix ) : Void (3D)
	// function transform2x2( m : Matrix ) : Void (2D)

}

interface IPointApi<Point> extends GenPointApi<Point,Int> {
}