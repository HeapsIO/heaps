package h3d.col;

class Capsule extends Collider {

	public var a : Point;
	public var b : Point;
	public var r : Float;
	static var tmpSphere = new Sphere(0., 0., 0., 0.);

	public inline function new(a : Point, b : Point, r : Float) {
		this.a = a;
		this.b = b;
		this.r = r;
	}

	public inline function contains( p : Point ) {
		return new Seg(a, b).distanceSq(p) < r*r;
	}

	/* https://iquilezles.org/articles/intersectors/ */
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
			var t = (-b- hxd.Math.sqrt(h))/a;
			var y = baoa + t * bard;
			if ( y > 0.0 && y < baba )
				return t;
			var oc = y <= 0.0 ? oa : ro - pb;
			b = rd.dot(oc);
			c = oc.dot(oc) - ra * ra;
			h = b*b - c;
			if( h > 0.0 )
				return -b - hxd.Math.sqrt(h);
		}
		return -1;
	}

	public function inFrustum( f : Frustum, ?m : h3d.Matrix ) {
		if( m != null )
			throw "Not implemented";
		tmpSphere.load(a.x + (b.x-a.x), a.y + (b.y-a.y), a.z + (b.z-a.z), (b.distance(a)/2 + r));
		return tmpSphere.inFrustum(f);
	}

	public function inSphere( s : Sphere ) {
		tmpSphere.load(a.x + (b.x-a.x), a.y + (b.y-a.y), a.z + (b.z-a.z), (b.distance(a)/2 + r));
		return tmpSphere.inSphere(s);
	}

	public function toString() {
		return "Capsule{" + a + "," + b + "," + hxd.Math.fmt(r) + "}";
	}

	public function dimension() {
		return a.distance(b) + 2 * r;
	}

	public function closestPoint(p : Point) {
		throw "not implemented";
		return new h3d.col.Point();
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

		var prim = new h3d.prim.Sphere(r, segW, segH, 0.5);
		prim.translate(0, 0, dist / 2);
		prim.addNormals();
		var spherea = new h3d.scene.Mesh(prim);
		var sphereb = spherea.clone();
		spherea.rotate(0, Math.PI / 2, 0);
		obj.addChild(spherea);
		sphereb.rotate(0, -1 * Math.PI / 2, 0);
		obj.addChild(sphereb);

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