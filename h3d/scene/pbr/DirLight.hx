package h3d.scene.pbr;

class DirLight extends Light {

	var pbr : h3d.shader.pbr.Light.DirLight;
	public var direction : h3d.Vector;

	public function new(?direction, ?parent) {
		pbr = new h3d.shader.pbr.Light.DirLight();
		super(pbr,parent);
		this.direction = direction == null ? new h3d.Vector(0,0,-1) : direction;
	}

	override function get_isSun() {
		return pbr.isSun;
	}

	override function set_isSun(b:Bool) {
		return pbr.isSun = b;
	}

	override function emit(ctx:RenderContext) {
		pbr.lightColor.load(_color);
		pbr.lightColor.scale3(power * power);
		pbr.lightDir.load(direction);
		pbr.lightDir.scale3(-1);
		pbr.lightDir.normalize();
		super.emit(ctx);
	}

}