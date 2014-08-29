package h3d.prim;
import h3d.col.Point;

class Sphere extends Polygon {

	var segsH : Int;
	var segsW : Int;

	public function new( segsW = 8, segsH = 6 ) {
		this.segsH = segsH;
		this.segsW = segsW;
		var t = 0., dt = Math.PI / segsH, dp = Math.PI * 2 / segsW;
		var pts = [], idx = new hxd.IndexBuffer();
		var dx = 1, dy = segsW + 1;
		for( y in 0...segsH ) {
			var p = 0.;
			var st = Math.sin(t);
			var pz = Math.cos(t);
			for( x in 0...segsW + 1 ) {
				var px = st * Math.cos(p);
				var py = st * Math.sin(p);
				var i = pts.length;
				pts.push(new Point(px, py, pz));
				p += dp;
				if( x != segsW ) {
					idx.push(i);
					idx.push(i + dy);
					idx.push(i + dx);
					idx.push(i + dy);
					idx.push(i + dx + dy);
					idx.push(i + dx);
				}
			}
			t += dt;
		}
		for( x in 0...segsW + 1 )
			pts.push(new Point(0, 0, -1));
		super(pts, idx);
	}

	override function addNormals() {
		normals = points;
	}

	override function addUVs() {
		uvs = [];
		for( y in 0...segsH + 1 )
			for( x in 0...segsW + 1 )
				uvs.push(new UV(x / segsW, y / segsH));
	}

}

