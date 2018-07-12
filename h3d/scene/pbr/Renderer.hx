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
	var enable : Bool;
	var size : Float;
	var blur : Float;
	var samples : Int;
	var radius : Float;
	var intensity : Float;
	var bias : Float;
}

typedef BloomProps = {
	var enable : Bool;
	var size : Float;
	var threshold : Float;
	var intensity : Float;
	var blur : Float;
}

typedef ShadowProps = {
	var enable : Bool;
	var power : Float;
	var blur : Float;
	var bias : Float;
	var quality : Float;
}

typedef RenderProps = {
	var mode : DisplayMode;
	var env : String;
	var envPower : Float;
	var exposure : Float;
	var sky : SkyMode;
	var tone : TonemapMap;
	var bloom : BloomProps;
	var sao : SaoProps;
	var shadow : ShadowProps;
	var emissive : Float;
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
	var bloomPass = new h3d.pass.ScreenFx(new h3d.shader.pbr.Bloom());
	var bloomBlur = new h3d.pass.Blur();
	var hasDebugEvent = false;

	public var skyMode : SkyMode = Hide;
	public var toneMode : TonemapMap = Reinhard;
	public var displayMode : DisplayMode = Pbr;
	public var env : Environment;
	public var exposure(get,set) : Float;
	public var debugMode = 0;

	static var ALPHA : hxsl.Output = Swiz(Value("output.color"),[W]);
	var output = new h3d.pass.Output("mrt",[
		Value("output.color"),
		Vec4([Value("output.normal",3),ALPHA]),
		Vec4([Value("output.metalness"), Value("output.roughness"), Value("output.occlusion"), ALPHA]),
		Vec4([Value("output.emissive"),Value("output.depth"),Const(0), ALPHA /* ? */])
	]);
	var decalsOutput = new h3d.pass.Output("decals",[
		Vec4([Swiz(Value("output.color"),[X,Y,Z]), Value("output.albedoStrength",1)]),
		Vec4([Value("output.normal",3), Value("output.normalStrength",1)]),
		Vec4([Value("output.metalness"), Value("output.roughness"), Value("output.occlusion"), Value("output.pbrStrength")]),
	]);

	public function new(env) {
		super();
		this.env = env;
		defaultPass = new h3d.pass.Default("default");
		pbrOut.addShader(pbrIndirect);
		pbrOut.addShader(pbrProps);
		slides.addShader(pbrProps);
		allPasses.push(output);
		allPasses.push(defaultPass);
		allPasses.push(shadows);
		allPasses.push(decalsOutput);
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
		var props : RenderProps = props;

		if( props.shadow.enable ) {
			var sh = props.shadow;
			shadows.power = sh.power;
			shadows.blur.radius = sh.blur;
			shadows.blur.quality = sh.quality;
			shadows.bias = sh.bias * 0.1;
			shadows.draw(get("shadow"));
		} else
			get("shadow");
		pbrDirect.enableShadow = props.shadow.enable;

		var albedo = allocTarget("albedo");
		var normal = allocTarget("normalDepth",false,1.,RGBA16F);
		var pbr = allocTarget("pbr",false,1.);
		var other = allocTarget("other",false,1.,RGBA32F);
		setTargets([albedo,normal,pbr,other]);
		clear(0, 1, 0);
		mainDraw();

		setTargets([albedo,normal,pbr]);
		ctx.setGlobal("depthMap",{ texture : other, channel : hxsl.Channel.G });
		decalsOutput.draw(get("decal"));

		setTarget(albedo);
		draw("albedo");

		if( displayMode == Env )
			clear(0xFF404040);

		if( displayMode == MatCap ) {
			clear(0xFF808080);
			setTarget(pbr);
			clear(0x00FF80FF);
		}

		if( props.sao.enable ) {
			var sp = props.sao;
			var saoTex = allocTarget("sao",false,sp.size);
			setTarget(saoTex);
			sao.shader.depthTextureChannel = B;
			sao.shader.normalTextureChannel = R;
			sao.shader.numSamples = sp.samples;
			sao.shader.sampleRadius	= sp.radius;
			sao.shader.intensity = sp.intensity;
			sao.shader.bias = sp.bias * sp.bias;
			sao.apply(other,normal,ctx.camera);
			saoBlur.radius = sp.blur;
			saoBlur.quality = 0.5;
			saoBlur.apply(ctx, saoTex);
			saoCopy.pass.setColorMask(false,false,true,false);
			saoCopy.apply(saoTex, pbr, Multiply);
		}

		var hdr = allocTarget("hdrOutput", false, 1, RGBA16F);
		setTarget(hdr);
		if( ctx.engine.backgroundColor != null )
			clear(ctx.engine.backgroundColor);
		pbrProps.albedoTex = albedo;
		pbrProps.normalTex = normal;
		pbrProps.pbrTex = pbr;
		pbrProps.otherTex = other;
		pbrProps.cameraInverseViewProj = ctx.camera.getInverseViewProj();

		pbrDirect.cameraPosition.load(ctx.camera.pos);
		pbrIndirect.cameraPosition.load(ctx.camera.pos);
		pbrIndirect.emissivePower = props.emissive * props.emissive;
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
				pbrOut.addShader(shadows.shader);
				pbrOut.addShader(pbrDirect);
				pbrOut.addShader(pbrSun);
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

		var bloom : h3d.mat.Texture = null;
		if( props.bloom.enable ) {
			var pb = props.bloom;
			bloom = allocTarget("bloom", false, pb.size, RGBA16F);
			setTarget(bloom);
			bloomPass.shader.hdr = hdr;
			bloomPass.shader.threshold = pb.threshold;
			bloomPass.shader.intensity = pb.intensity;
			bloomPass.render();
			bloomBlur.radius = pb.blur;
			bloomBlur.apply(ctx, bloom);
		}

		var ldr = allocTarget("ldrOutput");
		setTarget(ldr);
		tonemap.shader.bloom = bloom;
		tonemap.shader.hasBloom = bloom != null;
		tonemap.shader.mode = switch( toneMode ) {
		case Linear: 0;
		case Reinhard: 1;
		default: 0;
		};
		tonemap.shader.hdrTexture = hdr;
		tonemap.render();

		postDraw();
		resetTarget();


		switch( displayMode ) {

		case Pbr, Env, MatCap:
			fxaa.apply(ldr);

		case Debug:

			var shadowMap = ctx.textures.getNamed("shadowMap");
			slides.shader.shadowMap = shadowMap;
			slides.render();

			if( !hasDebugEvent ) {
				hasDebugEvent = true;
				hxd.Stage.getInstance().addEventTarget(onEvent);
			}

		}

		if( hasDebugEvent && displayMode != Debug ) {
			hasDebugEvent = false;
			hxd.Stage.getInstance().removeEventTarget(onEvent);
		}
	}

	function onEvent(e:hxd.Event) {
		if( e.kind == EPush && e.button == 2 ) {
			var st = hxd.Stage.getInstance();
			var x = Std.int((e.relX / st.width) * 4);
			var y = Std.int((e.relY / st.height) * 4);
			if( slides.shader.mode != Full ) {
				slides.shader.mode = Full;
			} else {
				var a : Array<h3d.shader.pbr.Slides.DebugMode>;
				if( y == 3 )
					a = [Emmissive,Depth,AO,Shadow];
				else
					a = [Albedo,Normal,Roughness,Metalness];
				slides.shader.mode = a[x];
			}
		}
	}

	// ---- PROPS

	override function getDefaultProps( ?kind : String ):Any {
		var props : RenderProps = {
			mode : Pbr,
			env : null,
			envPower : 1.,
			emissive : 1.,
			exposure : 0.,
			sky : Hide,
			tone : Reinhard,
			shadow : {
				enable : true,
				power : 40,
				blur : 9,
				bias : 0.1,
				quality : 0.3,
			},
			sao : {
				enable : false,
				size : 1,
				blur : 5,
				samples : 30,
				radius : 1,
				intensity : 1,
				bias : 0.1,
			},
			bloom : {
				enable : false,
				size : 0.5,
				blur : 3,
				intensity : 1.,
				threshold : 0.5,
			},
		};
		return props;
	}

	override function refreshProps() {
		if( env == null )
			return;
		var props : RenderProps = props;
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
		var props : RenderProps = props;

		var shadowProps = '
			<dl>
			<dt>Power</dt><dd><input type="range" min="0" max="100" step="0.1" field="shadow.power"/></dd>
			<dt>Blur</dt><dd><input type="range" min="0" max="20" field="shadow.blur"/></dd>
			<dt>Quality</dt><dd><input type="range" field="shadow.quality"/></dd>
			<dt>Bias</dt><dd><input type="range" min="0" max="1" field="shadow.bias"/></dd>
			</dt>
		';

		var saoProps = '
			<dl>
			<dt>Intensity</dt><dd><input type="range" min="0" max="10" field="sao.intensity"/></dd>
			<dt>Radius</dt><dd><input type="range" min="0" max="10" field="sao.radius"/></dd>
			<dt>Bias</dt><dd><input type="range" min="0" max="0.5" field="sao.bias"/></dd>
			<dt>Size</dt><dd><input type="range" min="0" max="1" field="sao.size"/></dd>
			<dt>Blur</dt><dd><input type="range" min="0" max="20" field="sao.blur"/></dd>
			<dt>Samples</dt><dd><input type="range" min="3" max="256" field="sao.samples" step="1"/></dd>
			</dl>
		';

		var bloomProps = '
			<dl>
			<dt>Intensity</dt><dd><input type="range" min="0" max="2" field="bloom.intensity"/></dd>
			<dt>Threshold</dt><dd><input type="range" min="0" max="1" field="bloom.threshold"/></dd>
			<dt>Size</dt><dd><input type="range" min="0" max="1" field="bloom.size"/></dd>
			<dt>Blur</dt><dd><input type="range" min="0" max="20" field="bloom.blur"/></dd>
			</dl>
		';

		return new js.jquery.JQuery('
			<div class="group" name="Renderer">
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
					<br/>
					<input type="range" min="0" max="2" field="envPower"/>
				</dd>
				<dt>Emissive</dt><dd><input type="range" min="0" max="2" field="emissive"></dd>
				<dt>Exposure</dt><dd><input type="range" min="-3" max="3" field="exposure"></dd>
			</dl>
			</div>

			<div class="group">
				<div class="title">
					<input type="checkbox" field="shadow.enable"/> Shadows
				</div>
				$shadowProps
			</div>

			<div class="group">
				<div class="title">
					<input type="checkbox" field="bloom.enable"/> Bloom
				</div>
				$bloomProps
			</div>

			<div class="group">
				<div class="title">
					<input type="checkbox" field="sao.enable"/> SAO
				</div>
				$saoProps
			</div>
		');
	}
	#end
}