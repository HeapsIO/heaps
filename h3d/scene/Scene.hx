package h3d.scene;

class Scene extends Object implements h3d.IDrawable {

	public var camera : h3d.Camera;
	public var mainPass(get, never) : h3d.pass.Base;
	var prePasses : Array<h3d.IDrawable>;
	var postPasses : Array<h3d.IDrawable>;
	var passes : Map<String,h3d.pass.Base>;
	var ctx : RenderContext;
	
	public function new() {
		super(null);
		camera = new h3d.Camera();
		ctx = new RenderContext();
		passes = new Map();
		postPasses = [];
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
			postPasses.push(p);
	}
	
	public function removePass(p) {
		postPasses.remove(p);
		prePasses.remove(p);
	}
	
	public function setElapsedTime( elapsedTime ) {
		ctx.elapsedTime = elapsedTime;
	}
	
	function createDefaultPass( name : String ) : h3d.pass.Base {
		switch( name ) {
		case "default", "alpha", "additive":
			return new h3d.pass.Base();
		case "distance":
			return new h3d.pass.Distance();
		default:
			throw "Don't know how to create pass '" + name + "', use s3d.setRenderPass()";
			return null;
		}
	}
	
	function get_mainPass() {
		return getPass("default");
	}
	
	public function getPass( name : String ) {
		var p = passes.get(name);
		if( p == null ) {
			p = createDefaultPass(name);
			setPass(name, p);
		}
		return p;
	}
	
	public function setPass( name : String, p : h3d.pass.Base ) {
		passes.set(name, p);
	}

	@:access(h3d.mat.Pass)
	@:access(h3d.scene.RenderContext)
	public function render( engine : h3d.Engine ) {
		camera.screenRatio = engine.width / engine.height;
		camera.update();
		var oldProj = engine.curProjMatrix;
		engine.curProjMatrix = camera.m;
		ctx.camera = camera;
		ctx.engine = engine;
		ctx.time += ctx.elapsedTime;
		ctx.frame++;
		for( p in prePasses )
			p.render(engine);
		sync(ctx);
		emitRec(ctx);
		// sort by pass id
		ctx.passes = haxe.ds.ListSort.sortSingleLinked(ctx.passes, function(p1, p2) {
			return p1.pass.passId - p2.pass.passId;
		});
		// dispatch to the actual pass implementation
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
			var render = getPass(curPass.pass.name);
			passes.push( { render : render, pass : curPass, prev : prev, next : p } );
			curPass = p;
		}
		@:privateAccess passes.sort(function(p1, p2) return p2.render.priority - p1.render.priority);
		for( p in passes )
			p.render.draw(ctx, p.pass);
		// restore linked list to reuse
		for( p in passes )
			p.prev.next = p.next;
		ctx.done();
		for( p in postPasses )
			p.render(engine);
		engine.curProjMatrix = oldProj;
		ctx.camera = null;
		ctx.engine = null;
	}
	
}