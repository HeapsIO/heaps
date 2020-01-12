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
	/*
		Distortion
	*/
	var Distortion = "Distortion";
}

@:enum abstract SkyMode(String) {
	var Hide = "Hide";
	var Env = "Env";
	var Specular = "Specular";
	var Irrad = "Irrad";
	var Background = "Background";
}

@:enum abstract TonemapMap(String) {
	var Linear = "Linear";
	var Reinhard = "Reinhard";
}

typedef RenderProps = {
	var mode : DisplayMode;
	var colorGradingLUT : String;
	var colorGradingLUTSize : Int;
	var enableColorGrading : Bool;
	var exposure : Float;
	var sky : SkyMode;
	var tone : TonemapMap;
	var emissive : Float;
	var occlusion : Float;
	var shadows : Bool;
}

class DepthCopy extends h3d.shader.ScreenShader {

	static var SRC = {
		@ignore @param var depthTexture : Channel;
		function fragment() {
			pixelColor = vec4(depthTexture.get(calculatedUV));
		}
	}
}

class Renderer extends h3d.scene.Renderer {
	var slides = new h3d.pass.ScreenFx(new h3d.shader.pbr.Slides());
	var pbrOut = new h3d.pass.ScreenFx(new h3d.shader.ScreenShader());
	var tonemap = new h3d.pass.ScreenFx(new h3d.shader.pbr.ToneMapping());
	var depthCopy = new h3d.pass.ScreenFx(new DepthCopy());
	var pbrLightPass : h3d.mat.Pass;
	var screenLightPass : h3d.pass.ScreenFx<h3d.shader.ScreenShader>;
	var fxaa = new h3d.pass.FXAA();
	var pbrIndirect = new h3d.shader.pbr.Lighting.Indirect();
	var pbrDirect = new h3d.shader.pbr.Lighting.Direct();
	var pbrProps = new h3d.shader.pbr.PropsImport();
	var hasDebugEvent = false;
	var enableFXAA = true;

	public var skyMode : SkyMode = Hide;
	public var toneMode : TonemapMap = Reinhard;
	public var colorGradingLUT : h3d.mat.Texture;
	public var colorGradingLUTSize : Int;
	public var enableColorGrading : Bool;
	public var displayMode : DisplayMode = Pbr;
	public var env : Environment;
	public var exposure(get,set) : Float;
	public var debugMode = 0;
	public var shadows = true;

	static var ALPHA : hxsl.Output = Swiz(Value("output.color"),[W]);
	var output = new h3d.pass.Output("default",[
		Value("output.color"),
		Vec4([Value("output.normal",3),ALPHA]),
		Vec4([Value("output.metalness"), Value("output.roughness"), Value("output.occlusion"), ALPHA]),
		Vec4([Value("output.emissive"),Value("output.depth"),Const(0), ALPHA /* ? */])
	]);
	var decalsOutput = new h3d.pass.Output("decals",[
		Vec4([Swiz(Value("output.color"),[X,Y,Z]), Value("output.albedoStrength",1)]),
		Vec4([Value("output.normal",3), Value("output.normalStrength",1)]),
		Vec4([Value("output.metalness"), Value("output.roughness"), Value("output.occlusion"), Value("output.pbrStrength")])
	]);


	public function new(?env) {
		super();
		this.env = env;
		defaultPass = new h3d.pass.Default("color");
		slides.addShader(pbrProps);
		pbrOut.addShader(pbrIndirect);
		pbrOut.addShader(pbrProps);
		pbrOut.pass.setBlendMode(Add);
		pbrOut.pass.stencil = new h3d.mat.Stencil();
		pbrOut.pass.stencil.setOp(Keep, Keep, Keep);
		pbrOut.pass.stencil.setFunc(NotEqual, 0x80, 0x80, 0x80); // ignore already drawn volumetricLightMap areas
		allPasses.push(output);
		allPasses.push(defaultPass);
		allPasses.push(decalsOutput);
		allPasses.push(new h3d.pass.Shadows(null));
		refreshProps();
	}

	override function dispose() {
		super.dispose();
	}

	inline function get_exposure() return tonemap.shader.exposure;
	inline function set_exposure(v:Float) return tonemap.shader.exposure = v;

	override function debugCompileShader(pass:h3d.mat.Pass) {
		output.setContext(this.ctx);
		return output.compileShader(pass);
	}

	override function getPassByName(name:String):h3d.pass.Base {
		switch( name ) {
		case "overlay", "beforeTonemapping", "albedo", "distortion", "afterTonemapping":
			return defaultPass;
		case "alpha", "additive":
			return output;
		}
		return super.getPassByName(name);
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
			pbrLightPass.depth(false, GreaterEqual);
			pbrLightPass.enableLights = true;
		}
		ctx.pbrLightPass = pbrLightPass;
	}

	inline function cullPasses( passes : h3d.pass.PassList, f : h3d.col.Collider -> Bool ) {
		var prevCollider = null;
		var prevResult = true;
		passes.filter(function(p) {
			var col = p.obj.cullingCollider;
			if( col == null )
				return true;
			if( col != prevCollider ) {
				prevCollider = col;
				prevResult = f(col);
			}
			return prevResult;
		});
	}

	override function draw( name : String ) {
		var passes = get(name);
		cullPasses(passes, function(col) return col.inFrustum(ctx.camera.frustum));
		defaultPass.draw(passes);
		passes.reset();
	}

	function renderPass(p:h3d.pass.Base, passes, ?sort) {
		cullPasses(passes, function(col) return col.inFrustum(ctx.camera.frustum));
		p.draw(passes, sort);
		passes.reset();
	}

	function mainDraw() {
		mark("MainDraw");
		renderPass(output, get("default"), frontToBack);
		renderPass(output, get("terrain"));
		renderPass(output, get("alpha"), backToFront);
		renderPass(output, get("additive"));
	}

	function drawBeforeTonemapping() {
		mark("BeforeTonemapping");
		draw("beforeTonemappingDecal");
		draw("beforeTonemapping");
	}

	function drawAfterTonemapping() {
		mark("AfterTonemapping");
		draw("afterTonemappingDecal");
		draw("afterTonemapping");
	}

	function applyTonemapping() {
		mark("ToneMapping");
		// Bloom Params
		var bloom = ctx.getGlobal("bloom");
		tonemap.shader.bloom = bloom;
		tonemap.shader.hasBloom = bloom != null;
		// Distortion Params
		var distortion = ctx.getGlobal("distortion");
		tonemap.shader.distortion = distortion;
		tonemap.shader.hasDistortion = distortion != null;
		// Color Grading Params
		tonemap.shader.pixelSize = new Vector(1.0/ctx.engine.width, 1.0/ctx.engine.height);
		tonemap.shader.hasColorGrading = enableColorGrading && colorGradingLUT != null;
		if( colorGradingLUT != null ) {
			tonemap.shader.colorGradingLUT = colorGradingLUT;
			tonemap.shader.lutSize = colorGradingLUTSize;
		}
		tonemap.shader.mode =	switch( toneMode ) {
									case Linear: 0;
									case Reinhard: 1;
									default: 0;
								};
		var hdr = ctx.getGlobal("hdr");
		tonemap.shader.hdrTexture = hdr;
		tonemap.render();
	}

	function postDraw() {
		mark("PostDraw");
		draw("overlay");
	}

	function drawShadows( ls : LightSystem ) {
		var light = @:privateAccess ctx.lights;
		var passes = get("shadow");
		if( !shadows )
			passes.clear();
		while( light != null ) {
			var plight = hxd.impl.Api.downcast(light, h3d.scene.pbr.Light);
			if( plight != null ) ls.drawLight(plight, passes);
			light = light.next;
		}
	}

	function apply( step : h3d.impl.RendererFX.Step ) {
		for( f in effects )
			if( f.enabled )
				f.apply(this, step);
	}

	override function computeStatic() {
		var light = @:privateAccess ctx.lights;
		var passes = get("shadow");
		while( light != null ) {
			var plight = hxd.impl.Api.downcast(light, h3d.scene.pbr.Light);
			if( plight != null ) {
				plight.shadows.setContext(ctx);
				plight.shadows.computeStatic(passes);
				passes.reset();
			}
			light = light.next;
		}
	}

	override function render() {
		var props : RenderProps = props;

		var albedo = allocTarget("albedo", true, 1.);
		var normal = allocTarget("normal", true, 1., RGBA16F);
		var pbr = allocTarget("pbr", true, 1.);
		var other = allocTarget("other", true, 1., RGBA32F);

		ctx.setGlobal("albedoMap", { texture : albedo, channel : hxsl.Channel.R });
		ctx.setGlobal("depthMap", { texture : other, channel : hxsl.Channel.G });
		ctx.setGlobal("normalMap", { texture : normal, channel : hxsl.Channel.R });
		ctx.setGlobal("occlusionMap", { texture : pbr, channel : hxsl.Channel.B });
		ctx.setGlobal("bloom", null);

		var ls = hxd.impl.Api.downcast(getLightSystem(), LightSystem);
		var count = ctx.engine.drawCalls;
		if( ls != null ) drawShadows(ls);
		if( ctx.lightSystem != null ) ctx.lightSystem.drawPasses = ctx.engine.drawCalls - count;

		setTargets([albedo,normal,pbr,other]);
		clear(0, 1, 0);
		mainDraw();

		mark("Decal");
		setTargets([albedo,normal,pbr]);
		renderPass(decalsOutput, get("decal"));

		if(renderMode == Default) {
			if( displayMode == Env )
				clear(0xFF404040);

			if( displayMode == MatCap ) {
				clear(0xFF808080);
				setTarget(pbr);
				clear(0x00FF80FF);
			}
		}
		apply(BeforeLighting);

		var hdr = allocTarget("hdrOutput", true, 1, RGBA16F);
		ctx.setGlobal("hdr", hdr);
		setTarget(hdr);
		clear(0);

		pbrProps.albedoTex = albedo;
		pbrProps.normalTex = normal;
		pbrProps.pbrTex = pbr;
		pbrProps.otherTex = other;
		pbrProps.cameraInverseViewProj = ctx.camera.getInverseViewProj();
		pbrProps.occlusionPower = props.occlusion * props.occlusion;

		pbrDirect.cameraPosition.load(ctx.camera.pos);

		if( env != null ) {
			pbrIndirect.cameraPosition.load(ctx.camera.pos);
			pbrIndirect.emissivePower = props.emissive * props.emissive;
			pbrIndirect.rot = hxd.Math.degToRad(env.rot);
			pbrIndirect.irrPower = env.power * env.power;
			pbrIndirect.irrLut = env.lut;
			pbrIndirect.irrDiffuse = env.diffuse;
			pbrIndirect.irrSpecular = env.specular;
			pbrIndirect.irrSpecularLevels = env.specLevels;
			pbrIndirect.cameraInvViewProj.load(ctx.camera.getInverseViewProj());

			pbrDirect.doDiscard = false;
			switch( renderMode ) {
			case Default:
				pbrIndirect.drawIndirectDiffuse = true;
				pbrIndirect.drawIndirectSpecular= true;
				pbrIndirect.showSky = skyMode != Hide;
				pbrIndirect.skyColor = false;
				pbrIndirect.skyMap = switch( skyMode ) {
				case Hide: null;
				case Env:
					pbrIndirect.skyScale = env.scale;
					pbrIndirect.skyThreshold = env.threshold;
					pbrIndirect.gammaCorrect = true;
					env.env;
				case Specular:
					pbrIndirect.skyScale = 1.0;
					pbrIndirect.gammaCorrect = false;
					env.specular;
				case Irrad:
					pbrIndirect.skyScale = 1.0;
					pbrIndirect.gammaCorrect = false;
					env.diffuse;
				case Background:
					pbrIndirect.skyColor = true;
					pbrIndirect.skyColorValue.setColor(ctx.engine.backgroundColor);
					pbrIndirect.gammaCorrect = true;
					null;
				};
			case LightProbe:
				pbrIndirect.drawIndirectDiffuse = false;
				pbrIndirect.drawIndirectSpecular = false;
				pbrIndirect.showSky = true;
				pbrIndirect.skyColor = false;
				pbrIndirect.skyMap = env.env;
			}
			pbrDirect.doDiscard = true;
		}

		var lpass = screenLightPass;
		if( lpass == null ) {
			lpass = new h3d.pass.ScreenFx(new h3d.shader.ScreenShader());
			lpass.addShader(pbrProps);
			lpass.addShader(pbrDirect);
			lpass.pass.setBlendMode(Add);
			screenLightPass = lpass;
		}

		mark("DirectLighting");
		// Direct Lighting - FullScreen
		pbrProps.isScreen = true;
		if( ls != null ) {
			var count = ctx.engine.drawCalls;
			ls.drawScreenLights(this, lpass);
			ctx.lightSystem.drawPasses += ctx.engine.drawCalls - count;
		}
		// Direct Lighting - With Primitive
		pbrProps.isScreen = false;
		draw(pbrLightPass.name);

		if( renderMode == LightProbe ) {
			pbrProps.isScreen = true;
			pbrOut.render();
			resetTarget();
			copy(hdr, null);
			// no warnings
			for( p in passObjects ) if( p != null ) p.rendered = true;
			return;
		}

		// Indirect Lighting - Diffuse with volumetricLightmap
		mark("VolumetricLightmap");
		pbrProps.isScreen = false;
		pbrIndirect.drawIndirectDiffuse = false;
		pbrIndirect.drawIndirectSpecular = env != null ? true : false;
		ctx.extraShaders = new hxsl.ShaderList(pbrProps, new hxsl.ShaderList(pbrIndirect, null));
		draw("volumetricLightmap");
		ctx.extraShaders = null;

		// Indirect Lighting - Diffuse and Specular
 		if( env != null ) {
			mark("Indirect Lighting");
			pbrProps.isScreen = true;
			pbrIndirect.drawIndirectDiffuse = true;
			pbrIndirect.drawIndirectSpecular = true;
			pbrOut.render();
		}

		drawBeforeTonemapping();
		apply(BeforeTonemapping);

		mark("Distortion");
		var distortion = allocTarget("distortion", true, 1.0, RG16F);
		ctx.setGlobal("distortion", distortion);
		setTarget(distortion);
		clear(0);
		draw("distortion");

		var ldr = allocTarget("ldrOutput");
		setTarget(ldr);
		ctx.setGlobal("ldr", ldr);

		applyTonemapping();

		drawAfterTonemapping();
		apply(AfterTonemapping);

		postDraw();

		apply(AfterUI);

		resetTarget();

		switch( displayMode ) {

		case Pbr, Env, MatCap:
			if( enableFXAA ) {
				mark("FXAA");
				fxaa.apply(ldr);
			}
			else {
				copy(ldr, null);
			}

		case Distortion:
			resetTarget();
			copy( distortion, null);

		case Debug:
			var shadowMap = ctx.textures.getNamed("shadowMap");
			if( shadowMap == null )
				shadowMap = h3d.mat.Texture.fromColor(0);
			slides.shader.shadowMap = shadowMap;
			slides.shader.shadowMapChannel = R;
			slides.render();

			if( !hasDebugEvent ) {
				hasDebugEvent = true;
				hxd.Window.getInstance().addEventTarget(onEvent);
			}
		}

		if( hasDebugEvent && displayMode != Debug ) {
			hasDebugEvent = false;
			hxd.Window.getInstance().removeEventTarget(onEvent);
		}
	}

	function onEvent(e:hxd.Event) {
		if( e.kind == EPush && e.button == 2 ) {
			var win = hxd.Window.getInstance();
			var x = Std.int((e.relX / win.width) * 4);
			var y = Std.int((e.relY / win.height) * 4);
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
			colorGradingLUT : null,
			colorGradingLUTSize : 1,
			enableColorGrading: true,
			emissive : 1.,
			exposure : 0.,
			sky : Irrad,
			tone : Linear,
			occlusion : 1.,
			shadows: true
		};
		return props;
	}

	function createEnv( t : h3d.mat.Texture ) {
		return new h3d.scene.pbr.Environment(t);
	}

	override function refreshProps() {

		var props : RenderProps = props;

		displayMode = props.mode;
		skyMode = props.sky;
		toneMode = props.tone;
		exposure = props.exposure;
		shadows = props.shadows;

		if( props.colorGradingLUT != null )
			colorGradingLUT = hxd.res.Loader.currentInstance.load(props.colorGradingLUT).toTexture();
		else
			colorGradingLUT = null;
		colorGradingLUTSize = props.colorGradingLUTSize;
		enableColorGrading = props.enableColorGrading;
	}

	#if editor
	override function editProps() {
		var props : RenderProps = props;
		return new js.jquery.JQuery('
			<div class="group" name="Renderer">
			<dl>

				<dt>Mode</dt>
				<dd>
					<select field="mode">
						<option value="Pbr">PBR</option>
						<option value="Env">Env</option>
						<option value="MatCap">MatCap</option>
						<option value="Debug">Debug</option>
						<option value="Distortion">Distortion</option>
					</select>
				</dd>

				<div class="group" name="Tone Mapping">
					<dt>Tone</dt>
					<dd>
						<select field="tone">
							<option value="Linear">Linear</option>
							<option value="Reinhard">Reinhard</option>
						</select>
					</dd>
				</div>

				<div class="group" name="Color Grading">
					<dt>LUT</dt><dd><input type="texturepath" field="colorGradingLUT" style="width:165px"/></dd>
					<dt>LUT Size</dt><dd><input step="1" type="range" min="0" max="32" field="colorGradingLUTSize"></dd>
					<dt>Enable</dt><dd><input type="checkbox" field="enableColorGrading"></dd>
				</div>

				<div class="group" name="Environment">
					<dt>Env</dt>
						<dd>
							<select field="sky">
								<option value="Hide">Hide</option>
								<option value="Env">Show</option>
								<option value="Specular">Show Specular</option>
								<option value="Irrad">Show Irrad</option>
								<option value="Background">Background Color</option>
							</select>
						</dd>
				</div>

				<div class="group" name="Params">
					<dt>Emissive</dt><dd><input type="range" min="0" max="2" field="emissive"></dd>
					<dt>Occlusion</dt><dd><input type="range" min="0" max="2" field="occlusion"></dd>
					<dt>Exposure</dt><dd><input type="range" min="-3" max="3" field="exposure"></dd>
					<dt>Shadows</dt><dd><input type="checkbox" field="shadows"></dd>
				</div>
			</dl>
			</div>
		');
	}
	#end
}