package h2d.col;
import hxd.Math;

class Ray {

	public var x : Float;
	public var y : Float;
	public var dx : Float;
	public var dy : Float;

	public inline function new( p1 : Point, p2 : Point ) {
		setPoints(p1, p2);
	}

	public inline function setPoints( p1 : Point, p2 : Point ) {
		x = p1.x;
		y = p1.y;
		dx = p2.x - x;
		dy = p2.y - y;
	}

	public inline function side( p : Point ) {
		return dx * (p.y - y) - dy * (p.x - x);
	}


	public inline function getPos() {
		return new Point(x, y);
	}

	public inline function getDir() {
		return new Point(dx, dy);
	}
}