package h2d.filter;
import hxd.Math;

class DropShadow extends Glow {

	public var distance : Float;
	public var angle : Float;

	public function new( distance : Float = 4., angle : Float = 0.785, color : Int = 0, alpha = 1., quality = 1, passes = 1, sigma = 1. ) {
		super(color, alpha, quality, passes, sigma);
		this.distance = distance;
		this.angle = angle;
	}

	override function sync(ctx, s) {
		super.sync(ctx, s);
		boundsExtend += Math.max(Math.abs(Math.cos(angle) * distance), Math.abs(Math.sin(angle) * distance));
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		pass.shader.fixedColor.setColor(color);
		pass.shader.fixedColor.w = alpha;
		var save = ctx.textures.allocTarget("glowSave", ctx, t.width, t.height, false);
		h3d.pass.Copy.run(t.getTexture(), save, None);
		pass.apply(t.getTexture(), ctx.textures.allocTarget("glowTmp", ctx, t.width, t.height, false));
		var dx = Math.round(Math.cos(angle) * distance);
		var dy = Math.round(Math.sin(angle) * distance);
		h3d.pass.Copy.run(save, t.getTexture(), Alpha, new h3d.Vector( dx / t.width, dy / t.height) );
		t.dx = dx;
		t.dy = dy;
		return t;
	}

}