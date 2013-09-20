package h3d.col;
import hxd.Math;

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
		if( l < Math.EPSILON ) l = 0 else l = Math.isqrt(l);
		lx *= l;
		ly *= l;
		lz *= l;
	}
	
	public inline function getPos() {
		return new Point(px, py, pz);
	}

	public inline function getDir() {
		return new Point(lx, ly, lz);
	}
	
	public function toString() {
		return "{" + getPos() + "," + getDir() + "}";
	}
	
	public inline function intersect( p : Plane ) : Null<Point> {
		var d = lx * p.nx + ly * p.ny + lz * p.nz;
		var nd = p.d - (px * p.nx + py * p.ny + pz * p.nz);
		// line parallel with plane
		if( Math.abs(d) < Math.EPSILON )
			return Math.abs(nd) < Math.EPSILON ? new Point(px, py, pz) : null;
		else {
			var k = nd / d;
			return new Point(px + lx * k, py + ly * k, pz + lz * k);
		}
	}

	public inline function collide( b : Bounds ) : Bool {
		var dx = 1 / lx;
		var dy = 1 / ly;
		var dz = 1 / lz;
		var t1 = (b.xMin - px) * dx;
		var t2 = (b.xMax - px) * dx;
		var t3 = (b.yMin - py) * dy;
		var t4 = (b.yMax - py) * dy;
		var t5 = (b.zMin - pz) * dz;
		var t6 = (b.zMax - pz) * dz;
		var tmin = Math.max(Math.max(Math.min(t1, t2), Math.min(t3, t4)), Math.min(t5, t6));
		var tmax = Math.min(Math.min(Math.max(t1, t2), Math.max(t3, t4)), Math.max(t5, t6));
		if( tmax < 0 ) {
			// t = tmax;
			return false;
		} else if( tmin > tmax ) {
			// t = tmax;
			return false;
		} else {
			// t = tmin;
			return true;
		}
	}
	
	public static function fromPoints( p1 : Point, p2 : Point ) {
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