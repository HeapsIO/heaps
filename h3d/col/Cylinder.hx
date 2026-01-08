package h3d.col;

class Cylinder extends Collider {

	public var a : Point;
	public var b : Point;
	public var r : Float;
	static var tmpSphere = new Sphere(0., 0., 0., 0.);

	public inline function new( a : Point, b : Point, r : Float ) {
		this.a = a;
		this.b = b;
		this.r = r;
	}

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		var ro = r.getPos();
		var rd = r.getDir();
		var ra = this.r;
		var pa = a;
		var pb = b;
		var ba = pb - pa;
		var oa = ro - pa;
		var baba = ba.dot(ba);
		var bard = ba.dot(rd);
		var baoa = ba.dot(oa);
		var rdoa = rd.dot(oa);
		var oaoa = oa.dot(oa);
		var a = baba - bard * bard;
		var b = baba * rdoa - baoa * bard;
		var c = baba * oaoa - baoa * baoa - ra * ra * baba;
		var h = b * b - a * c;
		if ( h >= 0.0 ) {
			var hs = hxd.Math.sqrt(h);
			var t = (-b - hs)/a;
			var y = baoa + t * bard;
			if ( y > 0.0 && y < baba )
				return t;
			t = ((y < 0.0 ? 0.0 : baba) - baoa) / bard;
			if( hxd.Math.abs(b + a * t) < hs )
				return t;
		}
		return -1;
	}

	public inline function contains( p : Point ) : Bool {
		var t = p.sub(a).dot(b.sub(a)) / a.distanceSq(b);
		if( t < 0 || t > 1 )
			return false;
		return p.distanceSq(new Point(a.x + t * (b.x - a.x), a.y + t * (b.y - a.y), a.z + t * (b.z - a.z))) < r * r;
	}

	public function inFrustum( f : Frustum, ?m : h3d.Matrix ) : Bool {
		if( m != null )
			throw "Not implemented";
		tmpSphere.load(a.x + (b.x-a.x), a.y + (b.y-a.y), a.z + (b.z-a.z), dimension() * 0.5);
		return tmpSphere.inFrustum(f);
	}

	public function inSphere( s : Sphere ) : Bool {
		tmpSphere.load(a.x + (b.x-a.x), a.y + (b.y-a.y), a.z + (b.z-a.z), dimension() * 0.5);
		return tmpSphere.inSphere(s);
	}

	public function toString() {
		return "Cylinder{" + a + "," + b + "," + hxd.Math.fmt(r) + "}";
	}

	public inline function dimension() : Float {
		var h2 = a.distance(b) * 0.5;
		return 2 * hxd.Math.sqrt(h2 * h2 + r * r);
	}

	public function closestPoint( p : Point ) : Point {
		throw "not implemented";
	}

	#if !macro
	public function makeDebugObj() : h3d.scene.Object {
		var obj = new h3d.scene.Object();

		var segW = 12;
		var segH = 6;

		var dir = a.sub(b);
		var full = a.add(b);
		var dist = a.distance(b);
		var midPoint = new Point(full.x / 2, full.y / 2, full.z / 2);

		var prim = new h3d.prim.Disc(r, segW);
		prim.translate(0, 0, dist / 2);
		prim.addNormals();
		var disca = new h3d.scene.Mesh(prim);
		var discb = disca.clone();
		disca.rotate(0, Math.PI / 2, 0);
		obj.addChild(disca);
		discb.rotate(0, -1 * Math.PI / 2, 0);
		obj.addChild(discb);

		var cyl = new h3d.prim.Cylinder(segW, r, dist, true);
		cyl.addNormals();
		var cylMesh = new h3d.scene.Mesh(cyl);
		cylMesh.rotate(0, Math.PI / 2, 0);
		obj.addChild(cylMesh);

		obj.setDirection(dir.toVector());
		obj.setPosition(midPoint.x, midPoint.y, midPoint.z);
		return obj;
	}
	#end

}
