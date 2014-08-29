package h3d.scene;

class PointLight extends Light {

	var pshader : h3d.shader.PointLight;
	public var params(get, set) : h3d.Vector;

	public function new(?parent) {
		pshader = new h3d.shader.PointLight();
		super(pshader, parent);
	}

	override function get_color() {
		return pshader.color;
	}

	inline function get_params() {
		return pshader.params;
	}

	inline function set_params(p) {
		return pshader.params = p;
	}

	override function emit(ctx) {
		pshader.lightPosition.set(absPos._41, absPos._42, absPos._43);
		super.emit(ctx);
	}

}