package h3d;
import hxd.Math;

class Matrix {

	static var tmp = new Matrix();

	public var _11 : Float;
	public var _12 : Float;
	public var _13 : Float;
	public var _14 : Float;
	public var _21 : Float;
	public var _22 : Float;
	public var _23 : Float;
	public var _24 : Float;
	public var _31 : Float;
	public var _32 : Float;
	public var _33 : Float;
	public var _34 : Float;
	public var _41 : Float;
	public var _42 : Float;
	public var _43 : Float;
	public var _44 : Float;

	public var tx(get, set) : Float;
	public var ty(get, set) : Float;
	public var tz(get, set) : Float;

	public function new() {
	}

	inline function get_tx() return _41;
	inline function get_ty() return _42;
	inline function get_tz() return _43;
	inline function set_tx(v) return _41 = v;
	inline function set_ty(v) return _42 = v;
	inline function set_tz(v) return _43 = v;

	public function zero() {
		_11 = 0.0; _12 = 0.0; _13 = 0.0; _14 = 0.0;
		_21 = 0.0; _22 = 0.0; _23 = 0.0; _24 = 0.0;
		_31 = 0.0; _32 = 0.0; _33 = 0.0; _34 = 0.0;
		_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 0.0;
	}

	public function identity() {
		_11 = 1.0; _12 = 0.0; _13 = 0.0; _14 = 0.0;
		_21 = 0.0; _22 = 1.0; _23 = 0.0; _24 = 0.0;
		_31 = 0.0; _32 = 0.0; _33 = 1.0; _34 = 0.0;
		_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
	}

	public function initRotateX( a : Float ) {
		var cos = Math.cos(a);
		var sin = Math.sin(a);
		_11 = 1.0; _12 = 0.0; _13 = 0.0; _14 = 0.0;
		_21 = 0.0; _22 = cos; _23 = sin; _24 = 0.0;
		_31 = 0.0; _32 = -sin; _33 = cos; _34 = 0.0;
		_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
	}

	public function initRotateY( a : Float ) {
		var cos = Math.cos(a);
		var sin = Math.sin(a);
		_11 = cos; _12 = 0.0; _13 = -sin; _14 = 0.0;
		_21 = 0.0; _22 = 1.0; _23 = 0.0; _24 = 0.0;
		_31 = sin; _32 = 0.0; _33 = cos; _34 = 0.0;
		_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
	}

	public function initRotateZ( a : Float ) {
		var cos = Math.cos(a);
		var sin = Math.sin(a);
		_11 = cos; _12 = sin; _13 = 0.0; _14 = 0.0;
		_21 = -sin; _22 = cos; _23 = 0.0; _24 = 0.0;
		_31 = 0.0; _32 = 0.0; _33 = 1.0; _34 = 0.0;
		_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
	}

	public function initTranslate( x = 0., y = 0., z = 0. ) {
		_11 = 1.0; _12 = 0.0; _13 = 0.0; _14 = 0.0;
		_21 = 0.0; _22 = 1.0; _23 = 0.0; _24 = 0.0;
		_31 = 0.0; _32 = 0.0; _33 = 1.0; _34 = 0.0;
		_41 = x; _42 = y; _43 = z; _44 = 1.0;
	}

	public function initScale( x = 1., y = 1., z = 1. ) {
		_11 = x; _12 = 0.0; _13 = 0.0; _14 = 0.0;
		_21 = 0.0; _22 = y; _23 = 0.0; _24 = 0.0;
		_31 = 0.0; _32 = 0.0; _33 = z; _34 = 0.0;
		_41 = 0.0; _42 = 0.0; _43 = 0.0; _44 = 1.0;
	}

	public function initRotateAxis( axis : Vector, angle : Float ) {
		var cos = Math.cos(angle), sin = Math.sin(angle);
		var cos1 = 1 - cos;
		var x = -axis.x, y = -axis.y, z = -axis.z;
		var xx = x * x, yy = y * y, zz = z * z;
		var len = Math.invSqrt(xx + yy + zz);
		x *= len;
		y *= len;
		z *= len;
		var xcos1 = x * cos1, zcos1 = z * cos1;
		_11 = cos + x * xcos1;
		_12 = y * xcos1 - z * sin;
		_13 = x * zcos1 + y * sin;
		_14 = 0.;
		_21 = y * xcos1 + z * sin;
		_22 = cos + y * y * cos1;
		_23 = y * zcos1 - x * sin;
		_24 = 0.;
		_31 = x * zcos1 - y * sin;
		_32 = y * zcos1 + x * sin;
		_33 = cos + z * zcos1;
		_34 = 0.;
		_41 = 0.; _42 = 0.; _43 = 0.; _44 = 1.;
	}

	public function initRotate( x : Float, y : Float, z : Float ) {
		var cx = Math.cos(x);
		var sx = Math.sin(x);
		var cy = Math.cos(y);
		var sy = Math.sin(y);
		var cz = Math.cos(z);
		var sz = Math.sin(z);
		var cxsy = cx * sy;
		var sxsy = sx * sy;
		_11 = cy * cz;
		_12 = cy * sz;
		_13 = -sy;
		_14 = 0;
		_21 = sxsy * cz - cx * sz;
		_22 = sxsy * sz + cx * cz;
		_23 = sx * cy;
		_24 = 0;
		_31 = cxsy * cz + sx * sz;
		_32 = cxsy * sz - sx * cz;
		_33 = cx * cy;
		_34 = 0;
		_41 = 0;
		_42 = 0;
		_43 = 0;
		_44 = 1;
	}

	public function translate( x = 0., y = 0., z = 0. ) {
		_11 += x * _14;
		_12 += y * _14;
		_13 += z * _14;
		_21 += x * _24;
		_22 += y * _24;
		_23 += z * _24;
		_31 += x * _34;
		_32 += y * _34;
		_33 += z * _34;
		_41 += x * _44;
		_42 += y * _44;
		_43 += z * _44;
	}

	public function scale( x = 1., y = 1., z = 1. ) {
		_11 *= x;
		_21 *= x;
		_31 *= x;
		_41 *= x;
		_12 *= y;
		_22 *= y;
		_32 *= y;
		_42 *= y;
		_13 *= z;
		_23 *= z;
		_33 *= z;
		_43 *= z;
	}

	public function rotate( x, y, z ) {
		var tmp = tmp;
		tmp.initRotate(x,y,z);
		multiply(this, tmp);
	}

	public function rotateAxis( axis, angle ) {
		var tmp = tmp;
		tmp.initRotateAxis(axis, angle);
		multiply(this, tmp);
	}

	public inline function pos( ?v : Vector ) {
		if( v == null )
			return new Vector( _41, _42 , _43 , _44 );
		v.x = _41;
		v.y = _42;
		v.z = _43;
		v.w = _44;
		return v;
	}

	public function prependTranslate( x = 0., y = 0., z = 0. ) {
		var vx = _11 * x + _21 * y + _31 * z + _41;
		var vy = _12 * x + _22 * y + _32 * z + _42;
		var vz = _13 * x + _23 * y + _33 * z + _43;
		var vw = _14 * x + _24 * y + _34 * z + _44;
		_41 = vx;
		_42 = vy;
		_43 = vz;
		_44 = vw;
	}

	public inline function getScale() {
		var v = new Vector();
		v.x = Math.sqrt(_11 * _11 + _12 * _12 + _13 * _13);
		v.y = Math.sqrt(_21 * _21 + _22 * _22 + _23 * _23);
		v.z = Math.sqrt(_31 * _31 + _32 * _32 + _33 * _33);
		if( getDeterminant() < 0 ) {
			v.x *= -1;
			v.y *= -1;
			v.z *= -1;
		}
		return v;
	}

	public function prependRotate( x, y, z ) {
		var tmp = tmp;
		tmp.initRotate(x,y,z);
		multiply(tmp, this);
	}

	public function prependRotateAxis( axis, angle ) {
		var tmp = tmp;
		tmp.initRotateAxis(axis, angle);
		multiply(tmp, this);
	}

	public function prependScale( sx = 1., sy = 1., sz = 1. ) {
		var tmp = tmp;
		tmp.initScale(sx,sy,sz);
		multiply(tmp, this);
	}

	@:noDebug
	public function multiply3x4( a : Matrix, b : Matrix ) {
		multiply3x4inline(a, b);
	}

	public inline function multiply3x4inline( a : Matrix, b : Matrix ) {
		var m11 = a._11; var m12 = a._12; var m13 = a._13;
		var m21 = a._21; var m22 = a._22; var m23 = a._23;
		var a31 = a._31; var a32 = a._32; var a33 = a._33;
		var a41 = a._41; var a42 = a._42; var a43 = a._43;
		var b11 = b._11; var b12 = b._12; var b13 = b._13;
		var b21 = b._21; var b22 = b._22; var b23 = b._23;
		var b31 = b._31; var b32 = b._32; var b33 = b._33;
		var b41 = b._41; var b42 = b._42; var b43 = b._43;

		_11 = m11 * b11 + m12 * b21 + m13 * b31;
		_12 = m11 * b12 + m12 * b22 + m13 * b32;
		_13 = m11 * b13 + m12 * b23 + m13 * b33;
		_14 = 0;

		_21 = m21 * b11 + m22 * b21 + m23 * b31;
		_22 = m21 * b12 + m22 * b22 + m23 * b32;
		_23 = m21 * b13 + m22 * b23 + m23 * b33;
		_24 = 0;

		_31 = a31 * b11 + a32 * b21 + a33 * b31;
		_32 = a31 * b12 + a32 * b22 + a33 * b32;
		_33 = a31 * b13 + a32 * b23 + a33 * b33;
		_34 = 0;

		_41 = a41 * b11 + a42 * b21 + a43 * b31 + b41;
		_42 = a41 * b12 + a42 * b22 + a43 * b32 + b42;
		_43 = a41 * b13 + a42 * b23 + a43 * b33 + b43;
		_44 = 1;
	}

	public function multiply( a : Matrix, b : Matrix ) {
		var a11 = a._11; var a12 = a._12; var a13 = a._13; var a14 = a._14;
		var a21 = a._21; var a22 = a._22; var a23 = a._23; var a24 = a._24;
		var a31 = a._31; var a32 = a._32; var a33 = a._33; var a34 = a._34;
		var a41 = a._41; var a42 = a._42; var a43 = a._43; var a44 = a._44;
		var b11 = b._11; var b12 = b._12; var b13 = b._13; var b14 = b._14;
		var b21 = b._21; var b22 = b._22; var b23 = b._23; var b24 = b._24;
		var b31 = b._31; var b32 = b._32; var b33 = b._33; var b34 = b._34;
		var b41 = b._41; var b42 = b._42; var b43 = b._43; var b44 = b._44;

		_11 = a11 * b11 + a12 * b21 + a13 * b31 + a14 * b41;
		_12 = a11 * b12 + a12 * b22 + a13 * b32 + a14 * b42;
		_13 = a11 * b13 + a12 * b23 + a13 * b33 + a14 * b43;
		_14 = a11 * b14 + a12 * b24 + a13 * b34 + a14 * b44;

		_21 = a21 * b11 + a22 * b21 + a23 * b31 + a24 * b41;
		_22 = a21 * b12 + a22 * b22 + a23 * b32 + a24 * b42;
		_23 = a21 * b13 + a22 * b23 + a23 * b33 + a24 * b43;
		_24 = a21 * b14 + a22 * b24 + a23 * b34 + a24 * b44;

		_31 = a31 * b11 + a32 * b21 + a33 * b31 + a34 * b41;
		_32 = a31 * b12 + a32 * b22 + a33 * b32 + a34 * b42;
		_33 = a31 * b13 + a32 * b23 + a33 * b33 + a34 * b43;
		_34 = a31 * b14 + a32 * b24 + a33 * b34 + a34 * b44;

		_41 = a41 * b11 + a42 * b21 + a43 * b31 + a44 * b41;
		_42 = a41 * b12 + a42 * b22 + a43 * b32 + a44 * b42;
		_43 = a41 * b13 + a42 * b23 + a43 * b33 + a44 * b43;
		_44 = a41 * b14 + a42 * b24 + a43 * b34 + a44 * b44;
	}

	public function multiplyValue( v : Float ) {
		_11 *= v;
		_12 *= v;
		_13 *= v;
		_14 *= v;
		_21 *= v;
		_22 *= v;
		_23 *= v;
		_24 *= v;
		_31 *= v;
		_32 *= v;
		_33 *= v;
		_34 *= v;
		_41 *= v;
		_42 *= v;
		_43 *= v;
		_44 *= v;
	}

	public inline function invert() {
		inverse(this);
	}

	public inline function getDeterminant() {
		return _11 * (_22*_33 - _23*_32) + _12 * (_23*_31 - _21*_33) + _13 * (_21*_32 - _22*_31);
	}

	public function inverse3x4( m : Matrix ) {
		var m11 = m._11, m12 = m._12, m13 = m._13;
		var m21 = m._21, m22 = m._22, m23 = m._23;
		var m31 = m._31, m32 = m._32, m33 = m._33;
		var m41 = m._41, m42 = m._42, m43 = m._43;
		_11 = m22*m33 - m23*m32;
		_12 = m13*m32 - m12*m33;
		_13 = m12*m23 - m13*m22;
		_14 = 0;
		_21 = m23*m31 - m21*m33;
		_22 = m11*m33 - m13*m31;
		_23 = m13*m21 - m11*m23;
		_24 = 0;
		_31 = m21*m32 - m22*m31;
		_32 = m12*m31 - m11*m32;
		_33 = m11*m22 - m12*m21;
		_34 = 0;
		_41 = -m21 * m32 * m43 + m21 * m33 * m42 + m31 * m22 * m43 - m31 * m23 * m42 - m41 * m22 * m33 + m41 * m23 * m32;
		_42 = m11 * m32 * m43 - m11 * m33 * m42 - m31 * m12 * m43 + m31 * m13 * m42 + m41 * m12 * m33 - m41 * m13 * m32;
		_43 = -m11 * m22 * m43 + m11 * m23 * m42 + m21 * m12 * m43 - m21 * m13 * m42 - m41 * m12 * m23 + m41 * m13 * m22;
		_44 = m11 * m22 * m33 - m11 * m23 * m32 - m21 * m12 * m33 + m21 * m13 * m32 + m31 * m12 * m23 - m31 * m13 * m22;
		_44 = 1;
		var det = m11 * _11 + m12 * _21 + m13 * _31;
		if(	Math.abs(det) < Math.EPSILON ) {
			zero();
			return;
		}
		var invDet = 1.0 / det;
		_11 *= invDet; _12 *= invDet; _13 *= invDet;
		_21 *= invDet; _22 *= invDet; _23 *= invDet;
		_31 *= invDet; _32 *= invDet; _33 *= invDet;
		_41 *= invDet; _42 *= invDet; _43 *= invDet;
	}

	public function inverse( m : Matrix ) {
		var m11 = m._11; var m12 = m._12; var m13 = m._13; var m14 = m._14;
		var m21 = m._21; var m22 = m._22; var m23 = m._23; var m24 = m._24;
		var m31 = m._31; var m32 = m._32; var m33 = m._33; var m34 = m._34;
		var m41 = m._41; var m42 = m._42; var m43 = m._43; var m44 = m._44;

		_11 = m22 * m33 * m44 - m22 * m34 * m43 - m32 * m23 * m44 + m32 * m24 * m43 + m42 * m23 * m34 - m42 * m24 * m33;
		_12 = -m12 * m33 * m44 + m12 * m34 * m43 + m32 * m13 * m44 - m32 * m14 * m43 - m42 * m13 * m34 + m42 * m14 * m33;
		_13 = m12 * m23 * m44 - m12 * m24 * m43 - m22 * m13 * m44 + m22 * m14 * m43 + m42 * m13 * m24 - m42 * m14 * m23;
		_14 = -m12 * m23 * m34 + m12 * m24 * m33 + m22 * m13 * m34 - m22 * m14 * m33 - m32 * m13 * m24 + m32 * m14 * m23;
		_21 = -m21 * m33 * m44 + m21 * m34 * m43 + m31 * m23 * m44 - m31 * m24 * m43 - m41 * m23 * m34 + m41 * m24 * m33;
		_22 = m11 * m33 * m44 - m11 * m34 * m43 - m31 * m13 * m44 + m31 * m14 * m43 + m41 * m13 * m34 - m41 * m14 * m33;
		_23 = -m11 * m23 * m44 + m11 * m24 * m43 + m21 * m13 * m44 - m21 * m14 * m43 - m41 * m13 * m24 + m41 * m14 * m23;
		_24 =  m11 * m23 * m34 - m11 * m24 * m33 - m21 * m13 * m34 + m21 * m14 * m33 + m31 * m13 * m24 - m31 * m14 * m23;
		_31 = m21 * m32 * m44 - m21 * m34 * m42 - m31 * m22 * m44 + m31 * m24 * m42 + m41 * m22 * m34 - m41 * m24 * m32;
		_32 = -m11 * m32 * m44 + m11 * m34 * m42 + m31 * m12 * m44 - m31 * m14 * m42 - m41 * m12 * m34 + m41 * m14 * m32;
		_33 = m11 * m22 * m44 - m11 * m24 * m42 - m21 * m12 * m44 + m21 * m14 * m42 + m41 * m12 * m24 - m41 * m14 * m22;
		_34 =  -m11 * m22 * m34 + m11 * m24 * m32 + m21 * m12 * m34 - m21 * m14 * m32 - m31 * m12 * m24 + m31 * m14 * m22;
		_41 = -m21 * m32 * m43 + m21 * m33 * m42 + m31 * m22 * m43 - m31 * m23 * m42 - m41 * m22 * m33 + m41 * m23 * m32;
		_42 = m11 * m32 * m43 - m11 * m33 * m42 - m31 * m12 * m43 + m31 * m13 * m42 + m41 * m12 * m33 - m41 * m13 * m32;
		_43 = -m11 * m22 * m43 + m11 * m23 * m42 + m21 * m12 * m43 - m21 * m13 * m42 - m41 * m12 * m23 + m41 * m13 * m22;
		_44 = m11 * m22 * m33 - m11 * m23 * m32 - m21 * m12 * m33 + m21 * m13 * m32 + m31 * m12 * m23 - m31 * m13 * m22;

		var det = m11 * _11 + m12 * _21 + m13 * _31 + m14 * _41;
		if(	Math.abs(det) < Math.EPSILON ) {
			zero();
			return;
		}

		det = 1.0 / det;
		_11 *= det;
		_12 *= det;
		_13 *= det;
		_14 *= det;
		_21 *= det;
		_22 *= det;
		_23 *= det;
		_24 *= det;
		_31 *= det;
		_32 *= det;
		_33 *= det;
		_34 *= det;
		_41 *= det;
		_42 *= det;
		_43 *= det;
		_44 *= det;
	}

	public function transpose() {
		var tmp;
		tmp = _12; _12 = _21; _21 = tmp;
		tmp = _13; _13 = _31; _31 = tmp;
		tmp = _14; _14 = _41; _41 = tmp;
		tmp = _23; _23 = _32; _32 = tmp;
		tmp = _24; _24 = _42; _42 = tmp;
		tmp = _34; _34 = _43; _43 = tmp;
	}

	public function clone() {
		var m = new Matrix();
		m._11 = _11; m._12 = _12; m._13 = _13; m._14 = _14;
		m._21 = _21; m._22 = _22; m._23 = _23; m._24 = _24;
		m._31 = _31; m._32 = _32; m._33 = _33; m._34 = _34;
		m._41 = _41; m._42 = _42; m._43 = _43; m._44 = _44;
		return m;
	}

	public function loadFrom( m : Matrix ) {
		_11 = m._11; _12 = m._12; _13 = m._13; _14 = m._14;
		_21 = m._21; _22 = m._22; _23 = m._23; _24 = m._24;
		_31 = m._31; _32 = m._32; _33 = m._33; _34 = m._34;
		_41 = m._41; _42 = m._42; _43 = m._43; _44 = m._44;
	}

	public function load( a : Array<Float> ) {
		_11 = a[0]; _12 = a[1]; _13 = a[2]; _14 = a[3];
		_21 = a[4]; _22 = a[5]; _23 = a[6]; _24 = a[7];
		_31 = a[8]; _32 = a[9]; _33 = a[10]; _34 = a[11];
		_41 = a[12]; _42 = a[13]; _43 = a[14]; _44 = a[15];
	}

	public function getFloats() {
		return [_11, _12, _13, _14, _21, _22, _23, _24, _31, _32, _33, _34, _41, _42, _43, _44];
	}

	public function toString() {
		return "MAT=[\n" +
			"  [ " + Math.fmt(_11) + ", " + Math.fmt(_12) + ", " + Math.fmt(_13) + ", " + Math.fmt(_14) + " ]\n" +
			"  [ " + Math.fmt(_21) + ", " + Math.fmt(_22) + ", " + Math.fmt(_23) + ", " + Math.fmt(_24) + " ]\n" +
			"  [ " + Math.fmt(_31) + ", " + Math.fmt(_32) + ", " + Math.fmt(_33) + ", " + Math.fmt(_34) + " ]\n" +
			"  [ " + Math.fmt(_41) + ", " + Math.fmt(_42) + ", " + Math.fmt(_43) + ", " + Math.fmt(_44) + " ]\n" +
		"]";
	}

	// ---- COLOR MATRIX FUNCTIONS -------

	static inline var lumR = 0.212671;
	static inline var lumG = 0.71516;
	static inline var lumB = 0.072169;

	public function colorHue( hue : Float ) {
		if( hue == 0. )
			return;
		var cv = Math.cos(hue);
		var sv = Math.sin(hue);
		tmp._11 = lumR + cv * (1 - lumR) - sv * lumR;
		tmp._12 = lumR - cv * lumR + sv * 0.143;
		tmp._13 = lumR - cv * lumR - sv * (1 - lumR);
		tmp._21 = lumG - cv * lumG - sv * lumG;
		tmp._22 = lumG + cv * (1 - lumG) + sv * 0.140;
		tmp._23 = lumG - cv * lumG + sv * lumG;
		tmp._31 = lumB - cv * lumB - sv * lumB;
		tmp._32 = lumB - cv * lumB - sv * 0.283;
		tmp._33 = lumB + cv * (1 - lumB) + sv * lumB;
		tmp._34 = 0;
		tmp._41 = 0;
		tmp._42 = 0;
		tmp._43 = 0;
		multiply3x4(this, tmp);
	}

	public function colorSaturation( sat : Float ) {
		var is = 1 - sat;
		var r = is * lumR;
		var g = is * lumG;
		var b = is * lumB;
		tmp._11 = r + sat;
		tmp._12 = r;
		tmp._13 = r;
		tmp._21 = g;
		tmp._22 = g + sat;
		tmp._23 = g;
		tmp._31 = b;
		tmp._32 = b;
		tmp._33 = b + sat;
		tmp._41 = 0;
		tmp._42 = 0;
		tmp._43 = 0;
		multiply3x4(this, tmp);
	}

	public function colorContrast( contrast : Float ) {
		var v = contrast + 1;
		tmp._11 = v;
		tmp._12 = 0;
		tmp._13 = 0;
		tmp._21 = 0;
		tmp._22 = v;
		tmp._23 = 0;
		tmp._31 = 0;
		tmp._32 = 0;
		tmp._33 = v;
		tmp._41 = -contrast*0.5;
		tmp._42 = -contrast*0.5;
		tmp._43 = -contrast*0.5;
		multiply3x4(this, tmp);
	}

	public function colorBrightness( brightness : Float ) {
		_41 += brightness;
		_42 += brightness;
		_43 += brightness;
	}

	public function colorBits( bits : Int, blend : Float ) {
		var t11 = 0., t12 = 0., t13 = 0.;
		var t21 = 0., t22 = 0., t23 = 0.;
		var t31 = 0., t32 = 0., t33 = 0.;
		var c = bits;
		if( c & 1 == 1 ) t11 = 1; c >>= 1;
		if( c & 1 == 1 ) t12 = 1; c >>= 1;
		if( c & 1 == 1 ) t13 = 1; c >>= 1;
		if( c & 1 == 1 ) t21 = 1; c >>= 1;
		if( c & 1 == 1 ) t22 = 1; c >>= 1;
		if( c & 1 == 1 ) t23 = 1; c >>= 1;
		if( c & 1 == 1 ) t31 = 1; c >>= 1;
		if( c & 1 == 1 ) t32 = 1; c >>= 1;
		if( c & 1 == 1 ) t33 = 1; c >>= 1;
		var r = t11 + t21 + t31;
		var g = t12 + t22 + t32;
		var b = t13 + t23 + t33;
		if( r > 1 ) { t11 /= r; t21 /= r; t31 /= r; }
		if( g > 1 ) { t12 /= g; t22 /= g; t32 /= g; }
		if( b > 1 ) { t13 /= b; t23 /= b; t33 /= b; }

		// multiply our 3x3 by current matrix

		var b11 = _11 * t11 + _12 * t21 + _13 * t31;
		var b12 = _11 * t12 + _12 * t22 + _13 * t32;
		var b13 = _11 * t13 + _12 * t23 + _13 * t33;

		var b21 = _21 * t11 + _22 * t21 + _23 * t31;
		var b22 = _21 * t12 + _22 * t22 + _23 * t32;
		var b23 = _21 * t13 + _22 * t23 + _23 * t33;

		var b31 = _31 * t11 + _32 * t21 + _33 * t31;
		var b32 = _31 * t12 + _32 * t22 + _33 * t32;
		var b33 = _31 * t13 + _32 * t23 + _33 * t33;

		// blend it
		var ik = blend, k = 1 - ik;
		_11 = _11 * k + b11 * ik;
		_12 = _12 * k + b12 * ik;
		_13 = _13 * k + b13 * ik;
		_21 = _21 * k + b21 * ik;
		_22 = _22 * k + b22 * ik;
		_23 = _23 * k + b23 * ik;
		_31 = _31 * k + b31 * ik;
		_32 = _32 * k + b32 * ik;
		_33 = _33 * k + b33 * ik;
	}

	public inline function colorAdd( c : Int ) {
		_41 += ((c >> 16) & 0xFF) / 255;
		_42 += ((c >> 8) & 0xFF) / 255;
		_43 += (c & 0xFF) / 255;
	}

	public inline function colorSet( c : Int, alpha = 1. ) {
		zero();
		_44 = alpha;
		colorAdd(c);
	}

	// STATICS

	public static function I() {
		var m = new Matrix();
		m.identity();
		return m;
	}

	public static function L( a : Array<Float> ) {
		var m = new Matrix();
		m.load(a);
		return m;
	}

	public static function T( x = 0., y = 0., z = 0. ) {
		var m = new Matrix();
		m.initTranslate(x, y, z);
		return m;
	}

	public static function R(x,y,z) {
		var m = new Matrix();
		m.initRotate(x,y,z);
		return m;
	}

	public static function S( x = 1., y = 1., z = 1.0 ) {
		var m = new Matrix();
		m.initScale(x, y, z);
		return m;
	}

	/**
		Build a rotation Matrix so the X axis will look at the given direction, and the Z axis will be the Up vector ([0,0,1] by default)
	**/
	public static function lookAtX( dir : Vector, ?up : Vector, ?m : Matrix ) {
		if( up == null ) up = new Vector(0, 0, 1);
		if( m == null ) m = new Matrix();
		var ax = dir.getNormalized();
		var ay = up.cross(ax).getNormalized();
		if( ay.lengthSq() < Math.EPSILON ) {
			ay.x = ax.y;
			ay.y = ax.z;
			ay.z = ax.x;
		}
		var az = ax.cross(ay);
		m._11 = ax.x;
		m._12 = ax.y;
		m._13 = ax.z;
		m._14 = 0;
		m._21 = ay.x;
		m._22 = ay.y;
		m._23 = ay.z;
		m._24 = 0;
		m._31 = az.x;
		m._32 = az.y;
		m._33 = az.z;
		m._34 = 0;
		m._41 = 0;
		m._42 = 0;
		m._43 = 0;
		m._44 = 1;
		return m;
	}

}