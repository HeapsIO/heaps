package h2d.filter;

private class MaskShader extends h3d.shader.ScreenShader {

	static var SRC = {

		@param var texture : Sampler2D;
		@param var mask : Sampler2D;
		@param var maskMatA : Vec3;
		@param var maskMatB : Vec3;

		function fragment() {
			var color = texture.get(input.uv);
			var uv = vec3(input.uv, 1);
			var k = mask.get( vec2(uv.dot(maskMatA), uv.dot(maskMatB)) );
			output.color = vec4(color.rgb, color.a * k.a);
		}

	};

}


class Mask extends AbstractMask {

	var pass : h3d.pass.ScreenFx<MaskShader>;

	public function new(mask, maskVisible=false) {
		super(mask);
		pass = new h3d.pass.ScreenFx(new MaskShader());
		this.maskVisible = maskVisible;
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var out = ctx.textures.allocTarget("maskTmp", ctx, t.width, t.height, false);
		ctx.engine.pushTarget(out);
		pass.shader.texture = t.getTexture();
		pass.shader.mask = getMaskTexture(t);
		pass.shader.maskMatA.set(maskMatrix.a, maskMatrix.c, maskMatrix.x);
		pass.shader.maskMatB.set(maskMatrix.b, maskMatrix.d, maskMatrix.y);
		pass.render();
		ctx.engine.popTarget();
		return h2d.Tile.fromTexture(out);
	}


}