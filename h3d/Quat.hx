package h3d;
import h3d.impl.Tools;

class Quat {
	
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public var w : Float;
	
	public function new( x = 0., y = 0., z = 0., w = 1. ) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	public function length() {
		return Math.sqrt(x * x + y * y + z * z + w * w);
	}
	
	public function clone() {
		return new Quat(x, y, z, w);
	}
	
	public function initRotateAxis( x : Float, y : Float, z : Float, a : Float ) {
		var sin = Math.sin(a / 2);
		var cos = Math.cos(a / 2);
		this.x = x * sin;
		this.y = y * sin;
		this.z = z * sin;
		this.w = cos * Math.sqrt(x * x + y * y + z * z); // allow not normalized axis
		normalize();
	}
	
	public function normalize() {
		var len = length();
		if( len < Tools.EPSILON ) {
			x = y = z = 0;
			w = 1;
		} else {
			var m = 1 / len;
			x *= m;
			y *= m;
			z *= m;
			w *= m;
		}
	}
	
	public function initRotate( ax : Float, ay : Float, az : Float ) {
		#if flash
		var Math = Math;
		#end
		var sinX = Math.sin( ax * 0.5 );
		var cosX = Math.cos( ax * 0.5 );
		var sinY = Math.sin( ay * 0.5 );
		var cosY = Math.cos( ay * 0.5 );
		var sinZ = Math.sin( az * 0.5 );
		var cosZ = Math.cos( az * 0.5 );
		var cosYZ = cosY * cosZ;
		var sinYZ = sinY * sinZ;
		x = sinX * cosYZ - cosX * sinYZ;
		y = cosX * sinY * cosZ + sinX * cosY * sinZ;
		z = cosX * cosY * sinZ - sinX * sinY * cosZ;
		w = cosX * cosYZ + sinX * sinYZ;
	}
	
	public function multiply( q : Quat ) {
		var x2 = x * q.w + w * q.x + y * q.z - z * q.y;
		var y2 = w * q.y - x * q.z + y * q.w + z * q.x;
		var z2 = w * q.z + x * q.y - y * q.x + z * q.w;
		var w2 = w * q.w - x * q.x - y * q.y - z * q.z;
		x = x2;
		y = y2;
		z = z2;
		w = w2;
	}
	
	public function toMatrix() {
		var m = new Matrix();
		saveToMatrix(m);
		return m;
	}
	
	public function toEuler() {
		return new Vector(
			Math.atan2(2 * (y * w + x * z), 1 - 2 * (y * y + z * z)),
			Math.asin(2 * (x * y + z * w)),
			Math.atan2(2 * (x * w - y * z), 1 - 2 * (x * x + z * z))
		);
	}
	
	public inline function lerp( q1 : Quat, q2 : Quat, v : Float ) {
		var x = q1.x * v + q2.x * (1 - v);
		var y = q1.y * v + q2.y * (1 - v);
		var z = q1.z * v + q2.z * (1 - v);
		var w = q1.w * v + q2.w * (1 - v);
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	public inline function dot( q : Quat ) {
		return x * q.x + y * q.y + z * q.z + w * q.w;
	}
	
	public function saveToMatrix( m : h3d.Matrix ) {
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
		return "{"+Tools.f(x)+","+Tools.f(y)+","+Tools.f(z)+","+Tools.f(w)+"}";
	}
	
}
