package h2d.col;
import hxd.Math;

@:forward(push,remove,insert,copy)
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

	inline function xSort(a : Point, b : Point) {
		if(a.x == b.x)
			return a.y < b.y ? -1 : 1;
		return a.x < b.x ? -1 : 1;
	}

	//see Monotone_chain convex hull algorithm
	public function convexHull() {
		var len = points.length;
		if( points.length < 3 )
			return points;

		points.sort(xSort);

		var hull = [];
		var k = 0;
		for (p in points) {
			while (k >= 2 && side(hull[k - 2], hull[k - 1], p) <= 0)
				k--;
			hull[k++] = p;
		}

	   var i = points.length - 2;
	   var len = k + 1;
	   while(i >= 0) {
			var p = points[i];
			while (k >= len && side(hull[k - 2], hull[k - 1], p) <= 0)
				k--;
			hull[k++] = p;
			i--;
	   }

	   while( hull.length >= k )
			hull.pop();
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

	public function centroid() {
		var A = 0.;
		var cx = 0.;
		var cy = 0.;

		var p0 = points[points.length - 1];
		for(p in points) {
			var a = p0.x * p.y - p.x * p0.y;
			cx += (p0.x + p.x) * a;
			cy += (p0.y + p.y) * a;
			A += a;
			p0 = p;
		}

		A *= 0.5;
		cx *= 1 / (6 * A);
		cy *= 1 / (6 * A);

		return new h2d.col.Point(cx, cy);
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

	public function transform(mat: h2d.col.Matrix) {
		for( i in 0...points.length ) {
			points[i] = mat.transform(points[i]);
		}
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

	public function findClosestPoint(pt : h2d.col.Point, maxDist : Float) {
		var closest = null;
		var minDist = maxDist * maxDist;
		for(cp in points) {
			var sqDist = cp.distanceSq(pt);
			if(sqDist < minDist) {
				closest = cp;
				minDist = sqDist;
			}
		}
		return closest;
	}

	/**
		Return the closest point on the edges of the polygon
	**/
	public function projectPoint(pt: h2d.col.Point) {
		var p1 = points[points.length - 1];
		var closestProj = null;
		var minDistSq = 1e10;
		for(p2 in points) {
			var proj = new Segment(p1, p2).project(pt);
			var distSq = proj.distanceSq(pt);
			if(distSq < minDistSq) {
				closestProj = proj;
				minDistSq = distSq;
			}
			p1 = p2;
		}
		return closestProj;
	}

	/**
		Return the squared distance of `pt` to the closest edge.
		If outside is `true`, only return a positive value if `pt` is outside the polygon, zero otherwise
		If outside is `false`, only return a positive value if `pt` is inside the polygon, zero otherwise
	**/
	public function distanceSq(pt : Point, ?outside : Bool) {
		var p1 = points[points.length - 1];
		var minDistSq = 1e10;
		for(p2 in points) {
			var s = new Segment(p1, p2);
			if(outside == null || s.side(pt) < 0 == outside) {
				var dist = s.distanceSq(pt);
				if(dist < minDistSq)
					minDistSq = dist;
			}
			p1 = p2;
		}
		return minDistSq == 1e10 ? 0. : minDistSq;
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
