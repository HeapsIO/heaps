package h2d.col;
import hxd.Math;

class Point #if apicheck implements h2d.impl.PointApi<Point,Matrix> #end {

	public var x : Float;
	public var y : Float;

	// -- gen api

	public inline function new(x = 0., y = 0.) {
		this.x = x;
		this.y = y;
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

	public inline function multiply( v : Float ) {
		return new Point(x * v, y * v);
	}

	public inline function equals( other : Point ) : Bool {
		return x == other.x && y == other.y;
	}

	public inline function dot( p : Point ) {
		return x * p.x + y * p.y;
	}

	public inline function lengthSq() {
		return x * x + y * y;
	}

	public inline function length() {
		return Math.sqrt(lengthSq());
	}

	public inline function normalize() {
		var k = lengthSq();
		if( k < Math.EPSILON ) k = 0 else k = Math.invSqrt(k);
		x *= k;
		y *= k;
	}

	public inline function normalized() {
		var k = lengthSq();
		if( k < Math.EPSILON ) k = 0 else k = Math.invSqrt(k);
		return new h2d.col.Point(x*k,y*k);
	}

	public inline function set(x=0.,y=0.) {
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
	}

	public inline function clone() {
		return new Point(x, y);
	}

	public inline function cross( p : Point ) {
		return x * p.y - y * p.x;
	}

	public inline function lerp( a : Point, b : Point, k : Float ) {
		x = hxd.Math.lerp(a.x, b.x, k);
		y = hxd.Math.lerp(a.y, a.y, k);
	}

	public inline function transform( m : Matrix ) {
		var mx = m.a * x + m.c * y + m.x;
		var my = m.b * x + m.d * y + m.y;
		this.x = mx;
		this.y = my;
	}

	public inline function transformed( m : Matrix ) {
		var mx = m.a * x + m.c * y + m.x;
		var my = m.b * x + m.d * y + m.y;
		return new Point(mx,my);
	}

	public inline function transform2x2( m : Matrix ) {
		var mx = m.a * x + m.c * y;
		var my = m.b * x + m.d * y;
		this.x = mx;
		this.y = my;
	}

	public inline function transformed2x2( m : Matrix ) {
		var mx = m.a * x + m.c * y;
		var my = m.b * x + m.d * y;
		return new Point(mx,my);
	}


	// -- end

	public inline function toIPoint( scale = 1. ) {
		return new IPoint(Math.round(x * scale), Math.round(y * scale));
	}

	public inline function rotate( angle : Float ) {
		var c = Math.cos(angle);
		var s = Math.sin(angle);
		var x2 = x * c - y * s;
		var y2 = x * s + y * c;
		x = x2;
		y = y2;
	}

}