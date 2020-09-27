package h2d.col;
import hxd.Math;

/**
	An affine 2D 2x3 matrix.

	Matrix properties are as follows:
	```
	[a, c, x]
	[b, d, y]
	```
**/
class Matrix {

	static var tmp = new Matrix();

	public var a : Float;
	public var b : Float;
	public var c : Float;
	public var d : Float;
	public var x : Float;
	public var y : Float;

	/**
		Create a new identity Matrix.
	**/
	public function new() {
		identity();
	}

	/**
		Sets the matrix values to ones that would perform no transformation.
		```
		[1, 0, 0]
		[0, 1, 0]
		```
	**/
	public inline function identity() {
		a = 1; b = 0; c = 0; d = 1;
		x = 0; y = 0;
	}

	/**
		Sets the matrix values to ones that would only move the transformed positions by given `x` and `y`.
		```
		[1, 0, x]
		[0, 1, y]
		```
	**/
	public inline function initTranslate(x, y) {
		a = 1; b = 0; c = 0; d = 1;
		this.x = x;
		this.y = y;
	}

	/**
		Sets the matrix values to ones that would only scale the transformed positions by given `sx` and `sy`.
		```
		[sx, 0, 0]
		[0, sy, 0]
		```
	**/
	public inline function initScale(sx, sy) {
		a = sx; b = 0; c = 0; d = sy;
		x = 0; y = 0;
	}

	/**
		Sets the matrix values to ones that would only rotate the transformed position by given `angle`.
		```
		[cos(angle), -sin(angle), 0]
		[sin(angle),  cos(angle), 0]
		```
	**/
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

	/**
		Sets the matrix values to ones that would only skew the transformed position by given `sx` and `sy`.
		```
		[1, tan(sx), 0]
		[tan(sy), 1, 0]
		```
	**/
	public inline function initSkew(sx, sy) {
		var tanX = Math.tan(sx);
		var tanY = Math.tan(sy);
		a = 1;
		b = tanY;
		c = tanX;
		d = 1;
		x = 0;
		y = 0;
	}

	/**
		Inverts the matrix to perform the opposite transformation. Can be used to undo the previously applied transformation.
		@see `Matrix.inverse`
	**/
	public function invert() {
		inverse(this);
	}

	/**
		Returns the determinant of the Matrix `a`, `b`, `c` and `d` values.
	**/
	public inline function getDeterminant() {
		return a * d - b * c;
	}

	/**
		Sets this Matrix value to be the inverse of the given Matrix `m`.
	**/
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

	/**
		Returns a new Point that is a result of transforming Point `pt` by this Matrix.
	**/
	public inline function transform( pt : Point ) {
		return new Point(pt.x * a + pt.y * c + x, pt.x * b + pt.y * d + y);
	}

	/**
		Applies translation transform to Matrix by given `x` and `y`.
	**/
	public inline function translate( x : Float, y : Float ) {
		this.x += x;
		this.y += y;
	}

	/**
		Applies translation transform on X-axis to Matrix by given `x`. Equivalent of `matrix.x += x`.
	**/
	public inline function translateX( x : Float ) {
		this.x += x;
	}

	/**
		Applies translation transform on Y-axis to Matrix by given `y`. Equivalent of `matrix.y += y`.
	**/
	public inline function translateY( y : Float ) {
		this.y += y;
	}

	/**
		Transforms given `x` and `y` with current Matrix values (excluding translation) and
		applies translation transform to Matrix by resulting `x` and `y`.
	**/
	public inline function prependTranslate( x : Float, y : Float ) {
		this.x += a * x + c * y;
		this.y += b * x + d * y;
	}

	/**
		Transforms given `x` with current Matrix values (excluding translation) and
		applies translation transform on X-axis to Matrix by resulting `x` and `y`.
		Equivalent of `matrix.x += matrix.a * x`.
	**/
	public inline function prependTranslateX( x : Float ) {
		this.x += a * x;
	}

	/**
		Transforms given `y` with current Matrix values (excluding translation) and
		applies translation transform on Y-axis to Matrix by resulting `y`.
		Equivalent of `matrix.y += matrix.d * y`.
	**/
	public inline function prependTranslateY( y : Float ) {
		this.y += d * y;
	}

	/**
		Concatenates Matrix `a` and `b` and stores the result in this Matrix. 
		Matrix can be the target of of it's own `multiply`.
		Keep in mind that order of matrixes matter in concatenation.
	**/
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

	/**
		Returns a Point with a total scaling applied by the Matrix.
		@param p Optional Point instance. If provided, sets values of given Point and returns it. Otherwise returns new Point instance.
	**/
	public inline function getScale(?p: h2d.col.Point) {
		if(p == null)
			p = new h2d.col.Point();
		p.x = Math.sqrt(a * a + b * b);
		p.y = Math.sqrt(c * c + d * d);
		if( getDeterminant() < 0 ) {
			p.x *= -1;
			p.y *= -1;
		}
		return p;
	}

	/**
		Multiplies the `a`, `c` and `x` by given `sx` and `b`, `d` and `y` by `sy`.
	**/
	public inline function scale( sx : Float, sy : Float ) {
		a *= sx;
		c *= sx;
		x *= sx;
		b *= sy;
		d *= sy;
		y *= sy;
	}

	/**
		Multiplies the `a`, `c` and `x` by given `sx`.
	**/
	public inline function scaleX( sx : Float ) {
		a *= sx;
		c *= sx;
		x *= sx;
	}

	/**
		Multiplies the `b`, `d` and `y` by `sy`.
	**/
	public inline function scaleY( sy : Float ) {
		b *= sy;
		d *= sy;
		y *= sy;
	}

	/**
		Applies rotation transform to the Matrix by given `angle`.
	**/
	public function rotate(angle: Float) {
		tmp.initRotate(angle);
		multiply(this, tmp);
	}

	/**
		Applies skewing transform to the Matrix by given `sx` and `sy`.
	**/
	public function skew( sx : Float, sy : Float ) {
		var aa = this.a, ab = this.b, ac = this.c, ad = this.d, ax = this.x, ay = this.y;
		// [1, tan(sx), 0]
		// [tan(sy), 1, 0]
		var bb = Math.tan(sy);
		var bc = Math.tan(sx);
		this.a = aa + ab * bc;
		this.b = aa * bb + ab;
		this.c = ac + ad * bc;
		this.d = ac * bb + ad;
		this.x = ax + ay * bc;
		this.y = ax * bb + ay;
	}

	/**
		Applies skewing transform on X-axis to the Matrix by given `sx`.
	**/
	public function skewX( sx : Float ) {
		// [1, tan(sx), 0]
		// [0, 1      , 0]
		var bc = Math.tan(sx);
		this.a = a + b * bc;
		this.c = c + d * bc;
		this.x = x + y * bc;
	}

	/**
		Applies skewing transform on Y-axis to the Matrix by given `sy`.
	**/
	public function skewY( sy : Float ) {
		// [1, tan(sx), 0]
		// [tan(sy), 1, 0]
		var bb = Math.tan(sy);
		this.b = a * bb + b;
		this.d = c * bb + d;
		this.y = x * bb + y;
	}

	/**
		Returns a copy of this Matrix.
	**/
	public function clone() {
		var m = new Matrix();
		m.a = a;
		m.b = b;
		m.c = c;
		m.d = d;
		m.x = x;
		m.y = y;
		return m;
	}

	/**
		Returns a Point with `x` and `y` of the Matrix.
		@param p Optional Point instance to use. Otherwise returns new instance.
	**/
	public inline function getPosition( ?p : h2d.col.Point ) {
		if( p == null ) p = new h2d.col.Point();
		p.set(x,y);
		return p;
	}

	@:dox(hide)
	public function toString() {
		return "MAT=[\n" +
			"  [ " + Math.fmt(a) + ", " + Math.fmt(b) + " ]\n" +
			"  [ " + Math.fmt(c) + ", " + Math.fmt(d) + " ]\n" +
			"  [ " + Math.fmt(x) + ", " + Math.fmt(y) + " ]\n" +
		"]";
	}


}