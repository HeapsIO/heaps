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
			var alpha = smoothAlpha ? k.a : float(k.a>0);
			output.color = color * alpha;
		}

	};

}

/**
	Performs an arbitrary shape masking of the filtered Object.

	@see `AbstractMask`
**/
class Mask extends AbstractMask {

	var pass : h3d.pass.ScreenFx<MaskShader>;
	/**
		Enables masking Object alpha merging. Otherwise causes unsmoothed masking of non-zero alpha areas.
	**/
	public var smoothAlpha(get, set) : Bool;

	/**
		Create new Mask filter.
		@param mask An `Object` that will be used for masking. See `AbstractMask.mask` for limitations.
		@param maskVisible When enabled, masking `Object` will be visible. Hidden otherwise.
		@param smoothAlpha Enables masking Object alpha merging. Otherwise causes unsmoothed masking of non-zero alpha areas.
	**/
	public function new(mask, maskVisible=false, smoothAlpha=false) {
		super(mask);
		pass = new h3d.pass.ScreenFx(new MaskShader());
		this.maskVisible = maskVisible;
		this.smoothAlpha = smoothAlpha;
	}

	function get_smoothAlpha() return pass.shader.smoothAlpha;
	function set_smoothAlpha(v) return pass.shader.smoothAlpha = v;

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var mask = getMaskTexture(ctx, t);
		if( mask == null ) {
			if( this.mask == null ) throw "Mask filter has no mask object";
			return null;
		}
		var out = ctx.textures.allocTileTarget("maskTmp", t);
		ctx.engine.pushTarget(out);
		pass.shader.texture = t.getTexture();
		pass.shader.mask = getMaskTexture(ctx, t);
		pass.shader.maskMatA.set(maskMatrix.a, maskMatrix.c, maskMatrix.x);
		pass.shader.maskMatB.set(maskMatrix.b, maskMatrix.d, maskMatrix.y);
		pass.render();
		ctx.engine.popTarget();
		return h2d.Tile.fromTexture(out);
	}


}