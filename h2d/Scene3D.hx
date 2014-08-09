package h2d;

class Scene3D extends Sprite {

	public var scene : h3d.scene.Scene;

	public function new( scene, ?parent ) {
		super(parent);
		this.scene = scene;
	}

	override function draw( ctx : RenderContext ) {
		scene.render(ctx.engine);
	}

}