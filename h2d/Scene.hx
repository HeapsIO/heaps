package h2d;
import hxd.Math;

/**
	Viewport alignment when scaling mode supports it. See `ScaleMode`.
**/
enum ScaleModeAlign {
	/** Anchor Scene viewport horizontally to the left side of the window. When passed to `verticalAlign` it will be treated as Center. **/
	Left;
	/** Anchor Scene viewport horizontally to the right side of the window. When passed to `verticalAlign` it will be treated as Center. **/
	Right;
	/** Anchor to the center of the window. **/
	Center;
	/** Anchor Scene viewport vertically to the top of the window. When passed to `horizontalAlign` it will be treated as Center. **/
	Top;
	/** Anchor Scene viewport vertically to the bottom of the window. When passed to `horizontalAlign` it will be treated as Center. **/
	Bottom;
}

/**
	Scaling mode of the 2D Scene.

	Set via `Scene.scaleMode`.

	See ScaleMode2D sample for usage showcase.
**/
enum ScaleMode {

	/**
		Matches scene size to window size. `width` and `height` of Scene will match window size. Default scaling mode.
	**/
	Resize;

	/**
		Sets constant Scene size and stretches it to cover entire window. This behavior is same as old `setFixedSize` method.

		@param width The width of the internal Scene viewport.
		@param height The height of the internal Scene viewport.
	**/
	Stretch(width : Int, height : Int);

	/**
		Sets constant Scene size and upscales it with preserving the aspect-ratio to fit the window.

		With `800x600` window, `LetterBox(320, 260)` will result in center-aligned Scene of size `320x260` upscaled to fit into the window.  
		With same window but setting of `LetterBox(320, 260, true, Left, Top)` would result in the same Scene internal size,
		upscaled to `640x480` resolution and anchored to the top-left corner of the window.

		Note that while it's called LetterBox, there is no viewport rendering clipping apart from the out-of-bounds culling in `RenderContext.drawTile` / `Object.emitTile`.

		@param width The width of the internal Scene viewport.
		@param height The height of the internal Scene viewport.
		@param integerScale When enabled, upscaling is performed only with integer increments (1x, 2x, 3x, etc) and can be used to achieve pixel-perfect scaling.
		While enabled, the Scene won't be downscaled when internal viewport is larger than the window size and will remain at 1x zoom. Default: `false`.
		@param horizontalAlign The horizontal viewport anchoring rule. Accepted values are `Left`, `Center` and `Right`. Default: `Center`.
		@param verticalAlign The vertical viewport anchoring rule. Accepted values are `Top`, `Center` and `Bottom`. Default: `Center`.

	**/
	LetterBox(width : Int, height : Int, ?integerScale : Bool, ?horizontalAlign : ScaleModeAlign, ?verticalAlign : ScaleModeAlign);

	/**
		Sets constant Scene size, scale and alignment. Does not perform any adaptation to the window size apart from alignment.

		With `800x600` window, `Fixed(200, 150, 2, Left, Center)` will result in the Scene size of `200x150`, and visually upscaled to `400x300`, and aligned to a middle-left of the window.

		@param width The width of the internal Scene viewport.
		@param height The height of the internal Scene viewport.
		@param zoom The scaling multiplier of internal viewport when rendering onto the screen.
		@param horizontalAlign The horizontal viewport anchoring rule. Accepted values are `Left`, `Center` and `Right`. Default: `Center`.
		@param verticalAlign The vertical viewport anchoring rule. Accepted values are `Top`, `Center` and `Bottom`. Default: `Center`.

	**/
	Fixed(width : Int, height: Int, zoom : Float, ?horizontalAlign : ScaleModeAlign, ?verticalAlign : ScaleModeAlign);

	/**
		Upscales/downscales the Scene internal viewport according to `level` and matches Scene size to `ceil(window size / level)`.

		With `800x600` window, `Zoom(2)` will result in the `400x300` Scene size upscaled to fill the entire window.
	**/
	Zoom(level : Float);

	/**
		Ensures that the Scene size will be of the minimum specified size.

		Automatically calculates zoom level based on provided size according to `min(window width / min width, window height / min height)`, then applies same scaling as `Zoom(level)`.
		The behavior is similar to `LetterBox`, however instead of constant internal viewport size, Scene size will change to cover the entire window.

		`minWidth` or `minHeight` can be set to `0` in order to force scaling adjustment account only for either horizontal of vertical window size.
		If both are `0`, results are undefined.

		With `800x600` window, `AutoZoom(320, 260, false)` will result in the Scene size of `347x260`. `AutoZoom(320, 260, true)` will result in the size of `400x300`.

		@param minWidth The minimum width of the internal Scene viewport.
		@param minHeight The minimum height of the internal Scene viewport.
		@param integerScale When enabled, upscaling is performed only with integer increments (1x, 2x, 3x, etc) and can be used to achieve pixel-perfect scaling.
		While enabled, the Scene won't be downscaled when internal viewport is larger than the window size and will remain at 1x zoom. Default: `false`.

	**/
	AutoZoom(minWidth : Int, minHeight : Int, ?integerScaling : Bool);
}

/**
	The root class for a 2D scene. All root objects are added to it before being drawn on screen.
**/
class Scene extends Layers implements h3d.IDrawable implements hxd.SceneEvents.InteractiveScene {

	/**
		The current width (in pixels) of the scene. Can change if the screen gets resized or `scaleMode` changes.
	**/
	public var width(default,null) : Int;

	/**
		The current height (in pixels) of the scene. Can change if the screen gets resized or `scaleMode` changes.
	**/
	public var height(default, null) : Int;

	/**
		Viewport horizontal scale transform value. Converts from scene space to screen space of [0, 2] range.
	**/
	var viewportA(default, null) : Float;
	/**
		Viewport vertical scale transform value. Converts from scene space to screen space of [0, 2] range.
	**/
	var viewportD(default, null) : Float;
	/**
		Horizontal viewport offset relative to top-left corner of the window. Can change if the screen gets resized or `scaleMode` changes.
		Offset is in screen-space coordinates: [-1, 1] where 0 is center of the window.
	**/
	var viewportX(default, null) : Float;
	/**
		Vertical viewport offset relative to top-left corner of the window. Can change if the screen gets resized or `scaleMode` changes.
		Offset is in screen-space coordinates: [-1, 1] where 0 is center of the window.
	**/
	var viewportY(default, null) : Float;

	/**
		Horizontal viewport offset relative to top-left corner of the window in pixels.
		Assigned if the screen gets resized or `scaleMode` changes.
	**/
	var offsetX(default, null) : Float;
	/**
		Vertical viewport offset relative to top-left corner of the window in pixels.
		Assigned if the screen gets resized or `scaleMode` changes.
	**/
	var offsetY(default, null) : Float;

	/**
		Horizontal scale of a scene when rendering to the screen.

		Can change if the screen gets resized or `scaleMode` changes.
	**/
	public var viewportScaleX(default, null) : Float;
	/**
		Vertical scale of a scene when rendering to the screen.

		Can change if the screen gets resized or `scaleMode` changes.
	**/
	public var viewportScaleY(default, null) : Float;

	/**
		The current mouse X coordinates (in pixels) relative to the current `Scene.interactiveCamera`.
	**/
	public var mouseX(get, null) : Float;

	/**
		The current mouse Y coordinates (in pixels) relative to the current `Scene.interactiveCamera`.
	**/
	public var mouseY(get, null) : Float;

	/**
		The zoom factor of the scene, allows to set a fixed x2, x4 etc. zoom for pixel art
		When setting a zoom > 0, the scene resize will be automatically managed.
	**/
	@:deprecated("zoom is deprecated, use scaleMode = Zoom(v) instead")
	@:dox(hide)
	public var zoom(get, set) : Int;

	/**
		Scene scaling mode.

		Important thing to keep in mind - Scene does not clip rendering to it's scaled size and
		graphics can render outside of it. However `RenderContext.drawTile` (and consecutively `Object.emitTile`) does check for those bounds and
		will clip out tiles that are outside of the scene bounds.
	**/
	public var scaleMode(default, set) : ScaleMode = Resize;

	/**
		List of all cameras attached to the Scene. Should contain at least one camera to render (created by default).

		Override `h2d.Camera.layerVisible` method to filter out specific layers from camera rendering.

		To add or remove cameras use `Scene.addCamera` and `Scene.removeCamera` methods.
	**/
	public var cameras(get, never) : haxe.ds.ReadOnlyArray<Camera>;
	var _cameras : Array<Camera>;
	/**
		Alias to the first camera in the camera list: `cameras[0]`
	**/
	public var camera(get, never) : Camera;

	/**
		Camera instance that handles the scene events.

		Due to Heaps structure, only one Camera can work with the Interactives.
		Contrary to rendering, event handling does not check if layer is visible for the camera or not.

		Should never be null. When set, if Camera does not belong to the Scene, it will be added with `Scene.addCamera`.
		Would cause an exception when trying to remove current interactive camera from the list.
	**/
	public var interactiveCamera(default, set) : Camera;

	/**
		Controls the default value for `h2d.Drawable.smooth`. Default: `false`
	**/
	public var defaultSmooth(get, set) : Bool;

	/**
		The current Scene renderer. Can be customized.
	**/
	public var renderer(get, set) : RenderContext;

	var interactive : Array<Interactive>;
	var eventListeners : Array< hxd.Event -> Void >;
	var ctx : RenderContext;
	var window : hxd.Window;
	@:allow(h2d.Interactive)
	var events : hxd.SceneEvents;
	var shapePoint : h2d.col.Point;

	/**
		Create a new 2D scene. A default 2D scene is already available in `hxd.App.s2d`.
	**/
	public function new() {
		super(null);
		var e = h3d.Engine.getCurrent();
		ctx = new RenderContext(this);
		_cameras = [];
		new Camera(this);
		interactiveCamera = camera;
		width = e.width;
		height = e.height;
		viewportA = 2 / e.width;
		viewportD = 2 / e.height;
		viewportX = -1;
		viewportY = -1;
		viewportScaleX = 1;
		viewportScaleY = 1;
		offsetX = 0;
		offsetY = 0;
		interactive = new Array();
		eventListeners = new Array();
		shapePoint = new h2d.col.Point();
		window = hxd.Window.getInstance();
		posChanged = true;
	}

	inline function get_defaultSmooth() return ctx.defaultSmooth;
	inline function set_defaultSmooth(v) return ctx.defaultSmooth = v;

	@:dox(hide) @:noCompletion
	public function setEvents(events : hxd.SceneEvents) {
		this.events = events;
	}

	function get_zoom() : Int {
		return switch ( scaleMode ) {
			case Zoom(level): Std.int(level);
			default: 0;
		}
	}

	function set_zoom(v:Int) {
		scaleMode = Zoom(v);
		return v;
	}

	function set_scaleMode( v : ScaleMode ) {
		scaleMode = v;
		checkResize();
		return v;
	}

	function get_renderer() return ctx;
	function set_renderer(v) { ctx = v; return v; }

	inline function get_camera() return _cameras[0];

	inline function get_cameras() return _cameras;

	function set_interactiveCamera( cam : Camera ) {
		if ( cam == null ) throw "Interactive cammera cannot be null!";
		if ( cam.scene != this ) this.addCamera(cam);
		return interactiveCamera = cam;
	}

	/**
		Adds a Camera to the Scene camera list with optional index at which it is added.
		@param cam The Camera instance to add.
		@param pos Optional index at which the camera will be inserted.
	**/
	public function addCamera( cam : Camera, ?pos : Int ) {
		if ( cam.scene != null )
			cam.scene.removeCamera(cam);
		cam.scene = this;
		cam.posChanged = true;
		if ( pos != null ) _cameras.insert(pos, cam);
		else _cameras.push(cam);
	}

	/**
		Removes the Camera from the Scene camera list.
		Attempting to remove current `Scene.interactiveCamera` would cause an exception.
	**/
	public function removeCamera( cam : Camera ) {
		if ( cam == interactiveCamera ) throw "Current interactive Camera cannot be removed from camera list!";
		cam.scene = null;
		_cameras.remove(cam);
	}

	/**
		Set the fixed size for the scene, will prevent automatic scene resizing when screen size changes.
	**/
	@:deprecated("setFixedSize is deprecated, use scaleMode = Stretch(w, h) instead")
	@:dox(hide) @:noCompletion
	public function setFixedSize( w : Int, h : Int ) {
		scaleMode = Stretch(w, h);
	}

	/**
		Recalculates the scene viewport parameters based on `scaleMode`.
	**/
	@:dox(hide) @:noCompletion
	public function checkResize() {
		var engine = h3d.Engine.getCurrent();

		inline function setSceneSize( w : Int, h : Int ) {
			if ( w != this.width || h != this.height ) {
				width = w;
				height = h;
				posChanged = true;
			}
		}

		inline function setViewportScale( sx : Float, sy : Float ) {
			viewportScaleX = sx;
			viewportScaleY = sy;
		}

		inline function calcViewport( horizontal : ScaleModeAlign, vertical : ScaleModeAlign, zoom : Float ) {
			viewportA = (zoom * 2) / engine.width;
			viewportD = (zoom * 2) / engine.height;
			setViewportScale(zoom, zoom);
			if ( horizontal == null ) horizontal = Center;
			switch ( horizontal ) {
				case Left:
					viewportX = -1;
					offsetX = 0;
				case Right:
					viewportX = 1 - (width * viewportA);
					offsetX = engine.width - width * zoom;
				default:
					// Simple `width * viewportA - 0.5` causes gaps between tiles
					viewportX = Math.floor((engine.width - width * zoom) / (zoom * 2)) * viewportA - 1.;
					offsetX = Math.floor((engine.width - width * zoom) / 2);
			}

			if ( vertical == null ) vertical = Center;
			switch ( vertical ) {
				case Top:
					viewportY = -1;
					offsetY = 0;
				case Bottom:
					viewportY = 1 - (height * viewportD);
					offsetY = engine.height - height * zoom;
				default:
					viewportY = Math.floor((engine.height - height * zoom) / (zoom * 2)) * viewportD - 1.;
					offsetY = Math.floor((engine.height - height * zoom) / 2);
			}
		}

		inline function zeroViewport() {
			viewportA = 2 / width;
			viewportD = 2 / height;
			viewportX = -1;
			viewportY = -1;
		}

		switch ( scaleMode ) {
			case Resize:
				setSceneSize(engine.width, engine.height);
				setViewportScale(1, 1);
				zeroViewport();
			case Stretch(_width, _height):
				setSceneSize(_width, _height);
				setViewportScale(engine.width / _width, engine.height / _height);
				zeroViewport();
			case LetterBox(_width, _height, integerScale, horizontalAlign, verticalAlign):
				setSceneSize(_width, _height);
				var zoom = Math.min(engine.width / _width, engine.height / _height);
				if ( integerScale ) {
					zoom = Std.int(zoom);
					if (zoom == 0) zoom = 1;
				}
				calcViewport(horizontalAlign, verticalAlign, zoom);
			case Fixed(_width, _height, zoom, horizontalAlign, verticalAlign):
				setSceneSize(_width, _height);
				calcViewport(horizontalAlign, verticalAlign, zoom);
			case Zoom(level):
				setSceneSize(Math.ceil(engine.width / level), Math.ceil(engine.height / level));
				setViewportScale(level, level);
				zeroViewport();
			case AutoZoom(minWidth, minHeight, integerScaling):
				var zoom = Math.min(engine.width / minWidth, engine.height / minHeight);
				if ( integerScaling ) {
					zoom = Std.int(zoom);
					if ( zoom == 0 ) zoom = 1;
				}
				setSceneSize(Math.ceil(engine.width / zoom), Math.ceil(engine.height / zoom));
				setViewportScale(zoom, zoom);
				zeroViewport();
		}
	}

	inline function screenXToViewport(mx:Float) {
		return @:privateAccess interactiveCamera.screenXToCamera(window.mouseX, window.mouseY);
	}

	inline function screenYToViewport(my:Float) {
		return @:privateAccess interactiveCamera.screenYToCamera(window.mouseX, window.mouseY);
	}

	function get_mouseX() {
		syncPos();
		var dx = screenXToViewport(window.mouseX) - absX;
		if( matC == 0 ) return dx / matA;
		var dy = screenYToViewport(window.mouseY) - absY;
		return (dx * matD - dy * matC) / (matA * matD - matB * matC);
	}

	function get_mouseY() {
		syncPos();
		var dy = screenYToViewport(window.mouseY) - absY;
		if( matB == 0 ) return dy / matD;
		var dx = screenXToViewport(window.mouseX) - absX;
		return (dy * matA - dx * matB) / (matA * matD - matB * matC);
	}

	@:dox(hide) @:noCompletion
	public function dispatchListeners( event : hxd.Event ) {
		screenToViewport(event);
		for( l in eventListeners ) {
			l(event);
			if( !event.propagate ) break;
		}
	}

	@:dox(hide) @:noCompletion
	public function isInteractiveVisible( i : hxd.SceneEvents.Interactive ) : Bool {
		var s : Object = cast i;
		while( s != this ) {
			if( s == null || !s.visible ) return false;
			s = s.parent;
		}
		return true;
	}

	/**
		Returns the topmost visible Interactive at the specified coordinates.
	**/
	public function getInteractive( x : Float, y : Float ) : Interactive {
		var pt = shapePoint;
		for( i in interactive ) {
			if( i.posChanged ) i.syncPos();

			var dx = x - i.absX;
			var dy = y - i.absY;
			var rx = (dx * i.matD - dy * i.matC) * i.invDet;
			var ry = (dy * i.matA - dx * i.matB) * i.invDet;

			if (i.shape != null) {
				pt.set(rx + i.shapeX, ry + i.shapeY);
				if ( !i.shape.contains(pt) ) continue;
			} else {
				if( ry < 0 || rx < 0 || rx >= i.width || ry >= i.height )
					continue;
			}

			// check visibility
			var visible = true;
			var p : Object = i;
			while( p != null ) {
				if( !p.visible ) {
					visible = false;
					break;
				}
				p = p.parent;
			}
			if( !visible ) continue;

			return i;
		}
		return null;
	}

	function screenToViewport( e : hxd.Event ) {
		interactiveCamera.eventToCamera(e);
	}

	@:dox(hide) @:noCompletion
	public function dispatchEvent( event : hxd.Event, to : hxd.SceneEvents.Interactive ) {
		var i : Interactive = cast to;
		screenToViewport(event);
		var dx = event.relX - i.absX;
		var dy = event.relY - i.absY;
		var rx = (dx * i.matD - dy * i.matC) * i.invDet;
		var ry = (dy * i.matA - dx * i.matB) * i.invDet;
		event.relX = rx;
		event.relY = ry;
		i.handleEvent(event);
	}

	@:dox(hide) @:noCompletion
	public function handleEvent( event : hxd.Event, last : hxd.SceneEvents.Interactive ) : hxd.SceneEvents.Interactive {
		screenToViewport(event);
		var ex = event.relX;
		var ey = event.relY;
		var index = last == null ? 0 : interactive.indexOf(cast last) + 1;
		var pt = shapePoint;
		for( idx in index...interactive.length ) {
			var i = interactive[idx];
			if( i == null ) break;

			if( i.invDet == 0 ) {
				// some interactives might have not been yet updated
				// make sure they won't match the collider
				continue;
			}

			var dx = ex - i.absX;
			var dy = ey - i.absY;
			var rx = (dx * i.matD - dy * i.matC) * i.invDet;
			var ry = (dy * i.matA - dx * i.matB) * i.invDet;

			if ( i.shape != null ) {
				// Check collision for Shape Interactive.
				pt.set(rx + i.shapeX,ry + i.shapeY);
				if ( !i.shape.contains(pt) ) continue;
			} else {
				// Check AABB for width/height Interactive.
				if( ry < 0 || rx < 0 || rx >= i.width || ry >= i.height )
					continue;
			}

			// check visibility
			var visible = true;
			var p : Object = i;
			while( p != null ) {
				if( !p.visible ) {
					visible = false;
					break;
				}
				p = p.parent;
			}
			if( !visible ) continue;

			event.relX = rx;
			event.relY = ry;

			i.handleEvent(event);

			if( event.cancel ) {
				event.cancel = false;
				event.propagate = false;
				continue;
			}

			return i;
		}
		return null;
	}

	/**
		Add an event listener that will capture all events that were not caught by an `h2d.Interactive`
	**/
	public function addEventListener( f : hxd.Event -> Void ) {
		eventListeners.push(f);
	}

	/**
		Remove a previously added event listener, returns false it was not part of the event listeners.
	**/
	public function removeEventListener( f : hxd.Event -> Void ) {
		for( e in eventListeners )
			if( Reflect.compareMethods(e, f) ) {
				eventListeners.remove(e);
				return true;
			}
		return false;
	}

	/**
		Starts input events capture and redirects them to `onEvent` method until `Scene.stopDrag` is called.

		While the method name may imply that only mouse events would be captured: This is not the case,
		as it will also capture all other input events, including keyboard events.

		@param onEvent A callback method that receives `hxd.Event` when input event happens.
		Unless `onEvent` sets `Event.propagate` to `true`, event won't be sent to other Interactives.
		@param onCancel An optional callback that is invoked when `Scene.stopDrag` is called.
		@param refEvent For touch events, when defined, only capture events that match the reference `Event.touchId`.
	**/
	public function startCapture( onEvent : hxd.Event -> Void, ?onCancel : Void -> Void, ?touchId : Int ) {
		events.startCapture(function(e) {
			screenToViewport(e);
			onEvent(e);
		},onCancel, touchId);
	}

	/**
		Stops current input event capture.
	**/
	public function stopCapture() {
		events.stopCapture();
	}

	@:deprecated("Renamed to startCapture") @:dox(hide)
	public inline function startDrag( onEvent : hxd.Event -> Void, ?onCancel : Void -> Void, ?refEvent : hxd.Event ) {
		startCapture(onEvent, onCancel, refEvent != null ? refEvent.touchId : null);
	}

	@:deprecated("Renamed to stopCapture") @:dox(hide)
	public inline function stopDrag() {
		stopCapture();
	}

	/**
		Get the currently focused Interactive.
	**/
	public function getFocus() : Interactive {
		if( events == null )
			return null;
		var f = events.getFocus();
		if( f == null )
			return null;
		var i = hxd.impl.Api.downcast(f, h2d.Interactive);
		if( i == null )
			return null;
		return interactive[interactive.indexOf(i)];
	}


	@:allow(h2d)
	function addEventTarget(i:Interactive) {
		// sort by which is over the other in the scene hierarchy
		inline function getLevel(i:Object) {
			var lv = 0;
			while( i != null ) {
				i = i.parent;
				lv++;
			}
			return lv;
		}
		inline function indexOf(p:Object, i:Object) {
			var id = -1;
			for( k in 0...p.children.length )
				if( p.children[k] == i ) {
					id = k;
					break;
				}
			return id;
		}
		var level = getLevel(i);
		for( index in 0...interactive.length ) {
			var i1 : Object = i;
			var i2 : Object = interactive[index];
			var lv1 = level;
			var lv2 = getLevel(i2);
			var p1 : Object = i1;
			var p2 : Object = i2;
			while( lv1 > lv2 ) {
				i1 = p1;
				p1 = p1.parent;
				lv1--;
			}
			while( lv2 > lv1 ) {
				i2 = p2;
				p2 = p2.parent;
				lv2--;
			}
			while( p1 != p2 ) {
				i1 = p1;
				p1 = p1.parent;
				i2 = p2;
				p2 = p2.parent;
			}
			if( indexOf(p1,i1) > indexOf(p2,i2) ) {
				interactive.insert(index, i);
				return;
			}
		}
		interactive.push(i);
	}

	@:allow(h2d)
	function removeEventTarget(i,notify=false) {
		interactive.remove(i);
		if( notify && events != null )
			@:privateAccess events.onRemove(i);
	}

	/**
		Dispose the scene and all its children, freeing used GPU memory.

		If Scene was allocated, causes `Object.onRemove` on all Scene objects.
	**/
	public function dispose() {
		if( allocated )
			onRemove();
		ctx.dispose();
	}

	/**
		<span class="label">Internal usage</span>

		Before `Scene.render` or `Scene.sync` are called, allows to set how much time has elapsed (in seconds) since the last frame in order to update scene animations.
		This is managed automatically by hxd.App.
	**/
	public function setElapsedTime( v : Float ) {
		ctx.elapsedTime = v;
	}

	function drawImplTo( s : Object, texs : Array<h3d.mat.Texture>, ?outputs : Array<hxsl.Output> ) {
		for( t in texs )
			if( !t.flags.has(Target) )
				throw "Can only draw to texture created with Target flag";
		ctx.engine = h3d.Engine.getCurrent();
		var oldBG = ctx.engine.backgroundColor;
		ctx.engine.backgroundColor = null; // prevent clear bg
		if( @:privateAccess !ctx.engine.inRender ) ctx.begin(); // don't reset current tex stack
		ctx.globalAlpha = alpha;
		ctx.begin();
		ctx.pushTargets(texs);
		if( outputs != null ) @:privateAccess ctx.manager.setOutput(outputs);
		s.drawRec(ctx);
		if( outputs != null ) @:privateAccess ctx.manager.setOutput();
		ctx.popTarget();
		ctx.engine.backgroundColor = oldBG;
	}

	/**
		Synchronize the scene without rendering, updating all objects and animations by the given amount of time, in seconds.
	**/
	public function syncOnly( et : Float ) {
		var engine = h3d.Engine.getCurrent();
		setElapsedTime(et);
		ctx.engine = engine;
		ctx.frame++;
		ctx.time += ctx.elapsedTime;
		ctx.globalAlpha = alpha;
		sync(ctx);
	}

	/**
		<span class="label">Internal usage</span>

		Render the scene on the screen.
	**/
	public function render( engine : h3d.Engine ) {
		ctx.engine = engine;
		ctx.frame++;
		ctx.time += ctx.elapsedTime;
		ctx.globalAlpha = alpha;
		sync(ctx);
		if( children.length == 0 ) return;
		ctx.begin();
		ctx.drawScene();
		ctx.end();
	}

	override function sync( ctx : RenderContext ) {
		var forceCamSync = posChanged;
		if( !allocated )
			onAdd();
		super.sync(ctx);
		for ( cam in cameras ) cam.sync(ctx, forceCamSync);
	}

	override function clipBounds(ctx:RenderContext, bounds:h2d.col.Bounds)
	{
		// Scene always uses whole window surface as a filter bounds as to not clip out cameras.
		if ( rotation == 0 ) {
			bounds.addPos(-absX, -absY);
			bounds.addPos(window.width / matA - absX, window.height / matD - absY);
		} else {
			inline function calc(x:Float, y:Float) {
				bounds.addPos(x * matA + y * matC, x * matB + y * matD);
			}
			var ww = window.width / matA - absX;
			var wh = window.height / matD - absY;
			calc(-absX, -absY);
			calc(ww - absX, -absY);
			calc(-absX, wh - absY);
			calc(ww - absX, wh - absY);
		}
		super.clipBounds(ctx, bounds);
	}

	override function drawContent(ctx:RenderContext)
	{
		if( ctx.front2back ) {
			for ( cam in cameras ) {
				if ( !cam.visible ) continue;
				var i = children.length;
				var l = layerCount;
				cam.enter(ctx);
				while ( l-- > 0 ) {
					var top = l == 0 ? 0 : layersIndexes[l - 1];
					if ( cam.layerVisible(l) ) {
						while ( i >= top ) {
							children[i--].drawRec(ctx);
						}
					} else {
						i = top - 1;
					}
				}
				cam.exit(ctx);
			}
			draw(ctx);
		} else {
			draw(ctx);
			for ( cam in cameras ) {
				if ( !cam.visible ) continue;
				var i = 0;
				var l = 0;
				cam.enter(ctx);
				while ( l < layerCount ) {
					var top = layersIndexes[l++];
					if ( cam.layerVisible(l - 1) ) {
						while ( i < top ) {
							children[i++].drawRec(ctx);
						}
					} else {
						i = top;
					}
				}
				cam.exit(ctx);
			}
		}
	}

	override function onAdd() {
		checkResize();
		super.onAdd();
		window.addResizeEvent(checkResize);
	}

	override function onRemove() {
		super.onRemove();
		window.removeResizeEvent(checkResize);
	}

	/**
		Capture the scene into a texture and returns the resulting `h2d.Bitmap`.

		@param target Optional Tile to render onto. If not set, new Texture with interval Scene viewport dimensions is allocated,
		otherwise Tile boundaries and Texture are used.
	**/
	public function captureBitmap( ?target : Tile ) {
		var engine = h3d.Engine.getCurrent();
		if( target == null ) {
			var tex = new h3d.mat.Texture(width, height, [Target]);
			target = new Tile(tex,0, 0, width, height);
		}
		engine.begin();
		engine.setRenderZone(Std.int(target.x), Std.int(target.y), hxd.Math.ceil(target.width), hxd.Math.ceil(target.height));

		var tex = target.getTexture();
		engine.pushTarget(tex);
		var ow = width, oh = height, ova = viewportA, ovd = viewportD, ovx = viewportX, ovy = viewportY;
		width = tex.width;
		height = tex.height;
		viewportA = 2 / width;
		viewportD = 2 / height;
		viewportX = -1;
		viewportY = -1;
		posChanged = true;
		render(engine);
		engine.popTarget();

		width = ow;
		height = oh;
		viewportA = ova;
		viewportD = ovd;
		viewportX = ovx;
		viewportY = ovy;
		posChanged = true;
		engine.setRenderZone();
		engine.end();
		return new Bitmap(target);
	}


}
