package h3d.col;

class ObjectCollider implements Collider {

	public var obj : h3d.scene.Object;
	public var collider : Collider;
	static var TMP_RAY = new Ray();
	static var TMP_MAT = new Matrix();

	public function new(obj, collider) {
		this.obj = obj;
		this.collider = collider;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		var tmpRay = TMP_RAY;
		TMP_RAY = null;
		tmpRay.load(r);
		r.transform(obj.getInvPos());
		var hit = collider.rayIntersection(r, bestMatch);
		if( hit < 0 ) {
			r.load(tmpRay);
			TMP_RAY = tmpRay;
			return hit;
		}
		var pt = r.getPoint(hit);
		pt.transform(@:privateAccess obj.absPos);
		r.load(tmpRay);
		TMP_RAY = tmpRay;
		return hxd.Math.distance(pt.x - r.px, pt.y - r.py, pt.z - r.pz);
	}

	public function contains( p : Point ) {
		var ptmp = p.clone();
		p.transform(obj.getInvPos());
		var b = collider.contains(p);
		p.load(ptmp);
		return b;
	}

	public function inFrustum( f : Frustum, ?m : h3d.Matrix ) {
		if( m == null )
			return collider.inFrustum(f, obj.getAbsPos());
		var mat = TMP_MAT;
		mat.multiply3x4inline(m, obj.getAbsPos());
		return collider.inFrustum(f, mat);
	}

	public function inSphere( s : Sphere ) {
		var invMat = obj.getInvPos();
		var oldX = s.x, oldY = s.y, oldZ = s.z, oldR = s.r;
		var center = s.getCenter();
		center.transform(invMat);
		var scale = invMat.getScale();
		s.x = center.x;
		s.y = center.y;
		s.z = center.z;
		s.r *= Math.max(Math.max(scale.x, scale.y), scale.z);
		var res = collider.inSphere(s);
		s.x = oldX;
		s.y = oldY;
		s.z = oldZ;
		s.r = oldR;
		return res;
	}

	#if !macro
	public function makeDebugObj() : h3d.scene.Object {
		var ret = collider.makeDebugObj();
		if( ret != null ) {
			ret.ignoreParentTransform = true;
			ret.follow = obj;
		}
		return ret;
	}
	#end

}