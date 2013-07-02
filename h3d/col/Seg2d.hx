package h3d.col;

class Seg2d {

	public var x : Float;
	public var y : Float;
	public var dx : Float;
	public var dy : Float;
	public var lenSq : Float;
	public var invLenSq : Float;
	
	public inline function new( p1 : Vector, p2 : Vector ) {
		x = p1.x;
		y = p1.y;
		dx = p2.x - x;
		dy = p2.y - y;
		lenSq = dx * dx + dy * dy;
		invLenSq = 1 / lenSq;
	}
	
	public inline function side( p : h3d.Vector ) {
		return dx * (p.y - y) - dy * (p.x - x);
	}
	
	public inline function distanceSq( p : h3d.Vector ) {
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

	public inline function distance( p : h3d.Vector ) {
		return FMath.sqrt(distanceSq(p));
	}

}