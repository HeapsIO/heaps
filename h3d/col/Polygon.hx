package h3d.col;

@:allow(h3d.col.Polygon)
class TriPlane extends Collider {

	public var next : TriPlane = null;

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

	var oriented : Bool;

	public function new(o = false) {
		oriented = o;
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

	public inline function clone() {
		var clone = new TriPlane(oriented);
		clone.load(this);
		if(next != null)
			clone.next = next.clone();
		return clone;
	}

	public inline function load( tp : TriPlane ) {
		p0x = tp.p0x;
		p0y = tp.p0y;
		p0z = tp.p0z;
		d1x = tp.d1x;
		d1y = tp.d1y;
		d1z = tp.d1z;
		d2x = tp.d2x;
		d2y = tp.d2y;
		d2z = tp.d2z;
		dot00 = tp.dot00;
		dot01 = tp.dot01;
		dot11 = tp.dot11;
		invDenom = tp.invDenom;
		nx = tp.nx;
		ny = tp.ny;
		nz = tp.nz;
		d = tp.d;
	}

	public function transform( m : h3d.Matrix ){
		var p0 = new Point(p0x, p0y, p0z);
		var p1 = new Point(d1x + p0x, d1y + p0y, d1z + p0z);
		var p2 = new Point(d2x + p0x, d2y + p0y, d2z + p0z);
		p0.transform(m);
		p1.transform(m);
		p2.transform(m);
		init(p0, p1, p2);
	}

	public inline function contains( p : Point ) {
		return isPointInTriangle(p.x, p.y, p.z);
	}

	public inline function side( p : Point ) {
		return nx * p.x + ny * p.y + nz * p.z - d >= 0;
	}

	public function inFrustum( f : Frustum, ?m : h3d.Matrix ) {
		throw "Not implemented";
		return false;
	}

	public function inSphere( s : Sphere ) {
		throw "Not implemented";
		return false;
	}

	public function closestPoint( p : Point ) {
		var p0 = new Point(p0x, p0y, p0z);

		if ( isPointInTriangle(p.x, p.y, p.z) ) {
			var d = p.sub(p0);
			var n = new Point(nx, ny, nz);
			n.normalize();
			var dProj = d.sub(n.scaled(d.dot(n)));
			return p0.add(dProj);
		}
		
		inline function closestPointLine(start : Point, d : Point) {
			var t = p.sub(start).dot(d) / d.dot(d);
			t = hxd.Math.clamp(t);
			return start.add(d.scaled(t));
		}
		var d1 = new Point(d1x, d1y, d1z);
		var d2 = new Point(d2x, d2y, d2z);
		var p1 = new Point(p0x, p0y, p0z).add(d1);
		var c1 = closestPointLine(p0, d1);
		var c2 = closestPointLine(p1, d2.sub(d1));
		var c3 = closestPointLine(p0, d2);

		var mag1 = p.sub(c1).lengthSq();
		var mag2 = p.sub(c2).lengthSq();
		var mag3 = p.sub(c3).lengthSq();

		var min = mag1;
		var c = c1;
		if ( mag2 < min ) {
			min = mag2;
			c = c2;
		}
		if ( mag3 < min ) {
			min = mag3;
			c = c3;
		}
		return c;
	}

	inline public function rayIntersection( r : Ray, bestMatch : Bool ) @:privateAccess {
		var dr = r.lx * nx + r.ly * ny + r.lz * nz;
		if( dr >= 0 && oriented ) // backface culling
			return -1.;
		var nd = d - (r.px * nx + r.py * ny + r.pz * nz);
		var k = nd / dr;
		if( k < 0 && oriented )
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

	public function getPoints() : Array<Point> {
		return [new Point(p0x, p0y, p0z), new Point(d1x + p0x, d1y + p0y, d1z + p0z), new Point(d2x + p0x, d2y + p0y, d2z + p0z)];
	}

	#if !macro
	public function makeDebugObj() : h3d.scene.Object {
		var p0 = new Point(p0x, p0y, p0z);
		var d1 = new Point(d1x, d1y, d1z);
		var d2 = new Point(d2x, d2y, d2z);
		var points : Array<Point> = [ p0, d1.add(p0), d2.add(p0) ];
		var prim = new h3d.prim.Polygon(points);
		prim.addNormals();
		return new h3d.scene.Mesh(prim);
	}
	#end

	public function dimension() {
		throw "Not implemented";
		return 0.0;
	}
}


class Polygon extends Collider {

	var triPlanes : TriPlane;
	var oriented : Bool;

	public function new(o = false) {
		oriented = o;
	}

	public function addBuffers( vertexes : haxe.ds.Vector<hxd.impl.Float32>, indexes : haxe.ds.Vector<Int>, stride = 3 ) {
		for(i in 0...Std.int(indexes.length / 3)) {
			var k = i * 3;

			var t = new TriPlane(oriented);

			var i0 = indexes[k] * stride;
			var i1 = indexes[k + 1] * stride;
			var i2 = indexes[k + 2] * stride;

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

	public function clone() : h3d.col.Polygon {
		var clone = new h3d.col.Polygon(oriented);
		clone.triPlanes = triPlanes.clone();
		return clone;
	}

	public function transform( m : h3d.Matrix ) {
		var t = triPlanes;
		while( t != null ) {
			t.transform(m);
			t = t.next;
		}
	}

	public function getPoints() : Array<Point> {
		var ret : Array<Point> = [];
		var t = triPlanes;
		while( t != null ) {
			ret = ret.concat(t.getPoints());
			t = t.next;
		}
		return ret;
	}

	public function getBounds(?bnds: h3d.col.Bounds) : h3d.col.Bounds {
		if(bnds == null) bnds = new h3d.col.Bounds();
		bnds.empty();
		var t = triPlanes;
		while( t != null ) {
			bnds.addPos(t.p0x, t.p0y, t.p0z);
			bnds.addPos(t.d1x + t.p0x, t.d1y + t.p0y, t.d1z + t.p0z);
			bnds.addPos(t.d2x + t.p0x, t.d2y + t.p0y, t.d2z + t.p0z);
			t = t.next;
		}
		return bnds;
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

	public function inFrustum( f : Frustum, ?m : h3d.Matrix ) {
		throw "Not implemented";
		return false;
	}

	public function inSphere( s : Sphere ) {
		throw "Not implemented";
		return false;
	}

	public function closestPoint( p : h3d.col.Point ) {
		var t = triPlanes;
		var minDistSq = hxd.Math.POSITIVE_INFINITY;
		var closest = null;
		while( t != null ) {
			var c = t.closestPoint(p);
			var distSq = p.distanceSq(c);
			if ( distSq < minDistSq ) {
				minDistSq = distSq;
				closest = c;
			}
			t = t.next;
		}
		return closest;
	}

	inline public function dimension() {
		return getBounds().dimension();
	}

	#if !macro
	public function makeDebugObj() : h3d.scene.Object {
		var points : Array<Point> = [];
		var idx = new hxd.IndexBuffer();

		var t = triPlanes;
		while( t != null ) {
			var p0 = new Point(t.p0x, t.p0y, t.p0z);
			var d1 = new Point(t.d1x, t.d1y, t.d1z);
			var d2 = new Point(t.d2x, t.d2y, t.d2z);
			points.push(p0);
			points.push(d1.add(p0));
			points.push(d2.add(p0));
			t = t.next;
		}
		var prim = new h3d.prim.Polygon(points);
		prim.addNormals();
		var mesh = new h3d.scene.Mesh(prim);
		if ( !oriented )
			mesh.material.mainPass.culling = None;
		return mesh;
	}
	#end

	public static function fromPolygon2D( p : h2d.col.Polygon, z = 0., oriented = true ) {
		var pout = new Polygon();
		if( p.isConvex() ) {
			var p0 = p[0];
			for( i in 0...p.length-2 ) {
				var p1 = p[i+1];
				var p2 = p[i+2];
				var t = new TriPlane(oriented);
				t.init(
					new h3d.col.Point(p0.x, p0.y, z),
					new h3d.col.Point(p1.x, p1.y, z),
					new h3d.col.Point(p2.x, p2.y, z)
				);
				t.next = pout.triPlanes;
				pout.triPlanes = t;
			}
		} else {
			var idx = p.fastTriangulate();
			for( i in 0...Std.int(idx.length/3) ) {
				var p0 = p[idx[i*3]];
				var p1 = p[idx[i*3+1]];
				var p2 = p[idx[i*3+2]];
				var t = new TriPlane(oriented);
				t.init(
					new h3d.col.Point(p0.x, p0.y, z),
					new h3d.col.Point(p1.x, p1.y, z),
					new h3d.col.Point(p2.x, p2.y, z)
				);
				t.next = pout.triPlanes;
				pout.triPlanes = t;
			}
		}
		return pout;
	}

}