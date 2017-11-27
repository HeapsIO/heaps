package h2d.filter;
import hxd.Math;

class DropShadow extends Glow {

	public var distance : Float;
	public var angle : Float;
	var alphaPass = new h3d.mat.Pass("");

	public function new( distance : Float = 4., angle : Float = 0.785, color : Int = 0, alpha = 1., quality = 1, passes = 1, sigma = 1. ) {
		super(color, alpha, quality, passes, sigma);
		this.distance = distance;
		this.angle = angle;
		alphaPass.addShader(new h3d.shader.UVDelta());
	}

	override function sync(ctx, s) {
		super.sync(ctx, s);
		boundsExtend += Math.max(Math.abs(Math.cos(angle) * distance), Math.abs(Math.sin(angle) * distance));
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		setParams();
		var save = ctx.textures.allocTarget("glowSave", ctx, t.width, t.height, false);
		h3d.pass.Copy.run(t.getTexture(), save, None);
		var glowTmpTex = (quality == 0) ? null : ctx.textures.allocTarget("glowTmp", ctx, t.width, t.height, false);
		pass.apply(save, glowTmpTex);
		var dx = Math.round(Math.cos(angle) * distance);
		var dy = Math.round(Math.sin(angle) * distance);
		alphaPass.getShader(h3d.shader.UVDelta).uvDelta.set(dx / t.width, dy / t.height);
		h3d.pass.Copy.run(t.getTexture(), save, Alpha, alphaPass );
		var ret = h2d.Tile.fromTexture(save);
		ret.dx = dx;
		ret.dy = dy;
		return ret;
	}

}
