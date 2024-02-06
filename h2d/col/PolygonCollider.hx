package h2d.col;

/**
	A `Collider` wrapper around `Polygons` to enable using those for hit-testing testing.
**/
class PolygonCollider extends Collider {
	/**
		The Polygons instance used for collision checks.
	**/
	public var polygons : Polygons;
	/**
		Whether Polygons is convex or concave.
		Convex polygons are cheaper to test against.
	**/
	public var isConvex : Bool;

	/**
		Create new PolygonCollider with specified Polygons and flag to check as convex or concave.
	**/
	public function new( polygons:Polygons, isConvex : Bool = false ) {
		this.polygons = polygons;
		this.isConvex = isConvex;
	}

	/**
		Test is Point `p` is inside `polygons`.
	**/
	public function contains( p : Point ) {
		if (polygons == null) return false;
		return polygons.contains(p, isConvex);
	}

	public function collideCircle( c : Circle ) : Bool {
		throw "Not implemented";
	}

	public function collideBounds( b : Bounds ) : Bool {
		throw "Not implemented";
	}

}