package h2d.col;
import hxd.Math;

@:forward(push,remove)
abstract Polygons(Array<Polygon>) from Array<Polygon> to Array<Polygon> {

	public var polygons(get, never) : Array<Polygon>;
	public var length(get, never) : Int;
	inline function get_length() return this.length;
	inline function get_polygons() return this;

	public inline function new( ?polygons ) {
		this = polygons == null ? [] : polygons;
	}

	public inline function iterator() {
		return new hxd.impl.ArrayIterator(this);
	}

	public function toIPolygons( scale = 1. ) : IPolygons {
		return [for( p in polygons ) p.toIPolygon(scale)];
	}

	public function getBounds( ?b : Bounds ) {
		if( b == null ) b = new Bounds();
		for( p in polygons )
			p.getBounds(b);
		return b;
	}

	public function contains( p : Point, isConvex = false ) {
		for( pl in polygons )
			if( pl.contains(p, isConvex) )
				return true;
		return false;
	}

	public function optimize( epsilon : Float ) : Polygons {
		return [for( p in polygons ) p.optimize(epsilon)];
	}

}
