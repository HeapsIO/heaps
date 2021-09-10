package h3d.col;

class PolygonBuffer implements Collider {

	var buffer : haxe.ds.Vector<hxd.impl.Float32>;
	var indexes : haxe.ds.Vector<Int>;
	var startIndex : Int;
	var triCount : Int;
	public var source : { entry : hxd.fs.FileEntry, geometryName : String };

	public function new() {
	}

	public function setData( buffer, indexes, startIndex = 0, triCount = -1 ) {
		this.buffer = buffer;
		this.indexes = indexes;
		this.startIndex = startIndex;
		this.triCount = triCount >= 0 ? triCount : Std.int((indexes.length - startIndex) / 3);
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
