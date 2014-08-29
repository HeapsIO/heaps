package h3d.scene;

class DirLight extends Light {

	var dshader : h3d.shader.DirLight;
	public var direction : h3d.Vector;

	public function new(dir, ?parent) {
		dshader = new h3d.shader.DirLight();
		direction = dir;
		super(dshader, parent);
		priority = 100;
	}

	override function get_color() {
		return dshader.color;
	}

	override function emit(ctx) {
		dshader.direction.set(-direction.x, -direction.y, -direction.z);
		dshader.direction.normalize();
		super.emit(ctx);
	}

}