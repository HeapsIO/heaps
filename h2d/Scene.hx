package h2d;
import hxd.Math;

class Scene extends Layers implements h3d.IDrawable implements hxd.SceneEvents.InteractiveScene {

	public var width(default,null) : Int;
	public var height(default, null) : Int;

	public var mouseX(get, null) : Float;
	public var mouseY(get, null) : Float;

	public var zoom(get, set) : Int;
	public var defaultSmooth(get, set) : Bool;
	public var renderer(get, set) : RenderContext;

	var fixedSize : Bool;
	var interactive : Array<Interactive>;
	var eventListeners : Array< hxd.Event -> Void >;
	var ctx : RenderContext;
	var stage : hxd.Stage;
	@:allow(h2d.Interactive)
	var events : hxd.SceneEvents;

	public function new() {
		super(null);
		var e = h3d.Engine.getCurrent();
		ctx = new RenderContext(this);
		width = e.width;
		height = e.height;
		interactive = new Array();
		eventListeners = new Array();
		stage = hxd.Stage.getInstance();
		posChanged = true;
	}

	inline function get_defaultSmooth() return ctx.defaultSmooth;
	inline function set_defaultSmooth(v) return ctx.defaultSmooth = v;

	public function setEvents(events) {
		this.events = events;
	}

	function get_zoom() {
		return Std.int(h3d.Engine.getCurrent().width / width);
	}

	function set_zoom(v:Int) {
		var e = h3d.Engine.getCurrent();
		var twidth = Math.ceil(stage.width / v);
		var theight = Math.ceil(stage.height / v);
		var totalWidth = twidth * v;
		var totalHeight = theight * v;
		// increase back buffer size if necessary
		if( totalWidth != e.width || totalHeight != e.height )
			e.resize(totalWidth, totalHeight);
		setFixedSize(twidth, theight);
		return v;
	}

	function get_renderer() return ctx;
	function set_renderer(v) { ctx = v; return v; }

	public function setFixedSize( w, h ) {
		width = w;
		height = h;
		fixedSize = true;
		posChanged = true;
	}

	public function checkResize() {
		if( fixedSize ) return;
		var engine = h3d.Engine.getCurrent();
		if( width != engine.width || height != engine.height ) {
			width = engine.width;
			height = engine.height;
			posChanged = true;
		}
	}
	
	inline function relMouseX() {
		return stage.mouseX * width / stage.width;
	}
	
	inline function relMouseY() {
		return stage.mouseY * height / stage.height;
	}

	function get_mouseX() {
		if (rotation == 0) {
			return relMouseX() / scaleX - absX;
		}
		var mx = relMouseX() - absX;
		var my = relMouseY() - absY;
		var invDet = 1 / (matA * matD - matB * matC);
		return (mx * matD - my * matC) * invDet;
	}

	function get_mouseY() {
		if (rotation == 0) {
			return relMouseY() / scaleY - absY;
		}
		var mx = relMouseX() - absX;
		var my = relMouseY() - absY;
		var invDet = 1 / (matA * matD - matB * matC);
		return (-mx * matB + my * matA) * invDet;
	}

	public function dispatchListeners( event : hxd.Event ) {
		screenToLocal(event);
		for( l in eventListeners ) {
			l(event);
			if( !event.propagate ) break;
		}
	}

	public function isInteractiveVisible( i : hxd.SceneEvents.Interactive ) {
		var s : Sprite = cast i;
		while( s != null ) {
			if( !s.visible ) return false;
			s = s.parent;
		}
		return true;
	}

	/**
	 * Return first Interactive which overlaps with x,y coordinates (Scene space) or null
	 */
	public function getInteractive( x : Float, y : Float ) {
		var rx = x * matA + y * matC + absX;
		var ry = x * matB + y * matD + absY;
		for ( i in interactive ) {

			// check bounds
			var local = toInteractiveLocal(i, rx, ry);
			if (local.x < 0 || local.x > i.width || local.y < 0 || local.y > i.height)
				continue;

			// check visibility
			var visible = true;
			var p : Sprite = i;
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
	
	inline function applyFixedSizeScale( e: hxd.Event ) {
		if (fixedSize) {
			e.relX *= width / stage.width;
			e.relY *= height / stage.height;
		}
	}

	function screenToLocal( e : hxd.Event ) {
		applyFixedSizeScale(e);
		var px = e.relX - absX;
		var py = e.relY - absY;
		var invDet = 1 / (matA * matD - matB * matC);
		e.relX = (px * matD - py * matC) * invDet;
		e.relY = ( -px * matB + py * matA) * invDet;
	}
	
	static inline function toInteractiveLocal( i : Interactive, x : Float, y : Float ) {
		var px = x - i.absX;
		var py = y - i.absY;
		var invDet = 1 / (i.matA * i.matD - i.matB * i.matC);
		var lx = (px * i.matD - py * i.matC) * invDet;
		var ly = ( -px * i.matB + py * i.matA) * invDet;
		return new h2d.col.Point(lx, ly);
	}

	public function dispatchEvent( event : hxd.Event, to : hxd.SceneEvents.Interactive ) {
		var i : Interactive = cast to;
		applyFixedSizeScale(event);
		var local = toInteractiveLocal(i, event.relX, event.relY);
		event.relX = local.x;
		event.relY = local.y;
		i.handleEvent(event);
	}

	public function handleEvent( event : hxd.Event, last : hxd.SceneEvents.Interactive ) : hxd.SceneEvents.Interactive {
		applyFixedSizeScale(event);
		var index = last == null ? 0 : interactive.indexOf(cast last) + 1;
		for( idx in index...interactive.length ) {
			var i = interactive[idx];
			if( i == null ) break;

			// check bounds
			var local = toInteractiveLocal(i, event.relX, event.relY);
			if (local.x < 0 || local.x > i.width || local.y < 0 || local.y > i.height)
				continue;

			// check visibility
			var visible = true;
			var p : Sprite = i;
			while( p != null ) {
				if( !p.visible ) {
					visible = false;
					break;
				}
				p = p.parent;
			}
			if( !visible ) continue;

			event.relX = local.x;
			event.relY = local.y;
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

	public function startDrag( f : hxd.Event -> Void, ?onCancel : Void -> Void, ?refEvent : hxd.Event ) {
		events.startDrag(function(e) {
			screenToLocal(e);
			f(e);
		},onCancel, refEvent);
	}

	public function stopDrag() {
		events.stopDrag();
	}

	public function getFocus() {
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
		inline function getLevel(i:Sprite) {
			var lv = 0;
			while( i != null ) {
				i = i.parent;
				lv++;
			}
			return lv;
		}
		inline function indexOf(p:Sprite, i:Sprite) {
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
			var i1 : Sprite = i;
			var i2 : Sprite = interactive[index];
			var lv1 = level;
			var lv2 = getLevel(i2);
			var p1 : Sprite = i1;
			var p2 : Sprite = i2;
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

	public function dispose() {
		if( allocated )
			onRemove();
		ctx.dispose();
	}

	public function setElapsedTime( v : Float ) {
		ctx.elapsedTime = v;
	}

	function drawImplTo( s : Sprite, t : h3d.mat.Texture ) {

		if( !t.flags.has(Target) ) throw "Can only draw to texture created with Target flag";

		ctx.engine = h3d.Engine.getCurrent();
		ctx.engine.begin();
		ctx.globalAlpha = alpha;
		ctx.begin();
		ctx.pushTarget(t);
		s.drawRec(ctx);
		ctx.popTarget();
		ctx.engine.frameCount--;
	}

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
		if( !fixedSize && (width != ctx.engine.width || height != ctx.engine.height) ) {
			width = ctx.engine.width;
			height = ctx.engine.height;
			posChanged = true;
		}
		super.sync(ctx);
	}

	public function captureBitmap( ?target : Tile ) {
		var engine = h3d.Engine.getCurrent();
		if( target == null ) {
			var tex = new h3d.mat.Texture(width, height, [Target]);
			target = new Tile(tex,0, 0, width, height);
		}
		engine.begin();
		engine.setRenderZone(target.x, target.y, target.width, target.height);

		var tex = target.getTexture();
		engine.pushTarget(tex);
		var ow = width, oh = height, of = fixedSize;
		setFixedSize(tex.width, tex.height);
		render(engine);
		engine.popTarget();

		width = ow;
		height = oh;
		fixedSize = of;
		posChanged = true;
		engine.setRenderZone();
		engine.end();
		engine.frameCount--;
		return new Bitmap(target);
	}


}