package h3d.col;

class Sphere implements Collider {

	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var r : Float;

	public inline function new(x=0., y=0., z=0., r=0.) {
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
		var r2 = this.r * this.r;
		var px = r.px + r.lx;
		var py = r.py + r.ly;
		var pz = r.pz + r.lz;

		var a = r.lx * r.lx + r.ly * r.ly + r.lz * r.lz;
		var b = 2 * r.lx * (x - px) +  2 * r.ly * (y - py) +  2 * r.lz * (z - pz);
		var c = (x * x + y * y + z * z) + (px * px + py * py + pz * pz) - 2 * (x * px + y * py + z * pz) - r2;

		var d = b * b - 4 * a * c;
		if( d < 0 )	return -1;

		d = Math.sqrt(d);
		var t = ( -b + d) / (2 * a);
		return 1 - t;
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
		r *= Math.max(Math.max(scale.x, scale.y), scale.z);
		var res = f.hasSphere(this);
		x = oldX;
		y = oldY;
		z = oldZ;
		r = oldR;
		return res;
	}

	public inline function inSphere( s : Sphere ) {
		return new Point(x,y,z).distanceSq(new Point(s.x,s.y,s.z)) < (s.r + r)*(s.r + r);
	}

	public function toString() {
		return "Sphere{" + getCenter()+","+ hxd.Math.fmt(r) + "}";
	}

	#if (hxbit && !macro)
	function customSerialize( ctx : hxbit.Serializer ) {
		ctx.addFloat(x);
		ctx.addFloat(y);
		ctx.addFloat(z);
		ctx.addFloat(r);
	}
	function customUnserialize( ctx : hxbit.Serializer ) {
		x = ctx.getFloat();
		y = ctx.getFloat();
		z = ctx.getFloat();
		r = ctx.getFloat();
	}
	#end

}