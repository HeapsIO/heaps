package h2d.col;
import hxd.Math;

class IPoint #if apicheck implements h2d.impl.PointApi.IPointApi<IPoint> #end {

	public var x : Int;
	public var y : Int;

	// -- gen api

	public inline function new(x = 0, y = 0) {
		this.x = x;
		this.y = y;
	}

	public inline function load( p : IPoint ) {
		this.x = p.x;
		this.y = p.y;
	}

	public inline function scale( v : Int ) {
		x *= v;
		y *= v;
	}

	public inline function multiply( v : Int ) {
		return new IPoint(x * v, y * v);
	}

	public inline function distanceSq( p : IPoint ) {
		var dx = x - p.x;
		var dy = y - p.y;
		return dx * dx + dy * dy;
	}

	public inline function distance( p : IPoint ) {
		return Math.sqrt(distanceSq(p));
	}

	public function toString() {
		return "{" + x + "," + y + "}";
	}

	public inline function sub( p : IPoint ) : IPoint {
		return new IPoint(x - p.x, y - p.y);
	}

	public inline function add( p : IPoint ) : IPoint {
		return new IPoint(x + p.x, y + p.y);
	}

	public inline function equals( other : IPoint ) : Bool {
		return x == other.x && y == other.y;
	}

	public inline function dot( p : IPoint ) {
		return x * p.x + y * p.y;
	}

	public inline function lengthSq() {
		return x * x + y * y;
	}

	public inline function length() {
		return Math.sqrt(lengthSq());
	}

	public inline function set(x=0,y=0) {
		this.x = x;
		this.y = y;
	}

	public inline function clone() {
		return new IPoint(x, y);
	}

	public inline function cross( p : IPoint ) {
		return x * p.y - y * p.x;
	}

	// -- end gen api

	public inline function toPoint( scale = 1. ) {
		return new Point(x * scale, y * scale);
	}

}