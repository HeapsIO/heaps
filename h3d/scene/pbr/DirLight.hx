package h3d.scene.pbr;

class DirLight extends Light {

	var pbr : h3d.shader.pbr.Light.DirLight;

	public function new(?dir: h3d.Vector, ?parent, ?cascade) {
		pbr = new h3d.shader.pbr.Light.DirLight();
		shadows = cascade ? new h3d.pass.CascadeShadowMap(this) : new h3d.pass.DirShadowMap(this);
		super(pbr,parent);
		if( dir != null ) setDirection(dir);
	}

	public override function clone( ?o : h3d.scene.Object ) : h3d.scene.Object {
		var dl = o == null ? new DirLight(null) : cast o;
		super.clone(dl);
		return dl;
	}

	override function getShadowDirection() : h3d.Vector {
		return absPos.front();
	}

	override function emit(ctx:RenderContext) {
		pbr.lightColor.load(_color);
		pbr.lightColor.scale(power * power);
		pbr.lightDir.load(absPos.front());
		pbr.lightDir.scale(-1);
		pbr.lightDir.normalize();
		pbr.occlusionFactor = occlusionFactor;
		super.emit(ctx);
	}

}