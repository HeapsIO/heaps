package h2d.col;
import hxd.Math;

class Seg {

	public var x : Float;
	public var y : Float;
	public var dx : Float;
	public var dy : Float;
	public var lenSq : Float;
	public var invLenSq : Float;

	public inline function new( p1 : Point, p2 : Point ) {
		setPoints(p1, p2);
	}

	public inline function setPoints( p1 : Point, p2 : Point ) {
		x = p1.x;
		y = p1.y;
		dx = p2.x - x;
		dy = p2.y - y;
		lenSq = dx * dx + dy * dy;
		invLenSq = 1 / lenSq;
	}

	public inline function side( p : Point ) {
		return dx * (p.y - y) - dy * (p.x - x);
	}

	public inline function distanceSq( p : Point ) {
		var px = p.x - x;
		var py = p.y - y;
		var t = px * dx + py * dy;
		return if( t < 0 )
			px * px + py * py
		else if( t > lenSq ) {
			var kx = p.x - (x + dx);
			var ky = p.y - (y + dy);
			kx * kx + ky * ky;
		} else {
			var tl2 = t * invLenSq;
			var pdx = x + tl2 * dx - p.x;
			var pdy = y + tl2 * dy - p.y;
			pdx * pdx + pdy * pdy;
		}
	}

	public inline function distance( p : Point ) {
		return Math.sqrt(distanceSq(p));
	}

	public inline function project( p : Point ) : Point {
		var px = p.x - x;
		var py = p.y - y;
		var t = px * dx + py * dy;
		return if( t < 0 )
			new Point(x, y);
		else if( t > lenSq )
			new Point(x + dx, y + dy);
		else {
			var tl2 = t * invLenSq;
			new Point(x + tl2 * dx, y + tl2 * dy);
		}
	}

}