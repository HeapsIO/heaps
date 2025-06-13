package h3d.scene.pbr;

enum abstract DisplayMode(String) {
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
	var Performance = "Performance";
}

enum abstract SkyMode(String) {
	var Hide = "Hide";
	var Env = "Env";
	var Specular = "Specular";
	var Irrad = "Irrad";
	var Background = "Background";
	var CustomColor = "CustomColor";
}

enum abstract TonemapMap(String) {
	var Linear = "Linear";
	var Reinhard = "Reinhard";
	var Filmic = "Filmic";
}

typedef RenderProps = {
	var mode : DisplayMode;
	var exposure : Float;
	var sky : SkyMode;
	var ?skyColor : Int;
	var tone : TonemapMap;
	var emissive : Float;
	var occlusion : Float;
	var ?a : Float;
	var ?b : Float;
	var ?c : Float;
	var ?d : Float;
	var ?e : Float;
	var ?forceDirectDiscard : Bool;
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

	public static final LIGHTMAP_STENCIL = 0x80;

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
	var enableFXAA = true;
	var currentStep : h3d.impl.RendererFX.Step;
	var performance = new h3d.pass.ScreenFx(new h3d.shader.pbr.PerformanceViewer());
	var indirectEnv = true;

	var textures = {
		albedo : (null:h3d.mat.Texture),
		normal : (null:h3d.mat.Texture),
		pbr : (null:h3d.mat.Texture),
		#if !MRT_low
		other : (null:h3d.mat.Texture),
		#end
		depth : (null:h3d.mat.Texture),
		hdr : (null:h3d.mat.Texture),
		ldr : (null:h3d.mat.Texture),
		velocity : (null:h3d.mat.Texture),
	};

	public var skyMode : SkyMode = Hide;
	public var toneMode : TonemapMap = Reinhard;
	public var displayMode : DisplayMode = Pbr;
	public var env : Environment;
	public var exposure(get,set) : Float;
	var debugShadowMapIndex = 1;

	#if editor
	var outline = new h3d.pass.ScreenFx(new hide.Renderer.ScreenOutline());
	var outlineBlur = new h3d.pass.Blur(4);
	#end

	static var ALPHA : hxsl.Output = Swiz(Value("output.color"),[W]);
	var output = new h3d.pass.Output("default",[
		Value("output.color"),
		Vec4([Value("output.normal",3),ALPHA]),
		#if !MRT_low
		Vec4([Value("output.metalness"), Value("output.roughness"), Value("output.occlusion"), ALPHA]),
		Vec4([Value("output.emissive"), Value("output.custom1"), Value("output.custom2"), ALPHA]),
		#else
		Vec4([Value("output.metalness"), Value("output.roughness"), Value("output.emissive"), ALPHA]),
		#end
		Vec4([Value("output.depth"),Const(0), Const(0), ALPHA /* ? */]),
		Vec4([Value("output.velocity", 2), Const(0), Const(0)])
	]);
	var decalsOutput = new h3d.pass.Output("decals",[
		Vec4([Swiz(Value("output.color"),[X,Y,Z]), Value("output.albedoStrength",1)]),
		Vec4([Value("output.normal",3), Value("output.normalStrength",1)]),
		#if !MRT_low
		Vec4([Value("output.metalness"), Value("output.roughness"), Value("output.occlusion"), Value("output.pbrStrength")]),
		Vec4([Value("output.emissive"), Value("output.custom1"), Value("output.custom2"), Value("output.emissiveStrength")])
		#else
		Vec4([Value("output.metalness"), Value("output.roughness"), Value("output.emissive"), Value("output.pbrStrength")])
		#end
	]);
	var colorDepthOutput = new h3d.pass.Output("colorDepth",[
		Value("output.color"),
		Vec4([Value("output.depth"),Const(0),Const(0),h3d.scene.pbr.Renderer.ALPHA])
	]);
	var colorDepthVelocityOutput = new h3d.pass.Output("colorDepthVelocityOutput",[
		Value("output.color"),
		Vec4([Value("output.depth"),Const(0),Const(0),h3d.scene.pbr.Renderer.ALPHA]),
		Vec4([Value("output.velocity", 2), Const(0), Const(0)])
	]);

	public function new(?env) {
		super();
		this.env = env;
		defaultPass = new h3d.pass.Output("color");
		slides.addShader(pbrProps);
		pbrOut.addShader(pbrIndirect);
		pbrOut.addShader(pbrProps);
		pbrOut.pass.setBlendMode(Add);
		pbrOut.pass.stencil = new h3d.mat.Stencil();
		pbrOut.pass.stencil.setOp(Keep, Keep, Keep);
		pbrOut.pass.stencil.setFunc(NotEqual, LIGHTMAP_STENCIL, LIGHTMAP_STENCIL, LIGHTMAP_STENCIL); // ignore already drawn volumetricLightMap areas
		allPasses.push(output);
		allPasses.push(defaultPass);
		allPasses.push(decalsOutput);
		allPasses.push(colorDepthOutput);
		allPasses.push(colorDepthVelocityOutput);
		allPasses.push(new h3d.pass.Shadows(null));
		refreshProps();
	}

	override function addShader(s:hxsl.Shader) {
		tonemap.addShader(s);
	}

	inline function get_exposure() return tonemap.shader.exposure;
	inline function set_exposure(v:Float) return tonemap.shader.exposure = v;

	override function getPassByName(name:String):h3d.pass.Output {
		switch( name ) {
		case "overlay", "beforeTonemapping", "beforeTonemappingAlpha", "albedo", "afterTonemapping", "forward", "forwardAlpha", "distortion":
			return defaultPass;
		case "default", "alpha", "additive":
			return output;
		case "decal":
			return decalsOutput;
		#if editor
		case "highlight", "highlightBack":
			return defaultPass;
		#end
		}
		return super.getPassByName(name);
	}

	override function startEffects() {
		processVolumetricEffects();
		super.startEffects();
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

	function renderPass(p:h3d.pass.Output, passes, ?sort) {
		cullPasses(passes, function(col) return col.inFrustum(ctx.camera.frustum));
		p.draw(passes, sort);
		passes.reset();
	}

	function lighting() {

		begin(Shadows);
		var ls = Std.downcast(getLightSystem(), h3d.scene.pbr.LightSystem);
		var count = ctx.engine.drawCalls;
		if( ls != null ) drawShadows(ls);
		if( ctx.lightSystem != null ) ctx.lightSystem.drawPasses = ctx.engine.drawCalls - count;
		end();

		if (ls != null) {
			while (ls.lightingShaders.length != 0)
				ls.lightingShaders.pop();
			ls.lightBuffer.sync(ctx);
		}

		begin(Lighting);
		if ( displayMode == Performance ) {
			var s = new h3d.shader.pbr.Light.Performance();
			performance.shader.gradient = getLightingPerformanceGradient();
			s.maxLights = performance.shader.gradient.width - 1;
			ls.lightingShaders.push(s);
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
		beforeFullScreenLights();
		if( ls != null ) {
			var count = ctx.engine.drawCalls;
			ls.drawScreenLights(this, lpass, shadows);
			ctx.lightSystem.drawPasses += ctx.engine.drawCalls - count;
		}
		afterFullScreenLights();
		// Direct Lighting - With Primitive
		pbrProps.isScreen = false;
		draw(pbrLightPass.name);

		if ( displayMode == Performance ) {
			var perf = allocTarget("performance", #if MRT_low RGB10A2 #else RGBA16F #end);
			h3d.pass.Copy.run(textures.hdr, perf);
			performance.shader.hdrMap = perf;
		}

		beforeIndirect();
		mark("Indirect Lighting");
		doIndirectLighting();
		afterIndirect();

		end();
	}

	function doIndirectLighting() {
		if( !renderLightProbes() && indirectEnv && env != null && env.power > 0.0 ) {
			pbrProps.isScreen = true;
			pbrIndirect.drawIndirectDiffuse = true;
			pbrIndirect.drawIndirectSpecular = true;
			pbrOut.render();
		}
	}

	function beforeIndirect() {}
	function afterIndirect() {}
	function beforeFullScreenLights() {}
	function afterFullScreenLights() {}

	function renderLightProbes() {
		var probePass = get("lightProbe");
		if( probePass.isEmpty() )
			return false;
		function probeSort( passes : h3d.pass.PassList ) {
			// Priority of the probe stored in _44 of AbsPos
			passes.sort( (po1, po2) -> return Std.int(po1.obj.getAbsPos()._44 - po2.obj.getAbsPos()._44) );
		}

		// Probe Rendering & Blending
		var probeOutput = allocTarget("probeOutput", true, 1.0, #if MRT_low RGB10A2 #else RGBA16F #end);
		ctx.engine.pushTarget(probeOutput);
		clear(0);

		// Default Env & SkyBox
		if( indirectEnv && env != null && env.power > 0.0 ) {
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
		while( light != null ) {
			var plight = Std.downcast(light, h3d.scene.pbr.Light);
			if( plight != null ) {
				if( !shadows ) passes.clear();
				ls.drawShadows(plight, passes);
			}
			light = light.next;
		}
	}

	function begin( step : h3d.impl.RendererFX.Step ) {
		var stepName = switch (step) {
		case Custom(n):
			n;
		default:
			step.getName();
		}
		mark(stepName);

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

		mark(stepName);
	}

	function renderEditorOutline() {
		#if editor
		if (showEditorGuides) {
			renderPass(defaultPass, get("debuggeom"), backToFront);
			renderPass(defaultPass, get("debuggeom_alpha"), backToFront);
		}

		if (showEditorOutlines) {
			var outlineTex = allocTarget("outline", true);
			ctx.engine.pushTarget(outlineTex);
			clear(0);
			draw("highlightBack");
			draw("highlight");
			ctx.engine.popTarget();
			var outlineBlurTex = allocTarget("outlineBlur", false);
			outline.pass.setBlendMode(Alpha);
			outlineBlur.apply(ctx, outlineTex, outlineBlurTex);
			outline.shader.texture = outlineBlurTex;
			outline.render();
		}
		#end
	}

	function renderEditorOverlay() {
		#if editor
		renderPass(defaultPass, get("overlay"), backToFront);
		renderPass(defaultPass, get("ui"), backToFront);
		#end
	}

	function end() {
		#if editor
			switch( currentStep ) {
				case MainDraw:
				case BeforeTonemapping:
					renderEditorOutline();
				case Overlay:
					renderEditorOverlay();
				default:
			}
		#end

		for( f in effects )
			if( f.enabled )
				f.end(this, currentStep);
		currentStep = null;
	}

	override function computeStatic() {
		var light = @:privateAccess ctx.lights;
		var passes = get("shadow");
		if (!shadows)
			passes.clear();
		while( light != null ) {
			var plight = Std.downcast(light, h3d.scene.pbr.Light);
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
		textures.normal = allocTarget("normal", true, 1., #if MRT_low RGB10A2 #else RGBA16F #end);
		textures.pbr = allocTarget("pbr", true, 1.);
		#if !MRT_low
		textures.other = allocTarget("other", true, 1., RGBA16F);
		#end
		textures.depth = allocTarget("depth", true, 1., R32F);
		textures.hdr = allocTarget("hdrOutput", true, 1, #if MRT_low RGB10A2 #else RGBA16F #end);
		textures.ldr = allocTarget("ldrOutput");
		if ( ctx.computeVelocity )
			textures.velocity = allocTarget("velocity", true, 1., RG16F );
	}

	public function getPbrDepth() {
		return textures.depth;
	}

	function initGlobals() {
		ctx.setGlobal("albedoMap", { texture : textures.albedo, channel : hxsl.Channel.R });
		ctx.setGlobal("depthMap", { texture : getPbrDepth(), channel : hxsl.Channel.R });
		ctx.setGlobal("normalMap", { texture : textures.normal, channel : hxsl.Channel.R });
		ctx.setGlobal("occlusionMap", { texture : textures.pbr, channel : hxsl.Channel.B });
		ctx.setGlobal("hdrMap", textures.hdr);
		ctx.setGlobal("ldrMap", textures.ldr);
		ctx.setGlobal("velocity", textures.velocity);
		ctx.setGlobal("global.time", ctx.time);
		ctx.setGlobal("camera.position", ctx.camera.pos);
		ctx.setGlobal("camera.inverseViewProj", ctx.camera.getInverseViewProj());
		ctx.setGlobal("camera.inverseView", ctx.camera.getInverseView());
	}

	function beginPbr() {
		var props : RenderProps = props;
		// reset tonemap shaders
		var s = @:privateAccess tonemap.pass.shaders;
		while( s != null ) {
			if( s.s != tonemap.shader ) tonemap.removeShader(s.s);
			s = s.next;
		}

		initTextures();
		initGlobals();

		pbrProps.albedoTex = textures.albedo;
		pbrProps.normalTex = textures.normal;
		pbrProps.pbrTex = textures.pbr;
		pbrProps.depthTex = getPbrDepth();
		#if !MRT_low
		pbrProps.otherTex = textures.other;
		#end
		pbrProps.cameraInverseViewProj = ctx.camera.getInverseViewProj();
		pbrProps.occlusionPower = props.occlusion * props.occlusion;

		pbrDirect.cameraPosition.load(ctx.camera.pos);

		if( env != null ) {
			pbrIndirect.cameraPosition.load(ctx.camera.pos);
			pbrIndirect.emissivePower = props.emissive * props.emissive;
			pbrIndirect.irrRotation.set(Math.cos(env.rotation), Math.sin(env.rotation));
			pbrIndirect.irrPower = env.power * env.power;
			pbrIndirect.irrLut = env.lut;
			pbrIndirect.irrDiffuse = env.diffuse;
			pbrIndirect.irrSpecular = env.specular;
			pbrIndirect.irrSpecularLevels = env.specLevels;
			pbrIndirect.cameraInvViewProj.load(ctx.camera.getInverseViewProj());
			pbrIndirect.skyHdrMax = 1.0;
			pbrIndirect.drawIndirectDiffuse = true;
			pbrIndirect.drawIndirectSpecular = true;

			pbrDirect.doDiscard = props.forceDirectDiscard ?? false;
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
				case CustomColor:
					pbrIndirect.skyColor = true;
					pbrIndirect.skyColorValue.setColor(props.skyColor);
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
			case Filmic: 2;
			default: 0;
		};
		if ( toneMode == Filmic ) {
			tonemap.shader.a = props.a;
			tonemap.shader.b = props.b;
			tonemap.shader.c = props.c;
			tonemap.shader.d = props.d;
			tonemap.shader.e = props.e;
		}
		tonemap.shader.hdrTexture = textures.hdr;
	}

	function drawPbrDecals( passName : String ) {
		var passes = get(passName);
		if( passes.isEmpty() ) return;
		ctx.engine.pushTargets([textures.albedo,textures.normal,textures.pbr]);
		renderPass(decalsOutput, passes);
		ctx.engine.popTarget();
	}

	function getPbrRenderTargets( depth : Bool ) {
		var targets = [textures.albedo, textures.normal, textures.pbr #if !MRT_low , textures.other #end];
		if ( depth )
			targets.push(getPbrDepth());
		if ( ctx.computeVelocity )
			targets.push(textures.velocity);
		return targets;
	}

	override function render() {
		beginPbr();
		setTarget(textures.depth);
		ctx.engine.clearF(new h3d.Vector4(1));

		setTargets(getPbrRenderTargets(false));
		clear(0, 1, 0);

		setTargets(getPbrRenderTargets(true));

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
		var ls = Std.downcast(getLightSystem(), h3d.scene.pbr.LightSystem);
		ls.forwardMode = true;
		setTargets([textures.hdr, getPbrDepth()]);
		renderPass(colorDepthOutput, get("forward"));
		setTarget(textures.hdr);
		renderPass(defaultPass, get("forwardAlpha"), backToFront);
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
			var defaultShadows : h3d.mat.Texture = ctx.getGlobal("mainLightShadowMap");
			var prev = slides.shader.shadowMap;
			var shadowMap = defaultShadows;
			if( debugShadowMapIndex < 0 )
				debugShadowMapIndex = 0;
			if( debugShadowMapIndex > 0 ) @:privateAccess {
				var k = debugShadowMapIndex;
				var l = ctx.lights;
				while( l != null && k > 0 ) {
					var pl = Std.downcast(l, Light);
					if( pl != null && pl.shadows != null ) {
						var cl = Std.downcast(pl.shadows, h3d.pass.CascadeShadowMap);
						if ( cl != null ) {
							for ( tex in cl.getShadowTextures() ) {
								if ( tex != null && tex != defaultShadows ) {
									k--;
									shadowMap = tex;
									if ( k == 0 ) break;
								}
							}
							if ( k == 0 ) break;
						} else {
							var tex = pl.shadows.getShadowTex();
							if( tex != null && tex != defaultShadows ) {
								k--;
								shadowMap = tex;
								if( k == 0 ) break;
							}
						}
					}
					l = l.next;
				}
				if( k > 0 )
					debugShadowMapIndex -= k;
				#if hl
				if( l != null && shadowMap != prev ) Sys.println("Debug light : " + l.name);
				#end
			}
			if( shadowMap == null )
				shadowMap = h3d.mat.Texture.fromColor(0);
			slides.shader.shadowMap = shadowMap;
			slides.shader.shadowMapCube = shadowMap;
			slides.shader.shadowIsCube = shadowMap.flags.has(Cube);
			slides.shader.shadowMapChannel = R;
			slides.shader.HAS_VELOCITY = textures.velocity != null;
			slides.shader.velocity = textures.velocity;
			pbrProps.isScreen = true;
			slides.render();
			if( !debugging ) {
				debugging = true;
				hxd.Window.getInstance().addEventTarget(onEvent);
			}
			renderEditorOutline();
			renderEditorOverlay();
		case Performance:
			if( enableFXAA ) {
				mark("FXAA");
				fxaa.apply(ldr);
			} else
				copy(ldr, null);
			performance.render();
			renderEditorOutline();
			renderEditorOverlay();
		}
		if( debugging && displayMode != Debug ) {
			debugging = false;
			hxd.Window.getInstance().removeEventTarget(onEvent);
		}
		mark("vsync");
		removeVolumetricEffects();
	}

	var debugPushPos : { x : Float, y : Float }
	function onEvent(e:hxd.Event) {
		if( e.kind == EPush && e.button == 2 )
			debugPushPos = { x : e.relX, y : e.relY };
		var win = hxd.Window.getInstance();

		if( e.kind == ERelease && e.button == 2 && hxd.Math.distance(e.relX-debugPushPos.x,e.relY-debugPushPos.y) < 10 ) {
			var x = Std.int((e.relX / win.width) * 3);
			var y = Std.int((e.relY / win.height) * 3);
			if( slides.shader.mode != Full ) {
				slides.shader.mode = Full;
			} else {
				var a : Array<h3d.shader.pbr.Slides.DebugMode>;
				if( y == 0 )
					a = [Albedo,Normal,Depth];
				else if ( y == 1 )
					a = [Metalness,Roughness,AO];
				else
					a = [Emissive,Shadow,Velocity];
				slides.shader.mode = a[x];
			}
		}
		if( e.kind == EWheel && (slides.shader.mode == Shadow || (slides.shader.mode == Full && e.relX > win.width/3 && e.relY > win.height/3)) )
			debugShadowMapIndex += e.wheelDelta > 0 ? 1 : -1;
	}

	function getLightingPerformanceGradient() {
		var g : h3d.mat.Texture = @:privateAccess ctx.engine.resCache.get("lighting_performance_gradient");
		if ( g != null )
			return g;
		g = hxd.res.Embed.getResource("h3d/scene/pbr/lighting_performance_gradient.png").toImage().toTexture();
		@:privateAccess ctx.engine.resCache.set("lighting_performance_gradient", g);
		g.filter = Nearest;
		return g;
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
			a : 2.51,
			b : 0.03,
			c : 2.43,
			d : 0.59,
			e : 0.14,
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
						<option value="Performance">Performance</option>
					</select>
				</dd>

				<div class="group" name="Tone Mapping">
					<dt>Tone</dt>
					<dd>
						<select field="tone">
							<option value="Linear">Linear</option>
							<option value="Reinhard">Reinhard</option>
							<option value="Filmic">Filmic</option>
						</select>
					</dd>
					<dt>Filmic a</dt><dd><input type="range" min="0" max="5" field="a"></dd>
					<dt>Filmic b</dt><dd><input type="range" min="0" max="2" field="b"></dd>
					<dt>Filmic c</dt><dd><input type="range" min="0" max="5" field="c"></dd>
					<dt>Filmic d</dt><dd><input type="range" min="0" max="5" field="d"></dd>
					<dt>Filmic e</dt><dd><input type="range" min="0" max="0.5" field="e"></dd>

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
								<option value="CustomColor">Custom Color</option>
							</select>
						</dd>
						'+(skyMode==CustomColor?'<dt>Sky Color</dt><dd><input type="color" field="skyColor"/></dd>':'')+'
					<dt>Force direct discard</dt><dd><input type="checkbox" field="forceDirectDiscard"></dd>
				</div>

				<div class="group" name="Params">
					<dt>Emissive</dt><dd><input type="range" min="0" max="2" field="emissive"></dd>
					<dt>Occlusion</dt><dd><input type="range" min="0" max="2" field="occlusion"></dd>
					<dt>Exposure</dt><dd><input type="range" min="-3" max="3" field="exposure"></dd>
				</div>
			</dl>
			</div>
		');
	}
	#end
}