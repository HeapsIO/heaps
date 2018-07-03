package h3d.scene.pbr;

@:enum abstract DisplayMode(String) {
	/*
		Full PBR display
	*/
	var Pbr = "Pbr";
	/*
		Set Albedo = 0x808080
	*/
	var Env = "Env";
	/*
		Set Albedo = 0x808080, Roughness = 0, Metalness = 1
	*/
	var MatCap = "MatCap";
	/*
		Debug slides
	*/
	var Debug = "Debug";
}

@:enum abstract SkyMode(String) {
	var Hide = "Hide";
	var Env = "Env";
	var Irrad = "Irrad";
}

@:enum abstract TonemapMap(String) {
	var Linear = "Linear";
	var Reinhard = "Reinhard";
}

typedef SaoProps = {
	var size : Int;
	var blur : Int;
	var samples : Int;
	var radius : Float;
	var intensity : Float;
	var bias : Float;
}

typedef PbrRenderProps = {
	var mode : DisplayMode;
	var env : String;
	var envPower : Float;
	var exposure : Float;
	var sky : SkyMode;
	var tone : TonemapMap;
	var sao : SaoProps;
}

class Renderer extends h3d.scene.Renderer {

	var slides = new h3d.pass.ScreenFx(new h3d.shader.pbr.Slides());
	var pbrOut = new h3d.pass.ScreenFx(new h3d.shader.ScreenShader());
	var tonemap = new h3d.pass.ScreenFx(new h3d.shader.pbr.ToneMapping());
	var pbrSun = new h3d.shader.pbr.Light.DirLight();
	var pbrLightPass : h3d.mat.Pass;
	var screenLightPass : h3d.pass.ScreenFx<h3d.shader.ScreenShader>;
	var fxaa = new h3d.pass.FXAA();
	var shadows = new h3d.pass.ShadowMap(2048);
	var pbrIndirect = new h3d.shader.pbr.Lighting.Indirect();
	var pbrDirect = new h3d.shader.pbr.Lighting.Direct();
	var pbrProps = new h3d.shader.pbr.PropsImport();
	var sao = new h3d.pass.ScalableAO();
	var saoBlur = new h3d.pass.Blur();
	var saoCopy = new h3d.pass.Copy();

	public var skyMode : SkyMode = Hide;
	public var toneMode : TonemapMap = Reinhard;
	public var displayMode : DisplayMode = Pbr;
	public var env : Environment;
	public var exposure(get,set) : Float;

	var output = new h3d.pass.Output("mrt",[
		Value("output.color"),
		Vec4([Value("output.normal",3),Value("output.depth",1)]),
		Vec4([Value("output.metalness"), Value("output.roughness"), Value("output.occlusion"), Const(0)]),
	]);

	public function new(env) {
		super();
		this.env = env;
		shadows.bias = 0.0;
		shadows.power = 1000;
		shadows.blur.passes = 1;
		defaultPass = new h3d.pass.Default("default");
		pbrOut.addShader(pbrIndirect);
		pbrOut.addShader(pbrProps);
		allPasses.push(output);
		allPasses.push(defaultPass);
		allPasses.push(shadows);
		refreshProps();
	}

	inline function get_exposure() return tonemap.shader.exposure;
	inline function set_exposure(v:Float) return tonemap.shader.exposure = v;

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
			/*
				This allows to discard light pixels when there is nothing
				between light volume and camera. Also prevents light shape
				to be discarded when the camera is inside its volume.
			*/
			pbrLightPass.culling = Front;
			pbrLightPass.depth(false, Greater);
			pbrLightPass.enableLights = true;
		}
		ctx.pbrLightPass = pbrLightPass;
	}

	function mainDraw() {
		output.draw(getSort("default", true));
		output.draw(getSort("alpha"));
		output.draw(get("additive"));
	}

	function postDraw() {
		draw("overlay");
	}

	override function render() {
		var props : PbrRenderProps = props;

		shadows.draw(get("shadow"));

		var albedo = allocTarget("albedo");
		var normal = allocTarget("normalDepth",0,false,RGBA32F);
		var pbr = allocTarget("pbr",0,false);
		setTargets([albedo,normal,pbr]);
		clear(0, 1, 0);
		mainDraw();

		setTarget(albedo);
		draw("albedo");

		if( props.sao != null ) {
			var sp = props.sao;
			var saoTex = allocTarget("sao",sp.size,false);
			setTarget(saoTex);
			sao.shader.depthTextureChannel = A;
			sao.shader.normalTextureChannel = R;
			sao.shader.numSamples = 1 << sp.samples;
			sao.shader.sampleRadius	= sp.radius;
			sao.shader.intensity = sp.intensity;
			sao.shader.bias = sp.bias * sp.bias;
			sao.apply(normal,normal,ctx.camera);
			saoBlur.passes = sp.blur;
			saoBlur.apply(saoTex);
			saoCopy.pass.setColorMask(false,false,true,false);
			saoCopy.apply(saoTex, pbr, Multiply);
		}

		if( displayMode == Env )
			clear(0xFF404040);

		if( displayMode == MatCap ) {
			clear(0xFF808080);
			setTarget(pbr);
			clear(0x00FF80FF);
		}

		var output = allocTarget("hdrOutput", 0, true, RGBA16F);
		setTarget(output);
		if( ctx.engine.backgroundColor != null )
			clear(ctx.engine.backgroundColor);
		pbrProps.albedoTex = albedo;
		pbrProps.normalTex = normal;
		pbrProps.pbrTex = pbr;
		pbrProps.cameraInverseViewProj = ctx.camera.getInverseViewProj();

		pbrDirect.cameraPosition.load(ctx.camera.pos);
		pbrIndirect.cameraPosition.load(ctx.camera.pos);
		pbrIndirect.irrPower = env.power * env.power;
		pbrIndirect.irrLut = env.lut;
		pbrIndirect.irrDiffuse = env.diffuse;
		pbrIndirect.irrSpecular = env.specular;
		pbrIndirect.irrSpecularLevels = env.specLevels;

		var ls = getLightSystem();
		if( ls.shadowLight == null ) {
			pbrOut.removeShader(pbrDirect);
			pbrOut.removeShader(pbrSun);
			pbrOut.removeShader(shadows.shader);
		} else {
			var pdir = Std.instance(ls.shadowLight, h3d.scene.pbr.DirLight);
			if( pbrOut.getShader(h3d.shader.pbr.Light.DirLight) == null ) {
				pbrOut.addShader(pbrDirect);
				pbrOut.addShader(pbrSun);
				pbrOut.addShader(shadows.shader);
			}
			pbrSun.lightColor.load(ls.shadowLight.color);
			if( pdir != null ) pbrSun.lightColor.scale3(pdir.power * pdir.power);
			pbrSun.lightDir.load(@:privateAccess ls.shadowLight.getShadowDirection());
			pbrSun.lightDir.scale3(-1);
			pbrSun.lightDir.normalize();
		}

		pbrOut.setGlobals(ctx);
		pbrDirect.doDiscard = false;
		pbrIndirect.showSky = skyMode != Hide;
		pbrIndirect.skyMap = skyMode == Irrad ? env.diffuse : env.env;
		pbrIndirect.cameraInvViewProj.load(ctx.camera.getInverseViewProj());
		pbrOut.render();
		pbrDirect.doDiscard = true;

		var ls = Std.instance(ls, LightSystem);
		var lpass = screenLightPass;
		if( lpass == null ) {
			lpass = new h3d.pass.ScreenFx(new h3d.shader.ScreenShader());
			lpass.addShader(pbrProps);
			lpass.addShader(pbrDirect);
			lpass.pass.setBlendMode(Add);
			screenLightPass = lpass;
		}
		if( ls != null ) ls.drawLights(this, lpass);

		pbrProps.isScreen = false;
		draw("lights");
		pbrProps.isScreen = true;

		var ldr = allocTarget("ldrOutput",0,true);
		setTarget(ldr);
		tonemap.shader.mode = switch( toneMode ) {
		case Linear: 0;
		case Reinhard: 1;
		default: 0;
		};
		tonemap.shader.hdrTexture = output;
		tonemap.render();

		postDraw();
		resetTarget();


		switch( displayMode ) {

		case Pbr, Env, MatCap:
			fxaa.apply(ldr);

		case Debug:

			slides.shader.shadowMap = ctx.textures.getNamed("shadowMap");
			slides.shader.albedo = albedo;
			slides.shader.normal = normal;
			slides.shader.pbr = pbr;
			slides.render();

		}
	}

	// ---- PROPS

	override function getDefaultProps( ?kind : String ):Any {
		var props : PbrRenderProps = {
			mode : Pbr,
			env : null,
			envPower : 1.,
			exposure : 0.,
			sky : Hide,
			tone : Reinhard,
			sao : null,
		};
		return props;
	}

	override function refreshProps() {
		if( env == null )
			return;
		var props : PbrRenderProps = props;
		if( props.env != null && props.env != env.source.name ) {
			var t = hxd.res.Loader.currentInstance.load(props.env).toTexture();
			var prev = env;
			var env = new h3d.scene.pbr.Environment(t);
			env.compute();
			this.env = env;
			prev.dispose();
		}
		displayMode = props.mode;
		skyMode = props.sky;
		toneMode = props.tone;
		exposure = props.exposure;
		env.power = props.envPower;
	}

	#if js
	override function editProps() {
		var props : PbrRenderProps = props;
		if( props.sao == cast true ) {
			props.sao = {
				size : 0,
				blur : 1,
				samples : 5,
				radius : 1,
				intensity : 1,
				bias : 0.1,
			};
		} else if( props.sao == cast false ) {
			Reflect.deleteField(props,"sao");
		}

		var saoProps = props.sao == null ? '' : '
			<dl>
			<dt>Intensity</dt><dd><input type="range" min="0" max="10" field="sao.intensity"/></dd>
			<dt>Radius</dt><dd><input type="range" min="0" max="10" field="sao.radius"/></dd>
			<dt>Bias</dt><dd><input type="range" min="0" max="0.5" field="sao.bias"/></dd>
			<dt>Size</dt><dd><input type="range" min="0" max="3" field="sao.size" step="1"/></dd>
			<dt>Blur</dt><dd><input type="range" min="0" max="5" field="sao.blur" step="1"/></dd>
			<dt>Samples</dt><dd><input type="range" min="3" max="10" field="sao.samples" step="1"/></dd>
			</dl>
		';

		return new js.jquery.JQuery('
			<dl>
				<dt>Tone</dt>
				<dd>
					<select field="tone">
						<option value="Linear">Linear</option>
						<option value="Reinhard">Reinhard</option>
					</select>
				</dd>
				<dt>Mode</dt>
				<dd>
					<select field="mode">
						<option value="Pbr">PBR</option>
						<option value="Env">Env</option>
						<option value="MatCap">MatCap</option>
						<option value="Debug">Debug</option>
					</select>
				</dd>
				<dt>Env</dt>
				<dd>
					<input type="texturepath" field="env" style="width:165px"/>
					<select field="sky" style="width:20px">
						<option value="Hide">Hide</option>
						<option value="Env">Show</option>
						<option value="Irrad">Show Irrad</option>
					</select>
				</dd>
				<dt>&nbsp;</dt><dd><input type="range" min="0" max="2" field="envPower"/></dd>
				<dt>Exposure</dt><dd><input type="range" min="-3" max="3" field="exposure"></dd>
			</dl>

			<dl>
				<dt>SAO</dt>
				<dd>
					<input type="checkbox" field="sao"/>
					$saoProps
				</dd>
			</dl>


		');
	}
	#end
}