package h3d.scene.pbr;

class DirLight extends Light {

	var pbr : h3d.shader.pbr.Light.DirLight;

	public function new(?parent) {
		pbr = new h3d.shader.pbr.Light.DirLight();
		super(pbr,parent);
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
		pbr.lightDir.load(absPos.front());
		pbr.lightDir.scale3(-1);
		pbr.lightDir.normalize();
		super.emit(ctx);
	}

}