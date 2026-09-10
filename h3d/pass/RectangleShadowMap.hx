package h3d.pass;

class RectangleShadowMap extends CubeShadowMap {

	var pshader : h3d.shader.PointShadow;

	public function new( light : h3d.scene.Light, useWorldDist : Bool ) {
		super(light, useWorldDist);
		shader = pshader = new h3d.shader.PointShadow();
	}

	override function set_mode(m:Shadows.RenderMode) {
		pshader.enable = m != None && enabled;
		return mode = m;
	}

	override function set_enabled(b:Bool) {
		pshader.enable = b && mode != None;
		return enabled = b;
	}

	override function getShadowTex() {
		return pshader.shadowMap;
	}

	override function syncShader(texture) {
		if( texture == null )
			throw "assert";

		var rectangleLight = cast(light, h3d.scene.pbr.RectangleLight);
		pshader.shadowMap = texture;
		pshader.shadowBias = bias;
		pshader.shadowPower = power;
		pshader.lightPos = light.getAbsPos().getPosition();
		pshader.zFar = rectangleLight.range;

		pshader.SAMPLING_MODE = samplingKind;
		// ESM
		pshader.shadowPower = power;

		// PCF
		pshader.pcfScale = pcfScale / ( 100.0 * texture.width );
	}

	override function createCollider(light : h3d.scene.Light) {
		var absPos = light.getAbsPos();
		var rectangleLight = cast(light, h3d.scene.pbr.RectangleLight);
		// TODO : Optimize culling
		return new h3d.col.Sphere(absPos.tx, absPos.ty, absPos.tz, rectangleLight.range);
	}

	override function cull(lightCollider : h3d.col.Collider, col : h3d.col.Collider ) {
		var sphere = cast(lightCollider, h3d.col.Sphere);
		return col.inSphere(sphere);
	}

	override function updateLightCameraNearFar(light : h3d.scene.Light) {
		var rectangleLight = cast(light, h3d.scene.pbr.RectangleLight);
		lightCamera.zFar = rectangleLight.range;
		lightCamera.zNear = 0.01;
	}
}