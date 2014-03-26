package h3d.prim;
import h3d.col.Point;

class Polygon extends Primitive {

	public var points : Array<Point>;
	public var normals : Array<Point>;
	public var uvs : Array<UV>;
	public var idx : hxd.IndexBuffer;
	public var colors : Array<Point>;
		
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
		if( normals != null )
			size += 3;
		if( uvs != null )
			size += 2;
		if( colors != null )
			size += 3;
			
		var buf = new hxd.FloatBuffer();
		for( k in 0...points.length ) {
			var p = points[k];
			buf.push(p.x);
			buf.push(p.y);
			buf.push(p.z);
			if( uvs != null ) {
				var t = uvs[k];
				buf.push(t.u);
				buf.push(t.v);
			}
			if( normals != null ) {
				var n = normals[k];
				buf.push(n.x);
				buf.push(n.y);
				buf.push(n.z);
			}
			if( colors != null ) {
				var c = colors[k];
				buf.push(c.x);
				buf.push(c.y);
				buf.push(c.z);
			}
		}
		buffer = h3d.Buffer.ofFloats(buf, size, idx == null ? [Triangles] : null);
		
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
		for( p in points ) {
			p.x += dx;
			p.y += dy;
			p.z += dz;
		}
	}

	public function scale( s : Float ) {
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

	public function addUVs() {
		throw "Not implemented for this polygon";
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
	
	public override function triCount() {
		var n = super.triCount();
		if( n != 0 )
			return n;
		return Std.int((idx == null ? points.length : idx.length) / 3);
	}

}