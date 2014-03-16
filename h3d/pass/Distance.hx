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
	
	override function draw(ctx : h3d.scene.RenderContext, passes) {
		if( texture == null || texture.isDisposed() || texture.width != ctx.engine.width || texture.height != ctx.engine.height ) {
			if( texture != null ) texture.dispose();
			texture = h3d.mat.Texture.alloc(ctx.engine.width, ctx.engine.height, true);
		}
		ctx.engine.setTarget(texture, true);
		super.draw(ctx, passes);
		ctx.engine.setTarget(null);
	}
	
}