package h3d;
import h3d.impl.Tools;

class Vector {

	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var w : Float;

	public function new( x = 0., y = 0., z = 0., w = 1. ) {
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
		return Math.sqrt(x * x + y * y + z * z);
	}

	public function normalize() {
		var k = length();
		if( k < Tools.EPSILON ) k = 0 else k = 1.0 / k;
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
	
	public inline function project3x3( m : Matrix ) {
		var px = x * m._11 + y * m._12 + z * m._13;
		var py = x * m._21 + y * m._22 + z * m._23;
		var pz = x * m._31 + y * m._32 + z * m._33;
		x = px;
		y = py;
		z = pz;
	}

	public inline function copy() {
		return new Vector(x,y,z,w);
	}

	public function toString() {
		return "{"+Tools.f(x)+","+Tools.f(y)+","+Tools.f(z)+","+Tools.f(w)+"}";
	}

}