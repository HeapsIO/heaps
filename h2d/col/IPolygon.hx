package h2d.col;
import hxd.Math;

enum OffsetKind {
	Square;
	Miter;
	Round( arc : Float );
}

@:forward(push,remove)
abstract IPolygon(Array<IPoint>) from Array<IPoint> to Array<IPoint> {

	public var points(get, never) : Array<IPoint>;
	public var length(get, never) : Int;
	inline function get_length() return this.length;
	inline function get_points() return this;

	public inline function new( ?points ) {
		this = points == null ? [] : points;
	}

	public inline function iterator() {
		return new hxd.impl.ArrayIterator(this);
	}

	public function toPolygon( scale = 1. ) {
		return [for( p in points ) p.toPoint(scale)];
	}

	public function getBounds( ?b : IBounds ) {
		if( b == null ) b = new IBounds();
		for( p in points )
			b.addPoint(p);
		return b;
	}

	public function union( p : IPolygon, withHoles = true ) : IPolygons {
		var c = new hxd.clipper.Clipper();
		if( !withHoles ) c.resultKind = NoHoles;
		c.addPolygon(this, Clip);
		c.addPolygon(p,Clip);
		return c.execute(Union, NonZero, NonZero);
	}

	public inline function intersection( p : IPolygon, withHoles = true ) : IPolygons {
		return clipperOp(p, Intersection, withHoles);
	}

	public inline function subtraction( p : IPolygon, withHoles = true ) : IPolygons {
		return clipperOp(p, Difference, withHoles);
	}

	public function offset( delta : Float, kind : OffsetKind, withHoles = true ) : IPolygons {
		var c = new hxd.clipper.Clipper.ClipperOffset();
		switch( kind ) {
		case Square:
			c.addPolygon(this, Square, ClosedPol);
		case Miter:
			c.addPolygon(this, Miter, ClosedPol);
		case Round(arc):
			c.ArcTolerance = arc;
			c.addPolygon(this, Round, ClosedPol);
		}
		if( !withHoles ) c.resultKind = NoHoles;
		return c.execute(delta);
	}

	function clipperOp( p : IPolygon, op, withHoles ) : IPolygons {
		var c = new hxd.clipper.Clipper();
		if( !withHoles ) c.resultKind = NoHoles;
		c.addPolygon(this, Subject);
		c.addPolygon(p, Clip);
		return c.execute(op, NonZero, NonZero);
	}

	public function convexHull() {
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
			   if( side(points[i], points[curr], points[next].toPoint()) < 0 )
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

	inline function side( p1 : IPoint, p2 : IPoint, t : Point ) {
		return (p2.x - p1.x) * (t.y - p1.y) - (p2.y - p1.y) * (t.x - p1.x);
	}

	public function isConvex() {
		var p1 = points[points.length - 2];
		var p2 = points[points.length - 1];
		var p3 = points[0];
		var s = side(p1, p2, p3.toPoint()) > 0;
		for( i in 1...points.length ) {
			p1 = p2;
			p2 = p3;
			p3 = points[i];
			if( side(p1, p2, p3.toPoint()) > 0 != s )
				return false;
		}
		return true;
	}

	public function reverse() : Void {
		this.reverse();
	}

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
		Creates a new optimized polygon by eliminating almost colinear edges according to epsilon distance.
	**/
	public function optimize( epsilon : Float ) : IPolygon {
		var out = [];
		optimizeRec(points, 0, points.length, out, epsilon);
		return out;
	}

	static function optimizeRec( points : Array<IPoint>, index : Int, len : Int, out : Array<IPoint>, epsilon : Float ) {
		var dmax = 0.;
		var result = [];

		inline function distPointSeg(p0:IPoint, p1:IPoint, p2:IPoint) {
			var A = p0.x - p1.x;
			var B = p0.y - p1.y;
			var C = p2.x - p1.x;
			var D = p2.y - p1.y;

			var dot = A * C + B * D;
			var dist = C * C + D * D;
			var param = -1.;
			if (dist != 0)
			  param = dot / dist;

			var xx : Float, yy : Float;

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

		var pfirst = points[index];
		var plast = points[len - 1];
		for( i in index+1...len - 1 ) {
			var d = distPointSeg(points[i], pfirst, plast);
			if(d > dmax) {
				index = i;
				dmax = d;
			}
		}

		if( dmax >= epsilon ) {
			optimizeRec(points, 0, index, out, epsilon);
			out.pop();
			optimizeRec(points, index, len, out, epsilon);
		} else {
			out.push(points[index]);
			out.push(points[len - 1]);
		}
	}

}
