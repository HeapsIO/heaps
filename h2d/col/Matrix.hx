package h2d.col;
import hxd.Math;

/**
	Affine 2D 2x3 matrix
**/
class Matrix {

	static var tmp = new Matrix();

	public var a : Float;
	public var b : Float;
	public var c : Float;
	public var d : Float;
	public var x : Float;
	public var y : Float;

	public function new() {
		identity();
	}

	public inline function identity() {
		a = 1; b = 0; c = 0; d = 1;
		x = 0; y = 0;
	}

	public inline function initTranslate(x, y) {
		a = 1; b = 0; c = 0; d = 1;
		this.x = x;
		this.y = y;
	}

	public inline function initScale(sx, sy) {
		a = sx; b = 0; c = 0; d = sy;
		x = 0; y = 0;
	}

	public inline function initRotate(angle) {
		var cos = Math.cos(angle);
		var sin = Math.sin(angle);
		a = cos;
		b = sin;
		c = -sin;
		d = cos;
		x = 0;
		y = 0;
	}

	public function invert() {
		inverse(this);
	}

	public inline function getDeterminant() {
		return a * d - b * c;
	}

	public function inverse( m : Matrix ) {
		var a = m.a, b = m.b;
		var c = m.c, d = m.d;
		var x = m.x, y = m.y;
		var invDet = 1 / getDeterminant();
		this.a = d * invDet;
		this.b = -b * invDet;
		this.c = -c * invDet;
		this.d = a * invDet;
		this.x = (-x * d + c * y) * invDet;
		this.y = (x * b - a * y) * invDet;
	}

	public inline function transform( pt : Point ) {
		return new Point(pt.x * a + pt.y * c + x, pt.x * b + pt.y * d + y);
	}

	public inline function translate( x : Float, y : Float ) {
		this.x += x;
		this.y += y;
	}

	public inline function prependTranslate( x : Float, y : Float ) {
		this.x += a * x + c * y;
		this.y += b * x + d * y;
	}

	public function multiply( a : Matrix, b : Matrix ) {
		var aa = a.a, ab = a.b, ac = a.c, ad = a.d, ax = a.x, ay = a.y;
		var ba = b.a, bb = b.b, bc = b.c, bd = b.d, bx = b.x, by = b.y;
		this.a = aa * ba + ab * bc;
		this.b = aa * bb + ab * bd;
		this.c = ac * ba + ad * bc;
		this.d = ac * bb + ad * bd;
		this.x = ax * ba + ay * bc + bx;
		this.y = ax * bb + ay * bd + by;
	}

	public inline function scale( sx : Float, sy : Float ) {
		a *= sx;
		c *= sx;
		x *= sx;
		b *= sy;
		d *= sy;
		y *= sy;
	}

	public function rotate(angle: Float) {
		tmp.initRotate(angle);
		multiply(this, tmp);
	}

	public function toString() {
		return "MAT=[\n" +
			"  [ " + Math.fmt(a) + ", " + Math.fmt(b) + " ]\n" +
			"  [ " + Math.fmt(c) + ", " + Math.fmt(d) + " ]\n" +
			"  [ " + Math.fmt(x) + ", " + Math.fmt(y) + " ]\n" +
		"]";
	}


}