package h3d.prim;

class UV {

	public var u : Float;
	public var v : Float;

	public function new(u,v) {
		this.u = u;
		this.v = v;
	}

	public function clone() {
		return new UV(u, v);
	}

	function toString() {
		return "{" + hxd.Math.fmt(u) + "," + hxd.Math.fmt(v) + "}";
	}

}