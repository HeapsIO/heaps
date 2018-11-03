package h2d.col;

class PolygonCollider implements Collider {

	public var polygons : Polygons;
	public var isConvex : Bool;

	/**
		Create new PolygonCollider with specified Polygons and flag to check as convex or concave.
	**/
	public function new( polygons:Polygons, isConvex : Bool = false ) {
		this.polygons = polygons;
		this.isConvex = isConvex;
	}

	public function contains( p : Point ) {
		if (polygons == null) return false;
		return polygons.contains(p, isConvex);
	}

}