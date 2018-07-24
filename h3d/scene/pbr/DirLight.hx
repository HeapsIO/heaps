package h3d.scene.pbr;

class DirLight extends Light {

	var pbr : h3d.shader.pbr.Light.DirLight;

	public function new(?dir: h3d.Vector, ?parent) {
		pbr = new h3d.shader.pbr.Light.DirLight();
		shadows = new h3d.pass.DirShadowMap();
		super(pbr,parent);
		if( dir != null ) setDirection(dir);
	}

	override function getShadowDirection() : h3d.Vector {
		return absPos.front();
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