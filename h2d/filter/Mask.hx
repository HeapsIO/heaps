package h2d.filter;

private class MaskShader extends h3d.shader.ScreenShader {

	static var SRC = {

		@param var texture : Sampler2D;
		@param var mask : Sampler2D;
		@param var maskMatA : Vec3;
		@param var maskMatB : Vec3;
		@const var smoothAlpha : Bool;

		function fragment() {
			var color = texture.get(input.uv);
			var uv = vec3(input.uv, 1);
			var k = mask.get( vec2(uv.dot(maskMatA), uv.dot(maskMatB)) );
			output.color = vec4(color.rgb, color.a * (smoothAlpha ? k.a : float(k.a>0)));
		}

	};

}


class Mask extends AbstractMask {

	var pass : h3d.pass.ScreenFx<MaskShader>;
	public var smoothAlpha(get, set) : Bool;

	public function new(mask, maskVisible=false, smoothAlpha=false) {
		super(mask);
		pass = new h3d.pass.ScreenFx(new MaskShader());
		this.maskVisible = maskVisible;
		this.smoothAlpha = smoothAlpha;
	}

	function get_smoothAlpha() return pass.shader.smoothAlpha;
	function set_smoothAlpha(v) return pass.shader.smoothAlpha = v;

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var mask = getMaskTexture(t);
		if( mask == null )
			throw "Mask should be rendered before masked object";
		var out = ctx.textures.allocTarget("maskTmp", t.width, t.height, false);
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