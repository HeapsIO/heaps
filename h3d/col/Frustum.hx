package h3d.col;

class Frustum {

	public var pleft : Plane;
	public var pright : Plane;
	public var ptop : Plane;
	public var pbottom : Plane;
	public var pnear : Plane;
	public var pfar : Plane;
	public var checkNearFar : Bool = true;

	public function new( mvp : h3d.Matrix ) {
		pleft = Plane.frustumLeft(mvp);
		pright = Plane.frustumRight(mvp);
		ptop = Plane.frustumTop(mvp);
		pbottom = Plane.frustumBottom(mvp);
		pnear = Plane.frustumNear(mvp);
		pfar = Plane.frustumFar(mvp);
		pleft.normalize();
		pright.normalize();
		ptop.normalize();
		pbottom.normalize();
		pnear.normalize();
		pfar.normalize();
	}

	public function transform( m : h3d.Matrix ) @:privateAccess {
		var m2 = new h3d.Matrix();
		m2.initInverse(m);
		m2.transpose();

		pleft.transformInverseTranspose(m2);
		pright.transformInverseTranspose(m2);
		ptop.transformInverseTranspose(m2);
		pbottom.transformInverseTranspose(m2);
		pfar.transformInverseTranspose(m2);
		pnear.transformInverseTranspose(m2);

		pleft.normalize();
		pright.normalize();
		ptop.normalize();
		pbottom.normalize();
		pnear.normalize();
		pfar.normalize();
	}

	public function transform3x3( m : h3d.Matrix ) @:privateAccess {
		var m2 = new h3d.Matrix();
		m2.initInverse3x3(m);
		m2.transpose();

		pleft.transformInverseTranspose(m2);
		pright.transformInverseTranspose(m2);
		ptop.transformInverseTranspose(m2);
		pbottom.transformInverseTranspose(m2);
		pfar.transformInverseTranspose(m2);
		pnear.transformInverseTranspose(m2);

		pleft.normalize();
		pright.normalize();
		ptop.normalize();
		pbottom.normalize();
		pnear.normalize();
		pfar.normalize();
	}

	public function hasSphere( s : Sphere ) {
		var p = s.getCenter();
		if( pleft.distance(p) < -s.r ) return false;
		if( pright.distance(p) < -s.r ) return false;
		if( ptop.distance(p) < -s.r ) return false;
		if( pbottom.distance(p) < -s.r ) return false;
		if( checkNearFar ) {
			if( pnear.distance(p) < -s.r ) return false;
			if( pfar.distance(p) < -s.r ) return false;
		}
		return true;
	}

	public function hasBounds( b : Bounds ) @:privateAccess {
		if( b.testPlane(pleft) < 0 )
			return false;
		if( b.testPlane(pright) < 0 )
			return false;
		if( b.testPlane(ptop) < 0 )
			return false;
		if( b.testPlane(ptop) < 0 )
			return false;
		if( b.testPlane(pnear) < 0 )
			return false;
		if( b.testPlane(pfar) < 0 )
			return false;
		return true;
	}

}