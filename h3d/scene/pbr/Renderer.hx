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
	var currentStep : h3d.impl.RendererFX.Step;

	var textures = {
		albedo : null,
		normal : null,
		pbr : null,
		other : null,
		hdr : null,
		ldr : null,
	};

	public var skyMode : SkyMode = Hide;
	public var toneMode : TonemapMap = Reinhard;
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

	override function addShader(s:hxsl.Shader) {
		tonemap.addShader(s);
	}

	inline function get_exposure() return tonemap.shader.exposure;
	inline function set_exposure(v:Float) return tonemap.shader.exposure = v;

	override function debugCompileShader(pass:h3d.mat.Pass) {
		output.setContext(this.ctx);
		return output.compileShader(pass);
	}

	override function getPassByName(name:String):h3d.pass.Base {
		switch( name ) {
		case "overlay", "beforeTonemapping", "albedo", "afterTonemapping", "forward":
			return defaultPass;
		case "default", "alpha", "additive":
			return output;
		case "decal":
			return decalsOutput;
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

	function lighting() {

		begin(Shadows);
		var ls = hxd.impl.Api.downcast(getLightSystem(), h3d.scene.pbr.LightSystem);
		var count = ctx.engine.drawCalls;
		if( ls != null ) drawShadows(ls);
		if( ctx.lightSystem != null ) ctx.lightSystem.drawPasses = ctx.engine.drawCalls - count;
		end();

		begin(Lighting);
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

		if( !renderLightProbes() && env != null ) {
			mark("Indirect Lighting");
			pbrProps.isScreen = true;
			pbrIndirect.drawIndirectDiffuse = true;
			pbrIndirect.drawIndirectSpecular = true;
			pbrOut.render();
		}

		end();
	}

	function renderLightProbes() {
		var probePass = get("lightProbe");
		if( probePass.isEmpty() )
			return false;
		function probeSort( passes : h3d.pass.PassList ) {
			// Priority of the probe stored in _44 of AbsPos
			passes.sort( (po1, po2) -> return Std.int(po1.obj.getAbsPos()._44 - po2.obj.getAbsPos()._44) );
		}

		// Probe Rendering & Blending
		var probeOutput = allocTarget("probeOutput", true, 1.0, RGBA16F);
		ctx.engine.pushTarget(probeOutput);
		clear(0);

		// Default Env & SkyBox
		if( env != null ) {
			mark("Indirect Lighting");
			pbrProps.isScreen = true;
			pbrIndirect.drawIndirectDiffuse = true;
			pbrIndirect.drawIndirectSpecular = true;
			pbrOut.render();
		}

		// Light Probe with Alpha Blend
		pbrProps.isScreen = false;
		renderPass(defaultPass, get("lightProbe"), probeSort);
		ctx.engine.popTarget();

		h3d.pass.Copy.run(probeOutput, textures.hdr, Add);
		return true;
	}

	function drawShadows( ls : LightSystem ) {
		var light = @:privateAccess ctx.lights;
		var passes = get("shadow");
		if( !shadows )
			passes.clear();
		while( light != null ) {
			var plight = hxd.impl.Api.downcast(light, h3d.scene.pbr.Light);
			if( plight != null ) ls.drawShadows(plight, passes);
			light = light.next;
		}
	}

	function begin( step : h3d.impl.RendererFX.Step ) {
		mark(step.getName());

		for( f in effects )
			if( f.enabled )
				f.begin(this, step);
		currentStep = step;

		if(step == Lighting && renderMode == Default) {
			if( displayMode == Env ) {
				ctx.engine.pushTarget(textures.albedo);
				clear(0xFF404040);
				ctx.engine.popTarget();
			}
			if( displayMode == MatCap ) {
				ctx.engine.pushTarget(textures.albedo);
				clear(0xFF808080);
				ctx.engine.popTarget();
				ctx.engine.pushTarget(textures.pbr);
				clear(0x00FF80FF);
				ctx.engine.popTarget();
			}
		}
	}

	function end() {
		for( f in effects )
			if( f.enabled )
				f.end(this, currentStep);
		currentStep = null;
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

	function initTextures() {
		textures.albedo = allocTarget("albedo", true, 1.);
		textures.normal = allocTarget("normal", true, 1., RGBA16F);
		textures.pbr = allocTarget("pbr", true, 1.);
		textures.other = allocTarget("other", true, 1., RGBA32F);
		textures.hdr = allocTarget("hdrOutput", true, 1, RGBA16F);
		textures.ldr = allocTarget("ldrOutput");
	}

	function initGlobals() {
		ctx.setGlobal("albedoMap", { texture : textures.albedo, channel : hxsl.Channel.R });
		ctx.setGlobal("depthMap", { texture : textures.other, channel : hxsl.Channel.G });
		ctx.setGlobal("normalMap", { texture : textures.normal, channel : hxsl.Channel.R });
		ctx.setGlobal("occlusionMap", { texture : textures.pbr, channel : hxsl.Channel.B });
		ctx.setGlobal("hdrMap", textures.hdr);
		ctx.setGlobal("ldrMap", textures.ldr);
		ctx.setGlobal("global.time", ctx.time);
		ctx.setGlobal("camera.position", ctx.camera.pos);
		ctx.setGlobal("camera.inverseViewProj", ctx.camera.getInverseViewProj());
	}

	function beginPbr() {
		var props : RenderProps = props;

		// reset tonemap shaders
		var s = @:privateAccess tonemap.shaders;
		while( s != null ) {
			if( s.s != tonemap.shader ) tonemap.removeShader(s.s);
			s = s.next;
		}

		initTextures();
		initGlobals();

		pbrProps.albedoTex = textures.albedo;
		pbrProps.normalTex = textures.normal;
		pbrProps.pbrTex = textures.pbr;
		pbrProps.otherTex = textures.other;
		pbrProps.cameraInverseViewProj = ctx.camera.getInverseViewProj();
		pbrProps.occlusionPower = props.occlusion * props.occlusion;

		pbrDirect.cameraPosition.load(ctx.camera.pos);

		if( env != null ) {
			pbrIndirect.cameraPosition.load(ctx.camera.pos);
			pbrIndirect.emissivePower = props.emissive * props.emissive;
			var rot = hxd.Math.degToRad(env.rot);
			pbrIndirect.irrRotation.set(Math.cos(rot), Math.sin(rot));
			pbrIndirect.irrPower = env.power * env.power;
			pbrIndirect.irrLut = env.lut;
			pbrIndirect.irrDiffuse = env.diffuse;
			pbrIndirect.irrSpecular = env.specular;
			pbrIndirect.irrSpecularLevels = env.specLevels;
			pbrIndirect.cameraInvViewProj.load(ctx.camera.getInverseViewProj());
			pbrIndirect.skyHdrMax = 1.0;
			pbrIndirect.drawIndirectDiffuse = true;
			pbrIndirect.drawIndirectSpecular = true;

			pbrDirect.doDiscard = false;
			switch( renderMode ) {
			case Default:
				pbrIndirect.showSky = skyMode != Hide;
				pbrIndirect.skyColor = false;
				pbrIndirect.skyMap = switch( skyMode ) {
				case Hide: null;
				case Env:
					pbrIndirect.skyHdrMax = env.hdrMax;
					pbrIndirect.gammaCorrect = true;
					env.env;
				case Specular:
					pbrIndirect.gammaCorrect = false;
					env.specular;
				case Irrad:
					pbrIndirect.gammaCorrect = false;
					env.diffuse;
				case Background:
					pbrIndirect.skyColor = true;
					pbrIndirect.skyColorValue.setColor(ctx.engine.backgroundColor);
					pbrIndirect.gammaCorrect = true;
					null;
				};
			case LightProbe:
				pbrIndirect.showSky = true;
				pbrIndirect.skyMap = env.env;
				pbrIndirect.gammaCorrect = false;
				pbrIndirect.skyHdrMax = env.hdrMax;
				pbrIndirect.skyColor = false;
			}

			if( pbrIndirect.skyMap == null && pbrIndirect.showSky && !pbrIndirect.skyColor )
				pbrIndirect.showSky = false;

		}
		else {
			pbrIndirect.drawIndirectDiffuse = false;
			pbrIndirect.drawIndirectSpecular = false;
		}

		tonemap.shader.mode = switch( toneMode ) {
			case Linear: 0;
			case Reinhard: 1;
			default: 0;
		};
		tonemap.shader.hdrTexture = textures.hdr;
	}

	function drawPbrDecals( passName : String ) {
		var passes = get(passName);
		if( passes.isEmpty() ) return;
		ctx.engine.pushTargets([textures.albedo,textures.normal,textures.pbr]);
		renderPass(decalsOutput, passes);
		ctx.engine.popTarget();
	}

	override function render() {
		beginPbr();

		setTargets([textures.albedo,textures.normal,textures.pbr,textures.other]);
		clear(0, 1, 0);

		begin(MainDraw);
		renderPass(output, get("terrain"));
		drawPbrDecals("terrainDecal");
		renderPass(output, get("default"), frontToBack);
		renderPass(output, get("alpha"), backToFront);
		renderPass(output, get("additive"));
		end();

		begin(Decals);
		drawPbrDecals("decal");
		end();

		setTarget(textures.hdr);
		clear(0);
		lighting();

		begin(Forward);
		var ls = hxd.impl.Api.downcast(getLightSystem(), h3d.scene.pbr.LightSystem);
		ls.forwardMode = true;
		draw("forward");
		ls.forwardMode = false;
		end();

		if( renderMode == LightProbe ) {
			resetTarget();
			copy(textures.hdr, null);
			// no warnings
			for( p in passObjects ) if( p != null ) p.rendered = true;
			return;
		}

		begin(BeforeTonemapping);
		draw("beforeTonemappingDecal");
		draw("beforeTonemapping");
		end();

		setTarget(textures.ldr);
		tonemap.render();

		begin(AfterTonemapping);
		draw("afterTonemappingDecal");
		draw("afterTonemapping");
		end();

		begin(Overlay);
		draw("overlay");
		end();

		endPbr();
	}

	function endPbr() {
		resetTarget();
		var ldr = ctx.getGlobal("ldrMap");
		switch( displayMode ) {
		case Pbr, Env, MatCap:
			if( enableFXAA ) {
				mark("FXAA");
				fxaa.apply(ldr);
			}
			else {
				copy(ldr, null);
			}
		case Debug:
			var shadowMap = ctx.getGlobal("mainLightShadowMap");
			if( shadowMap == null )
				shadowMap = h3d.mat.Texture.fromColor(0);
			slides.shader.shadowMap = shadowMap;
			slides.shader.shadowMapChannel = R;
			pbrProps.isScreen = true;
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
		mark("vsync");
	}

	var debugPushPos : { x : Float, y : Float }
	function onEvent(e:hxd.Event) {
		if( e.kind == EPush && e.button == 2 )
			debugPushPos = { x : e.relX, y : e.relY };
		if( e.kind == ERelease && e.button == 2 && hxd.Math.distance(e.relX-debugPushPos.x,e.relY-debugPushPos.y) < 10 ) {
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