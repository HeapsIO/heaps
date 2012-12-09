package h3d.scene;

class Scene extends Layers, implements h3d.IDrawable {

	public var camera : h3d.Camera;
	var extraPasses : Array<{ function render( engine : h3d.Engine ) : Void; }>;
	
	public function new() {
		super(null);
		camera = new h3d.Camera();
		extraPasses = [];
	}
	
	public function addPass(p) {
		extraPasses.push(p);
	}
	
	public function removePass(p) {
		extraPasses.remove(p);
	}
	
	// make it public
	public override function render( engine : h3d.Engine ) {
		camera.ratio = engine.width / engine.height;
		camera.update();
		var oldProj = engine.curProjMatrix;
		engine.curProjMatrix = camera.m;
		super.render(engine);
		for( p in extraPasses )
			p.render(engine);
		engine.curProjMatrix = oldProj;
	}
	
}