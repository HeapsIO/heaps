package h3d.col;
using hxd.Math;

class IPoint {

	public var x : Int;
	public var y : Int;
	public var z : Int;

	public inline function new(x=0,y=0,z=0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function toString() {
		return 'IPoint{$x,$y,$z}';
	}

	public inline function set(x, y, z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

}