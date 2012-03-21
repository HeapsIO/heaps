package h3d.prim;

class Quads extends Primitive {

	var pts : Array<h3d.Vector>;
	var uvs : Array<UV>;
	
	public function new( pts, ?uvs ) {
		this.pts = pts;
		this.uvs = uvs;
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
		}
		buffer = engine.mem.allocVector(v,uvs == null ? 3 : 5, 4);
	}
	
	override function render(engine) {
		if( buffer == null ) alloc(engine);
		engine.renderIndexes(buffer, engine.mem.quadIndexes, 2);
	}
	
}