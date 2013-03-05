package h3d;
import h3d.impl.Tools;

class Point {

	public var x : Float;
	public var y : Float;
	public var z : Float;
	
	public function new(x=0.,y=0.,z=0.) {
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
		return new Vector(y * p.z - z * p.y, z * p.x - x * p.z,  x * p.y - y * p.x);
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
	
	public function transform( m : Matrix ) {
		return new Point(x * m._11 + y * m._21 + z * m._31 + m._41, x * m._12 + y * m._22 + z * m._32 + m._42, x * m._13 + y * m._23 + z * m._33 + m._43);
	}
	
	public function toVector() {
		return new Vector(x, y, z);
	}

	public inline function clone() {
		return new Point(x,y,z);
	}

	public function toString() {
		return "{"+Tools.f(x)+","+Tools.f(y)+","+Tools.f(z)+"}";
	}
	
}