package h3d.scene.pbr;

enum DisplayMode {
	Pbr;
	Slides;
}

class Renderer extends h3d.scene.Renderer {

	var slides = new h3d.pass.ScreenFx(new h3d.shader.pbr.Slides());
	var pbrOut = new h3d.pass.ScreenFx(new h3d.shader.pbr.Lighting.Indirect());
	var pbrSun = new h3d.shader.pbr.Light.DirLight();
	var pbrLightPass : h3d.mat.Pass;
	var fxaa = new h3d.pass.FXAA();
	var shadows = new h3d.pass.ShadowMap(2048);
	var hasSun = false;

	public var pbrDirect = new h3d.shader.pbr.Lighting.Direct();
	public var pbrProps = new h3d.shader.pbr.PropsImport();
	public var displayMode : DisplayMode = Pbr;
	public var irrad : Irradiance;

	var output = new h3d.pass.Output("mrt",[
		Value("output.color"),
		Vec4([Value("output.normal",3),Value("output.depth",1)]),
		Vec4([Value("output.metalness"), Value("output.gloss"), Value("output.occlusion"), Const(0)]),
	]);

	public function new(irrad) {
		super();
		this.irrad = irrad;
		shadows.bias = 0.0;
		shadows.power = 1000;
		shadows.blur.passes = 1;
		defaultPass = new h3d.pass.Default("default");
		pbrDirect.doDiscard = false;
		pbrOut.addShader(new h3d.shader.ScreenShader());
		pbrOut.addShader(pbrProps);
		pbrOut.addShader(new h3d.shader.pbr.Shadow());
		allPasses.push(output);
		allPasses.push(defaultPass);
		allPasses.push(shadows);
	}

	function allocFTarget( name : String, size = 0, depth = true ) {
		return ctx.textures.allocTarget(name, ctx.engine.width >> size, ctx.engine.height >> size, depth, RGBA32F);
	}

	override function debugCompileShader(pass:h3d.mat.Pass) {
		output.setContext(this.ctx);
		return output.compileShader(pass);
	}

	override function start() {
		if( pbrLightPass == null ) {
			pbrLightPass = new h3d.mat.Pass("lights");
			pbrLightPass.addShader(new h3d.shader.BaseMesh());
			pbrLightPass.addShader(pbrDirect);
			pbrLightPass.addShader(pbrProps);
			pbrLightPass.blend(One, One);
			pbrLightPass.depthWrite = false;
			pbrLightPass.enableLights = true;
		}
		ctx.pbrLightPass = pbrLightPass;
	}

	override function render() {

		shadows.draw(get("shadow"));

		var albedo = allocTarget("albedo");
		var normal = allocFTarget("normal",0,false);
		var pbr = allocTarget("pbr",0,false);
		setTargets([albedo,normal,pbr]);
		clear(0, 1);
		output.draw(getSort("default", true));

		setTarget(albedo);
		draw("color");

		var output = allocTarget("hdrOutput", 0, true);
		setTarget(output);
		pbrProps.albedoTex = albedo;
		pbrProps.normalTex = normal;
		pbrProps.pbrTex = pbr;
		pbrProps.cameraInverseViewProj = ctx.camera.getInverseViewProj();

		pbrOut.shader.cameraPosition.load(ctx.camera.pos);
		pbrOut.shader.irrLut = irrad.lut;
		pbrOut.shader.irrDiffuse = irrad.diffuse;
		pbrOut.shader.irrSpecular = irrad.specular;
		pbrOut.shader.irrSpecularLevels = irrad.specLevels;

		var ls = getLightSystem();
		if( ls.shadowLight == null ) {
			pbrOut.removeShader(pbrDirect);
			pbrOut.removeShader(pbrSun);
		} else {
			if( pbrOut.getShader(h3d.shader.pbr.Light.DirLight) == null ) {
				pbrOut.addShader(pbrDirect);
				pbrOut.addShader(pbrSun);
			}
			pbrSun.lightColor.load(ls.shadowLight.color);
			pbrSun.lightDir.load(@:privateAccess ls.shadowLight.getShadowDirection());
			pbrSun.lightDir.scale3(-1);
			pbrSun.lightDir.normalize();
			pbrSun.isSun = true;
		}

		pbrOut.setGlobals(ctx);
		pbrOut.render();

		var ls = Std.instance(ls, LightSystem);
		if( ls != null ) ls.drawLights(this);

		pbrProps.isScreen = false;
		draw("lights");
		pbrProps.isScreen = true;

		draw("late");
		resetTarget();


		switch( displayMode ) {

		case Pbr:
			fxaa.apply(output);

		case Slides:

			slides.shader.albedo = albedo;
			slides.shader.normal = normal;
			slides.shader.pbr = pbr;
			slides.render();

		}

	}

}