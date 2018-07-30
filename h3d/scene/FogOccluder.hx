package h3d.scene;

class FogOccluder extends Mesh {

	public var strength = 1.0;
	public var fresnelIntensity = 0.0;
	public var fresnelPower = 1.0;
	var shader : h3d.shader.pbr.FogOccluder;

	public function new( ?parent ) {
		super(h3d.prim.Sphere.defaultUnitSphere(), null, parent);
		material.mainPass.setPassName("fogOccluder");
		material.mainPass.removeShader(material.mainPass.getShader(h3d.shader.pbr.PropsValues));
		material.texture = null;
		material.shadows = false;
		material.mainPass.depthTest = Less;
		material.mainPass.culling = Back;
		material.mainPass.blend(One, One);
		material.mainPass.blendOp = Max;
		shader = new h3d.shader.pbr.FogOccluder();
		material.mainPass.addShader(shader);
	}

	override function draw( ctx : RenderContext ) {
		primitive.render(ctx.engine);
	}

	override function emit( ctx : RenderContext ) {
		ctx.emit(material, this);
	}

	override function sync(ctx:RenderContext) {
		shader.spherePos = new h3d.Vector(x, y, z);
		shader.fresnelIntensity = fresnelIntensity;
		shader.fresnelPower = fresnelPower;
		shader.sphereRadius = scaleX;
		shader.cameraPos = ctx.camera.pos;
		shader.cameraMatrix = ctx.camera.m;
		shader.strength = strength;
	}

}