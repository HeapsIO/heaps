package h2d;

class TilePos {

	static inline var EPSILON_PIXEL = 0.00001;
	
	public var t : Tiles;
	public var u : Float;
	public var v : Float;
	public var u2 : Float;
	public var v2 : Float;
	public var dx : Int;
	public var dy : Int;
	public var w : Int;
	public var h : Int;
	
	public function new(t, x, y, w, h, dx=0, dy=0) {
		this.t = t;
		this.u = x / t.width;
		this.v = y / t.height;
		this.u2 = (x + w - EPSILON_PIXEL) / t.width;
		this.v2 = (y + h - EPSILON_PIXEL) / t.height;
		this.dx = dx;
		this.dy = dy;
		this.w = w;
		this.h = h;
	}
	
	public function getPosX() {
		return Std.int(u * t.width);
	}

	public function getPosY() {
		return Std.int(v * t.height);
	}
	
	public function toString() {
		return "TilePos(x=" + getPosX() + ",y=" + getPosY() + ",size=" + w + "x" + h + ")";
	}

}