package h3d.col;

interface Collider {

	public function rayIntersection( r : Ray, ?p : Point ) : Null<Point>;
	public function contains( p : Point ) : Bool;
	public function inFrustum( mvp : h3d.Matrix ) : Bool;

}


class OptimizedCollider implements Collider {

	public var a : Collider;
	public var b : Collider;

	public function new(a, b) {
		this.a = a;
		this.b = b;
	}

	public function rayIntersection( r : Ray, ?p : Point ) : Null<Point> {
		if( a.rayIntersection(r, p) == null )
			return null;
		return b.rayIntersection(r, p);
	}
	
	public function contains( p : Point ) {
		return a.contains(p) && b.contains(p);
	}
	
	public function inFrustum( mvp : h3d.Matrix ) {
		return a.inFrustum(mvp) && b.inFrustum(mvp);
	}

}
