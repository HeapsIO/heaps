package h3d.col;

interface RayCollider {

	public function rayIntersection( r : Ray, ?p : Point ) : Null<Point>;

}


class OptimizedCollider implements RayCollider {

	public var a : RayCollider;
	public var b : RayCollider;

	public function new(a, b) {
		this.a = a;
		this.b = b;
	}

	public function rayIntersection( r : Ray, ?p : Point ) : Null<Point> {
		if( a.rayIntersection(r, p) == null )
			return null;
		return b.rayIntersection(r, p);
	}

}
