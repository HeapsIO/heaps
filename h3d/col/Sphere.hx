package h3d.col;

class Sphere {

	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var r : Float;

	public inline function new(x=0., y=0., z=0., r=0.) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.r = r;
	}

	public inline function getCenter() {
		return new Point(x, y, z);
	}

	public function inFrustum( mvp : Matrix ) {
		var p = getCenter();
		var pl = Plane.frustumLeft(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		var pl = Plane.frustumRight(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		var pl = Plane.frustumBottom(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		var pl = Plane.frustumTop(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		var pl = Plane.frustumNear(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		var pl = Plane.frustumNear(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		return true;
	}

	public function toString() {
		return "Sphere{" + getCenter()+","+ hxd.Math.fmt(r) + "}";
	}

}