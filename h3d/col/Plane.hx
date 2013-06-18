package h3d.col;

@:allow(h3d.col)
class Plane {
	
	var nx : Float;
	var ny : Float;
	var nz : Float;
	var d : Float;
	
	inline function new(nx, ny, nz, d) {
		this.nx = nx;
		this.ny = ny;
		this.nz = nz;
		this.d = d;
	}
	
	/**
		Returns the plan normal, with the distance in the w value
	**/
	public inline function getNormal() {
		return new h3d.Vector(nx, ny, nz, d);
	}
	
	/**
		Normalize the plan, so we can use distance().
	**/
	public inline function normalize() {
		var len = 1 / Math.sqrt(nx * nx + ny * ny + nz * nz);
		nx *= len;
		ny *= len;
		nz *= len;
		d *= len;
	}
	
	public function toString() {
		return "{" + FMath.fmt(nx) + "," + FMath.fmt(ny) + "," + FMath.fmt(nz) + "," + FMath.fmt(d) + "}";
	}
	
	/**
		Returns the signed distance between a point an the plane. This requires the plan to be normalized. If the distance is negative it means that we are "under" the plan.
	**/
	public inline function distance( p : Vector ) {
		return nx * p.x + ny * p.y + nz * p.z - d;
	}
	
	public inline function project( p : Vector ) : Vector {
		var d = distance(p);
		return new Vector(p.x + d * nx, p.y + d * ny, p.z + d * nz);
	}

	public inline function projectTo( p : Vector, out : Vector ) {
		var d = distance(p);
		out.x = p.x + d * nx;
		out.y = p.y + d * ny;
		out.z = p.z + d * nz;
	}
	
	public static inline function fromPoints( p0 : Vector, p1 : Vector, p2 : Vector ) {
		var d1 = p1.sub(p0);
		var d2 = p2.sub(p0);
		var n = d1.cross(d2);
		return new Plane(n.x,n.y,n.z,n.dot3(p0));
	}
	
	public static inline function fromNormalPoint( n : Vector, p : Vector ) {
		return new Plane(n.x,n.y,n.z,n.dot3(p));
	}
	
	public static inline function X(v:Float) {
		return new Plane( 1, 0, 0, v );
	}
	
	public static inline function Y(v:Float) {
		return new Plane( 0, 1, 0, v );
	}

	public static inline function Z(v:Float) {
		return new Plane( 0, 0, 1, v );
	}
	
}