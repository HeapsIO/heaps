package h3d.col;
import hxd.Math;

class Seg {

	public var p1 : Point;
	public var p2 : Point;
	public var lenSq : Float;

	public inline function new( p1 : Point, p2 : Point ) {
		this.p1 = p1;
		this.p2 = p2;
		lenSq = p1.distanceSq(p2);
	}

	public inline function distanceSq( p : Point ) {
		var t = p.sub(p1).dot(p2.sub(p1)) / lenSq;
		return if( t < 0 )
			p.distanceSq(p1);
		else if( t > 1 ) {
			p.distanceSq(p2);
		} else
			p.distanceSq(new Point(p1.x + t * (p2.x - p1.x), p1.y + t * (p2.y - p1.y)));
	}

	public inline function distance( p : Point ) {
		return Math.sqrt(distanceSq(p));
	}

	public function toString() {
		return 'Seg{$p1,$p2}';
	}

}