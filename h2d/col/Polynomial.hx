package h2d.col;

private class Matrix {
	public var data : haxe.ds.Vector<haxe.ds.Vector<Float>>;
	public var m : Int;
	public var n : Int;

	public function new(m, n) {
		this.m = m;
		this.n = n;
		this.data = new haxe.ds.Vector(m);
		for( i in 0...m )
			data[i] = new haxe.ds.Vector(n);
	}

	public function clone() {
		var m2 = new Matrix(m, n);
		for( i in 0...m )
			for( j in 0...n )
				m2.data[i][j] = data[i][j];
		return m2;
	}

	function toString() {
		return "[" + [for( k in data ) "\n" + Std.string(k)].join("") + "\n]";
	}
}

private class QR {

	var qr : haxe.ds.Vector<haxe.ds.Vector<Float>>;
	var rDiag : haxe.ds.Vector<Float>;
	var m : Int;
	var n : Int;

	public function new( mat : Matrix ) {
		this.m = mat.m;
		this.n = mat.n;
		qr = mat.clone().data;
		rDiag = new haxe.ds.Vector(n);

		for( k in 0...n ) {
			var nrm = 0.;
			for( i in k...m )
				nrm = hypot(nrm, qr[i][k]);
			if( nrm != 0 ) {
				if( qr[k][k] < 0 ) nrm = -nrm;
				for( i in k...m )
					qr[i][k] /= nrm;
				qr[k][k] += 1.0;
				for( j in k + 1...n ) {
					var s = 0.;
					for( i in k...m )
						s += qr[i][k] * qr[i][j];
					s = -s / qr[k][k];
					for( i in k...m )
						qr[i][j] += s * qr[i][k];
				}
			}
			rDiag[k] = -nrm;
		}
	}

	function isFullRank() {
		for( j in 0...n )
			if( rDiag[j] == 0 )
				return false;
		return true;
	}

	public function solve( b : Matrix ) {
		if( b.m != m ) throw "Invalid matrix size";
		if( !isFullRank() ) return null;
		var nx = b.n;
		var X = b.clone().data;
		for( k in 0...n )
			for( j in 0...nx ) {
				var s = 0.;
				for( i in k...m )
					s += qr[i][k] * X[i][j];
				s = -s / qr[k][k];
				for( i in k...m )
					X[i][j] += s * qr[i][k];
			}
		var k = n - 1;
		while( k >= 0 ) {
			for( j in 0...nx )
				X[k][j] /= rDiag[k];
			for( i in 0...k )
				for( j in 0...nx )
					X[i][j] -= X[k][j] * qr[i][k];
			k--;
		}
		var beta = new Array();
		for( i in 0...n )
			beta.push(X[i][0]);
		return beta;
	}

	function hypot( x : Float, y : Float ) {
		if( x < 0 ) x = -x;
		if( y < 0 ) y = -y;
		var t;
		if( x < y ) {
			t = x;
			x = y;
		} else
			t = y;
		t = t/x;
		return x * Math.sqrt(1+t*t);
	}

}

/**
	See `Polynomial.regress`.
**/
class Polynomial {

	/**
		Calculate the best fit curve of given degree that match the input values. Returns the polynomial exponents. For instance [2,8,-5] will represent 2 + 8 x - 5 x^2
	**/
	public static function regress( xVals : Array<Float>, yVals : Array<Float>, degree : Int ) : Array<Float> {
		var n = xVals.length;
		// fix bug with 4 values
		if( n == 4 ) {
			xVals.unshift(xVals[0]);
			yVals.unshift(yVals[0]);
			n++;
		}
		var x = new Matrix(n, degree + 1);
		for( i in 0...n )
			for( j in 0...degree+1 )
				x.data[i][j] = Math.pow(xVals[i], j);

		var y = new Matrix(yVals.length, n);
		for( i in 0...yVals.length )
			y.data[i][0] = yVals[i];

		var qr = new QR(x);
		var beta = qr.solve(y);
		if( beta == null ) {
			beta = regress(xVals, yVals, degree-1);
			beta.push(0);
		}
		return beta;
	}

}