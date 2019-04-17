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

	public function inFrustum( f : Frustum ) {
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

	#if (hxbit && !macro)
	function customSerialize( ctx : hxbit.Serializer ) {
		ctx.addFloat(a.x);
		ctx.addFloat(a.y);
		ctx.addFloat(a.z);
		ctx.addFloat(b.x);
		ctx.addFloat(b.y);
		ctx.addFloat(b.z);
		ctx.addFloat(r);
	}
	function customUnserialize( ctx : hxbit.Serializer ) {
		a = new Point(ctx.getFloat(), ctx.getFloat(), ctx.getFloat());
		b = new Point(ctx.getFloat(), ctx.getFloat(), ctx.getFloat());
		r = ctx.getFloat();
	}
	#end

}