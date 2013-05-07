package h3d.scene;

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
	
	public function addPass(p,before=false) {
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
		camera.screenRatio = engine.width / engine.height;
		camera.update();
		var oldProj = engine.curProjMatrix;
		engine.curProjMatrix = camera.m;
		ctx.camera = camera;
		ctx.engine = engine;
		ctx.time += ctx.elapsedTime;
		ctx.frame++;
		ctx.currentPass = 0;
		for( p in prePasses )
			p.render(engine);
		sync(ctx);
		drawRec(ctx);
		ctx.finalize();
		for( p in extraPasses )
			p.render(engine);
		engine.curProjMatrix = oldProj;
		ctx.camera = null;
		ctx.engine = null;
	}
	
}