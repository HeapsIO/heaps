package h3d.scene;

class Scene extends Layers {

	public var camera : h3d.Camera;
	
	public function new() {
		super(null);
		camera = new h3d.Camera();
	}
	
	// make it public
	public override function render( engine : h3d.Engine ) {
		camera.ratio = engine.width / engine.height;
		camera.update();
		var oldProj = engine.curProjMatrix;
		engine.curProjMatrix = camera.m;
		super.render(engine);
		engine.curProjMatrix = oldProj;
	}
	
}