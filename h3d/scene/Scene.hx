package h3d.scene;

class Scene extends Object implements h3d.IDrawable implements hxd.SceneEvents.InteractiveScene {

	public var camera : h3d.Camera;
	public var lightSystem : h3d.pass.LightSystem;
	public var renderer : Renderer;
	var prePasses : Array<h3d.IDrawable>;
	var postPasses : Array<h3d.IDrawable>;
	var ctx : RenderContext;
	var interactives : Array<Interactive>;
	@:allow(h3d.scene.Interactive)
	var events : hxd.SceneEvents;
	var hitInteractives : Array<Interactive>;

	public function new() {
		super(null);
		hitInteractives = [];
		interactives = [];
		camera = new h3d.Camera();
		ctx = new RenderContext();
		renderer = new Renderer();
		lightSystem = new h3d.pass.LightSystem();
		postPasses = [];
		prePasses = [];
	}

	@:noCompletion public function setEvents(events) {
		this.events = events;
	}

	public function dispatchListeners(event:hxd.Event) {
	}

	function sortHitPointByCameraDistance( i1 : Interactive, i2 : Interactive ) {
		var z1 = i1.hitPoint.w;
		var z2 = i2.hitPoint.w;
		if( z1 > z2 )
			return -1;
		return 1;
	}

	public function dispatchEvent( event : hxd.Event, to : hxd.SceneEvents.Interactive ) {
		var i : Interactive = cast to;
		// TODO : compute relX/Y/Z
		i.handleEvent(event);
	}

	public function handleEvent( event : hxd.Event, last : hxd.SceneEvents.Interactive ) {

		if( interactives.length == 0 )
			return null;

		if( hitInteractives.length == 0 ) {

			var stage = hxd.Stage.getInstance();
			var screenX = (event.relX / stage.width - 0.5) * 2;
			var screenY = -(event.relY / stage.height - 0.5) * 2;
			var p0 = camera.unproject(screenX, screenY, 0);
			var p1 = camera.unproject(screenX, screenY, 1);
			var r = h3d.col.Ray.fromPoints(p0.toPoint(), p1.toPoint());
			var saveR = r.clone();

			var hitTmp = new h3d.col.Point();
			for( i in interactives ) {

				var p : h3d.scene.Object = i;
				while( p != null && p.visible )
					p = p.parent;
				if( p != null ) continue;

				var minv = i.getInvPos();
				r.transform(minv);
				r.normalize();

				// check for NaN
				if( r.lx != r.lx ) {
					r.load(saveR);
					continue;
				}

				var hit = i.shape.rayIntersection(r, hitTmp);
				r.load(saveR);
				if( hit == null ) continue;

				i.hitPoint.x = hit.x;
				i.hitPoint.y = hit.y;
				i.hitPoint.z = hit.z;
				hitInteractives.push(i);
			}

			if( hitInteractives.length == 0 )
				return null;

			if( hitInteractives.length > 1 ) {
				for( i in hitInteractives ) {
					var m = i.invPos;
					var p = i.hitPoint.clone();
					p.transform3x4(i.absPos);
					p.project(camera.m);
					i.hitPoint.w = p.z;
				}
				hitInteractives.sort(sortHitPointByCameraDistance);
			}

			hitInteractives.unshift(null);
		}

		while( hitInteractives.length > 0 ) {

			var i = hitInteractives.pop();
			if( i == null )
				return null;

			event.relX = i.hitPoint.x;
			event.relY = i.hitPoint.y;
			event.relZ = i.hitPoint.z;
			i.handleEvent(event);

			if( event.cancel ) {
				event.cancel = false;
				event.propagate = true;
				continue;
			}

			if( !event.propagate )
				hitInteractives = [];

			return i;
		}

		return null;
	}

	override function clone( ?o : Object ) {
		var s = o == null ? new Scene() : cast o;
		s.camera = camera.clone();
		super.clone(s);
		return s;
	}

	override function dispose() {
		super.dispose();
		if( hardwarePass != null ) {
			hardwarePass.dispose();
			hardwarePass = null;
		}
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

	@:allow(h3d)
	function addEventTarget(i:Interactive) {
		interactives.push(i);
	}

	@:allow(h3d)
	function removeEventTarget(i:Interactive) {
		if( interactives.remove(i) && events != null )
			@:privateAccess events.onRemove(i);
	}

	public function setElapsedTime( elapsedTime ) {
		ctx.elapsedTime = elapsedTime;
	}

	var hardwarePass : h3d.pass.HardwarePick;

	/**
		Use GPU rendering to pick a model at the given pixel position.
		hardwarePick() will check all scene visible meshes bounds against a ray cast with current camera, then draw them into a 1x1 pixel texture with a specific shader.
		The texture will then be read and the color will identify the object that was rendered at this pixel.
		This is a very precise way of doing scene picking since it performs exactly the same transformations (skinning, custom shaders, etc.) but might be more costly than using CPU colliders.
		Please note that when done during/after rendering, this might clear the screen on some platforms so it should always be done before rendering.
	**/
	public function hardwarePick( pixelX : Float, pixelY : Float) {
		var engine = h3d.Engine.getCurrent();
		camera.screenRatio = engine.width / engine.height;
		camera.update();
		ctx.camera = camera;
		ctx.engine = engine;
		ctx.start();

		var ray = camera.rayFromScreen(pixelX, pixelY);
		hardwarePickEmit(ray, ctx);
		ctx.lightSystem = null;

		var found = null;
		var passes = @:privateAccess ctx.passes;

		if( passes != null ) {
			var p = hardwarePass;
			if( p == null )
				hardwarePass = p = new h3d.pass.HardwarePick();
			ctx.setGlobal("depthMap", h3d.mat.Texture.fromColor(0xFF00000, 0));
			p.pickX = pixelX;
			p.pickY = pixelY;
			p.setContext(ctx);
			@:privateAccess ctx.passes = passes = p.draw(passes);
			if( p.pickedIndex >= 0 ) {
				while( p.pickedIndex > 0 ) {
					p.pickedIndex--;
					passes = passes.next;
				}
				found = passes.obj;
			}
		}

		ctx.done();
		ctx.camera = null;
		ctx.engine = null;
		return found;
	}

	@:access(h3d.mat.Pass)
	@:access(h3d.scene.RenderContext)
	public function render( engine : h3d.Engine ) {

		if( !allocated )
			onAlloc();

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
		lightSystem.initLights(ctx);
		renderer.process(ctx, passes);

		// check that passes have been rendered
		#if debug
		for( p in passes ) {
			if( !p.rendered ) {
				trace("Pass " + p.name+" has not been rendered : don't know how to handle.");
				var o = p.passes;
				while( o != null ) {
					trace(" used by " + o.obj.name == null ? "" + o.obj : o.obj.name);
					o = o.next;
				}
			}
		}
		#end

		ctx.done();
		for( p in postPasses )
			p.render(engine);
		ctx.camera = null;
		ctx.engine = null;
	}

}