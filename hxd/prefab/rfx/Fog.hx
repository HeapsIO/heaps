package hxd.prefab.rfx;

typedef FogProps = {
	var density : Float;
	var fadeStrength : Float;
	var height : Float;
	var range : Float;
	var stepCount : Int;
	var color : Int;
	var tilling : Float;
	var speed : Float;
	var direction : Float;

	var turbulenceText : String;
	var turbulenceScale : Float;
	var turbulenceIntensity : Float;
	var turbulenceSpeed  : Float;

	var fadingSpeed  : Float;
}

class Fog extends RendererFX {

	var fogPass = new h3d.pass.ScreenFx(new h3d.shader.pbr.Fog());
	var fogClear = new h3d.pass.ScreenFx(new h3d.shader.pbr.Fog.FogClear());
	var fogTurbulence : h3d.mat.Texture;
	var fogTexture : h3d.mat.Texture;
	var fogOcclusion : h3d.mat.Texture;
	var prevfogOcclusion : h3d.mat.Texture;
	var prevCamMat : h3d.Matrix;

	public function new(?parent) {
		super(parent);

		fogPass.pass.setBlendMode(Alpha);

		props = ({
				density : 1.0,
				fadeStrength : 1.0,
				height : 0,
				range : 10,
				stepCount : 10,
				tilling : 1.0,
				speed : 0.0,
				direction : 0.0,

				turbulenceText : null,
				turbulenceScale: 0.0,
				turbulenceIntensity : 0.0,
				turbulenceSpeed : 0.0,

				fadingSpeed : 1.0,

				color : 0xFFFFFF,
			} : FogProps);
	}

	override function apply( r : h3d.scene.Renderer, step : RendererFX.Step ) {
		var ctx = r.ctx;
		var props : FogProps = props;

		if( fogOcclusion == null ) fogOcclusion = new h3d.mat.Texture(ctx.engine.width, ctx.engine.height, [Target], RGBA);
		if( prevfogOcclusion == null ) prevfogOcclusion = new h3d.mat.Texture(ctx.engine.width, ctx.engine.height, [Target], RGBA);

		if(fogOcclusion.width != ctx.engine.width || fogOcclusion.height != ctx.engine.height){
			fogOcclusion.dispose();
			fogOcclusion = new h3d.mat.Texture(ctx.engine.width, ctx.engine.height, [Target], RGBA);
		}

		if(prevfogOcclusion.width != ctx.engine.width || prevfogOcclusion.height != ctx.engine.height){
			prevfogOcclusion.dispose();
			prevfogOcclusion = new h3d.mat.Texture(ctx.engine.width, ctx.engine.height, [Target], RGBA);
		}

		if( fogTexture == null ) syncFogTexture();

		if( props.turbulenceText != null && (fogTurbulence == null || props.turbulenceText != fogTurbulence.name)) {
			var prev = fogTurbulence;
			fogTurbulence = hxd.res.Loader.currentInstance.load(props.turbulenceText).toTexture();
			fogTurbulence.wrap = Repeat;
			if(prev != null) prev.dispose();
		}

		if( step == AfterHdr ) {

			var depth : hxsl.ChannelTexture = ctx.getGlobal("depthMap");

			// Draw Fog Occluders
			ctx.setGlobal("fogHeight", props.height);
			ctx.setGlobal("fogRange", props.range);
			fogPass.setGlobals(ctx);
			fogOcclusion.depthBuffer = ctx.engine.driver.getDefaultDepthBuffer();
			ctx.engine.pushTarget(fogOcclusion);
			fogClear.shader.dt = ctx.elapsedTime;
			fogClear.shader.fadingSpeed = props.fadingSpeed;
			fogClear.shader.prevCamMat = prevCamMat == null ? ctx.camera.m : prevCamMat;
			fogClear.shader.cameraInverseViewProj = ctx.camera.getInverseViewProj();
			fogClear.shader.prevfogOcclusion = prevfogOcclusion;
			fogClear.shader.depthTexture = depth.texture;
			fogClear.shader.depthTextureChannel = depth.channel;
			fogClear.render();
			r.draw("fogOccluder");
			ctx.engine.popTarget();

			// Draw Fog
			fogPass.shader.fogOcclusion = fogOcclusion;
			fogPass.shader.depthTexture = depth.texture;
			fogPass.shader.depthTextureChannel = depth.channel;
			fogPass.shader.cameraPos = ctx.camera.pos;
			fogPass.shader.cameraInverseViewProj.load(ctx.camera.getInverseViewProj());
			fogPass.shader.density = props.density;
			fogPass.shader.fadeStrength = props.fadeStrength;
			fogPass.shader.maxStepCount = props.stepCount;
			fogPass.shader.tilling = new h3d.Vector(props.tilling, props.tilling);
			fogPass.shader.speed = new h3d.Vector(Math.cos(Math.degToRad(props.direction)) * props.speed, Math.sin(Math.degToRad(props.direction)) * props.speed);
			fogPass.shader.turbulenceSpeed = new h3d.Vector(props.turbulenceSpeed / 10.0, props.turbulenceSpeed / 10.0);
			fogPass.shader.time = ctx.time;
			fogPass.shader.texture = fogTexture == null ? h3d.mat.Texture.fromColor(0xFFFFFF) : fogTexture;
			fogPass.shader.turbulenceText = fogTurbulence == null ? h3d.mat.Texture.fromColor(0xFFFFFF) : fogTurbulence;
			fogPass.shader.turbulenceScale = props.turbulenceScale;
			fogPass.shader.turbulenceIntensity = props.turbulenceIntensity;
			fogPass.shader.color = h3d.Vector.fromColor(props.color);
			fogPass.render();

			var temp = prevfogOcclusion;
			prevfogOcclusion = fogOcclusion;
			fogOcclusion = temp;
			prevCamMat = ctx.camera.m.clone();
		}
	}


	function syncFogTexture() {
		if( fogTexture != null ) fogTexture.dispose();
		var c = Std.instance(this.children[0], hide.prefab.Noise);
		fogTexture = c == null ? h3d.mat.Texture.fromColor(0x808080,0.5) : c.toTexture();
		fogTexture.wrap = Repeat;
	}

	#if editor

	override function getHideProps() {
		var p = super.getHideProps();
		p.allowChildren = function(name) return name == "noise";
		p.onChildUpdate = function(p) syncFogTexture();
		return p;
	}

	override function edit( ctx : hide.prefab.EditContext ) {
		var props : FogProps = props;
		ctx.properties.add(new hide.Element('
			<dl>

			<div class="group" name="Fog">
				<dt>Color</dt><dd><input type="color" field="color"></dd>
				<dt>Tilling</dt><dd><input type="range" min="1" max="100" field="tilling"></dd>
				<dt>Density</dt><dd><input type="range" min="0" max="2" field="density"></dd>
				<dt>Height</dt><dd><input type="range" min="-20" max="20" field="height"></dd>
				<dt>Range</dt><dd><input type="range" min="1" max="10" field="range"></dd>
				<dt>Fade Strength</dt><dd><input type="range" min="0" max="1" field="fadeStrength"></dd>
				<dt>Speed</dt><dd><input type="range" min="0" max="10" field="speed"></dd>
				<dt>Direction</dt><dd><input type="range" min="0" max="360" step ="0.1" field="direction"></dd>
			</div>

			<div class="group" name="Quality">
				<dt>Step Count</dt><dd><input type="range" min="1" max="100" step="1" field="stepCount"></dd>
			</div>

			<div class="group" name="Turbulence">
				<dt>Texture</dt><input type="texturepath" field="turbulenceText"/>
				<dt>Scale</dt><dd><input type="range" min="0" max="1" field="turbulenceScale"></dd>
				<dt>Speed</dt><dd><input type="range" min="0" max="10" field="turbulenceSpeed"></dd>
				<dt>Intensity</dt><dd><input type="range" min="0" max="1" field="turbulenceIntensity"></dd>
			</div>

			<div class="group" name="Trail">
				<dt>Fading Speed</dt><dd><input type="range" min="0" max="2" field="fadingSpeed"></dd>
			</div>

			</dt>
		'),props, function(pname) {
			if(pname == "turbulenceText") {
				if(fogTurbulence != null) fogTurbulence.dispose();
				fogTurbulence = ctx.rootContext.loadTexture(props.turbulenceText);
				fogTurbulence.wrap = Repeat;
			}
		});
	}
	#end

	static var _ = Library.register("rfx.fog", Fog);

}
