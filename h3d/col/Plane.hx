package h3d.col;
import hxd.Math;

@:allow(h3d.col)
class Plane {

	// Place equation :  nx.X + ny.Y + nz.Z - d = 0
	var nx : Float;
	var ny : Float;
	var nz : Float;
	var d : Float;

	public inline function new(nx, ny, nz, d) {
		this.nx = nx;
		this.ny = ny;
		this.nz = nz;
		this.d = d;
	}

	/**
		Returns the plan normal
	**/
	public inline function getNormal() {
		return new Point(nx, ny, nz);
	}

	public inline function getNormalDistance() {
		return d;
	}

	public inline function load( p : Plane ) {
		nx = p.nx;
		ny = p.ny;
		nz = p.nz;
		d = p.d;
	}

	public function transform( m : h3d.Matrix ) {
		var m2 = new h3d.Matrix();
		m2.initInverse(m);
		m2.transpose();
		transformInverseTranspose(m2);
	}

	public function transform3x3( m : h3d.Matrix ) {
		var m2 = new h3d.Matrix();
		m2.initInverse3x3(m);
		m2.transpose();
		transformInverseTranspose(m2);
	}

	inline function transformInverseTranspose(m:h3d.Matrix) {
		var v = new h3d.Vector(nx, ny, nz, -d);
		v.transform(m);
		nx = v.x;
		ny = v.y;
		nz = v.z;
		d = -v.w;
	}

	/**
		Normalize the plan, so we can use distance().
	**/
	public inline function normalize() {
		var len = Math.invSqrt(nx * nx + ny * ny + nz * nz);
		nx *= len;
		ny *= len;
		nz *= len;
		d *= len;
	}

	public function toString() {
		return "Plane{" + getNormal()+","+ hxd.Math.fmt(d) + "}";
	}

	/**
		Returns the signed distance between a point an the plane. This requires the plan to be normalized. If the distance is negative it means that we are "under" the plan.
	**/
	public inline function distance( p : Point ) {
		return nx * p.x + ny * p.y + nz * p.z - d;
	}

	public inline function side( p : Point ) {
		return distance(p) >= 0;
	}

	public inline function project( p : Point ) : Point {
		var d = distance(p);
		return new Point(p.x - d * nx, p.y - d * ny, p.z - d * nz);
	}

	public inline function projectTo( p : Point, out : Point ) {
		var d = distance(p);
		out.x = p.x - d * nx;
		out.y = p.y - d * ny;
		out.z = p.z - d * nz;
	}

	public static inline function fromPoints( p0 : Point, p1 : Point, p2 : Point ) {
		var d1 = p1.sub(p0);
		var d2 = p2.sub(p0);
		var n = d1.cross(d2);
		return new Plane(n.x,n.y,n.z,n.dot(p0));
	}

	public static inline function fromNormalPoint( n : Point, p : Point ) {
		return new Plane(n.x,n.y,n.z,n.dot(p));
	}

	public static inline function X(v:Float=0.0) {
		return new Plane( 1, 0, 0, v );
	}

	public static inline function Y(v:Float=0.0) {
		return new Plane( 0, 1, 0, v );
	}

	public static inline function Z(v:Float=0.0) {
		return new Plane( 0, 0, 1, v );
	}

	public static inline function frustumLeft( mvp : Matrix ) {
		return new Plane(mvp._14 + mvp._11, mvp._24 + mvp._21 , mvp._34 + mvp._31, -(mvp._44 + mvp._41));
	}

	public static inline function frustumRight( mvp : Matrix ) {
		return new Plane(mvp._14 - mvp._11, mvp._24 - mvp._21 , mvp._34 - mvp._31, mvp._41 - mvp._44);
	}

	public static inline function frustumBottom( mvp : Matrix ) {
		return new Plane(mvp._14 + mvp._12, mvp._24 + mvp._22 , mvp._34 + mvp._32, -(mvp._44 + mvp._42));
	}

	public static inline function frustumTop( mvp : Matrix ) {
		return new Plane(mvp._14 - mvp._12, mvp._24 - mvp._22 , mvp._34 - mvp._32, mvp._42 - mvp._44);
	}

	public static inline function frustumNear( mvp : Matrix ) {
		return new Plane(mvp._13, mvp._23, mvp._33, -mvp._43);
	}

	public static inline function frustumFar( mvp : Matrix ) {
		return new Plane(mvp._14 - mvp._13, mvp._24 - mvp._23, mvp._34 - mvp._33, mvp._43 - mvp._44);
	}

}