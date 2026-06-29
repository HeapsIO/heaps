package h2d.col;
import hxd.Math;

/**
	An abstract over the list of `Segment`s. Alternative representation of a polygon.

	Segments must be connected to form a complete polygonal shape.
	Provides a more efficient distance calculus.

	@see `h2d.Polygon`
**/
abstract Segments(Array<Segment>) from Array<Segment> to Array<Segment> {

	/**
		The underlying Array of segments.
	**/
	public var segments(get, never) : Array<Segment>;
	inline function get_segments() return this;
	/**
		The amount of segments in the polygon.
	**/
	public var length(get, never) : Int;
	inline function get_length() return this.length;

	@:dox(hide)
	public inline function iterator() {
		return new hxd.impl.ArrayIterator(this);
	}

	/**
		Tests if Point `p` is inside this Segments.
		@param p The Point to test against.
		@param isConvex Use simplified collision test suited for convex polygons. Results are undefined if polygon is concave.

		**Note**: Currently only convex check is implemented and using non-convex test results in an exception.
	**/
	public function containsPoint( p : Point, isConvex : Bool ) {
		if( isConvex ) {
			for( s in segments )
				if( s.side(p) < 0 )
					return false;
		} else {
			// Ray-casting (winding number) algorithm for arbitrary polygons.
			// Counts intersections of a horizontal ray starting from point p and going right.
			var w = 0;
			for( s in segments ) {
				var startY = s.y;
				var endY = s.y + s.dy;
				if( endY <= p.y ) {
					if( startY > p.y && s.side(p) < 0 )
						w++;
				} else if( startY <= p.y && s.side(p) > 0 ) {
					w--;
				}
			}
			return w != 0;
		}
		return true;
	}

	/**
		Converts this Segments to a Polygon.
	**/
	public function toPolygon() : Polygon {
		return [for( s in segments ) new h2d.col.Point(s.x, s.y)];
	}

	/**
		Projects Point `p` onto closest Segment in Segments and returns new Point with projected position.
	**/
	public function project( p : Point ) : Point {
		var dmin = 1e20, smin = null;
		for( s in segments ) {
			var d = s.distanceSq(p);
			if( d < dmin ) {
				dmin = d;
				smin = s;
			}
		}
		return smin.project(p);
	}

	/**
		Returns squared distance from the Segments to the Point `p`.
	**/
	public function distanceSq( p : Point ) {
		var dmin = 1e20;
		for( s in segments ) {
			var d = s.distanceSq(p);
			if( d < dmin ) dmin = d;
		}
		return dmin;
	}

	/**
		Returns distance from the Segments to the Point `p`.
	**/
	public inline function distance( p : Point ) {
		return Math.sqrt(distanceSq(p));
	}

}