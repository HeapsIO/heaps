package h3d.prim;

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
		return FMath.sqrt(x * x + y * y + z * z);
	}

	public function normalize() {
		var k = x * x + y * y + z * z;
		if( k < FMath.EPSILON ) k = 0 else k = FMath.isqrt(k);
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
		return "{"+FMath.fmt(x)+","+FMath.fmt(y)+","+FMath.fmt(z)+"}";
	}
	
}