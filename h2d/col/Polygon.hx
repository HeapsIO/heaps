package h2d.col;
import hxd.Math;

@:forward(push,remove)
abstract Polygon(Array<Point>) from Array<Point> to Array<Point> {

	public var points(get, never) : Array<Point>;
	public var length(get, never) : Int;
	inline function get_length() return this.length;
	inline function get_points() return this;

	public inline function new( ?points ) {
		this = points == null ? [] : points;
	}

	public inline function iterator() {
		return new hxd.impl.ArrayIterator(this);
	}

	/**
		Uses EarCut algorithm to quickly triangulate the polygon.
		This will not create the best triangulation possible but is quite solid wrt self-intersections and merged points.
		Returns the points indexes
	**/
	public function fastTriangulate() {
		return new hxd.earcut.Earcut().triangulate(points);
	}

	public function toSegments() : Segments {
		var segments = [];
		var p1 = points[points.length - 1];
		for( p2 in points ) {
			var s = new Segment(p1, p2);
			segments.push(s);
			p1 = p2;
		}
		return segments;
	}

	public function toIPolygon( scale = 1. ) {
		return [for( p in points ) p.toIPoint(scale)];
	}

	public function getBounds( ?b : Bounds ) {
		if( b == null ) b = new Bounds();
		for( p in points )
			b.addPoint(p);
		return b;
	}

	//sources : https://fr.wikipedia.org/wiki/Parcours_de_Graham
	//step by step demonstration : http://www.algomation.com/algorithm/graham-scan-convex-hull
	public function convexHull() {
		var len = points.length;
		if( points.length < 3 )
			return points;

		//find lowest y points
		var p0 = points[0];
		for( p in points ) {
			if( p.y < p0.y || (p.y == p0.y && p.x < p0.x) )
				p0 = p;
		}

		//sort by angle from p0
		var pts : Array<{p : h2d.col.Point, a : Float}> = [];
		var p1 = new h2d.col.Point(p0.x + 1e5, p0.y);
		for(p in points) {
			if(p.x == p0.x && p.y == p0.y) continue;
			pts.push({p : p, a : side(p0, p1, p)});
		}
		pts.sort(function(pa, pb) return side(p0, pa.p, pb.p) > 0 ? -1 : 1);

		//remove same angle points (includes duplicated points)
		var index = pts.length - 1;
		while(index > 0) {
			var cur = pts[index];
			var prev = pts[index - 1];
			if(cur.a == prev.a) {
				if(Math.distanceSq(cur.p.x - p0.x, cur.p.y - p0.y) < Math.distanceSq(prev.p.x - p0.x, prev.p.y - p0.y))
					pts.remove(cur);
				else pts.remove(prev);
			}
			index--;
		}

		//set hull
		var hull = [ p0, pts[0].p, pts[1].p ];
		for (i in 2...pts.length) {
			var pi = pts[i].p;
			while (side(hull[hull.length - 2], hull[hull.length - 1], pi) <= 0)
				hull.pop();
			hull.push(pi);
		}

		return hull;
	}

	public function isClockwise() {
		var sum = 0.;
		var p1 = points[points.length - 1];
		for( p2 in points ) {
			sum += (p2.x - p1.x) * (p2.y + p1.y);
			p1 = p2;
		}
		return sum < 0; // Y axis is negative compared to classic maths
	}

	public function area() {
		var sum = 0.;
		var p1 = points[points.length - 1];
		for( p2 in points ) {
			sum += p2.x * p1.y - p1.x * p2.y;
			p1 = p2;
		}
		return Math.abs(sum) * 0.5;
	}

	inline function side( p1 : Point, p2 : Point, t : Point ) {
		return (p2.x - p1.x) * (t.y - p1.y) - (p2.y - p1.y) * (t.x - p1.x);
	}

	public function isConvex() {
		var p1 = points[points.length - 2];
		var p2 = points[points.length - 1];
		var p3 = points[0];
		var s = side(p1, p2, p3) > 0;
		for( i in 1...points.length ) {
			p1 = p2;
			p2 = p3;
			p3 = points[i];
			if( side(p1, p2, p3) > 0 != s )
				return false;
		}
		return true;
	}

	public function reverse() : Void {
		this.reverse();
	}

	@:noDebug
	public function contains( p : Point, isConvex = false ) {
		if( isConvex ) {
			var p1 = points[points.length - 1];
			for( p2 in points ) {
				if( side(p1, p2, p) < 0 )
					return false;
				p1 = p2;
			}
			return true;
		} else {
			var w = 0;
			var p1 = points[points.length - 1];
			for (p2 in points) {
				if (p2.y <= p.y) {
					if (p1.y > p.y && side(p2, p1, p) > 0)
						w++;
				}
				else if (p1.y <= p.y && side(p2, p1, p) < 0)
					w--;
				p1 = p2;
			}
			return w != 0;
		}
	}

	public function rayIntersection( r : h2d.col.Ray, ?pt : Point ) {
		var dmin = 1E9;
		var p0 = points[points.length - 1];

		for(p in points) {
			if(r.side(p0) * r.side(p) > 0) {
				p0 = p;
				continue;
			}

			var u = ( r.dx * (p0.y - r.y) - r.dy * (p0.x - r.x) ) / ( r.dy * (p.x - p0.x) - r.dx * (p.y - p0.y) );
			var x = p0.x + u * (p.x - p0.x);
			var y = p0.y + u * (p.y - p0.y);
			var d = Math.distanceSq(x - r.x, y - r.y);

			if(d < dmin) {
				if( pt == null ) pt = new Point();
				pt.x = x;
				pt.y = y;
				dmin = d;
			}
			p0 = p;
		}

		return pt;
	}

	/**
		Creates a new optimized polygon by eliminating almost colinear edges according to epsilon distance.
	**/
	public function optimize( epsilon : Float ) : Polygon {
		var out = [];
		optimizeRec(points, 0, points.length - 1, out, epsilon);
		return out;
	}

	static function optimizeRec( points : Array<Point>, start : Int, end : Int, out : Array<Point>, epsilon : Float ) {
		var dmax = 0.;

		inline function distPointSeg(p0:Point, p1:Point, p2:Point) {
			var A = p0.x - p1.x;
			var B = p0.y - p1.y;
			var C = p2.x - p1.x;
			var D = p2.y - p1.y;

			var dot = A * C + B * D;
			var dist = C * C + D * D;
			var param = -1.;
			if (dist != 0)
			  param = dot / dist;

			var xx, yy;

			if (param < 0) {
				xx = p1.x;
				yy = p1.y;
			}
			else if (param > 1) {
				xx = p2.x;
				yy = p2.y;
			}
			else {
				xx = p1.x + param * C;
				yy = p1.y + param * D;
			}

			var dx = p0.x - xx;
			var dy = p0.y - yy;
			return dx * dx + dy * dy;
		}

		var pfirst = points[start];
		var plast = points[end];
		var index = 0;
		for( i in start + 1...end ) {
			var d = distPointSeg(points[i], pfirst, plast);
			if(d > dmax) {
				index = i;
				dmax = d;
			}
		}

		if( dmax >= epsilon * epsilon ) {
			optimizeRec(points, start, index, out, epsilon);
			out.pop();
			optimizeRec(points, index, end, out, epsilon);
		} else {
			out.push(points[start]);
			out.push(points[end]);
		}
	}

}
