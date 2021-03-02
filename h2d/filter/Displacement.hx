package h2d.filter;
import hxd.Math;

/**
	Applies a normal map to the filtered Object in order to displace pixels.

	Uses red and green channels to displaces horizontal and vertical axes accordingly.
**/
class Displacement extends Filter {

	/**
		The normal map used for displacement lookup.
	**/
	public var normalMap : h2d.Tile;
	/**
		Horizontal displacement distance in pixels.
	**/
	public var dispX : Float;
	/**
		Vertical displacement distance in pixels.
	**/
	public var dispY : Float;
	/**
		When enabled, the displacement map will wrap around when lookup reaches its edges.
		Otherwise out-of-bounds values are clamped to the border.
	**/
	public var wrap(default, set) : Bool;
	var disp = new h3d.pass.ScreenFx(new h3d.shader.Displacement());

	/**
		Create a new displacement filter.
		@param normalMap The normal map used for displacement lookup.
		@param dispX Horizontal displacement distance in pixels.
		@param dispY Vertical displacement distance in pixels.
		@param wrap Wrap normal map around when lookup UV goes out of bounds.
	**/
	public function new( normalMap : h2d.Tile, dispX : Float = 5., dispY = 5., wrap = true ) {
		super();
		this.normalMap = normalMap;
		this.dispX = dispX;
		this.dispY = dispY;
		this.wrap = wrap;
	}

	function set_wrap(w) {
		var t = normalMap == null ? null : normalMap.getTexture();
		if( t != null ) t.wrap = w ? Repeat : Clamp;
		return wrap = w;
	}

	override function sync(ctx, s) {
		boundsExtend = Math.max(Math.abs(dispX), Math.abs(dispY));
	}

	override function draw( ctx : RenderContext, t : h2d.Tile ) {
		var out = ctx.textures.allocTileTarget("displacementOutput", t);
		ctx.engine.pushTarget(out);
		var s = disp.shader;
		s.texture = t.getTexture();
		s.displacement.set(dispX / t.width, dispY / t.height);
		s.normalMap = normalMap.getTexture();
		s.normalPos.set(normalMap.u, normalMap.v);
		s.normalScale.set(normalMap.u2 - normalMap.u, normalMap.v2 - normalMap.v);
		disp.render();
		ctx.engine.popTarget();
		return h2d.Tile.fromTexture(out);
	}

}
