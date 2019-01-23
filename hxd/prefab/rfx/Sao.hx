package hxd.prefab.rfx;

typedef SaoProps = {
	var size : Float;
	var blur : Float;
	var samples : Int;
	var radius : Float;
	var intensity : Float;
	var bias : Float;
	var microIntensity : Float;
	var useWorldUV : Bool;
}

class Sao extends RendererFX {

	var sao : h3d.pass.ScalableAO;
	var saoBlur = new h3d.pass.Blur();
	var saoCopy = new h3d.pass.Copy();

	public function new(?parent) {
		super(parent);
		props = ({
			size : 1,
			blur : 5,
			samples : 30,
			radius : 1,
			intensity : 1,
			bias : 0.1,
			microIntensity : 1.0,
			useWorldUV : false,
		} : SaoProps);
	}

	override function apply( r : h3d.scene.Renderer, step : RendererFX.Step ) {
		if( step == BeforeHdr ) {
			if( sao == null ) sao = new h3d.pass.ScalableAO();
			var props : SaoProps = props;
			var ctx = r.ctx;
			var saoTex = r.allocTarget("sao",false, props.size);
			var microOcclusion = r.allocTarget("sao",false, props.size);
			var normal : hxsl.ChannelTexture = ctx.getGlobal("normalMap");
			var depth : hxsl.ChannelTexture = ctx.getGlobal("depthMap");
			var occlu : hxsl.ChannelTexture = ctx.getGlobal("occlusionMap");
			ctx.engine.pushTarget(saoTex);
			sao.shader.numSamples = props.samples;
			sao.shader.sampleRadius	= props.radius;
			sao.shader.intensity = props.intensity;
			sao.shader.bias = props.bias * props.bias;
			sao.shader.depthTextureChannel = depth.channel;
			sao.shader.normalTextureChannel = normal.channel;
			sao.shader.useWorldUV = props.useWorldUV;
			sao.shader.microOcclusion = occlu.texture;
			sao.shader.microOcclusionChannel = occlu.channel;
			sao.shader.microOcclusionIntensity = props.microIntensity;
			sao.apply(depth.texture,normal.texture,ctx.camera);
			ctx.engine.popTarget();

			saoBlur.radius = props.blur;
			saoBlur.quality = 0.5;
			saoBlur.apply(ctx, saoTex);

			saoCopy.pass.setColorChannel(occlu.channel);
			saoCopy.apply(saoTex, occlu.texture);
		}
	}

	#if editor
	override function edit( ctx : hide.prefab.EditContext ) {
		ctx.properties.add(new hide.Element('
			<dl>
			<dt>Intensity</dt><dd><input type="range" min="0" max="10" field="intensity"/></dd>
			<dt>Radius</dt><dd><input type="range" min="0" max="10" field="radius"/></dd>
			<dt>Bias</dt><dd><input type="range" min="0" max="0.5" field="bias"/></dd>
			<dt>Size</dt><dd><input type="range" min="0" max="1" field="size"/></dd>
			<dt>Blur</dt><dd><input type="range" min="0" max="20" field="blur"/></dd>
			<dt>Samples</dt><dd><input type="range" min="3" max="256" field="samples" step="1"/></dd>
			<dt>Micro Intensity</dt><dd><input type="range" min="0" max="1" field="microIntensity"/></dd>
			<dt>Use World UV</dt><dd><input type="checkbox" field="useWorldUV"/></dd>
			</dl>
		'),props);
	}
	#end

	static var _ = Library.register("rfx.sao", Sao);

}
