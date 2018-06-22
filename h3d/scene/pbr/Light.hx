package h3d.scene.pbr;

class Light extends h3d.scene.Light {

	var _color : h3d.Vector;
	var primitive : h3d.prim.Primitive;
	@:s public var power : Float = 1.;
	public var shadows : hxsl.Shader;

	function new(shader,?parent) {
		super(shader,parent);
		_color = new h3d.Vector(1,1,1,1);
	}

	override function get_color() {
		return _color;
	}

	override function set_color(v:h3d.Vector) {
		return _color = v;
	}

	override function get_enableSpecular() {
		return true;
	}

	override function set_enableSpecular(b) {
		if( !b ) throw "Not implemented for this light";
		return true;
	}

}
