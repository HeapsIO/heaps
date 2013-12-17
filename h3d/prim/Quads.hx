package h3d.prim;
import h3d.col.Point;

class Quads extends Primitive {

var mem :  hxd.FloatBuffer;

	var pts : Array<Point>;
	var uvs : Array<UV>;
	var normals : Array<Point>;
	
	public function new( pts, ?uvs, ?normals ) {
		this.pts = pts;
		this.uvs = uvs;
		this.normals = normals;
	}
	
	public function scale( x : Float, y : Float, z : Float ) {
		for( p in pts ) {
			p.x *= x;
			p.y *= y;
			p.z *= z;
		}
	}
	
	public function addTCoords() {
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
	
	public function addNormals() {
		throw "Not implemented";
	}
	
	override function alloc( engine : Engine ) {
		dispose();
		var v = new hxd.FloatBuffer();
mem = v;
		for( i in 0...pts.length ) {
			var pt = pts[i];
			v.push(pt.x);
			v.push(pt.y);
			v.push(pt.z);
			if( uvs != null ) {
				var t = uvs[i];
				v.push(t.u);
				v.push(t.v);
			}
			if( normals != null ) {
				var n = normals[i];
				v.push(n.x);
				v.push(n.y);
				v.push(n.z);
			}
		}
		var size = 3;
		if( normals != null ) size += 3;
		if( uvs != null ) size += 2;
		buffer = engine.mem.allocVector(v,size, 4);
	}
	
	public function getPoints() {
		return pts;
	}
public function getMem() {
	return mem;
}
	
	override function render(engine) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		engine.renderQuadBuffer(buffer);
	}
	
}