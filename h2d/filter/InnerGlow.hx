package h2d.filter;

private class GlowShader extends h3d.shader.ScreenShader {
	static var SRC = {

		@param var texture : Sampler2D;
		@param var color : Vec3;

		function fragment() {
			var a = texture.get(input.uv).a;
			output.color = vec4(color, 1-a);
		}
	};
}

private class GlowBlendShader extends h3d.shader.ScreenShader {
	static var SRC = {

		@param var srcTex : Sampler2D;
		@param var glowTex : Sampler2D;
		@param var alpha : Float;

		function fragment() {
			var src = srcTex.get(input.uv);
			var glow = glowTex.get(input.uv);
			var color = mix(src, glow, alpha);
			output.color = vec4(color.rgb * src.a, src.a);
		}
	};
}

/**
	Adds a glow backdrop to the filtered Object.
**/
class InnerGlow extends Blur {

	public var color : Int;
	public var alpha : Float;
	public var blendMode : BlendMode = Alpha;

	/**
		Create new Glow filter.
		@param color The color of the glow.
		@param alpha Transparency value of the glow.
		@param radius The glow distance in pixels.
		@param gain The glow color intensity.
		@param quality The sample count on each pixel as a tradeoff of speed/quality.
	**/

	var glowPass = new h3d.pass.ScreenFx<GlowShader>(new GlowShader());
	var blendPass = new h3d.pass.ScreenFx<GlowBlendShader>(new GlowBlendShader());

	public function new( color : Int = 0xFFFFFF, alpha = 1., radius = 1., gain = 1., quality = 1. ) {
		super(radius, gain, quality);
		this.color = color;
		this.alpha = alpha;
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var tex = t.getTexture();
		var glowMaskTex = ctx.textures.allocTileTarget("innerGlowMask", t);
		glowPass.shader.color.setColor(color);
		glowPass.shader.texture = tex;
		ctx.engine.pushTarget(glowMaskTex);
		glowPass.render();
		ctx.engine.popTarget();

		pass.apply(ctx, glowMaskTex);

		var blended = ctx.textures.allocTileTarget("innerGlowBlended", t);
		h3d.pass.Copy.run(tex, blended, None);
		h3d.pass.Copy.run(glowMaskTex, blended, blendMode);
		
		blendPass.shader.alpha = alpha;
		blendPass.shader.srcTex = tex;
		blendPass.shader.glowTex = blended;
		ctx.engine.pushTarget(tex);
		blendPass.render();
		ctx.engine.popTarget();
		return t;
	}

}