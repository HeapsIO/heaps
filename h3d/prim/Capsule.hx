package h3d.prim;
import h3d.col.Point;

class Capsule extends Polygon {

	var ray : Float;
	var length : Float;
	var segs : Int;

	public function new( ray = 1., length = 1., segs = 8 ) {
		this.ray = ray;
		this.length = length;
		this.segs = segs;

		var dp = Math.PI / segs;
		var pts = [], idx = new hxd.IndexBuffer();
		normals = [];
		function halfSphere(offsetX : Float, offsetPhi : Float) {
			var indexOffset = pts.length;
			for( y in 0...segs+1 ) {
				var t = (y / segs) * Math.PI;
				var st = Math.sin(t);
				var pz = Math.cos(t);
				var p = offsetPhi;
				for( x in 0...segs+1 ) {
					var px = st * Math.cos(p);
					var py = st * Math.sin(p);
					pts.push(new Point(px * ray + offsetX, py * ray, pz * ray));
					normals.push(new Point(px, py, pz));
					p += dp;
				}
			}
			for( y in 0...segs ) {
				for( x in 0...segs ) {
					inline function vertice(x, y) return x + y * (segs + 1) + indexOffset;
					var v1 = vertice(x + 1, y);
					var v2 = vertice(x, y);
					var v3 = vertice(x, y + 1);
					var v4 = vertice(x + 1, y + 1);
					if( y != 0 ) {
						idx.push(v1);
						idx.push(v2);
						idx.push(v4);
					}
					if( y != segs - 1 ) {
						idx.push(v2);
						idx.push(v3);
						idx.push(v4);
					}
				}
			}
		}
		function cylinder() {
			var indexOffset = pts.length;
			for( y in 0...segs * 2 + 1 ) {
				var t = y / segs * Math.PI;
				var st = Math.sin(t);
				var pz = Math.cos(t);
				pts.push(new Point(-length * 0.5, st * ray, pz * ray));
				pts.push(new Point(length * 0.5, st * ray, pz * ray));
				normals.push(new Point(0.0, st, pz));
				normals.push(new Point(0.0, st, pz));
			}
			for( x in 0...segs * 2 ) {
				inline function vertice(i) return i + indexOffset;
				var v0 = vertice(x * 2);
				var v1 = vertice(x * 2 + 1);
				var v2 = vertice(x * 2 + 2);
				var v3 = vertice(x * 2 + 3);
				idx.push(v0);
				idx.push(v1);
				idx.push(v2);
				idx.push(v1);
				idx.push(v3);
				idx.push(v2);
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

	public static function defaultUnitCapsule() {
		var engine = h3d.Engine.getCurrent();
		var s : Capsule = @:privateAccess engine.resCache.get(Capsule);
		if( s != null )
			return s;
		s = new h3d.prim.Capsule(1, 1, 16);
		@:privateAccess engine.resCache.set(Capsule, s);
		return s;
	}

}
