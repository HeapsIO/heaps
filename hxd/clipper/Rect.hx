package hxd.clipper;

class Rect {
	public var left : Int;
	public var top : Int;
	public var right : Int;
	public var bottom : Int;

	public function new(l=0,t=0,r=0,b=0) {
		this.left = l; this.top = t;
		this.right = r; this.bottom = b;
	}
}
