package h2d.col;
import hxd.Math;

class Circle {

	public var x : Float;
	public var y : Float;
	public var ray : Float;

	public inline function new( x : Float, y : Float, ray : Float ) {
		this.x = x;
		this.y = y;
		this.ray = ray;
	}

	public inline function distanceSq( p : Point ) {
		var dx = p.x - x;
		var dy = p.y - y;
		var d = dx * dx + dy * dy - ray * ray;
		return d < 0 ? 0 : d;
	}

	public inline function side( p : Point ) {
		var dx = p.x - x;
		var dy = p.y - y;
		return ray * ray - (dx * dx + dy * dy);
	}

	public inline function collideCircle( c : Circle ) {
		var dx = x - c.x;
		var dy = y - c.y;
		return dx * dx + dy * dy < (ray + c.ray) * (ray + c.ray);
	}

	public function toString() {
		return '{${Math.fmt(x)},${Math.fmt(y)},${Math.fmt(ray)}}';
	}

}