package h3d.col;

class PolygonBuffer extends Collider {

	var buffer : haxe.ds.Vector<hxd.impl.Float32>;
	var indexes : haxe.ds.Vector<Int>;
	var startIndex : Int;
	var triCount : Int;
	public var isConvex : Bool;
	public var source : { entry : hxd.fs.FileEntry, geometryName : String };

	public function new() {
	}

	public function setData( buffer, indexes, startIndex = 0, triCount = -1, isConvex = false ) {
		this.buffer = buffer;
		this.indexes = indexes;
		this.startIndex = startIndex;
		this.triCount = triCount >= 0 ? triCount : Std.int((indexes.length - startIndex) / 3);
		this.isConvex = isConvex;
	}

	public function getBounds() {
		var i = startIndex;
		var b = new Bounds();
		for( t in 0...triCount*3 ) {
			var pos = indexes[i++] * 3;
			b.addPos(buffer[pos++], buffer[pos++], buffer[pos]);
		}
		return b;
	}

	public function getPoints() {
		var vmin = 1 << 30;
		var vmax = -(1<<30);
		for( i in startIndex...startIndex + triCount*3 ) {
			var pos = indexes[i];
			if( pos < vmin ) vmin = pos;
			if( pos > vmax ) vmax = pos;
		}
		var vcount = (vmax + 1) - vmin;
		var bits = new hxd.impl.BitSet(vcount);
		var points = [];
		for( i in startIndex...startIndex + triCount*3 ) {
			var pos = indexes[i];
			var vidx = pos - vmin;
			if( !bits.get(vidx) ) {
				pos *= 3;
				points.push(new FPoint(buffer[pos++], buffer[pos++], buffer[pos]));
				bits.set(vidx);
			}
		}
		return points;
	}

	public function contains( p : Point ) {
		// CONVEX only : TODO : check convex (cache result)
		var i = startIndex;
		var p = new FPoint(p.x, p.y, p.z);
		for( t in 0...triCount ) {
			var i0 = indexes[i++] * 3;
			var p0 = new FPoint(buffer[i0++], buffer[i0++], buffer[i0]);
			var i1 = indexes[i++] * 3;
			var p1 = new FPoint(buffer[i1++], buffer[i1++], buffer[i1]);
			var i2 = indexes[i++] * 3;
			var p2 = new FPoint(buffer[i2++], buffer[i2++], buffer[i2]);

			var d1 = p1.sub(p0);
			var d2 = p2.sub(p0);
			var n = d1.cross(d2);
			var d = n.dot(p0);

			if( n.dot(p) >= d )
				return false;
		}
		return true;
	}

	public function inFrustum( f : Frustum, ?m : h3d.Matrix ) {
		throw "Not implemented";
		return false;
	}

	public function inSphere( s : Sphere ) {
		throw "Not implemented";
		return false;
	}

	public function dimension() {
		return getBounds().dimension();
	}

	inline function isPointInTriangle( d : FPoint, d1 : FPoint, d2 : FPoint ) {
		// Compute vectors
		var dot02 = d1.dot(d);
		var dot12 = d2.dot(d);

		var dot00 = d1.dot(d1);
		var dot01 = d1.dot(d2);
		var dot11 = d2.dot(d2);
		var invDenom = 1 / (dot00 * dot11 - dot01 * dot01);

		// Compute barycentric coordinates
		var u = (dot11 * dot02 - dot01 * dot12) * invDenom;
		var v = (dot00 * dot12 - dot01 * dot02) * invDenom;

		// Check if point is in triangle
		return (u >= 0) && (v >= 0) && (u + v < 1);
	}

	inline function closestPointLine(p : FPoint, start : FPoint, d : FPoint) {
		var t = p.sub(start).dot(d) / d.dot(d);
		t = hxd.Math.clamp(t);
		return start.add(d.scaled(t));
	}

	public function closestPoint( p : h3d.col.Point ) {
		var p = new FPoint(p.x, p.y, p.z);
		var minDistSq = hxd.Math.POSITIVE_INFINITY;
		var closest = null;

		var i = startIndex;
		for ( t in 0...triCount ) {
			var i0 = indexes[i++] * 3;
			var p0 = new FPoint(buffer[i0++], buffer[i0++], buffer[i0]);
			var i1 = indexes[i++] * 3;
			var p1 = new FPoint(buffer[i1++], buffer[i1++], buffer[i1]);
			var i2 = indexes[i++] * 3;
			var p2 = new FPoint(buffer[i2++], buffer[i2++], buffer[i2]);

			var c = null;
			var d1 = p1.sub(p0);
			var d2 = p2.sub(p0);
			var d = p.sub(p0);
			if ( isPointInTriangle(d, d1, d2) ) {
				var n = d1.cross(d2).normalized();
				var dProj = d.sub(n.scaled(d.dot(n)));
				c = p0.add(dProj);
			} else {
				var c1 = closestPointLine(p, p0, d1);
				var c2 = closestPointLine(p, p1, d2.sub(d1));
				var c3 = closestPointLine(p, p0, d2);

				var mag1 = p.sub(c1).lengthSq();
				var mag2 = p.sub(c2).lengthSq();
				var mag3 = p.sub(c3).lengthSq();

				var min = mag1;
				c = c1;
				if ( mag2 < min ) {
					min = mag2;
					c = c2;
				}
				if ( mag3 < min ) {
					min = mag3;
					c = c3;
				}
			}

			var distSq = p.distanceSq(c);
			if ( distSq < minDistSq ) {
				closest = c;
				minDistSq = distSq;
			}
		}
		return new h3d.col.Point(closest.x, closest.y, closest.z);
	}

	// Möller–Trumbore intersection
	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		var i = startIndex;
		var rdir = new FPoint(r.lx, r.ly, r.lz);
		var r0 = new FPoint(r.px, r.py, r.pz);
		var best = -1.;
		for( t in 0...triCount ) {
			var i0 = indexes[i++] * 3;
			var p0 = new FPoint(buffer[i0++], buffer[i0++], buffer[i0]);
			var i1 = indexes[i++] * 3;
			var p1 = new FPoint(buffer[i1++], buffer[i1++], buffer[i1]);
			var i2 = indexes[i++] * 3;
			var p2 = new FPoint(buffer[i2++], buffer[i2++], buffer[i2]);

			var e1 = p1.sub(p0);
			var e2 = p2.sub(p0);
			var p = rdir.cross(e2);
			var det = e1.dot(p);
			if( det < hxd.Math.EPSILON ) continue; // backface culling (negative) and near parallel (epsilon)

			var invDet = 1 / det;
			var T = r0.sub(p0);
			var u = T.dot(p) * invDet;

			if( u < 0 || u > 1 ) continue;

			var q = T.cross(e1);
			var v = rdir.dot(q) * invDet;

			if( v < 0 || u + v > 1 ) continue;

			var t = e2.dot(q) * invDet;

			if( t < hxd.Math.EPSILON ) continue;

			if( !bestMatch ) return t;
			if( best < 0 || t < best ) best = t;
		}
		return best;
	}

	#if !macro
	public function makeDebugObj() : h3d.scene.Object {
		var points = new Array<Point>();
		var idx = new hxd.IndexBuffer();
		var i = startIndex;
		for( t in 0...triCount ) {
			idx.push(indexes[i++]);
			idx.push(indexes[i++]);
			idx.push(indexes[i++]);
		}
		i = 0;
		while( i < buffer.length ) {
			points.push(new Point(buffer[i++], buffer[i++], buffer[i++]));
		}
		var prim = new h3d.prim.Polygon(points, idx);
		prim.addNormals();
		return new h3d.scene.Mesh(prim);
	}
	#end

}
