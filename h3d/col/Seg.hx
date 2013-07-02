package h3d.col;

class Seg {
	
	public var p1 : Vector;
	public var p2 : Vector;
	public var lenSq : Float;
	
	public inline function new( p1 : Vector, p2 : Vector ) {
		this.p1 = p1;
		this.p2 = p2;
		lenSq = p1.distanceSq(p2);
	}
	
	public inline function distanceSq( p : Vector ) {
		var t = p.sub(p1).dot3(p2.sub(p1)) / lenSq;
		return if( t < 0 )
			p.distanceSq(p1);
		else if( t > 1 ) {
			p.distanceSq(p2);
		} else
			p.distanceSq(new Vector(p1.x + t * (p2.x - p1.x), p1.y + t * (p2.y - p1.y)));
	}
	
	public inline function distance( p : Vector ) {
		return FMath.sqrt(distanceSq(p));
	}
	
}