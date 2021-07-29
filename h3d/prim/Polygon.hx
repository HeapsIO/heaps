package h3d.prim;
import h3d.col.Point;

class Polygon extends MeshPrimitive {

	public var points : Array<Point>;
	public var normals : Array<Point>;
	public var tangents : Array<Point>;
	public var uvs : Array<UV>;
	public var idx : hxd.IndexBuffer;
	public var colors : Array<Point>;
	var scaled = 1.;
	var translatedX = 0.;
	var translatedY = 0.;
	var translatedZ = 0.;

	public function new( points, ?idx ) {
		this.points = points;
		this.idx = idx;
	}

	override function getBounds() {
		var b = new h3d.col.Bounds();
		for( p in points )
			b.addPoint(p);
		return b;
	}

	override function alloc( engine : h3d.Engine ) {
		dispose();

		var size = 3;
		var names = ["position"];
		var positions = [0];
		if( normals != null ) {
			names.push("normal");
			positions.push(size);
			size += 3;
		}
		if( tangents != null ) {
			names.push("tangent");
			positions.push(size);
			size += 3;
		}
		if( uvs != null ) {
			names.push("uv");
			positions.push(size);
			size += 2;
		}
		if( colors != null ) {
			names.push("color");
			positions.push(size);
			size += 3;
		}

		var buf = new hxd.FloatBuffer();
		for( k in 0...points.length ) {
			var p = points[k];
			buf.push(p.x);
			buf.push(p.y);
			buf.push(p.z);
			if( normals != null ) {
				var n = normals[k];
				buf.push(n.x);
				buf.push(n.y);
				buf.push(n.z);
			}
			if( tangents != null ) {
				var t = tangents[k];
				buf.push(t.x);
				buf.push(t.y);
				buf.push(t.z);
			}
			if( uvs != null ) {
				var t = uvs[k];
				buf.push(t.u);
				buf.push(t.v);
			}
			if( colors != null ) {
				var c = colors[k];
				buf.push(c.x);
				buf.push(c.y);
				buf.push(c.z);
			}
		}
		var flags : Array<h3d.Buffer.BufferFlag> = [];
		if( idx == null ) flags.push(Triangles);
		if( normals == null || tangents != null ) flags.push(RawFormat);
		buffer = h3d.Buffer.ofFloats(buf, size, flags);

		for( i in 0...names.length )
			addBuffer(names[i], buffer, positions[i]);

		if( idx != null )
			indexes = h3d.Indexes.alloc(idx);
	}


	public function unindex() {
		if( idx != null && points.length != idx.length ) {
			var p = [];
			var used = [];
			for( i in 0...idx.length )
				p.push(points[idx[i]].clone());
			if( normals != null ) {
				var n = [];
				for( i in 0...idx.length )
					n.push(normals[idx[i]].clone());
				normals = n;
			}
			if( tangents != null ) {
				var t = [];
				for( i in 0...idx.length )
					t.push(tangents[idx[i]].clone());
				tangents = t;
			}
			if( colors != null ) {
				var n = [];
				for( i in 0...idx.length )
					n.push(colors[idx[i]].clone());
				colors = n;
			}
			if( uvs != null ) {
				var t = [];
				for( i in 0...idx.length )
					t.push(uvs[idx[i]].clone());
				uvs = t;
			}
			points = p;
			idx = null;
		}
	}

	public function translate( dx, dy, dz ) {
		translatedX += dx;
		translatedY += dy;
		translatedZ += dz;
		for( p in points ) {
			p.x += dx;
			p.y += dy;
			p.z += dz;
		}
	}

	public function scale( s : Float ) {
		scaled *= s;
		for( p in points ) {
			p.x *= s;
			p.y *= s;
			p.z *= s;
		}
	}

	public function addNormals() {
		// make per-point normal
		normals = new Array();
		for( i in 0...points.length )
			normals[i] = new Point();
		var pos = 0;
		for( i in 0...triCount() ) {
			var i0, i1, i2;
			if( idx == null ) {
				i0 = pos++;
				i1 = pos++;
				i2 = pos++;
			} else {
				i0 = idx[pos++];
				i1 = idx[pos++];
				i2 = idx[pos++];
			}
			var p0 = points[i0];
			var p1 = points[i1];
			var p2 = points[i2];
			// this is the per-face normal
			var n = p1.sub(p0).cross(p2.sub(p0));
			// add it to each point
			normals[i0].x += n.x; normals[i0].y += n.y; normals[i0].z += n.z;
			normals[i1].x += n.x; normals[i1].y += n.y; normals[i1].z += n.z;
			normals[i2].x += n.x; normals[i2].y += n.y; normals[i2].z += n.z;
		}
		// normalize all normals
		for( n in normals )
			n.normalize();
	}

	public function addTangents() {
		if( normals == null )
			addNormals();
		if( uvs == null )
			addUVs();
		tangents = [];
		for( i in 0...points.length )
			tangents[i] = new Point();
		var pos = 0;
		for( i in 0...triCount() ) {
			var i0, i1, i2;
			if( idx == null ) {
				i0 = pos++;
				i1 = pos++;
				i2 = pos++;
			} else {
				i0 = idx[pos++];
				i1 = idx[pos++];
				i2 = idx[pos++];
			}
			var p0 = points[i0];
			var p1 = points[i1];
			var p2 = points[i2];
			var uv0 = uvs[i0];
			var uv1 = uvs[i1];
			var uv2 = uvs[i2];
			var n = normals[i0];

			var k0 = p1.sub(p0);
			var k1 = p2.sub(p0);
			k0.scale(uv2.v - uv0.v);
			k1.scale(uv1.v - uv0.v);
			var t = k0.sub(k1);
			var b = n.cross(t);
			b.normalize();
			t = b.cross(n);
			t.normalize();

			// add it to each point
			tangents[i0].x += t.x; tangents[i0].y += t.y; tangents[i0].z += t.z;
			tangents[i1].x += t.x; tangents[i1].y += t.y; tangents[i1].z += t.z;
			tangents[i2].x += t.x; tangents[i2].y += t.y; tangents[i2].z += t.z;
		}
		for( t in tangents )
			t.normalize();
	}

	public function addUVs() {
		uvs = [];
		for( i in 0 ... points.length )
			uvs[i] = new UV(points[i].x, points[i].y);
	}

	public function uvScale( su : Float, sv : Float ) {
		if( uvs == null )
			throw "Missing UVs";
		var m = new Map<UV,Bool>();
		for( t in uvs ) {
			if( m.exists(t) ) continue;
			m.set(t, true);
			t.u *= su;
			t.v *= sv;
		}
	}

	override function triCount() {
		var n = super.triCount();
		if( n != 0 )
			return n;
		return Std.int((idx == null ? points.length : idx.length) / 3);
	}

	override function vertexCount() {
		return points.length;
	}

	override function getCollider() : h3d.col.Collider {
		var vertexes = new haxe.ds.Vector<hxd.impl.Float32>(points.length * 3);
		var indexes = new haxe.ds.Vector<Int>(idx.length);
		var vid = 0;
		for( p in points ) {
			vertexes[vid++] = p.x;
			vertexes[vid++] = p.y;
			vertexes[vid++] = p.z;
		}
		for( i in 0...idx.length )
			indexes[i] = idx[i];
		var poly = new h3d.col.Polygon();
		poly.addBuffers(vertexes, indexes);
		return poly;
	}

	override function render( engine : h3d.Engine ) {
		if( buffer == null || buffer.isDisposed() )
			alloc(engine);
		var bufs = getBuffers(engine);
		if( indexes != null )
			engine.renderMultiBuffers(bufs, indexes);
		else if( buffer.flags.has(Quads) )
			engine.renderMultiBuffers(bufs, engine.mem.quadIndexes, 0, triCount());
		else
			engine.renderMultiBuffers(bufs, engine.mem.triIndexes, 0, triCount());
	}

}