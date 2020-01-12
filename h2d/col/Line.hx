package h2d.col;

class Line {

	public var p1 : Point;
	public var p2 : Point;

	private var dx:Float;
	private var dy:Float;

	public inline function new(p1,p2) {
		this.p1 = p1;
		this.p2 = p2;
		this.dx = p2.x - p1.x;
		this.dy = p2.y - p1.y;
	}

	public inline function side( p : Point ) {
		return dx * (p.y - p1.y) - dy * (p.x - p1.x);
	}

	public inline function project( p : Point ) {
		var k = ((p.x - p1.x) * dx + (p.y - p1.y) * dy) / (dx * dx + dy * dy);
		return new Point(dx * k + p1.x, dy * k + p1.y);
	}

	public inline function intersect( l : Line ) {
		var d = (p1.x - p2.x) * (l.p1.y - l.p2.y) - (p1.y - p2.y) * (l.p1.x - l.p2.x);
		if( hxd.Math.abs(d) < hxd.Math.EPSILON )
			return null;
		var a = p1.x*p2.y - p1.y * p2.x;
		var b = l.p1.x*l.p2.y - l.p1.y*l.p2.x;
		return new Point( (a * (l.p1.x - l.p2.x) - (p1.x - p2.x) * b) / d, (a * (l.p1.y - l.p2.y) - (p1.y - p2.y) * b) / d );
	}

	public inline function intersectWith( l : Line, pt : Point ) {
		var d = (p1.x - p2.x) * (l.p1.y - l.p2.y) - (p1.y - p2.y) * (l.p1.x - l.p2.x);
		if( hxd.Math.abs(d) < hxd.Math.EPSILON )
			return false;
		var a = p1.x*p2.y - p1.y * p2.x;
		var b = l.p1.x*l.p2.y - l.p1.y*l.p2.x;
		pt.x = (a * (l.p1.x - l.p2.x) - (p1.x - p2.x) * b) / d;
		pt.y = (a * (l.p1.y - l.p2.y) - (p1.y - p2.y) * b) / d;
		return true;
	}

	public inline function distanceSq( p : Point ) {
		var k = ((p.x - p1.x) * dx + (p.y - p1.y) * dy) / (dx * dx + dy * dy);
		var mx = dx * k + p1.x - p.x;
		var my = dy * k + p1.y - p.y;
		return mx * mx + my * my;
	}

	public inline function distance( p : Point ) {
		return hxd.Math.sqrt(distanceSq(p));
	}

	public inline function angle() {
		return Math.atan2(dy, dx);
	}

	public inline function lenght():Float {
		return Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
	}

}