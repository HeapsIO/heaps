package h3d.prim;
import h3d.col.Point;

class Quads extends Primitive {

	var pts : Array<Point>;
	var uvs : Array<UV>;
	var normals : Array<Point>;

	/**
	* You have to pass vertices in this order: top left, top right, bottom left, bottom right
	*/
	public function new( pts, ?uvs, ?normals ) {
		this.pts = pts;
		this.uvs = uvs;
		this.normals = normals;
	}

	override public function getBounds() {
		var b = new h3d.col.Bounds();
		for( p in pts )
			b.addPoint(p);
		return b;
	}

	override function triCount() {
		return pts.length >> 1;
	}

	override function vertexCount() {
		return pts.length;
	}

	public function transform( m : h3d.Matrix ) {
		for( p in pts )
			p.transform(m);
		if( normals != null )
			for( n in normals ) {
				n.transform3x3(m);
				n.normalize();
			}
	}

	public function translate( dx : Float, dy : Float, dz : Float ) {
		for( p in pts ) {
			p.x += dx;
			p.y += dy;
			p.z += dz;
		}
	}

	public function scale( x : Float, y : Float, z : Float ) {
		for( p in pts ) {
			p.x *= x;
			p.y *= y;
			p.z *= z;
		}
	}

	/**
	* Warning : This will splice four basic uv value but can provoke aliasing problems.
	*/
	public function addUVs() {
		uvs = [];
		var a = new UV(0, 1);
		var b = new UV(1, 1);
		var c = new UV(0, 0);
		var d = new UV(1, 0);
		for( i in 0...pts.length >> 2 ) {
			uvs.push(a);
			uvs.push(b);
			uvs.push(c);
			uvs.push(d);
		}
	}

	override function alloc( engine : Engine ) {
		dispose();
		var v = new hxd.FloatBuffer();
		for( i in 0...pts.length ) {
			var pt = pts[i];
			v.push(pt.x);
			v.push(pt.y);
			v.push(pt.z);
			if( normals != null ) {
				var n = normals[i];
				v.push(n.x);
				v.push(n.y);
				v.push(n.z);
			}
			if( uvs != null ) {
				var t = uvs[i];
				v.push(t.u);
				v.push(t.v);
			}
		}
		var size = 3;
		if( normals != null ) size += 3;
		if( uvs != null ) size += 2;
		var flags : Array<h3d.Buffer.BufferFlag> = [Quads];
		if( normals == null ) flags.push(RawFormat);
		buffer = h3d.Buffer.ofFloats(v, size, flags);
	}

	public function addNormals() {
		// make per-point normal
		normals = new Array();
		var points = pts;
		for( i in 0...points.length )
			normals[i] = new Point();
		var pos = 0;
		for( i in 0...points.length>>2 ) {
			var i = i << 2;
			var i0 = i, i1 = i+1, i2 = i+2;
			var p0 = points[i0];
			var p1 = points[i1];
			var p2 = points[i2];
			// this is the per-face normal
			var n = p1.sub(p0).cross(p2.sub(p0));
			// add it to each point
			normals[i0].x += n.x; normals[i0].y += n.y; normals[i0].z += n.z;
			normals[i1].x += n.x; normals[i1].y += n.y; normals[i1].z += n.z;
			normals[i2].x += n.x; normals[i2].y += n.y; normals[i2].z += n.z;

			var i0 = i+3, i1 = i+2, i2 = i+1;
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

	public function getPoints() {
		return pts;
	}

	override function render(engine) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		engine.renderQuadBuffer(buffer);
	}

}
