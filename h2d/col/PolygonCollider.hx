package h2d.col;

class PolygonCollider implements Collider {

	/**
		Shortcut for first polygon in `polygons` in case when only one polygon is used for collider.
	**/
	public var polygon(get, set) : Polygon;
	public var polygons : Polygons;
	public var isConvex : Bool;

	/**
		Create new PolygonCollider with specified polygon or polygons and flag to check as convex or concave.
		If both are present, polygon is inserted at the start of polygon list.
	**/
	public function new( ?polygon:Polygon, ?polygons:Polygons, isConvex : Bool = false ) {
		if (polygons == null) polygons = new Polygons();
		if (polygon != null) (polygons:Array<Polygon>).unshift(polygon);
		this.polygons = polygons;
		this.isConvex = isConvex;
	}

	inline function get_polygon() {
		return polygons != null ? polygons[0] : null;
	}

	inline function set_polygon( poly : Polygon ) {
		if (polygons == null) polygons = new Polygons([poly]);
		else polygons[0] = poly;
		return poly;
	}

	public function contains( p : Point ) {
		if (polygons == null) return false;
		return polygons.contains(p, isConvex);
	}

}