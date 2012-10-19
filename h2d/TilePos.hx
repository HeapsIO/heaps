package h2d;

class TilePos {

	public var t : Tiles;
	public var u : Float;
	public var v : Float;
	public var u2 : Float;
	public var v2 : Float;
	public var dx : Int;
	public var dy : Int;
	public var w : Int;
	public var h : Int;
	
	public function new(t, u, v, u2, v2, dx, dy, w, h) {
		this.t = t;
		this.u = u;
		this.v = v;
		this.u2 = u2;
		this.v2 = v2;
		this.dx = dx;
		this.dy = dy;
		this.w = w;
		this.h = h;
	}
	
	public function toString() {
		return "TilePos(x=" + Std.int(u * t.width) + ",y=" + Std.int(v * t.height) + ",size=" + w + "x" + h + ")";
	}

}