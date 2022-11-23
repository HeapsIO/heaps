package h3d.prim;
import h3d.col.Point;

class Sphere extends Polygon {

	var ray : Float;
	var segsH : Int;
	var segsW : Int;

	// Use 1 for a full sphere, 0.5 for a half sphere
	var portion : Float;

	public function new( ray = 1., segsW = 8, segsH = 6, portion = 1. ) {
		this.ray = ray;
		this.segsH = segsH;
		this.segsW = segsW;
		this.portion = portion;

		var dp = Math.PI * 2 / segsW;
		var pts = [], idx = new hxd.IndexBuffer();
		for( y in 0...segsH+1 ) {
			var t = (y / segsH) * Math.PI * portion;
			var st = Math.sin(t);
			var pz = Math.cos(t);
			var p = 0.;
			for( x in 0...segsW+1 ) {
				var px = st * Math.cos(p);
				var py = st * Math.sin(p);
				pts.push(new Point(px * ray, py * ray, pz * ray));
				p += dp;
			}
		}
		for( y in 0...segsH ) {
			for( x in 0...segsW ) {
				inline function vertice(x, y) return x + y * (segsW + 1);
				var v1 = vertice(x + 1, y);
				var v2 = vertice(x, y);
				var v3 = vertice(x, y + 1);
				var v4 = vertice(x + 1, y + 1);
				if( y != 0 ) {
					idx.push(v1);
					idx.push(v2);
					idx.push(v4);
				}
				if( y != segsH - 1 || portion != 1. ) {
					idx.push(v2);
					idx.push(v3);
					idx.push(v4);
				}
			}
		}

		super(pts, idx);
	}

	override public function getCollider() : h3d.col.Collider {
		return new h3d.col.Sphere(translatedX, translatedY, translatedZ, ray * scaled);
	}

	override function addNormals() {
		normals = points;
	}

	override function addUVs() {
		uvs = [];
		for( y in 0...segsH + 1 )
			for( x in 0...segsW + 1 )
				uvs.push(new UV(1 - x / segsW, y / segsH));
	}

	public static function defaultUnitSphere() {
		var engine = h3d.Engine.getCurrent();
		var s : Sphere = @:privateAccess engine.resCache.get(Sphere);
		if( s != null )
			return s;
		s = new h3d.prim.Sphere(1, 16, 16);
		s.addNormals();
		s.addUVs();
		@:privateAccess engine.resCache.set(Sphere, s);
		return s;
	}

}
