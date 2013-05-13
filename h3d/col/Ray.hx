package h3d.col;

@:allow(h3d.col)
class Ray {
	
	var px : Float;
	var py : Float;
	var pz : Float;
	var lx : Float;
	var ly : Float;
	var lz : Float;
	
	inline function new() {
	}
	
	public function normalize() {
		var l = lx * lx + ly * ly + lz * lz;
		if( l < FMath.EPSILON ) l = 0 else l = FMath.isqrt(l);
		lx *= l;
		ly *= l;
		lz *= l;
	}
	
	public function toString() {
		return "{[" + FMath.fmt(px) + "," + FMath.fmt(py) + "," + FMath.fmt(pz) + "],[" + FMath.fmt(lx) + "," + FMath.fmt(ly) + "," + FMath.fmt(lz) + "]}";
	}
	
	public inline function intersect( p : Plane ) : Vector {
		var d = lx * p.nx + ly * p.ny + lz * p.nz;
		var nd = p.d - (px * p.nx + py * p.ny + pz * p.nz);
		// line parallel with plane
		if( FMath.abs(d) < FMath.EPSILON )
			return FMath.abs(nd) < FMath.EPSILON ? new Vector(px, py, pz) : null;
		else {
			var k = nd / d;
			return new Vector(px + lx * k, py + ly * k, pz + lz * k);
		}
	}
	
	public static function fromPoints( p1 : Vector, p2 : Vector ) {
		var r = new Ray();
		r.px = p1.x;
		r.py = p1.y;
		r.pz = p1.z;
		r.lx = p2.x - p1.x;
		r.ly = p2.y - p1.y;
		r.lz = p2.z - p1.z;
		return r;
	}
	
	
}