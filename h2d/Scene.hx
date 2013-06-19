package h2d;

class Scene extends Layers implements h3d.IDrawable {

	public var width(default,null) : Int;
	public var height(default, null) : Int;
	
	public var mouseX(get, null) : Float;
	public var mouseY(get, null) : Float;
	
	var fixedSize : Bool;
	var interactive : flash.Vector<Interactive>;
	var pendingEvents : flash.Vector<Event>;
	var stage : flash.display.Stage;
	var ctx : RenderContext;
	
	@:allow(h2d.Interactive)
	var currentOver : Interactive;
	var pushList : Array<Interactive>;
	var currentDrag : { f : Event -> Void, ref : Null<Int> };
	
	public function new() {
		super(null);
		var e = h3d.Engine.getCurrent();
		ctx = new RenderContext();
		width = e.width;
		height = e.height;
		interactive = new flash.Vector();
		pushList = new Array();
		stage = flash.Lib.current.stage;
		posChanged = true;
	}
	
	public function setFixedSize( w, h ) {
		width = w;
		height = h;
		fixedSize = true;
		posChanged = true;
	}

	override function onDelete() {
		if( h3d.System.isTouch ) {
			stage.removeEventListener(flash.events.TouchEvent.TOUCH_BEGIN, onTouchDown);
			stage.removeEventListener(flash.events.TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.removeEventListener(flash.events.TouchEvent.TOUCH_END, onTouchUp);
		} else {
			stage.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(flash.events.MouseEvent.MOUSE_WHEEL, onMouseWheel);
			flash.ui.Mouse.cursor = flash.ui.MouseCursor.AUTO;
		}
		super.onDelete();
	}
	
	override function onAlloc() {
		if( h3d.System.isTouch ) {
			flash.ui.Multitouch.inputMode = flash.ui.MultitouchInputMode.TOUCH_POINT;
			stage.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, onTouchDown);
			stage.addEventListener(flash.events.TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(flash.events.TouchEvent.TOUCH_END, onTouchUp);
		} else {
			stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		super.onAlloc();
	}
	
	function screenXToLocal(mx:Float) {
		return (mx - x) * width / (stage.stageWidth * scaleX);
	}

	function screenYToLocal(my:Float) {
		return (my - y) * height / (stage.stageHeight * scaleY);
	}
	
	function get_mouseX() {
		return screenXToLocal(stage.mouseX);
	}

	function get_mouseY() {
		return screenYToLocal(stage.mouseY);
	}
			
	function onMouseDown(e:Dynamic) {
		if( pendingEvents != null )
			pendingEvents.push(new Event(EPush, mouseX, mouseY));
	}

	function onMouseUp(e:Dynamic) {
		if( pendingEvents != null )
			pendingEvents.push(new Event(ERelease, mouseX, mouseY));
	}
	
	function onMouseMove(e:Dynamic) {
		if( pendingEvents != null )
			pendingEvents.push(new Event(EMove, mouseX, mouseY));
	}
	
	function onMouseWheel(e:flash.events.MouseEvent) {
		if( pendingEvents != null ) {
			var ev = new Event(EWheel, mouseX, mouseY);
			ev.wheelDelta = -e.delta / 3.0;
			pendingEvents.push(ev);
		}
	}
	
	function onTouchDown(e:flash.events.TouchEvent) {
		if( pendingEvents != null ) {
			var ev = new Event(EPush, screenXToLocal(e.localX), screenYToLocal(e.localY));
			ev.touchId = e.touchPointID;
			pendingEvents.push(ev);
		}
	}

	function onTouchUp(e:flash.events.TouchEvent) {
		if( pendingEvents != null ) {
			var ev = new Event(ERelease, screenXToLocal(e.localX), screenYToLocal(e.localY));
			ev.touchId = e.touchPointID;
			pendingEvents.push(ev);
		}
	}
	
	function onTouchMove(e:flash.events.TouchEvent) {
		if( pendingEvents != null ) {
			var ev = new Event(EMove, screenXToLocal(e.localX), screenYToLocal(e.localY));
			ev.touchId = e.touchPointID;
			pendingEvents.push(ev);
		}
	}
	
	function emitEvent( event : Event ) {
		var x = event.relX, y = event.relY;
		var rx = x * matA + y * matB + absX;
		var ry = x * matC + y * matD + absY;
		var r = height / width;
		var checkOver = false, checkPush = false;
		switch( event.kind ) {
		case EMove: checkOver = true;
		case EPush, ERelease: checkPush = true;
		default:
		}
		for( i in interactive ) {
			// TODO : we are not sure that the positions are correctly updated !
			
			// this is a bit tricky since we are not in the not-euclide viewport space
			// (r = ratio correction)
			var dx = rx - i.absX;
			var dy = ry - i.absY;
			
			var w1 = i.width * i.matA * r;
			var h1 = i.width * i.matC;
			var ky = h1 * dx - w1 * dy;
			// up line
			if( ky < 0 )
				continue;
				
			var w2 = i.height * i.matB * r;
			var h2 = i.height * i.matD;
			var kx = w2 * dy - h2 * dx;
				
			// left line
			if( kx < 0 )
				continue;
			
			var max = h1 * w2 - w1 * h2;
			// bottom/right
			if( ky >= max || kx * r >= max )
				continue;

						
			event.relX = (kx * r / max) * i.width;
			event.relY = (ky / max) * i.height;
			
			i.handleEvent(event);
			if( event.cancel )
				event.cancel = false;
			else if( checkOver ) {
				if( currentOver != i ) {
					var old = event.propagate;
					if( currentOver != null ) {
						event.kind = EOut;
						// relX/relY is not correct here
						currentOver.handleEvent(event);
					}
					event.kind = EOver;
					event.cancel = false;
					i.handleEvent(event);
					if( event.cancel )
						currentOver = null;
					else {
						currentOver = i;
						checkOver = false;
					}
					event.kind = EMove;
					event.cancel = false;
					event.propagate = old;
				} else
					checkOver = false;
			} else if( checkPush ) {
				if( event.kind == EPush )
					pushList.push(i);
				else
					pushList.remove(i);
			}
				
			if( event.propagate ) {
				event.propagate = false;
				continue;
			}
			break;
		}
		if( checkOver && currentOver != null ) {
			event.kind = EOut;
			currentOver.handleEvent(event);
			event.kind = EMove;
			currentOver = null;
		}
	}
	
	public function checkEvents() {
		if( pendingEvents == null ) {
			if( interactive.length == 0 )
				return;
			pendingEvents = new flash.Vector();
		}
		var old = pendingEvents;
		if( old.length == 0 )
			return;
		pendingEvents = null;
		for( e in old ) {
			if( currentDrag != null && (currentDrag.ref == null || currentDrag.ref == e.touchId) ) {
				currentDrag.f(e);
				if( e.cancel )
					continue;
			}
			emitEvent(e);
			if( e.kind == ERelease && pushList.length > 0 ) {
				for( i in pushList ) {
					// relX/relY is not correct here
					i.handleEvent(e);
				}
				pushList = new Array();
			}
		}
		if( interactive.length > 0 )
			pendingEvents = new flash.Vector();
	}
	
	public function startDrag( f : Event -> Void, ?refEvent : Event ) {
		currentDrag = { f : f, ref : refEvent == null ? null : refEvent.touchId };
	}
	
	public function stopDrag() {
		currentDrag = null;
	}
	
	@:allow(h2d)
	function addEventTarget(i) {
		// latest added gets priority
		interactive.unshift(i);
	}
	
	@:allow(h2d)
	function removeEventTarget(i) {
		for( k in 0...interactive.length )
			if( interactive[k] == i ) {
				interactive.splice(k, 1);
				break;
			}
	}

	override function calcAbsPos() {
		// init matrix without rotation
		matA = scaleX;
		matB = 0;
		matC = 0;
		matD = scaleY;
		absX = x;
		absY = y;
		
		// adds a pixels-to-viewport transform
		var w = 2 / width;
		var h = -2 / height;
		absX = absX * w - 1;
		absY = absY * h + 1;
		matA *= w;
		matB *= h;
		matC *= w;
		matD *= h;
		
		// perform final rotation around center
		if( rotation != 0 ) {
			var cr = h3d.FMath.cos(rotation);
			var sr = h3d.FMath.sin(rotation);
			var tmpA = matA * cr + matB * sr;
			var tmpB = matA * -sr + matB * cr;
			var tmpC = matC * cr + matD * sr;
			var tmpD = matC * -sr + matD * cr;
			var tmpX = absX * cr + absY * sr;
			var tmpY = absX * -sr + absY * cr;
			matA = tmpA;
			matB = tmpB;
			matC = tmpC;
			matD = tmpD;
			absX = tmpX;
			absY = tmpY;
		}
	}
	
	public function dispose() {
		if( allocated )
			onDelete();
	}
	
	public function render( engine : h3d.Engine ) {
		ctx.engine = engine;
		ctx.frame++;
		ctx.time += ctx.elapsedTime;
		ctx.currentPass = 0;
		sync(ctx);
		drawRec(ctx);
	}
	
	override function sync( ctx : RenderContext ) {
		if( !allocated )
			onAlloc();
		if( !fixedSize && (width != ctx.engine.width || height != ctx.engine.height) ) {
			width = ctx.engine.width;
			height = ctx.engine.height;
			posChanged = true;
		}
		Tools.checkCoreObjects();
		super.sync(ctx);
	}
	
	public function captureBitmap( ?target : Tile ) {
		var engine = h3d.Engine.getCurrent();
		if( target == null ) {
			var tw = 1, th = 1;
			while( tw < width ) tw <<= 1;
			while( th < height ) th <<= 1;
			var tex = engine.mem.allocTargetTexture(tw, th);
			target = new Tile(tex,0, 0, width, height);
		}
		engine.begin();
		engine.setRenderZone(target.x, target.y, target.width, target.height);
		var tex = target.getTexture();
		engine.setTarget(tex);
		var ow = width, oh = height, of = fixedSize;
		setFixedSize(tex.width, tex.height);
		render(engine);
		width = ow;
		height = oh;
		fixedSize = of;
		posChanged = true;
		engine.setTarget(null);
		engine.setRenderZone();
		engine.end();
		return new Bitmap(target);
	}
	
	
}