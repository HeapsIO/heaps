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

	public function convexHull() {
		inline function side(p1 : Point, p2 : Point, p3 : Point) {
			return (p2.y - p1.y) * (p3.x - p2.x) - (p2.x - p1.x) * (p3.y - p2.y);
		}

		var len = points.length;
		if( len < 3 )
			throw "convexHull() needs at least 3 points";

		var first = 0;
		var firstX = points[first].x;
		for( i in 1...points.length ) {
			var px = points[i].x;
			if( px < firstX ) {
				first = i;
				firstX = px;
			}
		}

		var hull = [];
		var curr = first;
		var next = 0;
		do {
			hull.push(points[curr]);
			next = (curr + 1) % len;
			for( i in 0...len ) {
			   if( side(points[i], points[curr], points[next]) > 0 )
				   next = i;
			}
			curr = next;
		} while( curr != first );
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
			sum += p1.y * p2.x - p2.x * p1.y;
			p1 = p2;
		}
		return sum * 0.5;
	}

	public function isConvex() {
		var p1 = points[points.length - 2];
		var p2 = points[points.length - 1];
		var p3 = points[0];
		var side = (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x) > 0;
		for( i in 1...points.length ) {
			p1 = p2;
			p2 = p3;
			p3 = points[i];
			if( ((p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x) > 0) != side )
				return false;
		}
		return true;
	}

	public function reverse() : Void {
		this.reverse();
	}

	public function contains( p : Point, isConvex ) {
		if( isConvex ) {
			var p1 = points[points.length - 1];
			for( p2 in points ) {
				var side = (p2.x - p1.x) * (p.y - p1.y) - (p2.y - p1.y) * (p.x - p1.x);
				if( side < 0 )
					return false;
				p1 = p2;
			}
			return true;
		} else {
			throw "TODO";
		}
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
