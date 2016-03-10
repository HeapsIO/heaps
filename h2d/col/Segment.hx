package h2d.col;
import hxd.Math;

class Segment {

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

	public function rayIntersection( r : h2d.col.Ray ) {
		if(r.side(new Point(x, y)) * r.side(new Point(x + dx, y + dy)) > 0)
			return null;

		var x1 = x, y1 = y;
		var x2 = x + dx, y2 = y + dy;
		var x3 = r.x, y3 = r.y;
		var x4 = r.x + r.dx, y4 = r.y + r.dy;

		var u = ( (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3) ) / ( (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1) );
		var px = x1 + u * (x2 - x1);
		var py = y1 + u * (y2 - y1);

		return new Point(px, py);
	}

}