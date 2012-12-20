package h3d.scene;

class Scene extends Layers, implements h3d.IDrawable {

	public var camera : h3d.Camera;
	var extraPasses : Array<h3d.IDrawable>;
	
	public function new() {
		super(null);
		camera = new h3d.Camera();
		extraPasses = [];
	}
	
	override function clone( ?o : Object ) {
		var s = o == null ? new Scene() : cast o;
		s.camera = camera.clone();
		super.clone(s);
		return s;
	}
	
	public function addPass(p) {
		extraPasses.push(p);
	}
	
	public function removePass(p) {
		extraPasses.remove(p);
	}
	
	// make it public
	public function render( engine : h3d.Engine ) {
		camera.ratio = engine.width / engine.height;
		camera.update();
		var oldProj = engine.curProjMatrix;
		engine.curProjMatrix = camera.m;
		var ctx = new RenderContext(engine, camera);
		renderContext(ctx);
		ctx.finalize();
		for( p in extraPasses )
			p.render(engine);
		engine.curProjMatrix = oldProj;
	}
	
}