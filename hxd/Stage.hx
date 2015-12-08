package hxd;

class Stage {

	/**
		Touch is enabled by default and will be activated if the screen has touch capacities (see hxd.System.isTouch).
		But for Flash/AIR Desktop, you might prefer to disable it in order to keep mouse/keys events.
	**/
	public static var ENABLE_TOUCH = true;

	#if (flash || openfl || nme)
	var stage : flash.display.Stage;
	var fsDelayed : Bool;
	#end
	var resizeEvents : List<Void -> Void>;
	var eventTargets : List<Event -> Void>;

	#if js
	@:allow(hxd)
	static function getCanvas() {
		var canvas : js.html.CanvasElement = cast js.Browser.document.getElementById("webgl");
		if( canvas == null ) throw "Missing canvas#webgl";
		return canvas;
	}
	var canvas : js.html.CanvasElement;
	var canvasPos : js.html.ClientRect;
	#end

	public var width(get, null) : Int;
	public var height(get, null) : Int;
	public var mouseX(get, null) : Int;
	public var mouseY(get, null) : Int;
	public var mouseLock(get, set) : Bool;

	function new() {
		eventTargets = new List();
		resizeEvents = new List();
		#if (flash || openfl || nme)
		stage = flash.Lib.current.stage;
		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.addEventListener(flash.events.Event.RESIZE, onResize);
		initGesture(false);
		#elseif js
		canvas = getCanvas();
		canvasPos = canvas.getBoundingClientRect();
		js.Browser.window.addEventListener("mousedown", onMouseDown);
		js.Browser.window.addEventListener("mousemove", onMouseMove);
		js.Browser.window.addEventListener("mouseup", onMouseUp);
		js.Browser.window.addEventListener("mousewheel", onMouseWheel);
		js.Browser.window.addEventListener("keydown", onKeyDown);
		js.Browser.window.addEventListener("keyup", onKeyUp);
		canvas.addEventListener("mousedown", function(e) {
			onMouseDown(e);
			e.stopPropagation();
			e.preventDefault();
		});
		var curW = this.width, curH = this.height;
		var t0 = new haxe.Timer(100);
		t0.run = function() {
			canvasPos = canvas.getBoundingClientRect();
			var cw = this.width, ch = this.height;
			if( curW != cw || curH != ch ) {
				curW = cw;
				curH = ch;
				onResize(null);
			}
		};
		#end
		#if flash
		if( untyped hxd.System.isAir() )
			setupOnCloseEvent();
		#end
	}
	
	#if (flash || openfl)

	function initGesture(b) {
		if( hxd.System.isTouch && ENABLE_TOUCH ) {
			if( b )  {
				flash.ui.Multitouch.inputMode = flash.ui.MultitouchInputMode.GESTURE;
				stage.removeEventListener(flash.events.TouchEvent.TOUCH_BEGIN, onTouchDown);
				stage.removeEventListener(flash.events.TouchEvent.TOUCH_MOVE, onTouchMove);
				stage.removeEventListener(flash.events.TouchEvent.TOUCH_END, onTouchUp);
				stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
				stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
			} else {
				flash.ui.Multitouch.inputMode = flash.ui.MultitouchInputMode.TOUCH_POINT;
				stage.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, onTouchDown);
				stage.addEventListener(flash.events.TouchEvent.TOUCH_MOVE, onTouchMove);
				stage.addEventListener(flash.events.TouchEvent.TOUCH_END, onTouchUp);
				stage.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
				stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
			}
		} else {
			stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(flash.events.KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(flash.events.MouseEvent.RIGHT_MOUSE_DOWN, onRMouseDown);
			stage.addEventListener(flash.events.MouseEvent.RIGHT_MOUSE_UP, onRMouseUp);
		}
	}

	function setupOnCloseEvent() {
		var nw : flash.events.EventDispatcher = Reflect.field(stage, "nativeWindow");
		if( nw == null ) return;
		nw.addEventListener("closing", function(e:flash.events.Event) {
			if( !onClose() )
				e.preventDefault();
		});
	}
	#end

	public dynamic function onClose() {
		return true;
	}

	public function event( e : hxd.Event ) {
		for( et in eventTargets )
			et(e);
	}

	public function addEventTarget(et) {
		eventTargets.add(et);
	}

	public function removeEventTarget(et) {
		eventTargets.remove(et);
	}

	public function addResizeEvent( f : Void -> Void ) {
		resizeEvents.push(f);
	}

	public function removeResizeEvent( f : Void -> Void ) {
		resizeEvents.remove(f);
	}

	function onResize(e:Dynamic) {
		for( r in resizeEvents )
			r();
	}

	public function setFullScreen( v : Bool ) {
		#if flash
		var isAir = flash.system.Capabilities.playerType == "Desktop";
		var state = v ? (isAir ? flash.display.StageDisplayState.FULL_SCREEN_INTERACTIVE : flash.display.StageDisplayState.FULL_SCREEN) : flash.display.StageDisplayState.NORMAL;
		if( stage.displayState != state ) {
			var t = flash.Lib.getTimer();
			// delay first fullsrceen toggle on OSX/Air to prevent the command window to spawn over
			if( v && isAir && t < 5000 && !fsDelayed && flash.system.Capabilities.os.indexOf("Mac") != -1 ) {
				fsDelayed = true;
				haxe.Timer.delay(function() this.setFullScreen(v), 1000);
				return;
			}
			stage.displayState = state;
		}
		#elseif hxsdl
		var win = @:privateAccess System.win;
		win.fullScreen = v;
		#end
	}

	static var inst = null;
	public static function getInstance() {
		if( inst == null ) inst = new Stage();
		return inst;
	}

#if (flash || openfl || nme)

	inline function get_mouseX() {
		return Std.int(stage.mouseX);
	}

	inline function get_mouseY() {
		return Std.int(stage.mouseY);
	}

	inline function get_width() {
		return stage.stageWidth;
	}

	inline function get_height() {
		return stage.stageHeight;
	}

	inline function get_mouseLock() {
		#if cpp
		return false;
		#else
		return stage.mouseLock;
		#end
	}

	inline function set_mouseLock(v) {
		#if cpp
		return false;
		#else
		return stage.mouseLock = v;
		#end
	}

	function onMouseDown(e:Dynamic) {
		event(new Event(EPush, mouseX, mouseY));
	}

	function onRMouseDown(e:Dynamic) {
		var e = new Event(EPush, mouseX, mouseY);
		e.button = 1;
		event(e);
	}

	function onMouseUp(e:Dynamic) {
		event(new Event(ERelease, mouseX, mouseY));
	}

	function onRMouseUp(e:Dynamic) {
		var e = new Event(ERelease, mouseX, mouseY);
		e.button = 1;
		event(e);
	}

	function onMouseMove(e:Dynamic) {
		event(new Event(EMove, mouseX, mouseY));
	}

	function onMouseWheel(e:flash.events.MouseEvent) {
		var ev = new Event(EWheel, mouseX, mouseY);
		ev.wheelDelta = -e.delta / 3.0;
		event(ev);
	}

	function onKeyUp(e:flash.events.KeyboardEvent) {
		var ev = new Event(EKeyUp, mouseX, mouseY);
		ev.keyCode = e.keyCode;
		ev.charCode = getCharCode(e);
		event(ev);
	}

	function onKeyDown(e:flash.events.KeyboardEvent) {
		var ev = new Event(EKeyDown, mouseX, mouseY);
		ev.keyCode = e.keyCode;
		ev.charCode = getCharCode(e);
		event(ev);
		#if flash
		// prevent escaping fullscreen in air
		if( e.keyCode == flash.ui.Keyboard.ESCAPE ) e.preventDefault();
		if( e.keyCode == "S".code && e.ctrlKey ) e.preventDefault();
		// prevent ALT menu (sadly DONT WORK)
		if( e.keyCode == 18 ) {
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
		}
		// prevent back exiting app in mobile
		if( e.keyCode == flash.ui.Keyboard.BACK ) {
			e.preventDefault();
			e.stopImmediatePropagation();
		}
		#end
	}

	function getCharCode( e : flash.events.KeyboardEvent ) {
		#if cpp
		return e.charCode;
		#else
		// disable some invalid charcodes
		if( e.keyCode == 27 ) e.charCode = 0;
		// Flash charCode are not valid, they assume an english keyboard. Let's do some manual translation here (to complete with command keyboards)
		switch( flash.system.Capabilities.language ) {
		case "fr":
			return switch( e.keyCode ) {
			case 49: if( e.altKey ) 0 else if( e.shiftKey ) '1'.code else e.charCode;
			case 50: if( e.altKey ) '~'.code else if( e.shiftKey ) '2'.code else e.charCode;
			case 51: if( e.altKey ) '#'.code else if( e.shiftKey ) '3'.code else e.charCode;
			case 52: if( e.altKey ) '{'.code else if( e.shiftKey ) '4'.code else e.charCode;
			case 53: if( e.altKey ) '['.code else if( e.shiftKey ) '5'.code else e.charCode;
			case 54: if( e.altKey ) '|'.code else if( e.shiftKey ) '6'.code else e.charCode;
			case 55: if( e.altKey ) '`'.code else if( e.shiftKey ) '7'.code else e.charCode;
			case 56: if( e.altKey ) '\\'.code else if( e.shiftKey ) '8'.code else e.charCode;
			case 57: if( e.altKey ) '^'.code else if( e.shiftKey ) '9'.code else e.charCode;
			case 48: if( e.altKey ) '@'.code else if( e.shiftKey ) '0'.code else e.charCode;
			case 219: if( e.altKey ) ']'.code else if( e.shiftKey ) '°'.code else e.charCode;
			case 187: if( e.altKey ) '}'.code else if( e.shiftKey ) '+'.code else e.charCode;
			case 188: if( e.altKey ) 0 else if( e.shiftKey ) '?'.code else e.charCode;
			case 190: if( e.altKey ) 0 else if( e.shiftKey ) '.'.code else e.charCode;
			case 191: if( e.altKey ) 0 else if( e.shiftKey ) '/'.code else e.charCode;
			case 223: if( e.altKey ) 0 else if( e.shiftKey ) '§'.code else e.charCode;
			case 192: if( e.altKey ) 0 else if( e.shiftKey ) '%'.code else e.charCode;
			case 220: if( e.altKey ) 0 else if( e.shiftKey ) 'µ'.code else e.charCode;
			case 221: if( e.altKey ) 0 else if( e.shiftKey ) '¨'.code else '^'.code;
			case 186: if( e.altKey ) '¤'.code else if( e.shiftKey ) '£'.code else e.charCode;
			default:
				e.charCode;
			}
		default:
			return e.charCode;
		}
		#end
	}

	function onTouchDown(e:flash.events.TouchEvent) {
		var ev = new Event(EPush, e.localX, e.localY);
		ev.touchId = e.touchPointID;
		event(ev);
	}

	function onTouchUp(e:flash.events.TouchEvent) {
		var ev = new Event(ERelease, e.localX, e.localY);
		ev.touchId = e.touchPointID;
		event(ev);
	}

	function onTouchMove(e:flash.events.TouchEvent) {
		var ev = new Event(EMove, e.localX, e.localY);
		ev.touchId = e.touchPointID;
		event(ev);
	}

#elseif js

	var curMouseX : Float = 0.;
	var curMouseY : Float = 0.;

	function get_width() {
		return Math.round(canvasPos.width * js.Browser.window.devicePixelRatio);
	}

	function get_height() {
		return Math.round(canvasPos.height * js.Browser.window.devicePixelRatio);
	}

	function get_mouseX() {
		return Math.round((curMouseX - canvasPos.left) * js.Browser.window.devicePixelRatio);
	}

	function get_mouseY() {
		return Math.round((curMouseY - canvasPos.top) * js.Browser.window.devicePixelRatio);
	}

	function get_mouseLock() {
		return false;
	}

	function set_mouseLock(b) {
		throw "Mouse lock not supported";
		return false;
	}

	function onMouseDown(e:js.html.MouseEvent) {
		event(new Event(EPush, mouseX, mouseY));
	}

	function onMouseUp(e:js.html.MouseEvent) {
		event(new Event(ERelease, mouseX, mouseY));
	}

	function onMouseMove(e:js.html.MouseEvent) {
		curMouseX = e.clientX;
		curMouseY = e.clientY;
		event(new Event(EMove, mouseX, mouseY));
	}

	function onMouseWheel(e:js.html.MouseEvent) {
		var ev = new Event(EWheel, mouseX, mouseY);
		ev.wheelDelta = untyped -e.wheelDelta / 30.0;
		event(ev);
	}

	function onKeyUp(e:js.html.KeyboardEvent) {
		var ev = new Event(EKeyUp, mouseX, mouseY);
		ev.keyCode = e.keyCode;
		ev.charCode = e.charCode;
		event(ev);
	}

	function onKeyDown(e:js.html.KeyboardEvent) {
		var ev = new Event(EKeyDown, mouseX, mouseY);
		ev.keyCode = e.keyCode;
		ev.charCode = e.charCode;
		event(ev);
	}

#elseif hxsdl

	function get_mouseX() {
		return @:privateAccess System.mouseX;
	}

	function get_mouseY() {
		return @:privateAccess System.mouseY;
	}

	function get_width() {
		return @:privateAccess System.windowWidth;
	}

	function get_height() {
		return @:privateAccess System.windowHeight;
	}

	function get_mouseLock() {
		return false;
	}

	function set_mouseLock(b) {
		if( b ) throw "Not implemented";
		return b;
	}

#else

	function get_mouseX() {
		return 0;
	}

	function get_mouseY() {
		return 0;
	}

	function get_width() {
		return 0;
	}

	function get_height() {
		return 0;
	}

	function get_mouseLock() {
		return false;
	}

	function set_mouseLock(b) {
		if( b ) throw "Not implemented";
		return b;
	}

#end

}