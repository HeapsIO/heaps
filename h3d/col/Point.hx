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

	public inline function scale( v : Float ) {
		x *= v;
		y *= v;
		z *= v;
	}

	public inline function inFrustum( f : Frustum ) {
		return f.hasPoint(this);
	}

	public inline function set(x, y, z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public inline function multiply( f : Float ) {
		return new Point(x * f, y * f, z * f);
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

	public inline function setLength(len:Float) {
		normalizeFast();
		x *= len;
		y *= len;
		z *= len;
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

	public inline function normalizeFast() {
		var k = x * x + y * y + z * z;
		k = k.invSqrt();
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

	public inline function transform3x3( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31;
		var py = x * m._12 + y * m._22 + z * m._32;
		var pz = x * m._13 + y * m._23 + z * m._33;
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

	public inline function load( p : Point ) {
		this.x = p.x;
		this.y = p.y;
		this.z = p.z;
	}

	public function toString() {
		return 'Point{${x.fmt()},${y.fmt()},${z.fmt()}}';
	}

}