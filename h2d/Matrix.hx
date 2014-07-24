package h2d;
import hxd.Math;
import h2d.col.Point;

class Matrix
{
	public var a : Float;
	public var b : Float;
	public var c : Float;
	public var d : Float;
	
	public var tx : Float;
	public var ty : Float;
	
	/**
	 * Loaded with identity by default
	 */
	public inline function new(a=1.,b=0.,c=0.,d=1.,tx=0.,ty=0.) {
		setTo(a, b, c, d, tx, ty);
	}
	
	public inline function zero() {
		a = b = c = d = tx = ty = 0.0;
	}
	
	public inline function identity() {
		a = 1.; b = 0.; c = 0.; d = 1.; tx = 0.; ty = 0.;
	}
	
	public inline function setTo(a=1.,b=0.,c=0.,d=1.,tx=0.,ty=0.) {
		this.a = a;	
		this.b = b; 
		this.c = c;
		this.d = d;
		
		this.tx = tx;
		this.ty = ty;
	}
	
	public function invert ():Matrix {

		var norm = a * d - b * c;
		if (norm == 0) {

			a = b = c = d = 0;
			tx = -tx;
			ty = -ty;
		} else {
			norm = 1.0 / norm;
			var a1 = d * norm;
			d = a * norm;
			a = a1;
			b *= -norm;
			c *= -norm;

			var tx1 = - a * tx - c * ty;
			ty = - b * tx - d * ty;
			tx = tx1;
		}

		return this;

	}
	
	public inline function rotate (angle:Float):Void {
		var c = Math.cos(angle);
		var s=  Math.sin(angle);
		concat32(	c, s, 
					-s, c,
					0.0,0.0 );
	}

	public inline function scale (x:Float, y:Float):Void {
		a *= x;
		b *= y;

		c *= x;
		d *= y;

		tx *= x;
		ty *= y;
	}
	
	#if !debug inline #end
	public 
	function skew(x, y) {
		concat32(	1.0, Math.tan(x), 
					Math.tan(y), 1.0,
					0.0,0.0 			);
	}
	
	#if !debug inline #end 
	public 
	function makeSkew(x:Float, y:Float):Void {
		identity();
		b = Math.tan( x );
		c = Math.tan( y );
	}

	public inline function setRotation (angle:Float, scale:Float = 1):Void {
		a = Math.cos (angle) * scale;
		c = Math.sin (angle) * scale;
		b = -c;
		d = a;
		tx = ty = 0;
	}

	public function toString ():String {
		return "(a=" + a + ", b=" + b + ", c=" + c + ", d=" + d + ", tx=" + tx + ", ty=" + ty + ")";
	}

	public inline function transformPoint (point:Point):Point {
		return new Point (point.x * a + point.y * c + tx, point.x * b + point.y * d + ty);
	}
	
	public function concat(m:Matrix):Void {
		var a1 = a * m.a + b * m.c;
		b = a * m.b + b * m.d;
		a = a1;

		var c1 = c * m.a + d * m.c;
		d = c * m.b + d * m.d;

		c = c1;

		var tx1 = tx * m.a + ty * m.c + m.tx;
		ty = tx * m.b + ty * m.d + m.ty;
		tx = tx1;
	}
	
	/**
	 * Does not apply tx/ty
	 */
	public #if !debug inline #end function concat22(m:Matrix):Void {
		var a1 = a * m.a + b * m.c;
		b = a * m.b + b * m.d;
		a = a1;

		var c1 = c * m.a + d * m.c;
		d = c * m.b + d * m.d;

		c = c1;
	}
	
	public #if !debug inline #end function concat32(ma:Float,mb:Float,mc:Float,md:Float,mtx:Float,mty:Float):Void {
		var a1 = a * ma + b * mc;
		b = a * mb + b * md;
		a = a1;

		var c1 = c * ma + d * mc;
		d = c * mb + d * md;

		c = c1;

		var tx1 = tx * ma + ty * mc + mtx;
		ty = tx * mb + ty * md + mty;
		tx = tx1;
	}
	
	/**
	 * Same as transformPoint except allow memory conservation
	 * @param	?res reuseable parameter
	 */
	public inline function transformPoint2 (pointx:Float, pointy : Float, ?res:Point):Point {
		var p  = res == null?new Point():res;
		var px = pointx;
		var py = pointy;
		p.x = px * a + py * c + tx;
		p.y = px * b + py * d + ty;
		return p;
	}
	
	public inline function transformX (px:Float, py : Float):Float{
		return px * a + py * c + tx;
	}
	
	public inline function transformY (px:Float, py : Float):Float{
		return px * b + py * d + ty;
	}

	public inline function translate (x:Float, y:Float):Void {
		tx += x;
		ty += y;
	}
	
}