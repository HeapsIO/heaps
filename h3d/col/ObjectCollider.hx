package h3d.col;

class ObjectCollider implements Collider implements h3d.impl.Serializable {

	@:s public var obj : h3d.scene.Object;
	@:s public var collider : Collider;
	var tmpRay = new Ray();

	public function new(obj, collider) {
		this.obj = obj;
		this.collider = collider;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		tmpRay.load(r);
		r.transform(obj.getInvPos());
		var hit = collider.rayIntersection(r, bestMatch);
		if( hit < 0 ) {
			r.load(tmpRay);
			return hit;
		}
		var pt = r.getPoint(hit);
		pt.transform(@:privateAccess obj.absPos);
		r.load(tmpRay);
		return hxd.Math.distance(pt.x - r.px, pt.y - r.py, pt.z - r.pz);
	}

	public function contains( p : Point ) {
		var ptmp = p.clone();
		p.transform(obj.getInvPos());
		var b = collider.contains(p);
		p.load(ptmp);
		return b;
	}

	public function inFrustum( mvp : h3d.Matrix ) {
		throw "Not implemented";
		return false;
	}

	#if hxbit
	function customSerialize( ctx : hxbit.Serializer ) {
	}
	function customUnserialize( ctx : hxbit.Serializer ) {
	}
	#end

}