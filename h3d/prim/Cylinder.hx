package h3d.prim;
import h3d.col.Point;

class Cylinder extends Quads {

	var segs : Int;

	public function new( segs : Int, ray = 1.0, height = 1.0, centered = false ) {
		var pts = new Array();
		var normals = new Array();
		var ds = Math.PI * 2 / segs;
		this.segs = segs;
		var z0 = centered ? -height * 0.5 : 0;
		var z1 = centered ? -z0 : height;
		for( s in 0...segs ) {
			var a = s * ds;
			var a2 = (s + 1) * ds;
			var x = Math.cos(a) * ray, y = Math.sin(a) * ray;
			var x2 = Math.cos(a2) * ray, y2 = Math.sin(a2) * ray;
			pts.push(new Point(x, y, z0));
			pts.push(new Point(x2, y2, z0));
			pts.push(new Point(x, y, z1));
			pts.push(new Point(x2, y2, z1));

			var n0 = new Point(Math.cos(a), Math.sin(a), 0);
			var n1 = new Point(Math.cos(a2), Math.sin(a2), 0);
			normals.push(n0);
			normals.push(n1);
			normals.push(n0.clone());
			normals.push(n1.clone());
		}
		super(pts,normals);
	}

	override function addUVs() {
		uvs = new Array();
		for( s in 0...segs ) {
			var u = s / segs;
			var u2 = (s + 1) / segs;
			uvs.push(new UV(1-u, 1));
			uvs.push(new UV(1-u2, 1));
			uvs.push(new UV(1-u, 0));
			uvs.push(new UV(1-u2, 0));
		}
	}

}