package h2d.filter;

class Glow extends Blur {

	public var color : Int;
	public var alpha : Float;
	public var knockout : Bool;
	public var smoothColor : Bool;

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
		var save = ctx.textures.allocTarget("glowSave", t.width, t.height, false);
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