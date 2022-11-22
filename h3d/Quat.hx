package h3d;
using hxd.Math;

@:noDebug
class Quat {

	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var w : Float;

	public inline function new( x = 0., y = 0., z = 0., w = 1. ) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public inline function set(x, y, z, w) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public inline function identity() {
		x = y = z = 0;
		w = 1;
	}

	public inline function lengthSq() {
		return x * x + y * y + z * z + w * w;
	}

	public inline function length() {
		return lengthSq().sqrt();
	}

	public inline function load( q : Quat ) {
		this.x = q.x;
		this.y = q.y;
		this.z = q.z;
		this.w = q.w;
	}

	public function clone() {
		return new Quat(x, y, z, w);
	}

	public function initMoveTo( from : Vector, to : Vector ) {
		//		H = Normalize(From + To)
		//		Q = (From ^ H, From . H)
		//
		// We have an issue when From.To moves towards -1, a small tilt on From ^ To will result in big tilt.
		var hx = from.x + to.x;
		var hy = from.y + to.y;
		var hz = from.z + to.z;
		var h = Math.invSqrt(hx * hx + hy * hy + hz * hz);
		x = from.y * hz - from.z * hy;
		y = from.z * hx - from.x * hz;
		z = from.x * hy - from.y * hx;
		w = from.x * hx + from.y * hy + from.z * hz;
		normalize();
	}

	public function initNormal( dir : h3d.col.Point ) {
		var dir = dir.normalized();
		if( dir.x*dir.x+dir.y*dir.y < Math.EPSILON )
			initDirection(new h3d.Vector(1,0,0));
		else {
			var ay = new h3d.col.Point(dir.x, dir.y, 0).normalized();
			var az = dir.cross(ay);
			initDirection(dir.cross(az).toVector());
		}
	}

	public function initDirection( dir : Vector ) {
		// inlined version of initRotationMatrix(Matrix.lookAtX(dir))
		var ax = dir.clone().normalized();
		var ay = new Vector(-ax.y, ax.x, 0).normalized();
		if( ay.lengthSq() < Math.EPSILON ) {
			ay.x = ax.y;
			ay.y = ax.z;
			ay.z = ax.x;
		}
		var az = ax.cross(ay);
		var tr = ax.x + ay.y + az.z;
		if( tr > 0 ) {
			var s = (tr + 1.0).sqrt() * 2;
			var ins = 1 / s;
			x = (ay.z - az.y) * ins;
			y = (az.x - ax.z) * ins;
			z = (ax.y - ay.x) * ins;
			w = 0.25 * s;
		} else if( ax.x > ay.y && ax.x > az.z ) {
			var s = (1.0 + ax.x - ay.y - az.z).sqrt() * 2;
			var ins = 1 / s;
			x = 0.25 * s;
			y = (ay.x + ax.y) * ins;
			z = (az.x + ax.z) * ins;
			w = (ay.z - az.y) * ins;
		} else if( ay.y > az.z ) {
			var s = (1.0 + ay.y - ax.x - az.z).sqrt() * 2;
			var ins = 1 / s;
			x = (ay.x + ax.y) * ins;
			y = 0.25 * s;
			z = (az.y + ay.z) * ins;
			w = (az.x - ax.z) * ins;
		} else {
			var s = (1.0 + az.z - ax.x - ay.y).sqrt() * 2;
			var ins = 1 / s;
			x = (az.x + ax.z) * ins;
			y = (az.y + ay.z) * ins;
			z = 0.25 * s;
			w = (ax.y - ay.x) * ins;
		}
	}

	public function initRotateAxis( x : Float, y : Float, z : Float, a : Float ) {
		var sin = (a / 2).sin();
		var cos = (a / 2).cos();
		this.x = x * sin;
		this.y = y * sin;
		this.z = z * sin;
		this.w = cos * (x * x + y * y + z * z).sqrt(); // allow not normalized axis
		normalize();
	}

	public function initRotateMatrix( m : Matrix ) {
		var tr = m._11 + m._22 + m._33;
		if( tr > 0 ) {
			var s = (tr + 1.0).sqrt() * 2;
			var ins = 1 / s;
			x = (m._23 - m._32) * ins;
			y = (m._31 - m._13) * ins;
			z = (m._12 - m._21) * ins;
			w = 0.25 * s;
		} else if( m._11 > m._22 && m._11 > m._33 ) {
			var s = (1.0 + m._11 - m._22 - m._33).sqrt() * 2;
			var ins = 1 / s;
			x = 0.25 * s;
			y = (m._21 + m._12) * ins;
			z = (m._31 + m._13) * ins;
			w = (m._23 - m._32) * ins;
		} else if( m._22 > m._33 ) {
			var s = (1.0 + m._22 - m._11 - m._33).sqrt() * 2;
			var ins = 1 / s;
			x = (m._21 + m._12) * ins;
			y = 0.25 * s;
			z = (m._32 + m._23) * ins;
			w = (m._31 - m._13) * ins;
		} else {
			var s = (1.0 + m._33 - m._11 - m._22).sqrt() * 2;
			var ins = 1 / s;
			x = (m._31 + m._13) * ins;
			y = (m._32 + m._23) * ins;
			z = 0.25 * s;
			w = (m._12 - m._21) * ins;
		}
	}

	public function normalize() {
		var len = x * x + y * y + z * z + w * w;
		if( len < hxd.Math.EPSILON ) {
			x = y = z = 0;
			w = 1;
		} else {
			var m = len.invSqrt();
			x *= m;
			y *= m;
			z *= m;
			w *= m;
		}
	}

	public function initRotation( ax : Float, ay : Float, az : Float ) {
		var sinX = ( ax * 0.5 ).sin();
		var cosX = ( ax * 0.5 ).cos();
		var sinY = ( ay * 0.5 ).sin();
		var cosY = ( ay * 0.5 ).cos();
		var sinZ = ( az * 0.5 ).sin();
		var cosZ = ( az * 0.5 ).cos();
		var cosYZ = cosY * cosZ;
		var sinYZ = sinY * sinZ;
		x = sinX * cosYZ - cosX * sinYZ;
		y = cosX * sinY * cosZ + sinX * cosY * sinZ;
		z = cosX * cosY * sinZ - sinX * sinY * cosZ;
		w = cosX * cosYZ + sinX * sinYZ;
	}

	public function multiply( q1 : Quat, q2 : Quat ) {
		var x2 = q1.x * q2.w + q1.w * q2.x + q1.y * q2.z - q1.z * q2.y;
		var y2 = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x;
		var z2 = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w;
		var w2 = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
		x = x2;
		y = y2;
		z = z2;
		w = w2;
	}

	public function toEuler() {
		return toMatrix().getEulerAngles();
	}

	public inline function lerp( q1 : Quat, q2 : Quat, v : Float, nearest = false ) {
		var v2 = 1 - v;
		if( nearest && q1.dot(q2) < 0 )
			v = -v;
		var x = q1.x * v2 + q2.x * v;
		var y = q1.y * v2 + q2.y * v;
		var z = q1.z * v2 + q2.z * v;
		var w = q1.w * v2 + q2.w * v;
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public function slerp( q1 : Quat, q2 : Quat, v : Float ) {
		var cosHalfTheta = q1.dot(q2);
		if( cosHalfTheta.abs() >= 1 ) {
			this.x = q1.x;
			this.y = q1.y;
			this.z = q1.z;
			this.w = q1.w;
			return;
		}
		var halfTheta = cosHalfTheta.acos();
		var invSinHalfTheta = (1 - cosHalfTheta * cosHalfTheta).invSqrt();
		if( invSinHalfTheta.abs() > 1e3 ) {
			this.lerp(q1, q2, 0.5, true);
			return;
		}
		var a = ((1 - v) * halfTheta).sin() * invSinHalfTheta;
		var b = (v * halfTheta).sin() * invSinHalfTheta * (cosHalfTheta < 0 ? -1 : 1);
		this.x = q1.x * a + q2.x * b;
		this.y = q1.y * a + q2.y * b;
		this.z = q1.z * a + q2.z * b;
		this.w = q1.w * a + q2.w * b;
	}

	public inline function conjugate() {
		x = -x;
		y = -y;
		z = -z;
	}

	/**
		Negate the quaternion: this will not change the actual angle, use `conjugate` for that.
	**/
	public inline function negate() {
		x = -x;
		y = -y;
		z = -z;
		w = -w;
	}

	public inline function dot( q : Quat ) {
		return x * q.x + y * q.y + z * q.z + w * q.w;
	}

	public inline function getDirection() {
		return new h3d.Vector(1 - 2 * ( y * y + z * z ), 2 * ( x * y + z * w ), 2 * ( x * z - y * w ));
	}

	/**
		Save to a Left-Handed matrix
	**/
	public function toMatrix( ?m : h3d.Matrix ) {
		if( m == null ) m = new h3d.Matrix();
		var xx = x * x;
		var xy = x * y;
		var xz = x * z;
		var xw = x * w;
		var yy = y * y;
		var yz = y * z;
		var yw = y * w;
		var zz = z * z;
		var zw = z * w;
		m._11 = 1 - 2 * ( yy + zz );
		m._12 = 2 * ( xy + zw );
		m._13 = 2 * ( xz - yw );
		m._14 = 0;
		m._21 = 2 * ( xy - zw );
		m._22 = 1 - 2 * ( xx + zz );
		m._23 = 2 * ( yz + xw );
		m._24 = 0;
		m._31 = 2 * ( xz + yw );
		m._32 = 2 * ( yz - xw );
		m._33 = 1 - 2 * ( xx + yy );
		m._34 = 0;
		m._41 = 0;
		m._42 = 0;
		m._43 = 0;
		m._44 = 1;
		return m;
	}

	public function toString() {
		return '{${x.fmt()},${y.fmt()},${z.fmt()},${w.fmt()}}';
	}

}
