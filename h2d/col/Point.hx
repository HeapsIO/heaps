package h2d.col;
import hxd.Math;

class Point {

	public var x : Float;
	public var y : Float;

	public inline function new(x = 0., y = 0.) {
		this.x = x;
		this.y = y;
	}

	public inline function toIPoint( scale = 1. ) {
		return new IPoint(Math.round(x * scale), Math.round(y * scale));
	}

	public inline function distanceSq( p : Point ) {
		var dx = x - p.x;
		var dy = y - p.y;
		return dx * dx + dy * dy;
	}

	public inline function distance( p : Point ) {
		return Math.sqrt(distanceSq(p));
	}

	public function toString() {
		return "{" + Math.fmt(x) + "," + Math.fmt(y) + "}";
	}

	public inline function sub( p : Point ) {
		return new Point(x - p.x, y - p.y);
	}

	public inline function add( p : Point ) {
		return new Point(x + p.x, y + p.y);
	}

	public inline function dot( p : Point ) {
		return x * p.x + y * p.y;
	}

	public inline function rotate( angle : Float ) {
		var c = Math.cos(angle);
		var s = Math.sin(angle);
		var x2 = x * c - y * s;
		var y2 = x * s + y * c;
		x = x2;
		y = y2;
	}

	public inline function lengthSq() {
		return x * x + y * y;
	}

	public inline function length() {
		return Math.sqrt(lengthSq());
	}

	public function normalize() {
		var k = lengthSq();
		if( k < Math.EPSILON ) k = 0 else k = Math.invSqrt(k);
		x *= k;
		y *= k;
	}

	public inline function normalizeFast() {
		var k = lengthSq();
		k = Math.invSqrt(k);
		x *= k;
		y *= k;
	}

	public inline function set(x,y) {
		this.x = x;
		this.y = y;
	}

	public inline function load( p : h2d.col.Point ) {
		this.x = p.x;
		this.y = p.y;
	}

	public inline function scale( f : Float ) {
		x *= f;
		y *= f;
		return this;
	}

	public inline function clone() {
		return new Point(x, y);
	}

}