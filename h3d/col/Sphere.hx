package h3d.col;

class Sphere implements RayCollider {

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

	public function rayIntersection( r : Ray, ?p : Point ) : Null<Point> {
		var r2 = this.r * this.r;
		var px = r.px + r.lx;
		var py = r.py + r.ly;
		var pz = r.pz + r.lz;

		var a = r.lx * r.lx + r.ly * r.ly + r.lz * r.lz;
		var b = 2 * r.lx * (x - px) +  2 * r.ly * (y - py) +  2 * r.lz * (z - pz);
		var c = (x * x + y * y + z * z) + (px * px + py * py + pz * pz) - 2 * (x * px + y * py + z * pz) - r2;

		var d = b * b - 4 * a * c;
		if( d < 0 )	return null;

		d = Math.sqrt(d);
		var t = ( -b + d) / (2 * a);
		if( p == null ) p = new Point();
		p.set(px - t * r.lx , py - t * r.ly, pz - t * r.lz);
		return p;
	}

	public function inFrustum( mvp : Matrix ) {
		var p = getCenter();
		var pl = Plane.frustumLeft(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		pl = Plane.frustumRight(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		pl = Plane.frustumBottom(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		pl = Plane.frustumTop(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		pl = Plane.frustumNear(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		pl = Plane.frustumNear(mvp);
		pl.normalize();
		if( pl.distance(p) > r )
			return false;
		return true;
	}

	public function toString() {
		return "Sphere{" + getCenter()+","+ hxd.Math.fmt(r) + "}";
	}

}