package h3d.scene;

class Scene extends Object implements h3d.IDrawable implements hxd.SceneEvents.InteractiveScene {

	public var camera : h3d.Camera;
	public var lightSystem : h3d.pass.LightSystem;
	public var renderer(default,set) : Renderer;
	var ctx : RenderContext;
	var interactives : Array<Interactive>;
	@:allow(h3d.scene.Interactive)
	var events : hxd.SceneEvents;
	var hitInteractives : Array<Interactive>;
	var eventListeners : Array<hxd.Event -> Void>;
	var stage : hxd.Stage;

	public function new() {
		super(null);
		stage = hxd.Stage.getInstance();
		eventListeners = [];
		hitInteractives = [];
		interactives = [];
		camera = new h3d.Camera();
		// update ratio before render (prevent first-frame difference)
		var engine = h3d.Engine.getCurrent();
		if( engine != null )
			camera.screenRatio = engine.width / engine.height;
		ctx = new RenderContext();
		renderer = h3d.mat.MaterialSetup.current.createRenderer();
		lightSystem = h3d.mat.MaterialSetup.current.createLightSystem();
	}

	@:noCompletion public function setEvents(events) {
		this.events = events;
	}

	public function addEventListener( f : hxd.Event -> Void ) {
		eventListeners.push(f);
	}

	public function removeEventListener( f : hxd.Event -> Void ) {
		for( e in eventListeners )
			if( Reflect.compareMethods(e, f) ) {
				eventListeners.remove(e);
				return true;
			}
		return false;
	}

	public function dispatchListeners(event:hxd.Event) {
		for( l in eventListeners ) {
			l(event);
			if( !event.propagate ) break;
		}
	}

	function set_renderer(r) {
		renderer = r;
		if( r != null ) @:privateAccess r.ctx = ctx;
		return r;
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

	public function isInteractiveVisible( i : hxd.SceneEvents.Interactive ) {
		var o : Object = cast i;
		while( o != null ) {
			if( !o.visible ) return false;
			o = o.parent;
		}
		return true;
	}

	public function handleEvent( event : hxd.Event, last : hxd.SceneEvents.Interactive ) {

		if( interactives.length == 0 )
			return null;

		if( hitInteractives.length == 0 ) {

			var screenX = (event.relX / stage.width - 0.5) * 2;
			var screenY = -(event.relY / stage.height - 0.5) * 2;
			var p0 = camera.unproject(screenX, screenY, 0);
			var p1 = camera.unproject(screenX, screenY, 1);
			var r = h3d.col.Ray.fromPoints(p0.toPoint(), p1.toPoint());
			var saveR = r.clone();
			var priority = 0x80000000;

			for( i in interactives ) {

				if( i.priority < priority ) continue;

				var p : h3d.scene.Object = i;
				while( p != null && p.visible )
					p = p.parent;
				if( p != null ) continue;

				var minv = i.getInvPos();
				r.transform(minv);

				// check for NaN
				if( r.lx != r.lx ) {
					r.load(saveR);
					continue;
				}

				var hit = i.shape.rayIntersection(r, i.bestMatch);
				if( hit < 0 ) {
					r.load(saveR);
					continue;
				}

				var hitPoint = r.getPoint(hit);
				r.load(saveR);

				i.hitPoint.x = hitPoint.x;
				i.hitPoint.y = hitPoint.y;
				i.hitPoint.z = hitPoint.z;

				if( i.priority > priority ) {
					while( hitInteractives.length > 0 ) hitInteractives.pop();
					priority = i.priority;
				}

				hitInteractives.push(i);
			}

			if( hitInteractives.length == 0 )
				return null;


			if( hitInteractives.length > 1 ) {
				for( i in hitInteractives ) {
					var m = i.invPos;
					var wfactor = 0.;

					// adjust result with better precision
					if( i.preciseShape != null ) {
						r.transform(m);
						var hit = i.preciseShape.rayIntersection(r, i.bestMatch);
						if( hit > 0 ) {
							var hitPoint = r.getPoint(hit);
							i.hitPoint.x = hitPoint.x;
							i.hitPoint.y = hitPoint.y;
							i.hitPoint.z = hitPoint.z;
						} else
							wfactor = 1.;
						r.load(saveR);
					}

					var p = i.hitPoint.clone();
					p.w = 1;
					p.transform3x4(i.absPos);
					p.project(camera.m);
					i.hitPoint.w = p.z + wfactor;
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
				event.propagate = false;
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
		ctx.scene = this;
		ctx.start();

		var ray = camera.rayFromScreen(pixelX, pixelY);
		var savedRay = ray.clone();

		iterVisibleMeshes(function(m) {
			if( m.primitive == null ) return;
			ray.transform(m.getInvPos());
			if( m.primitive.getBounds().rayIntersection(ray,false) >= 0 )
				ctx.emitPass(m.material.mainPass, m);
			ray.load(savedRay);
		});

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
		ctx.scene = null;
		return found;
	}

	/**
		Only sync without rendering
	**/
	public function syncOnly( et : Float ) {
		var engine = h3d.Engine.getCurrent();
		setElapsedTime(et);
		var t = engine.getCurrentTarget();
		if( t == null )
			camera.screenRatio = engine.width / engine.height;
		else
			camera.screenRatio = t.width / t.height;
		camera.update();
		ctx.camera = camera;
		ctx.engine = engine;
		ctx.scene = this;
		ctx.start();
		syncRec(ctx);
		ctx.camera = null;
		ctx.engine = null;
		ctx.scene = null;
	}

	@:access(h3d.mat.Pass)
	@:access(h3d.scene.RenderContext)
	public function render( engine : h3d.Engine ) {

		if( !allocated )
			onAdd();

		var t = engine.getCurrentTarget();
		if( t == null )
			camera.screenRatio = engine.width / engine.height;
		else
			camera.screenRatio = t.width / t.height;
		camera.update();
		ctx.camera = camera;
		ctx.engine = engine;
		ctx.scene = this;
		ctx.start();

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
		renderer.process(passes);

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
		ctx.scene = null;
		ctx.camera = null;
		ctx.engine = null;
	}


	public function serializeScene() : haxe.io.Bytes {
		#if hxbit
		var s = new hxd.fmt.hsd.Serializer();
		return s.saveHSD(this, false, camera);
		#else
		throw "You need -lib hxbit to serialize the scene data";
		#end
	}

	#if hxbit
	override function customSerialize(ctx:hxbit.Serializer) {
		throw this + " should not be serialized";
	}
	#end

}