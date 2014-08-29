package h2d.col;
import hxd.Math;

class Poly {

	public var points : Array<Point>;
	var segments : Array<Seg>;

	public function new( points ) {
		this.points = points;
	}

	public function isConvex() {
		for( i in 0...points.length ) {
			var p1 = points[i];
			var p2 = points[(i + 1) % points.length];
			var p3 = points[(i + 2) % points.length];
			if( (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x) < 0 )
				return false;
		}
		return true;
	}

	public function calculateArea() {
		var s = 0.;
		for( i in 0...points.length ) {
			var p = points[i];
			var n = points[(i + 1) % points.length];
			s += p.y * n.x - p.x * n.y;
		}
		return s * 0.5;
	}

	public function getSegments() {
		if( segments != null )
			return segments;
		segments = [];
		for( i in 0...points.length ) {
			var s = new Seg(points[i], points[(i + 1) % points.length]);
			segments.push(s);
		}
		return segments;
	}

	public function hasPoint( p : Point ) {
		for( s in getSegments() )
			if( s.side(p) < 0 )
				return false;
		return true;
	}

	public function project( p : Point ) : Point {
		var dmin = 1e20, smin = null;
		for( s in getSegments() ) {
			var d = s.distanceSq(p);
			if( d < dmin ) {
				dmin = d;
				smin = s;
			}
		}
		return smin.project(p);
	}

	public function distanceSq( p : Point ) {
		var dmin = 1e20;
		for( s in getSegments() ) {
			var d = s.distanceSq(p);
			if( d < dmin ) dmin = d;
		}
		return dmin;
	}

	public inline function distance( p : Point ) {
		return Math.sqrt(distanceSq(p));
	}

}