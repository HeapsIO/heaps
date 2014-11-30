package h2d.filter;
import hxd.Math;

class Displacement extends Filter {

	public var normalMap : h2d.Tile;
	public var dispX : Float;
	public var dispY : Float;
	public var wrap(default, set) : Bool;
	var disp = new h3d.pass.ScreenFx(new h3d.shader.Displacement());

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
		var out = ctx.textures.allocTarget("displacementOutput", ctx, t.width, t.height, false);
		ctx.engine.setTarget(out);
		var s = disp.shader;
		s.texture = t.getTexture();
		s.displacement.set(dispX / t.width, dispY / t.height);
		s.normalMap = normalMap.getTexture();
		s.normalPos.set(normalMap.u, normalMap.v);
		s.normalScale.set(normalMap.u2 - normalMap.u, normalMap.v2 - normalMap.v);
		disp.render();
		return h2d.Tile.fromTexture(out);
	}

}