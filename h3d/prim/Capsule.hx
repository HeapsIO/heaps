package h3d.prim;
import h3d.col.Point;

class Capsule extends Polygon {

	var ray : Float;
	var length : Float;
	var segsH : Int;
	var segsW : Int;

	public function new( ray = 1., length = 1., segsW = 8, segsH = 6 ) {
		this.ray = ray;
		this.length = length;
		this.segsH = segsH;
		this.segsW = segsW;

		var dp = Math.PI / segsW;
		var pts = [], idx = new hxd.IndexBuffer();
		normals = [];
		var portion = 0.51;
		function halfSphere(offsetX : Float, offsetPhi : Float) {
			var indexOffset = pts.length;
			for( y in 0...segsH+1 ) {
				var t = (y / segsH) * Math.PI;
				var st = Math.sin(t);
				var pz = Math.cos(t);
				var p = offsetPhi;
				for( x in 0...segsW+1 ) {
					var px = st * Math.cos(p);
					var py = st * Math.sin(p);
					pts.push(new Point(px * ray + offsetX, py * ray, pz * ray));
					normals.push(new Point(px, py, pz));
					p += dp;
				}
			}
			for( y in 0...segsH ) {
				for( x in 0...segsW ) {
					inline function vertice(x, y) return x + y * (segsW + 1) + indexOffset;
					var v1 = vertice(x + 1, y);
					var v2 = vertice(x, y);
					var v3 = vertice(x, y + 1);
					var v4 = vertice(x + 1, y + 1);
					if( y != 0 ) {
						idx.push(v1);
						idx.push(v2);
						idx.push(v4);
					}
					if( y != segsH - 1 ) {
						idx.push(v2);
						idx.push(v3);
						idx.push(v4);
					}
				}
			}
		}
		var ds = Math.PI / segsW;
		var x0 = -length / 2.0;
		var x1 = length / 2.0;
		function cylinder() {
			for( s in 0...segsW * 2 + 1 ) {
				var a = s * ds;
				var a2 = (s + 1) * ds;
				var y = Math.cos(a) * ray, z = Math.sin(a) * ray;
				var y2 = Math.cos(a2) * ray, z2 = Math.sin(a2) * ray;

				var index = pts.length;
				pts.push(new Point(x0, y, z));
				pts.push(new Point(x0, y2, z2));
				pts.push(new Point(x1, y, z));
				pts.push(new Point(x1, y2, z2));
	
				var n0 = new Point(0.0, Math.cos(a), Math.sin(a));
				var n1 = new Point(0.0, Math.cos(a2), Math.sin(a2));
				normals.push(n0);
				normals.push(n1);
				normals.push(n0.clone());
				normals.push(n1.clone());

				idx.push(pts.length);
				idx.push(pts.length + 1);
				idx.push(pts.length + 3);

				idx.push(pts.length + 0);
				idx.push(pts.length + 3);
				idx.push(pts.length + 2);
			}
		}
		halfSphere(-length * 0.5, Math.PI * 0.5);
		halfSphere(length * 0.5, -Math.PI * 0.5);
		cylinder();

		super(pts, idx);
	}

	override public function getCollider() : h3d.col.Collider {
		return new h3d.col.Sphere(translatedX, translatedY, translatedZ, ray * scaled);
	}

	override function addNormals() {
	}

	public static function defaultUnitSphere() {
		var engine = h3d.Engine.getCurrent();
		var s : Capsule = @:privateAccess engine.resCache.get(Capsule);
		if( s != null )
			return s;
		s = new h3d.prim.Capsule(1, 1, 16, 16);
		@:privateAccess engine.resCache.set(Capsule, s);
		return s;
	}

}
