package h3d.col;

class TriPlane implements Collider {

	public var next : TriPlane;

	var p0x : Float;
	var p0y : Float;
	var p0z : Float;

	var d1x : Float;
	var d1y : Float;
	var d1z : Float;

	var d2x : Float;
	var d2y : Float;
	var d2z : Float;

	var dot00 : Float;
	var dot01 : Float;
	var dot11 : Float;
	var invDenom : Float;
	var nx : Float;
	var ny : Float;
	var nz : Float;
	var d : Float;

	public function new() {
	}

	public inline function init( p0 : Point, p1 : Point, p2 : Point ) {
		p0x = p0.x;
		p0y = p0.y;
		p0z = p0.z;
		var d1 = p1.sub(p0);
		var d2 = p2.sub(p0);
		var n = d1.cross(d2);
		d = n.dot(p0);
		nx = n.x;
		ny = n.y;
		nz = n.z;

		d1x = d1.x;
		d1y = d1.y;
		d1z = d1.z;
		d2x = d2.x;
		d2y = d2.y;
		d2z = d2.z;

		dot00 = d1.dot(d1);
		dot01 = d1.dot(d2);
		dot11 = d2.dot(d2);
		invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
	}

	public inline function contains( p : Point ) {
		return isPointInTriangle(p.x, p.y, p.z);
	}

	public inline function side( p : Point ) {
		return nx * p.x + ny * p.y + nz * p.z - d >= 0;
	}

	public function inFrustum( m : h3d.Matrix ) {
		throw "Not implemented";
		return false;
	}

	inline public function rayIntersection( r : Ray, bestMatch : Bool ) @:privateAccess {
		var dr = r.lx * nx + r.ly * ny + r.lz * nz;
		if( dr >= 0 ) // backface culling
			return -1.;
		var nd = d - (r.px * nx + r.py * ny + r.pz * nz);
		var k = nd / dr;
		if( k < 0 )
			return -1;
		var px = r.px + r.lx * k;
		var py = r.py + r.ly * k;
		var pz = r.pz + r.lz * k;
		if( !isPointInTriangle(px, py, pz) )
			return -1;
		return k;
	}

	inline function isPointInTriangle( x : Float, y : Float, z : Float ) {
		// Compute vectors
		var v2 = new h3d.col.Point(x - p0x,  y - p0y, z - p0z);
		var dot02 = d1x * v2.x + d1y * v2.y + d1z * v2.z;
		var dot12 = d2x * v2.x + d2y * v2.y + d2z * v2.z;

		// Compute barycentric coordinates
		var u = (dot11 * dot02 - dot01 * dot12) * invDenom;
		var v = (dot00 * dot12 - dot01 * dot02) * invDenom;

		// Check if point is in triangle
		return (u >= 0) && (v >= 0) && (u + v < 1);
	}

}


class Polygon implements Collider {

	var triPlanes : TriPlane;

	public function new() {
	}

	public function addBuffers( vertexes : haxe.ds.Vector<hxd.impl.Float32>, indexes : haxe.ds.Vector<hxd.impl.UInt16>, stride = 3 ) {
		for(i in 0...Std.int(indexes.length / 3)) {
			var k = i * 3;

			var t = new TriPlane();

			var i0 = (indexes[k]:Int) * stride;
			var i1 = (indexes[k + 1]:Int) * stride;
			var i2 = (indexes[k + 2]:Int) * stride;

			t.init(
				new Point(vertexes[i0], vertexes[i0 + 1], vertexes[i0 + 2]),
				new Point(vertexes[i1], vertexes[i1 + 1], vertexes[i1 + 2]),
				new Point(vertexes[i2], vertexes[i2 + 1], vertexes[i2 + 2])
			);

			t.next = triPlanes;
			triPlanes = t;
		}
	}

	public function isConvex() {
		// TODO : check + cache result
		return true;
	}

	public function contains( p : Point ) {
		if( !isConvex() )
			throw "Not implemented for concave polygon";
		var t = triPlanes;
		while( t != null ) {
			if( t.side(p) )
				return false;
			t = t.next;
		}
		return true;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) {
		var t = triPlanes;
		var best = -1.;
		while( t != null ) {
			var d = t.rayIntersection(r, bestMatch);
			if( d >= 0 ) {
				if( !bestMatch ) return d;
				if( best < 0 || d < best ) best = d;
			}
			t = t.next;
		}
		return best;
	}

	public function inFrustum( m : h3d.Matrix ) {
		throw "Not implemented";
		return false;
	}

}