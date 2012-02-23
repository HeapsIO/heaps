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

	public inline function copy() {
		return new Point(x,y,z);
	}

	public function toString() {
		return "{"+Tools.f(x)+","+Tools.f(y)+","+Tools.f(z)+"}";
	}
	
}