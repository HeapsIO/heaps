package h3d.col;
using hxd.Math;

class Point #if apicheck implements h2d.impl.PointApi<Point,Matrix> #end {

	public var x : Float;
	public var y : Float;
	public var z : Float;

	// -- gen api ---

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

	public inline function set(x=0., y=0., z=0.) {
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

	public inline function multiply( v : Float ) {
		return new Point(x * v, y * v, z * v);
	}

	public inline function cross( p : Point ) {
		return new Point(y * p.z - z * p.y, z * p.x - x * p.z,  x * p.y - y * p.x);
	}

	public inline function equals( other : Point ) : Bool {
		return x == other.x && y == other.y && z == other.z;
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

	public inline function normalize() {
		var k = x * x + y * y + z * z;
		if( k < hxd.Math.EPSILON ) k = 0 else k = k.invSqrt();
		x *= k;
		y *= k;
		z *= k;
	}

	public inline function normalized() {
		var k = x * x + y * y + z * z;
		if( k < hxd.Math.EPSILON ) k = 0 else k = k.invSqrt();
		return new Point(x*k,y*k,z*k);
	}

	public inline function lerp( p1 : Point, p2 : Point, k : Float ) {
		var x = Math.lerp(p1.x, p2.x, k);
		var y = Math.lerp(p1.y, p2.y, k);
		var z = Math.lerp(p1.z, p2.z, k);
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public inline function transform( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + m._43;
		x = px;
		y = py;
		z = pz;
	}

	public inline function transformed( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + m._43;
		return new Point(px,py,pz);
	}

	public inline function transform3x3( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31;
		var py = x * m._12 + y * m._22 + z * m._32;
		var pz = x * m._13 + y * m._23 + z * m._33;
		x = px;
		y = py;
		z = pz;
	}

	public inline function transformed3x3( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31;
		var py = x * m._12 + y * m._22 + z * m._32;
		var pz = x * m._13 + y * m._23 + z * m._33;
		return new Point(px,py,pz);
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

	// ----

	public inline function inFrustum( f : Frustum, ?m : h3d.Matrix ) {
		return f.hasPoint(this);
	}

	public inline function toVector() {
		return new Vector(x, y, z);
	}


}