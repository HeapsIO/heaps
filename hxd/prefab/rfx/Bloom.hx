package hxd.prefab.rfx;

typedef BloomProps = {
	var size : Float;
	var threshold : Float;
	var intensity : Float;
	var blur : Float;
}

class Bloom extends RendererFX {

	var bloomPass = new h3d.pass.ScreenFx(new h3d.shader.pbr.Bloom());
	var bloomBlur = new h3d.pass.Blur();

	public function new(?parent) {
		super(parent);
		props = ({
			size : 0.5,
			blur : 3,
			intensity : 1.,
			threshold : 0.5,
		} : BloomProps);
	}

	override function apply(ctx:h3d.scene.RenderContext, step:hxd.prefab.rfx.RendererFX.Step) {
		if( step == AfterHdr ) {
			var pb : BloomProps = props;
			var bloom = ctx.textures.allocTargetScale("bloom", pb.size, false, RGBA16F);
			ctx.engine.pushTarget(bloom);
			bloomPass.shader.hdr = ctx.getGlobal("hdr");
			bloomPass.shader.threshold = pb.threshold;
			bloomPass.shader.intensity = pb.intensity;
			bloomPass.render();
			ctx.engine.popTarget();

			bloomBlur.radius = pb.blur;
			bloomBlur.apply(ctx, bloom);
			ctx.setGlobal("bloom",bloom);
		}
	}

	#if editor
	override function edit( ctx : hide.prefab.EditContext ) {
		ctx.properties.add(new hide.Element('
			<dl>
			<dt>Intensity</dt><dd><input type="range" min="0" max="2" field="intensity"/></dd>
			<dt>Threshold</dt><dd><input type="range" min="0" max="1" field="threshold"/></dd>
			<dt>Size</dt><dd><input type="range" min="0" max="1" field="size"/></dd>
			<dt>Blur</dt><dd><input type="range" min="0" max="20" field="blur"/></dd>
			</dl>
		'),props);
	}
	#end

	static var _ = Library.register("rfx.bloom", Bloom);

}