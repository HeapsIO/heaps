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

	public function checkSphere( s : Sphere ) {
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

}