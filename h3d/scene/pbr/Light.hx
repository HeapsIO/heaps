package h3d.scene.pbr;

class Light extends h3d.scene.Light {

	var primitive : h3d.prim.Primitive;
	public var isSun(get,set) : Bool;

	function get_isSun() {
		return false;
	}

	function set_isSun(b:Bool) {
		if( b ) throw "Not supported on this light";
		return b;
	}

	override function get_enableSpecular() {
		return true;
	}

	override function set_enableSpecular(b) {
		if( !b ) throw "Not implemented for this light";
		return true;
	}

}
