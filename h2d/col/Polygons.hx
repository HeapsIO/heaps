package h2d.col;
import hxd.Math;

/**
	An abstract over an Array of `Polygon` instances that define multiple polygonal shapes that can be collision-tested against.
	@see `h2d.IPolygons`
**/
@:forward(push,remove)
abstract Polygons(Array<Polygon>) from Array<Polygon> to Array<Polygon> {

	/**
		An underlying Polygon array.
	**/
	public var polygons(get, never) : Array<Polygon>;
	/**
		The amount of polygons in the Polygons instance.
	**/
	public var length(get, never) : Int;
	inline function get_length() return this.length;
	inline function get_polygons() return this;

	/**
		Create a new Polygons instance.
		@param polygons An optional list of polygons to use.
	**/
	public inline function new( ?polygons ) {
		this = polygons == null ? [] : polygons;
	}

	@:dox(hide)
	public inline function iterator() {
		return new hxd.impl.ArrayIterator(this);
	}

	/**
		Converts Polygons instance to Int-based IPolygons.
	**/
	public function toIPolygons( scale = 1. ) : IPolygons {
		return [for( p in polygons ) p.toIPolygon(scale)];
	}

	/**
		Returns bounding box of all Polygon instances in Polygons.
		@param b Optional Bounds instance to be filled. Returns new Bounds instance if `null`.
	**/
	public function getBounds( ?b : Bounds ) {
		if( b == null ) b = new Bounds();
		for( p in polygons )
			p.getBounds(b);
		return b;
	}

	/**
		Returns new `PolygonCollider` instance containing this Polygons.
		@param isConvex Use simplified collision test suited for convex polygons. Results are undefined if polygon is concave.
	**/
	public function getCollider(isConvex : Bool = false) {
		return new PolygonCollider(this, isConvex);
	}

	/**
		Tests if Point `p` is inside any of the Polygon instances in Polygons.
		@param p The point to test against.
		@param isConvex Use simplified collision test suited for convex polygons. Results are undefined if polygon is concave.
	**/
	public function contains( p : Point, isConvex = false ) {
		for( pl in polygons )
			if( pl.contains(p, isConvex) )
				return true;
		return false;
	}

	/**
		Returns the distance from Point `p` to the area covered by the Polygon instances in Polygons, `0` if inside any of them.
		@param p The point to measure from.
		@param isConvex Use simplified collision test suited for convex polygons. Results are undefined if polygon is concave.
	**/
	public function distance( p : Point, isConvex = false ) {
		return Math.sqrt(distanceSq(p, isConvex));
	}

	/**
		Same as `distance` but returns the squared value.
	**/
	public function distanceSq( p : Point, isConvex = false ) {
		var best = 1e10;
		for( pl in polygons ) {
			if( pl.contains(p, isConvex) )
				return 0.;
			var d = pl.distanceSq(p);
			if( d < best ) best = d;
		}
		return best;
	}

	/**
		Optimizes all polygons and returns new Polygons instances. See [h2d.col.Polygon.optimize].
	**/
	public function optimize( epsilon : Float ) : Polygons {
		return [for( p in polygons ) p.optimize(epsilon)];
	}

}
