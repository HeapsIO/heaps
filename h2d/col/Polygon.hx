package h2d.col;
import hxd.Math;

/**
	An abstract around an Array of `Point`s that define a polygonal shape that can be collision-tested against.
	@see `h2d.col.IPolygon`
**/
@:forward(push,remove,insert,copy)
abstract Polygon(Array<Point>) from Array<Point> to Array<Point> {

	/**
		The underlying Array of vertices.
	**/
	public var points(get, never) : Array<Point>;
	/**
		The amount of vertices in the polygon.
	**/
	public var length(get, never) : Int;
	inline function get_length() return this.length;
	inline function get_points() return this;

	/**
		Create a new Polygon shape.
		@param points An optional array of vertices the polygon should use.
	**/
	public inline function new( ?points ) {
		this = points == null ? [] : points;
	}

	@:dox(hide)
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

	/**
		Returns new Segments instance containing polygon edges.
	**/
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

	/**
		Converts Polygon to Int-based IPolygon.
	**/
	public function toIPolygon( scale = 1. ) : IPolygon {
		return [for( p in points ) p.toIPoint(scale)];
	}

	/**
		Returns bounding box of the Polygon.
		@param b Optional Bounds instance to be filled. Returns new Bounds instance if `null`.
	**/
	public function getBounds( ?b : Bounds ) {
		if( b == null ) b = new Bounds();
		for( p in points )
			b.addPoint(p);
		return b;
	}

	/**
		Returns new `PolygonCollider` instance containing this Polygon.
		@param isConvex Use simplified collision test suited for convex polygons. Results are undefined if polygon is concave.
	**/
	public function getCollider(isConvex : Bool = false) {
		return new PolygonCollider([this], isConvex);
	}

	inline function xSort(a : Point, b : Point) {
		if(a.x == b.x)
			return a.y < b.y ? -1 : 1;
		return a.x < b.x ? -1 : 1;
	}

	/**
		Returns a new Polygon containing a convex hull of this Polygon.
		See Monotone chain algorithm for more details.
	**/
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

	/**
		Tests if polygon points are in the clockwise order.
	**/
	public function isClockwise() {
		var sum = 0.;
		var p1 = points[points.length - 1];
		for( p2 in points ) {
			sum += (p2.x - p1.x) * (p2.y + p1.y);
			p1 = p2;
		}
		return sum < 0; // Y axis is negative compared to classic maths
	}

	/**
		Calculates total area of the Polygon.
	**/
	public function area() {
		var sum = 0.;
		var p1 = points[points.length - 1];
		for( p2 in points ) {
			sum += p2.x * p1.y - p1.x * p2.y;
			p1 = p2;
		}
		return Math.abs(sum) * 0.5;
	}

	/**
		Calculates a centroid of the Polygon and returns its position.
	**/
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

	/**
		Tests if polygon is convex or concave.
	**/
	public function isConvex() {
		if(points.length < 4) return true;
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

	/**
		Reverses the Polygon points ordering. Can be used to change polygon from anti-clockwise to clockwise.
	**/
	public function reverse() : Void {
		this.reverse();
	}

	/**
		Transforms Polygon points by provided matrix.
	**/
	public function transform(mat: h2d.col.Matrix) {
		for( i in 0...points.length ) {
			points[i] = mat.transform(points[i]);
		}
	}

	/**
		Tests if Point `p` is inside this Polygon.
		@param p The point to test against.
		@param isConvex Use simplified collision test suited for convex polygons. Results are undefined if polygon is concave.
	**/
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

	/**
		Returns closest Polygon vertex to Point `pt` within set maximum distance.
		@param pt The point to test against.
		@param maxDist Maximum distance vertex can be away from `pt` before it no longer considered close.
		@returns A `Point` instance in the Polygon representing closest vertex (not the copy). `null` if no vertices were found near the `pt` within `maxDist`.
	**/
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
		Return the distance of `pt` to the closest edge.
		If outside is `true`, only return a positive value if `pt` is outside the polygon, zero otherwise
		If outside is `false`, only return a positive value if `pt` is inside the polygon, zero otherwise
	**/
	public function distance(pt : Point, ?outside : Bool) {
		return Math.sqrt(distanceSq(pt, outside));
	}

	/**
	 * Same as `distance` but returns the squared value
	 */
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

	public function rayIntersection( r : h2d.col.Ray, bestMatch : Bool ) : Float {
		var dmin = -1.;
		var p0 = points[points.length - 1];

		for(p in points) {
			if(r.side(p0) * r.side(p) > 0) {
				p0 = p;
				continue;
			}

			var u = ( r.lx * (p0.y - r.py) - r.ly * (p0.x - r.px) ) / ( r.ly * (p.x - p0.x) - r.lx * (p.y - p0.y) );
			var x = p0.x + u * (p.x - p0.x);
			var y = p0.y + u * (p.y - p0.y);
			var d = Math.distanceSq(x - r.px, y - r.py);

			if(d < dmin || dmin < 0) {
				if( !bestMatch ) return Math.sqrt(d);
				dmin = d;
			}
			p0 = p;
		}

		return dmin < 0 ? dmin : Math.sqrt(dmin);
	}

	// find orientation of ordered triplet (p, q, r).
	// 0 --> p, q and r are colinear
	// 1 --> Clockwise
	// 2 --> Counterclockwise
	inline function orientation(p : h2d.col.Point, q : h2d.col.Point, r : h2d.col.Point) {
		var v = side(p, q, r);
		if (v == 0)	return 0;  		// colinear
		return v > 0 ? 1 : -1; 	// clock or counterclock wise
	}

	/**
		p, q, r : must be colinear points!
		checks if 'r' lies on segment 'pq'
	**/
	inline function onSegment(p : h2d.col.Point, q : h2d.col.Point, r : h2d.col.Point) {
		if(r.x > Math.max(p.x, q.x)) return false;
		if(r.x < Math.min(p.x, q.x)) return false;
		if(r.y > Math.max(p.y, q.y)) return false;
		if(r.y < Math.min(p.y, q.y)) return false;
		return true;
	}

	/**
		check if segment 'p1q1' and 'p2q2' intersect.
	**/
	function intersect(p1 : h2d.col.Point, q1 : h2d.col.Point, p2 : h2d.col.Point, q2 : h2d.col.Point) {
		var s1 = orientation(p1, q1, p2);
		var s2 = orientation(p1, q1, q2);
		var s3 = orientation(p2, q2, p1);
		var s4 = orientation(p2, q2, q1);

		if (s1 != s2 && s3 != s4) return true;

		if((s1 == 0 && onSegment(p1, q1, p2))
		|| (s2 == 0 && onSegment(p1, q1, q2))
		|| (s3 == 0 && onSegment(p2, q2, p1))
		|| (s4 == 0 && onSegment(p2, q2, q1)))
			return true;

		return false;
	}

	/**
		Check if polygon self-intersect
	**/
	public function selfIntersecting() {
		if(points.length < 4) return false;

		for(i in 0...points.length - 2) {
			var p1 = points[i];
			var q1 = points[i+1];
			for(j in i+2...points.length) {
				var p2 = points[j];
				var q2 = points[(j+1) % points.length];
				if(q2 != p1 && intersect(p1, q1, p2, q2))
					return true;
			}
		}

		return false;
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
