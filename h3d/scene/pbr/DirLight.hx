package h3d.scene.pbr;

class DirLight extends Light {

	var pbr : h3d.shader.pbr.Light.DirLight;

	public function new(?dir: h3d.Vector, ?parent) {
		pbr = new h3d.shader.pbr.Light.DirLight();
		super(pbr,parent);
		if(dir != null)
			setDirection(dir.x, dir.y, dir.z);
	}

	override function get_isSun() {
		return pbr.isSun;
	}

	override function set_isSun(b:Bool) {
		return pbr.isSun = b;
	}

	override function getShadowDirection() : h3d.Vector {
		return getDirection();	
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