package h3d.col;

class TransformCollider implements Collider {

	public var collider : Collider;
	public var mat(default, set) : h3d.Matrix;
	var invMat : h3d.Matrix;

	static var TMP_RAY = new Ray();
	static var TMP_MAT = new Matrix();

	public function new(mat, collider) {
		this.invMat = new h3d.Matrix();
		this.mat = mat;
		this.collider = collider;
	}

	function set_mat(m) {
		this.mat = m;
		invMat.initInverse(m);
		return m;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		var tmpRay = TMP_RAY;
		TMP_RAY = null;
		tmpRay.load(r);
		r.transform(invMat);
		var hit = collider.rayIntersection(r, bestMatch);
		if( hit < 0 ) {
			r.load(tmpRay);
			TMP_RAY = tmpRay;
			return hit;
		}
		var pt = r.getPoint(hit);
		pt.transform(mat);
		r.load(tmpRay);
		TMP_RAY = tmpRay;
		return hxd.Math.distance(pt.x - r.px, pt.y - r.py, pt.z - r.pz);
	}

	public function contains( p : Point ) {
		var ptmp = p.clone();
		p.transform(invMat);
		var b = collider.contains(p);
		p.load(ptmp);
		return b;
	}

	public function inFrustum( f : Frustum, ?m : h3d.Matrix ) {
		if( m == null )
			return collider.inFrustum(f, mat);
		var mat = TMP_MAT;
		mat.multiply3x4inline(m, this.mat);
		return collider.inFrustum(f, mat);
	}

	public function inSphere( s : Sphere ) {
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

	public static function make( mat : h3d.Matrix, col ) {
		if( mat.isIdentityEpsilon(1e-10) )
			return col;
		return new TransformCollider(mat, col);
	}

}