package h3d.prim;

class Quads extends Primitive {

	var pts : Array<h3d.Point>;
	var uvs : Array<UV>;
	var normals : Array<h3d.Point>;
	
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
		var v = new flash.Vector();
		var p = 0;
		for( i in 0...pts.length ) {
			var pt = pts[i];
			v[p++] = pt.x;
			v[p++] = pt.y;
			v[p++] = pt.z;
			if( uvs != null ) {
				var t = uvs[i];
				v[p++] = t.u;
				v[p++] = t.v;
			}
			if( normals != null ) {
				var n = normals[i];
				v[p++] = n.x;
				v[p++] = n.y;
				v[p++] = n.z;
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
	
	override function render(engine) {
		if( buffer == null ) alloc(engine);
		engine.renderQuadBuffer(buffer);
	}
	
}