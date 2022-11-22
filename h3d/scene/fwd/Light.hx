package h3d.scene.fwd;

class Light extends h3d.scene.Light {

	var objectDistance : Float; // used internaly
	var cullingDistance : Float = -1;
	public var priority : Int = 0;
	public var enableSpecular(get, set) : Bool;

	function get_enableSpecular() {
		return false;
	}

	function set_enableSpecular(b) {
		if( b ) throw "Not implemented for this light";
		return false;
	}

}