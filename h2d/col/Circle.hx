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

	public inline function collideBounds( b : Bounds ) {
		if( x < b.xMin - ray ) return false;
		if( x > b.xMax + ray ) return false;
		if( y < b.yMin - ray ) return false;
		if( y > b.yMax + ray ) return false;
		if( x < b.xMin && y < b.yMin && Math.distanceSq(x - b.xMin, y - b.yMin) > ray*ray ) return false;
		if( x > b.xMax && y < b.yMin && Math.distanceSq(x - b.xMax, y - b.yMin) > ray*ray ) return false;
		if( x < b.xMin && y > b.yMax && Math.distanceSq(x - b.xMin, y - b.yMax) > ray*ray ) return false;
		if( x > b.xMax && y > b.yMax && Math.distanceSq(x - b.xMax, y - b.yMax) > ray*ray ) return false;
		return true;
	}

	public function toString() {
		return '{${Math.fmt(x)},${Math.fmt(y)},${Math.fmt(ray)}}';
	}

}