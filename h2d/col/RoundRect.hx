package h2d.col;

/**
	A Collider representing the rectangle with the rounded edges, forming a 2D capsule.
**/
class RoundRect implements Collider {
	/**
		The horizontal position of the rectangle center.
	**/
	public var x : Float;
	/**
		The vertical position of the rectangle center.
	**/
	public var y : Float;
	var ray : Float;
	var dx : Float;
	var dy : Float;
	var lenSq : Float;
	var invLenSq : Float;

	/**
		Create a new RoundRect instance.
		@param x The horizontal position of the rectangle center.
		@param y The vertical position of the rectangle center.
		@param w The width of the rectangle.
		@param h The height of the rectangle.
		@param rotation The rotation of the rectangle.
	**/
	public inline function new(x:Float,y:Float,w:Float,h:Float,rotation:Float) {
		if( w < h ) {
			var tmp = w;
			w = h;
			h = tmp;
			rotation += Math.PI / 2;
		}
		var hseg = (w - h) * 0.5;
		var dx = hseg * Math.cos(rotation);
		var dy = hseg * Math.sin(rotation);
		this.x = x - dx;
		this.y = y - dy;
		this.dx = dx * 2;
		this.dy = dy * 2;
		this.ray = h * 0.5;
		lenSq = this.dx * this.dx + this.dy * this.dy;
		invLenSq = lenSq < hxd.Math.EPSILON ? 0 : 1 / lenSq;
	}

	// distance segment
	/**
		Returns the squared distance of the Point `p` to the central segment of the capsule
	**/
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

	/**
		Tests is given Point `p` is inside the capsule area.
	**/
	public inline function inside( p : Point ) {
		return distanceCenterSq(p) - ray * ray < 0;
	}

	/**
		Returns the distance of the Point `p` to the edge of the capsule.
	**/
	public inline function distance( p : Point ) {
		return Math.sqrt(distanceCenterSq(p)) - ray;
	}

	/**
		Returns an outwards normal of of the capsule edge in the direction of the Point `p`.

		Normal points outwards regardless of the Point being inside or outside of the capsule.
	**/
	public inline function getNormalAt( p : Point ) {
		var px = p.x - x;
		var py = p.y - y;
		var t = px * dx + py * dy;
		if( t < 0 ) {
			// done
		} else if( t > lenSq ) {
			px = p.x - (x + dx);
			py = p.y - (y + dy);
		} else {
			var tl2 = t * invLenSq;
			px = -(x + tl2 * dx - p.x);
			py = -(y + tl2 * dy - p.y);
		}
		return new Point(px, py);
	}

	/**
		Tests is given Point `p` is inside the capsule area.
	**/
	public function contains( p : Point ) {
		return inside(p);
	}

}