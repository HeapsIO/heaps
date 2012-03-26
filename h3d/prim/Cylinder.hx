package h3d.prim;

class Cylinder extends Quads {
	
	var segs : Int;
	
	public function new( segs : Int, ray = 1.0, height = 1.0 ) {
		var pts = new Array();
		var ds = Math.PI * 2 / segs;
		this.segs = segs;
		for( s in 0...segs ) {
			var a = s * ds;
			var a2 = (s + 1) / ds;
			var x = Math.cos(a) * ray, y = Math.sin(a) * ray;
			var x2 = Math.cos(a2) * ray, y2 = Math.sin(a2) * ray;
			pts.push(new Point(x, y, 0));
			pts.push(new Point(x, y, height));
			pts.push(new Point(x2, y2, 0));
			pts.push(new Point(x2, y2, height));
		}
		super(pts);
	}
	
	override public function addTCoords() {
		uvs = new Array();
		for( s in 0...segs ) {
			var u = s / segs;
			var u2 = (s + 1) / segs;
			uvs.push(new UV(u, 1));
			uvs.push(new UV(u, 0));
			uvs.push(new UV(u2, 1));
			uvs.push(new UV(u2, 0));
		}
	}
}