package h3d.prim;

class Polygon extends Primitive {

	public var points : Array<Point>;
	public var normals : Array<Point>;
	public var tangents : Array<Point>;
	public var tcoords : Array<UV>;
	public var idx : Array<Int>;
		
	public function new( points, ?idx ) {
		this.points = points;
		this.idx = idx;
	}

	override function alloc( engine : h3d.Engine ) {
		dispose();
		
		var size = 3;
		if( normals != null )
			size += 3;
		if( tcoords != null )
			size += 2;
			
		var buf = new flash.Vector<Float>();
		var i = 0;
		for( k in 0...points.length ) {
			var p = points[k];
			buf[i++] = p.x;
			buf[i++] = p.y;
			buf[i++] = p.z;
			if( tcoords != null ) {
				var t = tcoords[k];
				buf[i++] = t.u;
				buf[i++] = t.v;
			}
			if( normals != null ) {
				var n = normals[k];
				buf[i++] = n.x;
				buf[i++] = n.y;
				buf[i++] = n.z;
			}
			if( tangents != null ) {
				var t = tangents[k];
				buf[i++] = t.x;
				buf[i++] = t.y;
				buf[i++] = t.z;
			}
		}
		buffer = engine.mem.allocVector(buf, size, idx == null ? 3 : 0);
		
		if( idx != null ) {
			var idx : Array<UInt> = cast idx;
			indexes = engine.mem.allocIndex(flash.Vector.ofArray(idx));
		}
	}


	public function unindex() {
		if( idx != null && points.length != idx.length ) {
			var p = [];
			var used = [];
			for( i in idx )
				p.push(points[i].clone());
			if( normals != null ) {
				var n = [];
				for( i in idx )
					n.push(normals[i].clone());
				normals = n;
			}
			if( tcoords != null ) {
				var t = [];
				for( i in idx )
					t.push(tcoords[i].clone());
				tcoords = t;
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
	
	public override function triCount() {
		var n = super.triCount();
		if( n != 0 )
			return n;
		return Std.int((idx == null ? points.length : idx.length) / 3);
	}

}