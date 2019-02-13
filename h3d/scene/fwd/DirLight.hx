package h3d.scene.fwd;

class DirLight extends Light {

	var dshader : h3d.shader.DirLight;

	public function new(?dir: h3d.Vector, ?parent) {
		dshader = new h3d.shader.DirLight();
		super(dshader, parent);
		priority = 100;
		if( dir != null ) setDirection(dir);
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

	override function getShadowDirection() : h3d.Vector {
		return absPos.front();
	}

	override function emit(ctx) {
		dshader.direction.load(absPos.front());
		dshader.direction.normalize();
		super.emit(ctx);
	}
}