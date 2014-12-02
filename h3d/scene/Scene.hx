package h3d.scene;

class Scene extends Object implements h3d.IDrawable {

	public var camera : h3d.Camera;
	public var lightSystem : h3d.pass.LightSystem;
	public var renderer : Renderer;
	var prePasses : Array<h3d.IDrawable>;
	var postPasses : Array<h3d.IDrawable>;
	var ctx : RenderContext;

	public function new() {
		super(null);
		camera = new h3d.Camera();
		ctx = new RenderContext();
		renderer = new Renderer();
		lightSystem = new h3d.pass.LightSystem();
		postPasses = [];
		prePasses = [];
	}

	override function clone( ?o : Object ) {
		var s = o == null ? new Scene() : cast o;
		s.camera = camera.clone();
		super.clone(s);
		return s;
	}

	override function dispose() {
		super.dispose();
		renderer.dispose();
		renderer = new Renderer();
	}

	/**
	 allow to customize render passes (for example, branch sub scene or 2d context)
	 */
	public function addPass(p,before=false) {
		if( before )
			prePasses.push(p);
		else
			postPasses.push(p);
	}

	public function removePass(p) {
		postPasses.remove(p);
		prePasses.remove(p);
	}

	public function setElapsedTime( elapsedTime ) {
		ctx.elapsedTime = elapsedTime;
	}

	@:access(h3d.mat.Pass)
	@:access(h3d.scene.RenderContext)
	public function render( engine : h3d.Engine ) {
		camera.screenRatio = engine.width / engine.height;
		camera.update();
		ctx.camera = camera;
		ctx.engine = engine;
		ctx.start();
		for( p in prePasses )
			p.render(engine);
		syncRec(ctx);
		emitRec(ctx);
		// sort by pass id
		ctx.passes = haxe.ds.ListSort.sortSingleLinked(ctx.passes, function(p1, p2) {
			return p1.pass.passId - p2.pass.passId;
		});

		// group by pass implementation
		var curPass = ctx.passes;
		var passes = [];
		while( curPass != null ) {
			var passId = curPass.pass.passId;
			var p = curPass, prev = null;
			while( p != null && p.pass.passId == passId ) {
				prev = p;
				p = p.next;
			}
			prev.next = null;
			passes.push(new Renderer.PassGroup(curPass.pass.name,curPass));
			curPass = p;
		}

		// send to rendered
		ctx.lightSystem = lightSystem;
		renderer.process(ctx, passes);

		// relink pass objects to reuse
		var count = 0;
		var prev : h3d.pass.Object = null;
		for( p in passes ) {
			if( !p.rendered )
				throw "Pass " + p.name+" has not been rendered : don't know how to handle.";
			var p = p.passes;
			if( prev != null )
				prev.next = p;
			while( p != null ) {
				prev = p;
				p = p.next;
			}
		}
		if( passes.length > 0 ) ctx.passes = passes[0].passes;
		ctx.done();
		for( p in postPasses )
			p.render(engine);
		ctx.camera = null;
		ctx.engine = null;
	}

}