package hxd;

enum DisplayMode {
	Windowed;
	Borderless;
	Fullscreen;
	FullscreenResize;
}

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

	public var title(get, set) : String;
	@:isVar
	public var displayMode(get, set) : DisplayMode;

	// FLASH
	var stage : flash.display.Stage;
	var fsDelayed : Bool;

	function new() : Void {
		eventTargets = new List();
		resizeEvents = new List();

		stage = flash.Lib.current.stage;
		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.addEventListener(flash.events.Event.RESIZE, onResize);
		initGesture(false);
		if( isAir() )
			setupOnCloseEvent();
	}

	inline function isAir() {
		return @:privateAccess hxd.System.isAir();
	}

	function initGesture(b) {
		if( hxd.System.getValue(IsMobile) ) {
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


	@:deprecated("Use the displayMode property instead")
	public function setFullScreen( v : Bool ) : Void {
		this.displayMode = v ? Borderless : Windowed;
	}

	static var inst : Window = null;
	public static function getInstance() : Window {
		if( inst == null ) inst = new Window();
		return inst;
	}

	function setupOnCloseEvent() {
		var nw : flash.events.EventDispatcher = Reflect.field(stage, "nativeWindow");
		if( nw == null ) return;
		nw.addEventListener("closing", function(e:flash.events.Event) {
			if( !onClose() )
				e.preventDefault();
		});
	}

	#if !air3 static inline #end
	var multipleWindowsSupport = false;
	var lastX : Float = -1.;
	var lastY : Float = -1.;

	inline function get_mouseX() {
		return Std.int( multipleWindowsSupport ? lastX : stage.mouseX );
	}

	inline function get_mouseY() {
		return Std.int( multipleWindowsSupport ? lastY : stage.mouseY );
	}

	inline function get_width() {
		return stage.stageWidth;
	}

	inline function get_height() {
		return stage.stageHeight;
	}

	inline function get_mouseLock() {
		return stage.mouseLock;
	}

	inline function set_mouseLock(v) {
		return stage.mouseLock = v;
	}

	function get_vsync() : Bool return true;

	function set_vsync( b : Bool ) : Bool {
		if( !b ) throw "Can't disable vsync on this platform";
		return true;
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

	function onMouseMove(e:flash.events.MouseEvent) {
		if( multipleWindowsSupport ) {
			lastX = e.stageX;
			lastY = e.stageY;
		}
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
		event(ev);
	}

	function onKeyDown(e:flash.events.KeyboardEvent) {
		var ev = new Event(EKeyDown, mouseX, mouseY);
		ev.keyCode = e.keyCode;
		event(ev);

		var charCode = getCharCode(e);
		if( charCode != 0 ) {
			var ev = new Event(ETextInput, mouseX, mouseY);
			ev.charCode = charCode;
			event(ev);
		}

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
	}

	function getCharCode( e : flash.events.KeyboardEvent ) {
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

	function get_isFocused() : Bool return false;

	function get_displayMode() : DisplayMode {
		if (stage.displayState == flash.display.StageDisplayState.NORMAL) {
			return Windowed;
		}

		return Borderless;
	}

	function set_displayMode( m : DisplayMode ) : DisplayMode {
		var fullscreen = m != Windowed;
		var isAir = isAir();
		var state = fullscreen ? (isAir ? flash.display.StageDisplayState.FULL_SCREEN_INTERACTIVE : flash.display.StageDisplayState.FULL_SCREEN) : flash.display.StageDisplayState.NORMAL;
		if( stage.displayState != state ) {
			var t = flash.Lib.getTimer();
			// delay first fullsrceen toggle on OSX/Air to prevent the command window to spawn over
			if( fullscreen && isAir && t < 5000 && !fsDelayed && flash.system.Capabilities.os.indexOf("Mac") != -1 ) {
				fsDelayed = true;
				haxe.Timer.delay(function() { this.displayMode = m; }, 1000);
				return m;
			}
			stage.displayState = state;
		}

		return m;
	}

	function get_title() : String {
		return "";
	}

	function set_title( t : String ) : String {
		return t;
	}
}

