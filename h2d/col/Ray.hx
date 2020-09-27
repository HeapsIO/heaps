package h2d.col;
import hxd.Math;

class Ray {

	public var px : Float;
	public var py : Float;
	public var lx : Float;
	public var ly : Float;

	public inline function new() {
	}

	public inline function side( p : Point ) {
		return lx * (p.y - py) - ly * (p.x - px);
	}

	public inline function getPoint( distance : Float ) {
		return new Point(px + distance * lx, py + distance * ly);
	}

	public inline function getPos() {
		return new Point(px, py);
	}

	public inline function getDir() {
		return new Point(lx, ly);
	}

	function normalize() {
		var l = lx * lx + ly * ly;
		if( l == 1. ) return;
		if( l < Math.EPSILON ) l = 0 else l = Math.invSqrt(l);
		lx *= l;
		ly *= l;
	}

	public static inline function fromPoints( p1 : Point, p2 : Point ) {
		var r = new Ray();
		r.px = p1.x;
		r.py = p1.y;
		r.lx = p2.x - p1.x;
		r.ly = p2.y - p1.y;
		r.normalize();
		return r;
	}

	public static inline function fromValues( x, y, dx, dy ) {
		var r = new Ray();
		r.px = x;
		r.py = y;
		r.lx = dx;
		r.ly = dy;
		r.normalize();
		return r;
	}

}