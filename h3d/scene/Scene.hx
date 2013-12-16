package h3d.scene;
import hxd.Profiler;

class Scene extends Object implements h3d.IDrawable {

	public var camera : h3d.Camera;
	var prePasses : Array<h3d.IDrawable>;
	var extraPasses : Array<h3d.IDrawable>;
	var ctx : RenderContext;
	
	public function new() {
		super(null);
		camera = new h3d.Camera();
		ctx = new RenderContext();
		extraPasses = [];
		prePasses = [];
	}
	
	override function clone( ?o : Object ) {
		var s = o == null ? new Scene() : cast o;
		s.camera = camera.clone();
		super.clone(s);
		return s;
	}
	
	/**
	 allow to customize render passes (for example, branch sub scene or 2d context)
	 */
	public function addPass(p:h3d.IDrawable,before=false) {
		if( before )
			prePasses.push(p);
		else
			extraPasses.push(p);
	}
	
	public function removePass(p) {
		extraPasses.remove(p);
		prePasses.remove(p);
	}
	
	public function setElapsedTime( elapsedTime ) {
		ctx.elapsedTime = elapsedTime;
	}

	public function render( engine : h3d.Engine ) {
		Profiler.begin("Scene::render");
		camera.screenRatio = engine.width / engine.height;
		camera.update();
		var oldProj = engine.curProjMatrix;
		engine.curProjMatrix = camera.m;
		ctx.camera = camera;
		ctx.engine = engine;
		ctx.time += ctx.elapsedTime;
		ctx.frame++;
		ctx.currentPass = 0;
		
		Profiler.begin("Scene::extra");
		for( p in prePasses )
			p.render(engine);
		Profiler.end("Scene::pre");
		
		Profiler.begin("Scene::sync");
		sync(ctx);
		Profiler.end("Scene::sync");
		
		Profiler.begin("Scene::drawRec");
		drawRec(ctx);
		Profiler.end("Scene::drawRec");
		Profiler.begin("Scene::finalize");
		ctx.finalize();
		Profiler.end("Scene::finalize");
		
		Profiler.begin("Scene::extra");
		for ( p in extraPasses ) p.render(engine);
		Profiler.end("Scene::extra");
		
		engine.curProjMatrix = oldProj;
		ctx.camera = null;
		ctx.engine = null;
		Profiler.end("Scene::render");
	}
	
}