package h3d.scene;

class DirLight extends Light {

	var dshader : h3d.shader.DirLight;

	public function new(?parent) {
		dshader = new h3d.shader.DirLight();
		super(dshader, parent);
		priority = 100;
	}

	override function get_color() {
		return dshader.color;
	}

	override function set_color(v) {
		return dshader.color = v;
	}

	override function get_enableSpecular() {
		return dshader.enableSpecular;
	}

	override function set_enableSpecular(b) {
		return dshader.enableSpecular = b;
	}

	override function emit(ctx) {
		dshader.direction.load(absPos.front());
		dshader.direction.normalize();
		super.emit(ctx);
	}
}