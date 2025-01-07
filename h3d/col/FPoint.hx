package h3d.col;
using hxd.Math;

class FPoint {

	public var x : hxd.impl.Float32;
	public var y : hxd.impl.Float32;
	public var z : hxd.impl.Float32;

	public inline function new(x=0.,y=0.,z=0.) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public inline function set(x=0.,y=0.,z=0.) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public inline function sub( p : FPoint ) {
		return new FPoint(x - p.x, y - p.y, z - p.z);
	}

	public inline function add( p : FPoint ) {
		return new FPoint(x + p.x, y + p.y, z + p.z);
	}

	public inline function cross( p : FPoint ) {
		return new FPoint(y * p.z - z * p.y, z * p.x - x * p.z,  x * p.y - y * p.x);
	}

	public inline function dot( p : FPoint ) {
		return x * p.x + y * p.y + z * p.z;
	}

	public inline function distanceSq( v : FPoint ) {
		var dx = v.x - x;
		var dy = v.y - y;
		var dz = v.z - z;
		return dx * dx + dy * dy + dz * dz;
	}

	public inline function lengthSq() {
		return x * x + y * y + z * z;
	}

	public inline function normalized() {
		var k = lengthSq();
		if ( k < hxd.Math.EPSILON2 ) k = 0 else k = k.invSqrt();
		return new FPoint(x * k, y * k, z * k);
	}

	public inline function scaled(v : Float) {
		return new FPoint(x * v, y * v, z * v);
	}

	public function toString() {
		return 'FPoint{${x.fmt()},${y.fmt()},${z.fmt()}}';
	}

}