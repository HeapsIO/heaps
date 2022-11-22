package h3d.col;

class Capsule implements Collider {

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

	public function rayIntersection( r : Ray, bestMatch : Bool ) : Float {
		// computing  t'  =  (t * AB.RD + AB.AO) / AB.AB  =  t * m + n
		var AB = new h3d.col.Point(b.x-a.x, b.y-a.y, b.z-a.z);
		var o = r.getPos();
		var AO = new h3d.col.Point(o.x-a.x, o.y-a.y, o.z-a.z);

		var RD = r.getDir();

		var ABdotAB = AB.dot(AB);

		if (ABdotAB == 0) {
			tmpSphere.load(this.a.x, this.a.y, this.a.z, this.r);
			return tmpSphere.rayIntersection(r, bestMatch);
		}

		var m = AB.dot(RD) / ABdotAB;
		var n = AB.dot(AO) / ABdotAB;

		// using |PK| = r to solve t
		var Q = new h3d.col.Point(RD.x-(AB.x*m), RD.y-(AB.y*m), RD.z-(AB.z*m)); // RD - (AB * m)
		var R = new h3d.col.Point(AO.x-(AB.x*n), AO.y-(AB.y*n), AO.z-(AB.z*n)); // AO - (AB * n);

		var coefA = Q.dot(Q);
		var coefB = 2.0 * Q.dot(R);
		var coefC = R.dot(R) - (this.r * this.r);

		if (coefA == 0.0) { // if parallel
			tmpSphere.load(this.a.x, this.a.y, this.a.z, this.r);
			var intersectSphereA = tmpSphere.rayIntersection(r, bestMatch);
			tmpSphere.load(this.b.x, this.b.y, this.b.z, this.r);
			var intersectSphereB = tmpSphere.rayIntersection(r, bestMatch);

			if (intersectSphereA < 0 && intersectSphereB < 0) {
				return -1;
			}

			if (intersectSphereB < intersectSphereA) {
				return intersectSphereB;
			}

			if (intersectSphereA < intersectSphereB) {
				return intersectSphereA;
			}
		}

		var discriminant = coefB * coefB - 4.0 * coefA * coefC;

		if (discriminant < 0.0) {
			return -1;
		}
		var discriminantSqrt = Math.sqrt(discriminant);

		var t1 = (- coefB - discriminantSqrt) / (2.0 * coefA);
		var t2 = (- coefB + discriminantSqrt) / (2.0 * coefA);

		var tMin = (t1 < t2) ? t1 : t2;

		var tPrimeMin = tMin * m + n;

		if (tPrimeMin < 0.0) {
			tmpSphere.load(this.a.x, this.a.y, this.a.z, this.r);
			return tmpSphere.rayIntersection(r, bestMatch);
		} else if (tPrimeMin > 1.0) {
			tmpSphere.load(this.b.x, this.b.y, this.b.z, this.r);
			return tmpSphere.rayIntersection(r, bestMatch);
		} else {
			var intersection = new Point(o.x + (RD.x * tMin), o.y + (RD.y * tMin), o.z + (RD.z * tMin));
			return o.distance(intersection);
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