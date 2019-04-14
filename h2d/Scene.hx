package h2d;
import hxd.Math;

/**
	Scaling mode of the 2D Scene.
**/
enum ScaleMode
{
	/**
		Fills entire screen. `width` and `height` of Scene will match window size. Default scaling mode.
	**/
	Fill;
	/**
		Stretches the Scene to fill entire screen. This behavior is same as old `setFixedSize` method.
	**/
	Stretch(width : Int, height : Int);
	/**
		Preserves aspect-ratio when scaling the Scene.  
		If `centerViewport` is `true` - Scene will be centered relative to window size.
	**/
	KeepAspect(width : Int, height : Int, centerViewport : Bool);
	/**
		Same as KeepAspect, but using integer scaling.
	**/
	KeepPixelSize(width : Int, height : Int, centerViewport : Bool);
	/**
		Forces exact dimensions disregarding size of the window.
	**/
	Exact(width : Int, height : Int, zoom : Float, centerViewport : Bool);
	/**
		Same as Fill, but scales Scene according to `level`. This mode resizes Engine in some cases.
	**/
	Zoom(level : Float);
	/**
		Same as KeepAspect, but instead of fixed `width`/`height` it will be adjusted to fill entire screen. This mode resizes Engine in some cases.
	**/
	EnsureArea(width : Int, height : Int);
	/**
		Same as EnsureArea, but using integer scaling. This mode resizes Engine in some cases.
	**/
	EnsurePixelArea(width : Int, height : Int);
}

/**
	h2d.Scene is the root class for a 2D scene. All root objects are added to it before being drawn on screen.
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
		Horizontal viewport offset relative to top-left corner of the window. Can change if the screen gets resized or `scaleMode` changes.  
		Offset is in internal Scene resolution pixels.
	**/
	public var viewportX(default, null) : Float;
	/**
		Vertical viewport offset relative to top-left corner of the window. Can change if the screen gets resized or `scaleMode` changes.  
		Offset is in internal Scene resolution pixels.
	**/
	public var viewportY(default, null) : Float;
	/**
		Physical vertical viewport offset relative to the center of the window. Assigned if the screen gets resized or `scaleMode` changes.  
		Offset is in internal Scene resolution pixels.
	**/
	public var offsetX : Float;
	/**
		Physical horizontal viewport offset relative to the center of the window. Assigned if the screen gets resized or `scaleMode` changes.  
		Offset is in internal Scene resolution pixels.
	**/
	public var offsetY : Float;

	/**
		Horizontal ratio of the window used by the Scene (including scaling). Can change if the screen gets resized or `scaleMode` changes.
	**/
	public var ratioX(default, null) : Float;
	/**
		Vertical ratio of the window used by the Scene (including scaling). Can change if the screen gets resized or `scaleMode` changes.
	**/
	public var ratioY(default, null) : Float;

	/**
		The current mouse X coordinates (in pixel) relative to the scene.
	**/
	public var mouseX(get, null) : Float;

	/**
		The current mouse Y coordinates (in pixel) relative to the scene.
	**/
	public var mouseY(get, null) : Float;

	/**
		The zoom factor of the scene, allows to set a fixed x2, x4 etc. zoom for pixel art
		When setting a zoom > 0, the scene resize will be automaticaly managed.
	**/
	@:deprecated("zoom is deprecated, use scaleMode = Zoom(v) instead")
	public var zoom(get, set) : Int;

	/**
		Scene scaling mode. ( default : Fill )
		Important thing to keep in mind - Scene does not restrict rendering to it's scaled size and
		graphics can render outside of it. However `drawTile` does check for those bounds and 
		will clip out tiles that are outside of the scene bounds.
	**/
	public var scaleMode(default, set) : ScaleMode = Fill;

	/**
		Set the default value for `h2d.Drawable.smooth` (default: false)
	**/
	public var defaultSmooth(get, set) : Bool;

	/**
		The scene current renderer. Can be customized.
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
		Create a new scene. A default 2D scene is already available in `hxd.App.s2d`
	**/
	public function new() {
		super(null);
		var e = h3d.Engine.getCurrent();
		ctx = new RenderContext(this);
		width = e.width;
		height = e.height;
		offsetX = 0;
		offsetY = 0;
		ratioX = 1;
		ratioY = 1;
		viewportX = 0;
		viewportY = 0;
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

	/**
		Set the fixed size for the scene, will prevent automatic scene resizing when screen size changes.
	**/
	@:deprecated("setFixedSize is deprecated, use scaleMode = Strech(w, h) instead")
	public function setFixedSize( w : Int, h : Int ) {
		scaleMode = Stretch(w, h);
	}

	@:dox(hide) @:noCompletion
	public function checkResize() {
		var engine = h3d.Engine.getCurrent();
		inline function calcRatio( scale : Float ) {
			ratioX = (width * scale) / engine.width;
			ratioY = (height * scale) / engine.height;
		}

		inline function calcViewport( center : Bool, zoom : Float ) {
			if ( center ) {
				offsetX = 0;
				offsetY = 0;
				viewportX = (engine.width - width * zoom) / (2 * zoom);
				viewportY = (engine.height - height * zoom) / (2 * zoom);
			} else {
				offsetX = (engine.width - width * zoom) / (2 * zoom);
				offsetY = (engine.height - height * zoom) / (2 * zoom);
				viewportX = 0;
				viewportY = 0;
			}
		}
		inline function zeroViewport() {
			offsetX = 0;
			offsetY = 0;
			viewportX = 0;
			viewportY = 0;
		}

		switch ( scaleMode ) {
			case Fill:
				width = engine.width;
				height = engine.height;
				ratioX = 1;
				ratioY = 1;
				zeroViewport();
			case Stretch(_width, _height):
				width = _width;
				height = _height;
				ratioX = 1;
				ratioY = 1;
				zeroViewport();
			case KeepAspect(_width, _height, centerViewport):
				width = _width;
				height = _height;
				var zoom = Math.min(engine.width / _width, engine.height / _height);
				calcRatio(zoom);
				calcViewport(centerViewport, zoom);
			case KeepPixelSize(_width, _height, centerViewport):
				width = _width;
				height = _height;
				var zoom = Std.int(Math.min(engine.width / _width, engine.height / _height));
				if (zoom == 0) zoom = 1;
				calcRatio(zoom);
				calcViewport(centerViewport, zoom);
			case Exact(_width, _height, zoom, centerViewport):
				width = _width;
				height = _height;
				calcRatio(zoom);
				calcViewport(centerViewport, zoom);
			case Zoom(level):
				width = Math.ceil(engine.width / level);
				height = Math.ceil(engine.height / level);
				var bufWidth = Math.ceil(width * level);
				var bufHeight = Math.ceil(height * level);
				if (engine.width != bufWidth || engine.height != bufHeight) {
					engine.resize(bufWidth, bufHeight);
				}
				calcRatio(level);
				zeroViewport();
			case EnsureArea(_width, _height):
				var zoom = Math.min(engine.width / _width, engine.height / _height);
				width = Math.ceil(engine.width / zoom);
				height = Math.ceil(engine.height / zoom);
				var bufWidth = Math.ceil(width * zoom);
				var bufHeight = Math.ceil(height * zoom);
				if (engine.width != bufWidth || engine.height != bufHeight) {
					engine.resize(bufWidth, bufHeight);
				}
				calcRatio(zoom);
				zeroViewport();
			case EnsurePixelArea(_width, _height):
				var zoom = Std.int(Math.min(engine.width / _width, engine.height / _height));
				if (zoom == 0) zoom = 1;
				width = Math.ceil(engine.width / zoom);
				height = Math.ceil(engine.height / zoom);
				var bufWidth = Math.ceil(width * zoom);
				var bufHeight = Math.ceil(height * zoom);
				if (engine.width != bufWidth || engine.height != bufHeight) {
					engine.resize(bufWidth, bufHeight);
				}
				calcRatio(zoom);
				zeroViewport();
		}
		posChanged = true;
	}

	inline function screenXToLocal(mx:Float) {
		return mx * width / (window.width * ratioX * scaleX) - x - viewportX;
	}

	inline function screenYToLocal(my:Float) {
		return my * height / (window.height * ratioY * scaleY) - y - viewportY;
	}

	function get_mouseX() {
		return screenXToLocal(window.mouseX);
	}

	function get_mouseY() {
		return screenYToLocal(window.mouseY);
	}

	@:dox(hide) @:noCompletion
	public function dispatchListeners( event : hxd.Event ) {
		screenToLocal(event);
		for( l in eventListeners ) {
			l(event);
			if( !event.propagate ) break;
		}
	}

	@:dox(hide) @:noCompletion
	public function isInteractiveVisible( i : hxd.SceneEvents.Interactive ) : Bool {
		var s : Object = cast i;
		while( s != null ) {
			if( !s.visible ) return false;
			s = s.parent;
		}
		return true;
	}

	/**
		Return the topmost visible Interactive at the specific coordinates
	**/
	public function getInteractive( x : Float, y : Float ) : Interactive {
		var rx = x * matA + y * matB + absX;
		var ry = x * matC + y * matD + absY;
		var pt = shapePoint;
		for( i in interactive ) {

			var dx = rx - i.absX;
			var dy = ry - i.absY;

			var w1 = i.width * i.matA;
			var h1 = i.width * i.matC;
			var ky = h1 * dx + w1 * dy;

			// up line
			if( ky < 0 )
				continue;

			var w2 = i.height * i.matB;
			var h2 = i.height * i.matD;
			var kx = w2 * dy + h2 * dx;

			// left line
			if( kx < 0 )
				continue;

			var max = w1 * h2 - h1 * w2;

			// bottom/right
			if( ky >= max || kx >= max )
				continue;

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

			if (i.shape != null) {
				pt.set((kx / max) * i.width + i.shapeX, (ky / max) * i.height + i.shapeY);
				if ( !i.shape.contains(pt) ) continue;
			}

			return i;
		}
		return null;
	}

	function screenToLocal( e : hxd.Event ) {
		var x = screenXToLocal(e.relX);
		var y = screenYToLocal(e.relY);
		var rx = x * matA + y * matB + absX;
		var ry = x * matC + y * matD + absY;
		e.relX = rx;
		e.relY = ry;
	}

	@:dox(hide) @:noCompletion
	public function dispatchEvent( event : hxd.Event, to : hxd.SceneEvents.Interactive ) {
		var i : Interactive = cast to;
		screenToLocal(event);

		var rx = event.relX;
		var ry = event.relY;

		var dx = rx - i.absX;
		var dy = ry - i.absY;

		var w1 = i.width * i.matA;
		var h1 = i.width * i.matC;
		var ky = h1 * dx + w1 * dy;

		var w2 = i.height * i.matB;
		var h2 = i.height * i.matD;
		var kx = w2 * dy + h2 * dx;

		var max = w1 * h2 - h1 * w2;

		event.relX = (kx / max) * i.width;
		event.relY = (ky / max) * i.height;

		i.handleEvent(event);
	}

	@:dox(hide) @:noCompletion
	public function handleEvent( event : hxd.Event, last : hxd.SceneEvents.Interactive ) : hxd.SceneEvents.Interactive {
		screenToLocal(event);
		var rx = event.relX;
		var ry = event.relY;
		var index = last == null ? 0 : interactive.indexOf(cast last) + 1;
		var pt = shapePoint;
		for( idx in index...interactive.length ) {
			var i = interactive[idx];
			if( i == null ) break;

			var dx = rx - i.absX;
			var dy = ry - i.absY;

			if ( i.shape != null ) {
				// Check collision for Shape Interactive.

				pt.set(( dx * i.matD - dy * i.matC) * i.invDet + i.shapeX,
				       (-dx * i.matB + dy * i.matA) * i.invDet + i.shapeY);
				if ( !i.shape.contains(pt) ) continue;

				dx = pt.x - i.shapeX;
				dy = pt.y - i.shapeY;

			} else {
				// Check AABB for width/height Interactive.

				var w1 = i.width * i.matA;
				var h1 = i.width * i.matC;
				var ky = h1 * dx + w1 * dy;

				// up line
				if( ky < 0 )
					continue;

				var w2 = i.height * i.matB;
				var h2 = i.height * i.matD;
				var kx = w2 * dy + h2 * dx;

				// left line
				if( kx < 0 )
					continue;

				var max = w1 * h2 - h1 * w2;

				// bottom/right
				if( ky >= max || kx >= max )
					continue;

				dx = (kx / max) * i.width;
				dy = (ky / max) * i.height;
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

			event.relX = dx;
			event.relY = dy;

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

	/**
		Start a drag and drop operation, sending all events to `onEvent` instead of the scene until `stopDrag()` is called.
		@param	onCancel	If defined, will be called when stopDrag is called
		@param	refEvent	For touch events, only capture events that matches the reference event touchId
	**/
	public function startDrag( onEvent : hxd.Event -> Void, ?onCancel : Void -> Void, ?refEvent : hxd.Event ) {
		events.startDrag(function(e) {
			screenToLocal(e);
			onEvent(e);
		},onCancel, refEvent);
	}

	/**
		Stop the current drag and drop operation
	**/
	public function stopDrag() {
		events.stopDrag();
	}

	/**
		Get the currently focused Interactive
	**/
	public function getFocus() : Interactive {
		if( events == null )
			return null;
		var f = events.getFocus();
		if( f == null )
			return null;
		var i = Std.instance(f, h2d.Interactive);
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
		Dispose the scene and all its children, freeing used GPU memory
	**/
	public function dispose() {
		if( allocated )
			onRemove();
		ctx.dispose();
	}

	/**
		Before render() or sync() are called, allow to set how much time has elapsed (in seconds) since the last frame in order to update scene animations.
		This is managed automatically by hxd.App
	**/
	public function setElapsedTime( v : Float ) {
		ctx.elapsedTime = v;
	}

	function drawImplTo( s : Object, t : h3d.mat.Texture ) {

		if( !t.flags.has(Target) ) throw "Can only draw to texture created with Target flag";
		var needClear = !t.flags.has(WasCleared);
		ctx.engine = h3d.Engine.getCurrent();
		ctx.engine.begin();
		ctx.globalAlpha = alpha;
		ctx.begin();
		ctx.pushTarget(t);
		if( needClear )
			ctx.engine.clear(0);
		s.drawRec(ctx);
		ctx.popTarget();
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
		Render the scene on screen. Internal usage only.
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
		if( !allocated )
			onAdd();
		super.sync(ctx);
	}

	override function onAdd()
	{
		checkResize();
		super.onAdd();
		window.addResizeEvent(checkResize);
	}

	override function onRemove()
	{
		super.onRemove();
		window.removeResizeEvent(checkResize);
	}

	/**
		Capture the scene into a texture and render the resulting Bitmap
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
		var ow = width, oh = height, ox = offsetX, oy = offsetY;
		var ovx = viewportX, ovy = viewportY, orx = ratioX, ory = ratioY;
		width = tex.width;
		height = tex.height;
		ratioX = 1;
		ratioY = 1;
		offsetX = 0;
		offsetY = 0;
		viewportX = 0;
		viewportY = 0;
		posChanged = true;
		render(engine);
		engine.popTarget();

		width = ow;
		height = oh;
		ratioX = orx;
		ratioY = ory;
		offsetX = ox;
		offsetY = oy;
		viewportX = ovx;
		viewportY = ovy;
		posChanged = true;
		engine.setRenderZone();
		engine.end();
		return new Bitmap(target);
	}


}
