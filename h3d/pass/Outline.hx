package h3d.pass;

@ignore("shader")
class Outline extends ScreenFx<h3d.shader.Outline2D> {
	public var size : Float;
	public var color : Int;
	public var alpha : Float = 1.;
	public var quality : Float;
	public var multiplyAlpha : Bool;

	public function new(size = 4.0, color = 0x000000, quality = 0.3, multiplyAlpha = true) {
		super(new h3d.shader.Outline2D());
		this.size = size;
		this.color = color;
		this.quality = quality;
		this.multiplyAlpha = multiplyAlpha;
	}

	public function apply(ctx : h3d.impl.RenderContext, src : h3d.mat.Texture, ?output : h3d.mat.Texture) {
		if (output == null)
			output = src;
		var tmp = ctx.textures.allocTarget(src.name + "OutlineTmp", src.width, src.height, false, src.format);
		shader.color.setColor(color);
		shader.color.a = alpha;
		shader.size.set(size / src.width, size / src.height);
		shader.samples = Std.int(Math.max(quality * 100, 1));
		shader.multiplyAlpha = multiplyAlpha ? 0 : 1;

		shader.texture = src;
		engine.pushTarget(tmp);
		render();
		engine.popTarget();

		shader.texture = tmp;
		var outDepth = output.depthBuffer;
		output.depthBuffer = null;
		engine.pushTarget(output);
		render();
		engine.popTarget();
		output.depthBuffer = outDepth;
	}

}
