package hxd;

class Window {

	var resizeEvents : List<Void -> Void>;
	var eventTargets : List<Event -> Void>;

	public var width(get, never) : Int;
	public var height(get, never) : Int;
	public var mouseX(get, never) : Int;
	public var mouseY(get, never) : Int;
	public var mouseLock(get, set) : Bool;
	public var vsync(get, set) : Bool;
	public var isFocused(get, never) : Bool;

	var curMouseX : Float = 0.;
	var curMouseY : Float = 0.;

	var canvas : js.html.CanvasElement;
	var element : js.html.EventTarget;
	var canvasPos : { var width(default, never) : Float; var height(default, never) : Float; var left(default, never) : Float; var top(default, never) : Float; };
	var timer : haxe.Timer;

	var curW : Int;
	var curH : Int;

	var focused = true;

	public function new( ?canvas : js.html.CanvasElement, ?globalEvents ) : Void {
		eventTargets = new List();
		resizeEvents = new List();

		element = canvas == null || globalEvents ? js.Browser.window : canvas;
		if( canvas == null ) {
			canvas = cast js.Browser.document.getElementById("webgl");
			if( canvas == null ) throw "Missing canvas #webgl";
			if( canvas.getAttribute("globalEvents") == "0" )
				element = canvas;
		}
		this.canvas = canvas;
		canvasPos = canvas.getBoundingClientRect();
		element.addEventListener("mousedown", onMouseDown);
		element.addEventListener("mousemove", onMouseMove);
		element.addEventListener("mouseup", onMouseUp);
		element.addEventListener("wheel", onMouseWheel);
		element.addEventListener("touchstart", onTouchStart);
		element.addEventListener("touchmove", onTouchMove);
		element.addEventListener("touchend", onTouchEnd);
		element.addEventListener("keydown", onKeyDown);
		element.addEventListener("keyup", onKeyUp);
		element.addEventListener("keypress", onKeyPress);
		element.addEventListener("blur", onFocus.bind(false));
		element.addEventListener("focus", onFocus.bind(true));
		if( element == canvas ) {
			canvas.setAttribute("tabindex","1"); // allow focus
			canvas.style.outline = 'none';
		} else {
			canvas.addEventListener("mousedown", function(e) {
				onMouseDown(e);
				e.stopPropagation();
				e.preventDefault();
			});
			canvas.oncontextmenu = function(e){
				e.stopPropagation();
				e.preventDefault();
				return false;
			};
		}
		curW = this.width;
		curH = this.height;
		timer = new haxe.Timer(100);
		timer.run = checkResize;
	}

	function checkResize() {
		canvasPos = canvas.getBoundingClientRect();
		var cw = this.width, ch = this.height;
		if( curW != cw || curH != ch ) {
			curW = cw;
			curH = ch;
			onResize(null);
		}
	}

	public function dispose() {
		timer.stop();
	}

	public dynamic function onClose() : Bool {
		return true;
	}

	public function event( e : hxd.Event ) : Void {
		for( et in eventTargets )
			et(e);
	}

	public function addEventTarget( et : Event->Void ) : Void {
		eventTargets.add(et);
	}

	public function removeEventTarget( et : Event->Void ) : Void {
		for( e in eventTargets )
			if( Reflect.compareMethods(e,et) ) {
				eventTargets.remove(e);
				break;
			}
	}

	public function addResizeEvent( f : Void -> Void ) : Void {
		resizeEvents.push(f);
	}

	public function removeResizeEvent( f : Void -> Void ) : Void {
		for( e in resizeEvents )
			if( Reflect.compareMethods(e,f) ) {
				resizeEvents.remove(f);
				break;
			}
	}

	function onResize(e:Dynamic) : Void {
		for( r in resizeEvents )
			r();
	}

	public function resize( width : Int, height : Int ) : Void {
	}

	public function setFullScreen( v : Bool ) : Void {
	}

	public function setCurrent() {
		inst = this;
	}

	static var inst : Window = null;
	public static function getInstance() : Window {
		if( inst == null ) inst = new Window();
		return inst;
	}

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

	function get_mouseLock() : Bool {
		return false;
	}

	function set_mouseLock( v : Bool ) : Bool {
		if( v ) throw "Not implemented";
		return false;
	}

	function get_vsync() : Bool return true;

	function set_vsync( b : Bool ) : Bool {
		if( !b ) throw "Can't disable vsync on this platform";
		return true;
	}

	function onMouseDown(e:js.html.MouseEvent) {
		var ev = new Event(EPush, mouseX, mouseY);
		ev.button = switch( e.button ) {
			case 1: 2;
			case 2: 1;
			case x: x;
		};
		event(ev);
	}

	function onMouseUp(e:js.html.MouseEvent) {
		var ev = new Event(ERelease, mouseX, mouseY);
		ev.button = switch( e.button ) {
			case 1: 2;
			case 2: 1;
			case x: x;
		};
		event(ev);
	}

	function onMouseMove(e:js.html.MouseEvent) {
		curMouseX = e.clientX;
		curMouseY = e.clientY;
		event(new Event(EMove, mouseX, mouseY));
	}

	function onMouseWheel(e:js.html.WheelEvent) {
		e.preventDefault();
		var ev = new Event(EWheel, mouseX, mouseY);
		ev.wheelDelta = e.deltaY / 120; // browser specific?
		event(ev);
	}

	function onTouchStart(e:js.html.TouchEvent) {
		e.preventDefault();
		var x, y, ev;
		for (touch in e.changedTouches) {
			x = Math.round((touch.clientX - canvasPos.left) * js.Browser.window.devicePixelRatio);
			y = Math.round((touch.clientY - canvasPos.top) * js.Browser.window.devicePixelRatio);
			ev = new Event(EPush, x, y);
			ev.touchId = touch.identifier;
			event(ev);
		}
	}

	function onTouchMove(e:js.html.TouchEvent) {
		e.preventDefault();
		var x, y, ev;
		for (touch in e.changedTouches) {
			x = Math.round((touch.clientX - canvasPos.left) * js.Browser.window.devicePixelRatio);
			y = Math.round((touch.clientY - canvasPos.top) * js.Browser.window.devicePixelRatio);
			ev = new Event(EMove, x, y);
			ev.touchId = touch.identifier;
			event(ev);
		}
	}

	function onTouchEnd(e:js.html.TouchEvent) {
		e.preventDefault();
		var x, y, ev;
		for (touch in e.changedTouches) {
			x = Math.round((touch.clientX - canvasPos.left) * js.Browser.window.devicePixelRatio);
			y = Math.round((touch.clientY - canvasPos.top) * js.Browser.window.devicePixelRatio);
			ev = new Event(ERelease, x, y);
			ev.touchId = touch.identifier;
			event(ev);
		}
	}

	function onKeyUp(e:js.html.KeyboardEvent) {
		var ev = new Event(EKeyUp, mouseX, mouseY);
		ev.keyCode = e.keyCode;
		event(ev);
	}

	function onKeyDown(e:js.html.KeyboardEvent) {
		var ev = new Event(EKeyDown, mouseX, mouseY);
		ev.keyCode = e.keyCode;
		event(ev);
	}

	function onKeyPress(e:js.html.KeyboardEvent) {
		var ev = new Event(ETextInput, mouseX, mouseY);
		ev.charCode = e.charCode;
		event(ev);
	}

	function onFocus(b: Bool) {
		event(new Event(b ? EFocus : EFocusLost));
		focused = b;
	}

	function get_isFocused() : Bool return focused;
}
