package h2d.col;
import hxd.Math;

class IPoint {

	public var x : Int;
	public var y : Int;

	public inline function new(x = 0, y = 0) {
		this.x = x;
		this.y = y;
	}

	public inline function toPoint( scale = 1. ) {
		return new Point(x * scale, y * scale);
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

	public inline function sub( p : IPoint ) {
		return new Point(x - p.x, y - p.y);
	}

	public inline function add( p : IPoint ) {
		return new Point(x + p.x, y + p.y);
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

	public inline function set(x,y) {
		this.x = x;
		this.y = y;
	}

	public inline function clone() {
		return new IPoint(x, y);
	}

}