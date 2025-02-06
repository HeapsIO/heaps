package h3d.scene;

/**
	h3d.scene.Scene is the root class for a 3D scene. All root objects are added to it before being drawn on screen.
**/
class Scene extends Object implements h3d.IDrawable implements hxd.SceneEvents.InteractiveScene {

	/**
		The scene current camera.
	**/
	public var camera : h3d.Camera;

	/**
		The scene light system. Can be customized.
	**/
	public var lightSystem : LightSystem;

	/**
		The scene renderer. Can be customized.
	**/
	public var renderer(default,set) : Renderer;

	public var offsetX : Float = 0;
	public var offsetY : Float = 0;
	public var ratioX : Float = 1;
	public var ratioY : Float = 1;

	/**
		Adjust the position of the ray used to handle interactives.
	**/
	public var interactiveOffset : Float = 0;

	var ctx : RenderContext;
	var interactives : Array<Interactive>;
	@:allow(h3d.scene.Interactive)
	var events : hxd.SceneEvents;
	var hitInteractives : Array<Interactive>;
	var eventListeners : Array<hxd.Event -> Void>;
	var window : hxd.Window;
	#if debug
	public var checkPasses = true;
	#end

	/**
		Create a new scene. A default 3D scene is already available in `hxd.App.s3d`
	**/
	public function new( ?createRenderer = true, ?createLightSystem = true ) {
		super(null);
		window = hxd.Window.getInstance();
		eventListeners = [];
		hitInteractives = [];
		interactives = [];
		camera = new h3d.Camera();
		// update ratio before render (prevent first-frame difference)
		var engine = h3d.Engine.getCurrent();
		if( engine != null )
			camera.screenRatio = engine.width / engine.height;
		ctx = new RenderContext(this);
		if( createRenderer ) renderer = h3d.mat.MaterialSetup.current.createRenderer();
		if( createLightSystem ) lightSystem = h3d.mat.MaterialSetup.current.createLightSystem();
	}

	@:noCompletion @:dox(hide) public function setEvents(events) {
		this.events = events;
	}

	/**
		Add an event listener that will capture all events not caught by an h2d.Interactive
	**/
	public function addEventListener( f : hxd.Event -> Void ) {
		eventListeners.push(f);
	}

	/**
		Remove a previously added event listener, return false it was not part of our event listeners.
	**/
	public function removeEventListener( f : hxd.Event -> Void ) {
		for( e in eventListeners )
			if( Reflect.compareMethods(e, f) ) {
				eventListeners.remove(e);
				return true;
			}
		return false;
	}

	@:dox(hide) @:noCompletion
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

	@:dox(hide) @:noCompletion
	public function dispatchEvent( event : hxd.Event, to : hxd.SceneEvents.Interactive ) {
		var i : Interactive = cast to;
		// TODO : compute relX/Y/Z
		i.handleEvent(event);
	}

	@:dox(hide) @:noCompletion
	public function isInteractiveVisible( i : hxd.SceneEvents.Interactive ) {
		var o : Object = cast i;
		while( o != this ) {
			if( o == null || !o.visible ) return false;
			o = o.parent;
		}
		return true;
	}

	@:dox(hide) @:noCompletion
	public function handleEvent( event : hxd.Event, last : hxd.SceneEvents.Interactive ) {

		if( interactives.length == 0 )
			return null;

		if( hitInteractives.length == 0 ) {
			var x = event.relX - offsetX;
			var y = event.relY - offsetY;

			var width = ratioX * window.width;
			var height = ratioY * window.height;
			var screenX = (x / width - 0.5) * 2;
			var screenY = -(y / height - 0.5) * 2;

			var p0 = camera.unproject(screenX, screenY, 0);
			var p1 = camera.unproject(screenX, screenY, 1);
			var r = h3d.col.Ray.fromPoints(p0.toPoint(), p1.toPoint());
			if( interactiveOffset != 0 ) {
				r.px += r.lx * interactiveOffset;
				r.py += r.ly * interactiveOffset;
				r.pz += r.lz * interactiveOffset;
			}
			var saveR = r.clone();
			var priority = 0x80000000;

			for( i in interactives ) {

				if( i.priority < priority ) continue;

				var p : h3d.scene.Object = i;
				while( p != null && p.visible )
					p = p.parent;
				if( p != null ) continue;

				if( !i.isAbsoluteShape ) {
					var minv = i.getInvPos();
					r.transform(minv);
				}

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
					if( i.preciseShape != null || !i.bestMatch ) {
						if( !i.isAbsoluteShape )
							r.transform(m);
						var hit = (i.preciseShape ?? i.shape).rayIntersection(r, true);
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
					if( !i.isAbsoluteShape )
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

			if( !event.propagate ) {
				while( hitInteractives.length > 0 ) hitInteractives.pop();
			}

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

	/**
		Free the GPU memory for this Scene and its children
	**/
	public function dispose() {
		if ( allocated )
			onRemove();
		ctx.dispose();
		if(renderer != null) {
			renderer.dispose();
			renderer = new Renderer();
		}
	}

	@:allow(h3d)
	function addEventTarget(i:Interactive) {
		if( interactives.indexOf(i) >= 0 ) throw "assert";
		interactives.push(i);
	}

	@:allow(h3d)
	function removeEventTarget(i:Interactive) {
		if( interactives.remove(i) ) {
			if( events != null ) @:privateAccess events.onRemove(i);
			hitInteractives.remove(i);
		}
	}

	/**
		Before render() or sync() are called, allow to set how much time has elapsed (in seconds) since the last frame in order to update scene animations.
		This is managed automatically by hxd.App
	**/
	public function setElapsedTime( elapsedTime ) {
		ctx.elapsedTime = elapsedTime;
	}

	/**
		Synchronize the scene without rendering, updating all objects and animations by the given amount of time, in seconds.
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
		ctx.start();
		syncRec(ctx);
		ctx.done();
	}

	/**
		Perform a rendering with `RendererContext.computingStatic=true`, allowing the computation of static shadow maps, etc.
	**/
	public function computeStatic() {
		var old = ctx.elapsedTime;
		ctx.elapsedTime = 0;
		ctx.computingStatic = true;
		render(h3d.Engine.getCurrent());
		ctx.computingStatic = false;
		ctx.elapsedTime = old;
	}

	/**
		Automatically called when the 3D context is lost
	**/
	public function onContextLost() {
		ctx.wasContextLost = true;
	}

	/**
		Render the scene on screen. Internal usage only.
	**/
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

		if( camera.rightHanded )
			engine.driver.setRenderFlag(CameraHandness,1);

		ctx.start();
		renderer.start();
		renderer.startEffects();

		#if sceneprof h3d.impl.SceneProf.begin("sync", ctx.frame); #end
		mark("sync");
		syncRec(ctx);
		#if sceneprof
		h3d.impl.SceneProf.end();
		h3d.impl.SceneProf.begin("emit", ctx.frame);
		#end
		mark("emit");
		emitRec(ctx);
		#if sceneprof h3d.impl.SceneProf.end(); #end

		var passes = [];
		var passIndex = -1;
		for ( passId in 0...ctx.passes.length ) {
			var curPass = ctx.passes[passId];
			if ( curPass == null )
				continue;
			var pobjs = ctx.cachedPassObjects[++passIndex];
			if( pobjs == null ) {
				pobjs = new Renderer.PassObjects();
				ctx.cachedPassObjects[passIndex] = pobjs;
			}
			pobjs.name = curPass.pass.name;
			pobjs.passes.init(curPass);
			passes.push(pobjs);
		}

		// send to rendered
		if( lightSystem != null ) {
			ctx.lightSystem = lightSystem;
			lightSystem.initLights(ctx);
		}
		renderer.process(passes);

		// check that passes have been rendered
		#if (debug && !editor)
		if( !ctx.computingStatic && checkPasses)
			for( p in passes )
				if( !p.rendered )
					trace("Pass " + p.name+" has not been rendered : don't know how to handle.");
		#end

		if( camera.rightHanded )
			engine.driver.setRenderFlag(CameraHandness,0);

		ctx.done();
		ctx.wasContextLost = false;
		for( i in 0...passIndex ) {
			var p = ctx.cachedPassObjects[i];
			p.name = null;
			p.passes.init(null);
		}
	}

	public dynamic function mark(name : String) {
		@:privateAccess renderer.mark(name);
	}

	var prevDB : h3d.mat.Texture;
	var prevEngine = null;
	/**
		Temporarily overrides the output render target. This is useful for picture-in-picture rendering,
		where the output render target has a different size from the window.
		`tex` must have a matching depthBuffer attached.
		Call `setOutputTarget()` after `render()` has been called.
	**/
	public function setOutputTarget( ?engine: h3d.Engine, ?tex : h3d.mat.Texture ) @:privateAccess {
		if(tex != null) {
			if(prevDB != null) throw "missing setOutputTarget()";
			engine.pushTarget(tex);
			engine.width = tex.width;
			engine.height = tex.height;
			prevDB = ctx.textures.defaultDepthBuffer;
			prevEngine = engine;
			ctx.textures.defaultDepthBuffer = tex.depthBuffer;
		}
		else {
			prevEngine.popTarget();
			prevEngine.width = prevDB.width;
			prevEngine.height = prevDB.height;
			ctx.textures.defaultDepthBuffer = prevDB;
			prevDB = null;
			prevEngine = null;
		}
	}
}