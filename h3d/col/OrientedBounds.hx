package h3d.col;

class OrientedBounds extends Collider {
	public var centerX : Float = 0.0;
	public var centerY : Float = 0.0;
	public var centerZ : Float = 0.0;

	public var xx : Float = 1.0;
	public var xy : Float = 0.0;
	public var xz : Float = 0.0;

	public var yx : Float = 0.0;
	public var yy : Float = 1.0;
	public var yz : Float = 0.0;

	public var zx : Float = 0.0;
	public var zy : Float = 0.0;
	public var zz : Float = 1.0;

	public var hx : Float = 0.5;
	public var hy : Float = 0.5;
	public var hz : Float = 0.5;

	public function new() {
	}

	public function setMatrix(m: h3d.Matrix) {
		var s = inline m.getScale();
		var isx = 1.0/s.x;
		var isy = 1.0/s.y;
		var isz = 1.0/s.z;

		centerX = m.tx;
		centerY = m.ty;
		centerZ = m.tz;

		hx = s.x / 2.0;
		hy = s.y / 2.0;
		hz = s.z / 2.0;

		xx = m._11 * isx;
		xy = m._12 * isx;
		xz = m._13 * isx;

		yx = m._21 * isy;
		yy = m._22 * isy;
		yz = m._23 * isy;

		zx = m._31 * isz;
		zy = m._32 * isz;
		zz = m._33 * isz;
	}

	public function setEulerAngles(x: Float, y: Float, z: Float) {
		var cx = hxd.Math.cos(x); var sx = hxd.Math.sin(x);
		var cy = hxd.Math.cos(y); var sy = hxd.Math.sin(y);
		var cz = hxd.Math.cos(z); var sz  = hxd.Math.sin(z);

		xx = cy * cz;
		xy = sx*sy*cz + cx * sz;
		xz = -cx*sy*cz + sx*sz;

		yx = -cy*sz;
		yy = -sx*sy*sz + cx*cz;
		yz = cx*sy*sz + sx*cz;

		zx = sy;
		zy = -sx*cy;
		zz = cx*cy;
	}

	public function collideOrientedBounds(other: OrientedBounds) : Bool {
		// adapted from Christer Ericson "Real Time Collision Detection" Ch 4.4
		var ax = inline new h3d.Vector(xx,xy,xz);
		var ay = inline new h3d.Vector(yx,yy,yz);
		var az = inline new h3d.Vector(zx,zy,zz);

		var bx = inline new h3d.Vector(other.xx,other.xy,other.xz);
		var by = inline new h3d.Vector(other.yx,other.yy,other.yz);
		var bz = inline new h3d.Vector(other.zx,other.zy,other.zz);

		var R00 = ax.dot(bx);
		var R01 = ax.dot(by);
		var R02 = ax.dot(bz);

		var R10 = ay.dot(bx);
		var R11 = ay.dot(by);
		var R12 = ay.dot(bz);

		var R20 = az.dot(bx);
		var R21 = az.dot(by);
		var R22 = az.dot(bz);

		var ac = inline new h3d.Vector(centerX, centerY, centerZ);
		var bc = inline new h3d.Vector(other.centerX, other.centerY, other.centerZ);
		var t = inline bc.sub(ac);
		var tx = t.dot(ax);
		var ty = t.dot(ay);
		var tz = t.dot(az);
		t.x = tx; t.y = ty; t.z = tz;

		var absR00 = hxd.Math.abs(R00) + hxd.Math.EPSILON;
		var absR01 = hxd.Math.abs(R01) + hxd.Math.EPSILON;
		var absR02 = hxd.Math.abs(R02) + hxd.Math.EPSILON;

		var absR10 = hxd.Math.abs(R10) + hxd.Math.EPSILON;
		var absR11 = hxd.Math.abs(R11) + hxd.Math.EPSILON;
		var absR12 = hxd.Math.abs(R12) + hxd.Math.EPSILON;

		var absR20 = hxd.Math.abs(R20) + hxd.Math.EPSILON;
		var absR21 = hxd.Math.abs(R21) + hxd.Math.EPSILON;
		var absR22 = hxd.Math.abs(R22) + hxd.Math.EPSILON;


		// AXIS A0, A1, A2
		var ra = hx;
		var rb = other.hx * absR00 + other.hy * absR01 + other.hz * absR02;
		if (hxd.Math.abs(t.x) > ra + rb) return false;

		var ra = hy;
		var rb = other.hx * absR10 + other.hy * absR11 + other.hz * absR12;
		if (hxd.Math.abs(t.y) > ra + rb) return false;

		var ra = hz;
		var rb = other.hx * absR20 + other.hy * absR21 + other.hz * absR22;
		if (hxd.Math.abs(t.z) > ra + rb) return false;

		// Axis B0, B1, B2

		var ra = hx * absR00 + hy * absR10 + hz * absR20;
		var rb = other.hx;
		if (hxd.Math.abs(t.x * R00 + t.y * R10 + t.z * R20) > ra + rb) return false;

		var ra = hx * absR01 + hy * absR11 + hz * absR21;
		var rb = other.hy;
		if (hxd.Math.abs(t.x * R01 + t.y * R11 + t.z * R21) > ra + rb) return false;

		var ra = hx * absR02 + hy * absR12 + hz * absR22;
		var rb = other.hz;
		if (hxd.Math.abs(t.x * R02 + t.y * R12 + t.z * R22) > ra + rb) return false;

		// L = A0 x B0
		var ra = hy * absR20 + hz * absR10;
		var rb = other.hy * absR02 + other.hz * absR01;
		if (hxd.Math.abs(t.z * R10 - t.y * R20) > ra + rb) return false;

		// L = A0 x B1
		var ra = hy * absR21 + hz * absR11;
		var rb = other.hx * absR02 + other.hz * absR00;
		if (hxd.Math.abs(t.z * R11 - t.y * R21) > ra + rb) return false;

		// L = A0 x B2
		var ra = hy * absR22 + hz * absR12;
		var rb = other.hx * absR01 + other.hy * absR00;
		if (hxd.Math.abs(t.z * R12 - t.y * R22) > ra + rb) return false;

		// L = A1 x B0
		var ra = hx * absR20 + hz * absR00;
		var rb = other.hy * absR12 + other.hz * absR11;
		if (hxd.Math.abs(t.x * R20 - t.z * R00) > ra + rb) return false;

		// L = A1 x B1
		var ra = hx * absR21 + hz * absR01;
		var rb = other.hx * absR12 + other.hz * absR10;
		if (hxd.Math.abs(t.x * R21 - t.z * R01) > ra+ rb) return false;

		// L = A1 x B2
		var ra = hx * absR22 + hz * absR02;
		var rb = other.hx * absR11 + other.hy * absR10;
		if (hxd.Math.abs(t.x * R22 - t.z * R02) > ra + rb) return false;

		// L = A2 x B0
		var ra = hx * absR10 + hy * absR00;
		var rb = other.hy * absR22 + other.hz * absR21;
		if (hxd.Math.abs(t.y * R00 - t.x * R10) > ra + rb) return false;

		// L = A2 x B1
		var ra = hx * absR11 + hy * absR01;
		var rb = other.hx * absR22 + other.hz * absR20;
		if (hxd.Math.abs(t.y * R01 - t.x * R11) > ra + rb) return false;

		// L = A2 x B2
		var ra = hx * absR12 + hy * absR02;
		var rb = other.hx * absR21 + other.hy * absR20;
		if (hxd.Math.abs(t.y * R02 - t.x * R12) > ra + rb) return false;

		return true;
	}

	public function rayIntersection(r:Ray, bestMatch:Bool) : Float {
		var dx = r.px - centerX;
		var dy = r.py - centerY;
		var dz = r.pz - centerZ;

		var rpx = dx * xx + dy * xy + dz * xz;
		var rpy = dx * yx + dy * yy + dz * yz;
		var rpz = dx * zx + dy * zy + dz * zz;

		var rlx = r.lx * xx + r.ly * xy + r.lz * xz;
		var rly = r.lx * yx + r.ly * yy + r.lz * yz;
		var rlz = r.lx * zx + r.ly * zy + r.lz * zz;

		var tmin = 0.0;
		var tmax = hxd.Math.POSITIVE_INFINITY;

		if (hxd.Math.abs(rlx) < hxd.Math.EPSILON) {
			if (rpx < -hx || rpx > hx) return -1.0;
		} else {
			var ood = 1.0 / rlx;
			var t1 = (-hx - rpx) * ood;
			var t2 = (hx - rpx) * ood;

			if (t1 > t2) {
				var tmp = t2;
				t2 = t1;
				t1 = tmp;
			}

			if (t1 > tmin) tmin = t1;
			if (t2 < tmax) tmax = t2;

			if (tmin > tmax) return -1.0;
		}

		if (hxd.Math.abs(rly) < hxd.Math.EPSILON) {
			if (rpy < -hy || rpy > hy) return -1.0;
		} else {
			var ood = 1.0 / rly;
			var t1 = (-hy - rpy) * ood;
			var t2 = (hy - rpy) * ood;

			if (t1 > t2) {
				var tmp = t2;
				t2 = t1;
				t1 = tmp;
			}

			if (t1 > tmin) tmin = t1;
			if (t2 < tmax) tmax = t2;

			if (tmin > tmax) return -1.0;
		}

		if (hxd.Math.abs(rlz) < hxd.Math.EPSILON) {
			if (rpz < -hz || rpz > hz) return -1.0;
		} else {
			var ood = 1.0 / rlz;
			var t1 = (-hz - rpz) * ood;
			var t2 = (hz - rpz) * ood;

			if (t1 > t2) {
				var tmp = t2;
				t2 = t1;
				t1 = tmp;
			}

			if (t1 > tmin) tmin = t1;
			if (t2 < tmax) tmax = t2;

			if (tmin > tmax) return -1.0;
		}


		return tmin;
	}

	public function contains(p:Point):Bool {
		var dx = p.x - centerX;
		var dy = p.y - centerY;
		var dz = p.z - centerZ;

		var rpx = dx * xx + dy * xy + dz * xz;
		var rpy = dx * yx + dy * yy + dz * yz;
		var rpz = dx * zx + dy * zy + dz * zz;

		return (
			(hxd.Math.abs(hx) - hxd.Math.abs(rpx) > -hxd.Math.EPSILON) &&
			(hxd.Math.abs(hy) - hxd.Math.abs(rpy) > -hxd.Math.EPSILON) &&
			(hxd.Math.abs(hz) - hxd.Math.abs(rpz) > -hxd.Math.EPSILON)
		);
	}

	public function inFrustum(f:Frustum, ?localMatrix:Matrix):Bool {
		for (i in 0...8) {
			var v = inline getVertice(i);
			if (f.hasPoint(v)) return true;
		}
		return false;
	}

	public function inSphere(s:Sphere):Bool {
		var sp = inline s.getCenter();
		var rr = s.r * s.r;
		for (i in 0...8) {
			var v = inline getVertice(i);
			if (v.distanceSq(sp) > rr) return false;
		}
		return true;
	}

	public function dimension():Float {
		return 2.0 * hxd.Math.max(hx, hxd.Math.max(hy, hz));
	}

	inline public function getVertice(i: Int) : h3d.Vector {
		var sx = (i & 1) * 2 - 1;
		var sy = ((i >> 1) & 1) * 2 - 1;
		var sz = ((i >> 2) & 1) * 2 - 1;
		var ax = inline new h3d.Vector(xx,xy,xz);
		var ay = inline new h3d.Vector(yx,yy,yz);
		var az = inline new h3d.Vector(zx,zy,zz);
		var c = inline new h3d.Vector(centerX,centerY,centerZ);

		ax.scale(sx * hx);
		ay.scale(sy * hy);
		az.scale(sz * hz);

		return c+ax+ay+az;
	}

	public function getVertices(?out:Array<Vector>) : Array<Vector> {
		out = out ?? [];
		for (i in 0...8) {
			out.push(getVertice(i));
		}

		return out;
	}

	public function closestPoint(p : Point) {
		throw "not implemented";
		return new Point();
	}

	public function makeDebugObj():h3d.scene.Object {
		var g = new h3d.scene.Graphics();

		var verts : Array<Vector> = getVertices();

		g.lineStyle(1.0, 0xFFFFFF, 1.0);

		for (i in 0...4) {
			g.moveTo(verts[i].x, verts[i].y, verts[i].z);
			g.lineTo(verts[i+4].x, verts[i+4].y, verts[i+4].z);
		}

		for (i in 0...2) {
			g.moveTo(verts[i*4].x, verts[i*4].y, verts[i*4].z);
			g.lineTo(verts[i*4+1].x, verts[i*4+1].y, verts[i*4+1].z);
			g.lineTo(verts[i*4+3].x, verts[i*4+3].y, verts[i*4+3].z);
			g.lineTo(verts[i*4+2].x, verts[i*4+2].y, verts[i*4+2].z);
			g.lineTo(verts[i*4].x, verts[i*4].y, verts[i*4].z);
		}

		return g;
	}
}