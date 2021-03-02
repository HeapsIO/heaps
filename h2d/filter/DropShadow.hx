package h2d.filter;
import hxd.Math;

/**
	Adds a soft shadow to the filtered Object.
**/
class DropShadow extends Glow {

	/**
		The offset distance of the shadow in the direction of `DropShadow.angle`.
	**/
	public var distance : Float;
	/**
		The shadow offset direction angle.
	**/
	public var angle : Float;
	var alphaPass = new h3d.mat.Pass("");

	/**
		Create a new Shadow filter.
		@param distance The offset of the shadow in the `angle` direction.
		@param angle Shadow offset direction angle.
		@param color The color of the shadow.
		@param alpha Transparency value of the shadow.
		@param radius The shadow glow distance in pixels.
		@param gain The shadow color intensity.
		@param quality The sample count on each pixel as a tradeoff of speed/quality.
		@param smoothColor Produce gradient shadow when enabled, otherwise creates hard shadow without smoothing.
	**/
	public function new( distance : Float = 4., angle : Float = 0.785, color : Int = 0, alpha = 1., radius : Float = 1., gain : Float = 1, quality = 1., smoothColor = false ) {
		super(color, alpha, radius, gain, quality, smoothColor);
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
		var save = ctx.textures.allocTileTarget("glowSave", t);
		h3d.pass.Copy.run(t.getTexture(), save, None);
		pass.apply(ctx, save);
		var dx = Math.round(Math.cos(angle) * distance);
		var dy = Math.round(Math.sin(angle) * distance);
		alphaPass.getShader(h3d.shader.UVDelta).uvDelta.set(dx / t.width, dy / t.height);
		h3d.pass.Copy.run(t.getTexture(), save, Alpha, alphaPass);
		var ret = h2d.Tile.fromTexture(save);
		ret.dx = dx;
		ret.dy = dy;
		return ret;
	}

}
