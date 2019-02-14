package h3d.col;

class Sphere implements Collider {

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

	public inline function contains( p : Point ) {
		var dx = p.x - x;
		var dy = p.y - y;
		var dz = p.z - z;
		return dx * dx + dy * dy + dz * dz < r * r;
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

	public inline function inFrustum( f : Frustum ) {
		return f.hasSphere(this);
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