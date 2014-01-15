package h2d.col;

class RoundRect {

	var x : Float;
	var y : Float;
	var ray : Float;
	var dx : Float;
	var dy : Float;
	var lenSq : Float;
	var invLenSq : Float;
	
	public inline function new(x:Float,y:Float,rayW:Float,rayH:Float,rotation:Float) {
		if( rayW < rayH ) {
			var tmp = rayW;
			rayW = rayH;
			rayH = tmp;
			rotation += Math.PI / 2;
		}
		this.ray = rayH;
		var dx = (rayW - rayH) * Math.cos(rotation);
		var dy = (rayW - rayH) * Math.sin(rotation);
		this.x = x - dx;
		this.y = y - dy;
		this.dx = dx * 2;
		this.dy = dy * 2;
		lenSq = this.dx * this.dx + this.dy * this.dy;
		invLenSq = 1 / lenSq;
	}

	// distance segment
	public inline function distanceCenterSq( p : Point ) {
		var px = p.x - x;
		var py = p.y - y;
		var t = px * dx + py * dy;
		return if( t < 0 )
			px * px + py * py;
		else if( t > lenSq ) {
			var kx = p.x - (x + dx);
			var ky = p.y - (y + dy);
			kx * kx + ky * ky;
		} else {
			var tl2 = t * invLenSq;
			var pdx = x + tl2 * dx - p.x;
			var pdy = y + tl2 * dy - p.y;
			pdx * pdx + pdy * pdy;
		}
	}
	
	public inline function inside( p : Point ) {
		return distanceCenterSq(p) - ray * ray < 0;
	}

	public inline function distance( p : Point ) {
		return Math.sqrt(distanceCenterSq(p)) - ray;
	}

}