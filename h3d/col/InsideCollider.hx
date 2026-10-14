package h3d.col;

/**
	Wraps a collider so that a ray starting inside it hits it at distance 0, instead of missing it.
**/
class InsideCollider extends Collider {

	public var collider : Collider;

	public function new(collider) {
		this.collider = collider;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		var d = collider.rayIntersection(r, bestMatch);
		if( d < 0 && collider.contains(r.getPoint(0)) )
			return 0;
		return d;
	}

	public function contains( p : Point ) {
		return collider.contains(p);
	}

	public function inFrustum( f : Frustum, ?m : h3d.Matrix ) {
		return collider.inFrustum(f, m);
	}

	public function inSphere( s : Sphere ) {
		return collider.inSphere(s);
	}

	public function dimension() {
		return collider.dimension();
	}

	public function closestPoint( p : Point ) {
		return collider.closestPoint(p);
	}

	#if !macro
	public function makeDebugObj() : h3d.scene.Object {
		return collider.makeDebugObj();
	}
	#end

}
