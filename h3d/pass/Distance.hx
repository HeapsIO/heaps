package h3d.pass;

class Distance extends Base {
	
	var texture : h3d.mat.Texture;

	public function new() {
		super();
		priority = 10;
		lightSystem = null;
	}

	override function getOutputs() {
		return ["output.position", "output.distance"];
	}
	
	override function setGlobals() {
		super.setGlobals();
	}
	
	var b : h2d.Bitmap;
	
	override function draw(ctx : h3d.scene.RenderContext, passes) {
		if( texture == null || texture.isDisposed() || texture.width != ctx.engine.width || texture.height != ctx.engine.height ) {
			if( texture != null ) texture.dispose();
			texture = h3d.mat.Texture.alloc(ctx.engine.width>>1, ctx.engine.height>>1, true);
			if( b != null ) b.remove();
			b = new h2d.Bitmap(h2d.Tile.fromTexture(texture), @:privateAccess Main.inst.s2d);
			b.blendMode = None;
		}
		ctx.engine.setTarget(texture, true);
		super.draw(ctx, passes);
		ctx.engine.setTarget(null);
	}
	
}