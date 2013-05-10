package h3d.col;

@:allow(h3d.col)
class Plan {
	
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
	
	public static inline function fromPoints( p0 : Vector, p1 : Vector, p2 : Vector ) {
		var d1 = p1.sub(p0);
		var d2 = p2.sub(p0);
		var n = d1.cross(d2);
		return new Plan(n.x,n.y,n.z,n.dot3(p0));
	}
	
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
	
	public inline function distance( p : Vector ) {
		return nx * p.x + ny * p.y + nz * p.z - d;
	}

	public static inline function fromNormalPoint( n : Vector, p : Vector ) {
		return new Plan(n.x,n.y,n.z,n.dot3(p));
	}
	
	public static inline function X(v:Float) {
		return new Plan( 1, 0, 0, v );
	}
	
	public static inline function Y(v:Float) {
		return new Plan( 0, 1, 0, v );
	}

	public static inline function Z(v:Float) {
		return new Plan( 0, 0, 1, v );
	}
	
}