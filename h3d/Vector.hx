package h3d;

class Vector {

	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var w : Float;

	public inline function new( x = 0., y = 0., z = 0., w = 1. ) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public inline function sub( v : Vector ) {
		return new Vector(x - v.x, y - v.y, z - v.z, w - v.w);
	}

	public inline function add( v : Vector ) {
		return new Vector(x + v.x, y + v.y, z + v.z, w + v.w);
	}

	public inline function cross( v : Vector ) {
		return new Vector(y * v.z - z * v.y, z * v.x - x * v.z,  x * v.y - y * v.x, 1);
	}

	public inline function dot3( v : Vector ) {
		return x * v.x + y * v.y + z * v.z;
	}

	public inline function dot4( v : Vector ) {
		return x * v.x + y * v.y + z * v.z + w * v.w;
	}
	
	public inline function length() {
		return FMath.sqrt(x * x + y * y + z * z);
	}

	public function normalize() {
		var k = x * x + y * y + z * z;
		if( k < FMath.EPSILON ) k = 0 else k = FMath.isqrt(k);
		x *= k;
		y *= k;
		z *= k;
	}

	public function set(x,y,z,w=1.) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public inline function scale3( f : Float ) {
		x *= f;
		y *= f;
		z *= f;
	}
	
	public inline function project( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + w * m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + w * m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + w * m._43;
		var w = 1 / (x * m._14 + y * m._24 + z * m._34 + w * m._44);
		x = px * w;
		y = py * w;
		z = pz * w;
		w = 1;
	}
	
	public inline function transform3x4( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + w * m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + w * m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + w * m._43;
		x = px;
		y = py;
		z = pz;
	}

	public inline function transform( m : Matrix ) {
		var px = x * m._11 + y * m._21 + z * m._31 + w * m._41;
		var py = x * m._12 + y * m._22 + z * m._32 + w * m._42;
		var pz = x * m._13 + y * m._23 + z * m._33 + w * m._43;
		var pw = x * m._14 + y * m._24 + z * m._34 + w * m._44;
		x = px;
		y = py;
		z = pz;
		w = pw;
	}
	
	public inline function clone() {
		return new Vector(x,y,z,w);
	}

	public function toString() {
		return "{"+FMath.fmt(x)+","+FMath.fmt(y)+","+FMath.fmt(z)+","+FMath.fmt(w)+"}";
	}

}