package h2d.filter;

class Glow extends Blur {

	public var color : Int;
	public var alpha : Float;
	public var knockout : Bool;
	public var smoothColor : Bool;

	public function new( color : Int = 0xFFFFFF, alpha = 1., quality = 1, passes = 1, sigma = 1., smoothColor = false ) {
		super(quality, passes, sigma);
		this.color = color;
		this.alpha = alpha;
		this.smoothColor = smoothColor;
		pass.shader.hasFixedColor = true;
	}

	function setParams() {
		pass.shader.fixedColor.setColor(color);
		pass.shader.fixedColor.w = alpha;
		pass.shader.smoothFixedColor = smoothColor;
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		setParams();
		var save = ctx.textures.allocTarget("glowSave", ctx, t.width, t.height, false);
		h3d.pass.Copy.run(t.getTexture(), save, None);
		pass.apply(t.getTexture(), ctx.textures.allocTarget("glowTmp", ctx, t.width, t.height, false));
		if( knockout )
			h3d.pass.Copy.run(save, t.getTexture(), Erase);
		else
			h3d.pass.Copy.run(save, t.getTexture(), Alpha);
		return t;
	}

}