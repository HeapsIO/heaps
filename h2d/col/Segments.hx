package h2d.col;
import hxd.Math;

/**
	Another way to represent a Polygon. Segments must be connected.
	This allows efficient distance calculus.
**/
abstract Segments(Array<Segment>) from Array<Segment> to Array<Segment> {

	public var segments(get, never) : Array<Segment>;
	inline function get_segments() return this;
	public var length(get, never) : Int;
	inline function get_length() return this.length;

	public inline function iterator() {
		return new hxd.impl.ArrayIterator(this);
	}

	/**
		Tests if Point `p` is inside this Segments.
		@param p The Point to test against.
		@param isConvex Use simplified collision test suited for convex polygons. Results are undefined if polygon is concave.
		Currently only convex check is implemented and using non-convex test results in an exception.
	**/
	public function containsPoint( p : Point, isConvex : Bool ) {
		if( isConvex ) {
			for( s in segments )
				if( s.side(p) < 0 )
					return false;
		} else {
			throw "TODO";
		}
		return true;
	}

	/**
		Converts this Segments to a `Polygon`.
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