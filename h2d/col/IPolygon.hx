package h2d.col;
import hxd.Math;

/**
	The type of the edges when offsetting polygon with `IPolygon.offset`.
**/
enum OffsetKind {
	Square;
	Miter;
	Round( arc : Float );
}

/**
	An abstract around an Array of `IPoint`s that define a polygonal shape that can be collision-tested against.
	@see `h2d.col.Polygon`
**/
@:forward(push,remove)
abstract IPolygon(Array<IPoint>) from Array<IPoint> to Array<IPoint> {
	/**
		The underlying Array of vertices.
	**/
	public var points(get, never) : Array<IPoint>;
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
		Converts this IPolygon into a floating point-based Polygon.
	**/
	public function toPolygon( scale = 1. ) : Polygon {
		return [for( p in points ) p.toPoint(scale)];
	}

	/**
		Returns the bounding box of the IPolygon.
	**/
	public function getBounds( ?b : IBounds ) : IBounds {
		if( b == null ) b = new IBounds();
		for( p in points )
			b.addPoint(p);
		return b;
	}

	/**
		Combines this IPolygon and a given IPolygon `p` and returns the resulting IPolygons.
		@param p The IPolygon to union with.
		@param withHoles When enabled, keeps the holes in resulting polygons as a separate IPolygon.
	**/
	public function union( p : IPolygon, withHoles = true ) : IPolygons {
		var c = new hxd.clipper.Clipper();
		if( !withHoles ) c.resultKind = NoHoles;
		c.addPolygon(this, Clip);
		c.addPolygon(p,Clip);
		return c.execute(Union, NonZero, NonZero);
	}

	/**
		Calculates an intersection areas between this IPolygon and a given IPolygon `p` and returns the resulting IPolygons.
		@param p The IPolygon to intersect with.
		@param withHoles When enabled, keeps the holes in resulting polygons as a separate IPolygon. 
	**/
	public inline function intersection( p : IPolygon, withHoles = true ) : IPolygons {
		return clipperOp(p, Intersection, withHoles);
	}

	/**
		Subtracts the area of a given IPolygon `p` from this IPolygon and returns the resulting IPolygons.
		@param p The IPolygon to subtract with.
		@param withHoles When enabled, keeps the holes in resulting polygons as a separate IPolygon. 
	**/
	public inline function subtraction( p : IPolygon, withHoles = true ) : IPolygons {
		return clipperOp(p, Difference, withHoles);
	}

	/**
		Offsets the polygon edges by specified amount and returns the resulting IPolygons.
		@param delta The offset amount.
		@param kind The corner rounding method.
		@param withHoles When enabled, keeps the holes in resulting polygons as a separate IPolygon. 
	**/
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

	/**
		Returns a new IPolygon containing a convex hull of this IPolygon.
		See Monotone chain algorithm for more details.
	**/
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
			   if( side(points[i], points[curr], points[next]) < 0 )
				   next = i;
			}
			curr = next;
		} while( curr != first );
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
		Calculates total area of the IPolygon.
	**/
	public function area() {
		var sum = 0.;
		var p1 = points[points.length - 1];
		for( p2 in points ) {
			sum += p1.x * p2.y - p2.x * p1.y;
			p1 = p2;
		}
		return Math.abs(sum) * 0.5;
	}

	inline function side( p1 : IPoint, p2 : IPoint, t : IPoint ) {
		return (p2.x - p1.x) * (t.y - p1.y) - (p2.y - p1.y) * (t.x - p1.x);
	}

	/**
		Tests if the polygon is convex or concave.
	**/
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

	/**
		Reverses the IPolygon points ordering. Can be used to change polygon from anti-clockwise to clockwise.
	**/
	public function reverse() : Void {
		this.reverse();
	}

	/**
		Tests if Point `p` is inside this IPolygon.
		@param p The point to test against.
		@param isConvex Use simplified collision test suited for convex polygons. Results are undefined if polygon is concave.
	**/
	public function contains( p : Point, isConvex = false ) {
		if( isConvex ) {
			var p1 = points[points.length - 1];
			for( p2 in points ) {
				if( (p2.x - p1.x) * (p.y - p1.y) - (p2.y - p1.y) * (p.x - p1.x) < 0 )
					return false;
				p1 = p2;
			}
			return true;
		} else {
			var w = 0;
			var p1 = points[points.length - 1];
			for (p2 in points) {
				if (p2.y <= p.y) {
					if (p1.y > p.y && (p1.x - p2.x) * (p.y - p2.y) - (p1.y - p2.y) * (p.x - p2.x) > 0)
						w++;
				}
				else if (p1.y <= p.y && (p1.x - p2.x) * (p.y - p2.y) - (p1.y - p2.y) * (p.x - p2.x) < 0)
					w--;
				p1 = p2;
			}
			return w != 0;
		}
	}


	/**
		Creates a new optimized polygon by eliminating almost colinear edges according to the epsilon distance.
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
