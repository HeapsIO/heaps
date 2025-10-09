package h3d.col;

class Sphere extends Collider {

	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var r : Float;

	public inline function new(x=0., y=0., z=0., r=1.) {
		load(x, y, z, r);
	}

	public inline function load(sx=0., sy=0., sz=0., sr=0.) {
		this.x = sx;
		this.y = sy;
		this.z = sz;
		this.r = sr;
	}

	public inline function getCenter() {
		return new Point(x, y, z);
	}

	public inline function distance( p : Point ) {
		var d = distanceSq(p);
		return d < 0 ? -Math.sqrt(-d) : Math.sqrt(d);
	}

	public inline function distanceSq( p : Point ) {
		var dx = p.x - x;
		var dy = p.y - y;
		var dz = p.z - z;
		return dx * dx + dy * dy + dz * dz - r * r;
	}

	public inline function contains( p : Point ) {
		return distanceSq(p) < 0;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		var mx = r.px - x;
		var my = r.py - y;
		var mz = r.pz - z;
		var b = mx * r.lx + my * r.ly + mz * r.lz;
		var c = mx * mx + my * my + mz * mz - this.r * this.r;
		if ( c > 0.0 && b > 0.0 )
			return -1;
		var d = b * b - c;
		if ( d < 0.0 )
			return -1;
		var t = -b - Math.sqrt(d);
		return t < 0.0 ? 0.0 : t;
	}

	public inline function inFrustum( f : Frustum, ?m : h3d.Matrix ) {
		if( m != null ) return inFrustumMatrix(f,m);
		return f.hasSphere(this);
	}

	function inFrustumMatrix( f : Frustum, m : h3d.Matrix ) {
		var oldX = x, oldY = y, oldZ = z, oldR = r;
		var v = getCenter();
		v.transform(m);
		x = v.x;
		y = v.y;
		z = v.z;
		var scale = m.getScale();
		r *= Math.abs(Math.max(Math.max(scale.x, scale.y), scale.z));
		var res = f.hasSphere(this);
		x = oldX;
		y = oldY;
		z = oldZ;
		r = oldR;
		return res;
	}

	public function transform( m : h3d.Matrix ) {
		var s = m.getScale();
		var smax = hxd.Math.max(hxd.Math.max(hxd.Math.abs(s.x), hxd.Math.abs(s.y)), hxd.Math.abs(s.z));
		r *= smax;
		var pt = new h3d.col.Point(x,y,z);
		pt.transform(m);
		x = pt.x;
		y = pt.y;
		z = pt.z;
	}

	public inline function inSphere( s : Sphere ) {
		return new Point(x,y,z).distanceSq(new Point(s.x,s.y,s.z)) < (s.r + r)*(s.r + r);
	}

	public function toString() {
		return "Sphere{" + getCenter()+","+ hxd.Math.fmt(r) + "}";
	}

	public inline function dimension() {
		return r;
	}

	public inline function closestPoint( p : h3d.col.Point ) {
		var d = p.sub(getCenter()).normalized().scaled(r);
		return d.add(getCenter());
	}

	public inline function clone() {
		var s = new Sphere();
		s.x = x;
		s.y = y;
		s.z = z;
		s.r = r;
		return s;
	}

	#if !macro
	public function makeDebugObj() : h3d.scene.Object {
		var prim = h3d.prim.Sphere.defaultUnitSphere();
		var mesh = new h3d.scene.Mesh(prim);
		mesh.scale(r);
		mesh.setPosition(x,y,z);
		return mesh;
	}
	#end

}