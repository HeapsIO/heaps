package h3d.col;
using hxd.Math;

class Point {

	public var x : Float;
	public var y : Float;
	public var z : Float;

	public inline function new(x=0.,y=0.,z=0.) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function inFrustum( mvp : Matrix ) {
		if( !Plane.frustumLeft(mvp).side(this) )
			return false;
		if( !Plane.frustumRight(mvp).side(this) )
			return false;
		if( !Plane.frustumBottom(mvp).side(this) )
			return false;
		if( !Plane.frustumTop(mvp).side(this) )
			return false;
		if( !Plane.frustumNear(mvp).side(this) )
			return false;
		if( !Plane.frustumFar(mvp).side(this) )
			return false;
		return true;
	}

	public inline function set(x, y, z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public inline function sub( p : Point ) {
		return new Point(x - p.x, y - p.y, z - p.z);
	}

	public inline function add( p : Point ) {
		return new Point(x + p.x, y + p.y, z + p.z);
	}

	public inline function cross( p : Point ) {
		return new Point(y * p.z - z * p.y, z * p.x - x * p.z,  x * p.y - y * p.x);
	}

	public inline function lengthSq() {
		return x * x + y * y + z * z;
	}

	public inline function length() {
		return lengthSq().sqrt();
	}

	public inline function dot( p : Point ) {
		return x * p.x + y * p.y + z * p.z;
	}

	public inline function distanceSq( p : Point ) {
		var dx = p.x - x;
		var dy = p.y - y;
		var dz = p.z - z;
		return dx * dx + dy * dy + dz * dz;
	}

	public inline function distance( p : Point ) {
		return distanceSq(p).sqrt();
	}


	public function normalize() {
		var k = x * x + y * y + z * z;
		if( k < hxd.Math.EPSILON ) k = 0 else k = k.invSqrt();
		x *= k;
		y *= k;
		z *= k;
	}

	public inline function transform( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + m._43;
		x = px;
		y = py;
		z = pz;
	}

	public inline function toVector() {
		return new Vector(x, y, z);
	}

	public inline function clone() {
		return new Point(x,y,z);
	}

	public function toString() {
		return '{${x.fmt()},${y.fmt()},${z.fmt()}}';
	}

}