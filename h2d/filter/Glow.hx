package h2d.filter;

/**
	Adds a glow backdrop to the filtered Object.
**/
class Glow extends Blur {

	/**
		The color of the glow.
	**/
	public var color : Int;
	/**
		Transparency value of the glow.
	**/
	public var alpha : Float;
	/**
		Subtracts the original image from the glow output when enabled.
	**/
	public var knockout : Bool;
	/**
		Produce gradient glow when enabled, otherwise creates hard glow without smoothing.
	**/
	public var smoothColor : Bool;

	/**
		Create new Glow filter.
		@param color The color of the glow.
		@param alpha Transparency value of the glow.
		@param radius The glow distance in pixels.
		@param gain The glow color intensity.
		@param quality The sample count on each pixel as a tradeoff of speed/quality.
		@param smoothColor Produce gradient glow when enabled, otherwise creates hard glow without smoothing.
	**/
	public function new( color : Int = 0xFFFFFF, alpha = 1., radius = 1., gain = 1., quality = 1., smoothColor = false ) {
		super(radius, gain, quality);
		this.color = color;
		this.alpha = alpha;
		this.smoothColor = smoothColor;
		pass.shader.hasFixedColor = true;
	}

	function setParams() {
		pass.shader.fixedColor.setColor(color);
		pass.shader.fixedColor.w = smoothColor ? alpha * 1.5 /* more accurate ramp */ : alpha;
		pass.shader.smoothFixedColor = smoothColor;
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		setParams();
		var tex = t.getTexture();
		var old = tex.filter;
		var save = ctx.textures.allocTileTarget("glowSave", t);
		h3d.pass.Copy.run(tex, save, None);
		tex.filter = Linear;
		pass.apply(ctx, tex);
		tex.filter = old;
		if( knockout )
			h3d.pass.Copy.run(save, tex, Erase);
		else
			h3d.pass.Copy.run(save, tex, Alpha);
		return t;
	}

}