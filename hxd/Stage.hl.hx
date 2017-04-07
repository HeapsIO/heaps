package hxd;
import hxd.Key in K;

//@:coreApi
class Stage {

	var resizeEvents : List<Void -> Void>;
	var eventTargets : List<Event -> Void>;

	public var width(get, null) : Int;
	public var height(get, null) : Int;
	public var mouseX(get, null) : Int;
	public var mouseY(get, null) : Int;
	public var mouseLock(get, set) : Bool;
	public var vsync(get, set) : Bool;

	var window : sdl.Window;
	var fullScreenMode : sdl.Window.DisplayMode = Borderless;
	var windowWidth = 800;
	var windowHeight = 600;
	var curMouseX = 0;
	var curMouseY = 0;
	var shiftDown : Bool;

	static var CODEMAP = [for( i in 0...2048 ) i];
	static var CHARMAP = [for( i in 0...2048 ) 0];

	function new(title:String, width:Int, height:Int) {
		this.windowWidth = width;
		this.windowHeight = height;
		eventTargets = new List();
		resizeEvents = new List();
		window = new sdl.Window(title, width, height);
	}

	public dynamic function onClose() : Bool {
		return true;
	}

	public function event( e : hxd.Event ) : Void {
		for( et in eventTargets )
			et(e);
	}

	public function addEventTarget(et : Event -> Void) : Void {
		eventTargets.add(et);
	}

	public function removeEventTarget(et : Event -> Void) : Void {
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
		window.resize(width, height);
	}

	public function setFullScreen( v : Bool ) : Void {
		window.displayMode = v ? fullScreenMode : Windowed;
	}

	function get_mouseX() : Int {
		return curMouseX;
	}

	function get_mouseY() : Int {
		return curMouseY;
	}

	function get_width() : Int {
		return windowWidth;
	}

	function get_height() : Int {
		return windowHeight;
	}

	function get_mouseLock() : Bool {
		return false;
	}

	function get_vsync() : Bool return window.vsync;

	function set_vsync( b : Bool ) : Bool {
		window.vsync = b;
		return b;
	}

	function onEvent( e : sdl.Event ) : Void {
		var eh = null;
		switch( e.type ) {
		case WindowState:
			switch( e.state ) {
			case Resize:
				windowWidth = window.width;
				windowHeight = window.height;
				onResize(null);
			default:
			}
		case MouseDown:
			mouseX = e.mouseX;
			mouseY = e.mouseY;
			eh = new Event(EPush, e.mouseX, e.mouseY);
			// middle button -> 2 / right button -> 1
			eh.button = switch( e.button - 1 ) {
			case 0: 0;
			case 1: 2;
			case 2: 1;
			case x: x;
			}
		case MouseUp:
			mouseX = e.mouseX;
			mouseY = e.mouseY;
			eh = new Event(ERelease, e.mouseX, e.mouseY);
			eh.button = switch( e.button - 1 ) {
			case 0: 0;
			case 1: 2;
			case 2: 1;
			case x: x;
			};
		case MouseMove:
			mouseX = e.mouseX;
			mouseY = e.mouseY;
			eh = new Event(EMove, e.mouseX, e.mouseY);
		case KeyDown:
			eh = new Event(EKeyDown);
			if( e.keyCode & (1 << 30) != 0 ) e.keyCode = (e.keyCode & ((1 << 30) - 1)) + 1000;
			eh.keyCode = CODEMAP[e.keyCode];
			eh.charCode = CHARMAP[e.keyCode];
			if( eh.charCode == ":".code && shiftDown )
				eh.charCode = "/".code;
			if( eh.charCode >= 'a'.code && eh.charCode <= 'z'.code && shiftDown )
				eh.charCode += 'A'.code - 'a'.code;
			if( eh.keyCode & (K.LOC_LEFT | K.LOC_RIGHT) != 0 ) {
				e.keyCode = eh.keyCode & 0xFF;
				if( e.keyCode == K.SHIFT ) shiftDown = true;
				onEvent(e);
			}
		case KeyUp:
			eh = new Event(EKeyUp);
			if( e.keyCode & (1 << 30) != 0 ) e.keyCode = (e.keyCode & ((1 << 30) - 1)) + 1000;
			eh.keyCode = CODEMAP[e.keyCode];
			eh.charCode = CHARMAP[e.keyCode];
			if( eh.charCode == ":".code && shiftDown )
				eh.charCode = "/".code;
			if( eh.charCode >= 'a'.code && eh.charCode <= 'z'.code && shiftDown )
				eh.charCode += 'A'.code - 'a'.code;
			if( eh.keyCode & (K.LOC_LEFT | K.LOC_RIGHT) != 0 ) {
				e.keyCode = eh.keyCode & 0xFF;
				if( e.keyCode == K.SHIFT ) shiftDown = false;
				onEvent(e);
			}
		case MouseWheel:
			eh = new Event(EWheel, mouseX, mouseY);
			eh.wheelDelta = -e.wheelDelta;
		case GControllerAdded, GControllerRemoved, GControllerUp, GControllerDown, GControllerAxis:
			@:privateAccess hxd.Pad.onEvent( e );
		default:
		}
		if( eh != null ) event(eh);
	}


	function set_mouseLock(v:Bool) : Bool {
		if( v ) throw "Not implemented";
		return false;
	}


	static function initChars() : Void {

		inline function addKey(sdl, keyCode, charCode=0) {
			CODEMAP[sdl] = keyCode;
			if( charCode != 0 ) CHARMAP[sdl] = charCode;
		}

		/*
			SDL 2.0 does not allow to get the charCode from a key event.
			let's for now do a simple mapping, even if not very efficient
		*/

		// ASCII
		CHARMAP[K.BACKSPACE] = 8;
		CHARMAP[K.TAB] = 9;
		CHARMAP[K.ENTER] = 13;
		for( i in 32...127 )
			CHARMAP[i] = i;
		for( i in 0...26 )
			addKey(97 + i, K.A + i);
		for( i in 0...12 )
			addKey(1058 + i, K.F1 + i);

		// NUMPAD

		addKey(1084, K.NUMPAD_DIV, "/".code);
		addKey(1085, K.NUMPAD_MULT, "*".code);
		addKey(1086, K.NUMPAD_SUB, "-".code);
		addKey(1087, K.NUMPAD_ADD, "+".code);
		addKey(1088, K.NUMPAD_ENTER, 13);
		for( i in 0...9 )
			addKey(1089 + i, K.NUMPAD_1 + i, "1".code + i);
		addKey(1098, K.NUMPAD_0, "0".code);
		addKey(1099, K.NUMPAD_DOT, ".".code);

		// EXTRA
		var keys = [
			//K.BACKSPACE
			//K.TAB
			//K.ENTER
			1225 => K.LSHIFT,
			1229 => K.RSHIFT,
			1224 => K.LCTRL,
			1228 => K.RCTRL,
			1226 => K.LALT,
			1230 => K.RALT,
			// K.ESCAPE
			// K.SPACE
			1075 => K.PGUP,
			1078 => K.PGDOWN,
			1077 => K.END,
			1074 => K.HOME,
			1080 => K.LEFT,
			1082 => K.UP,
			1079 => K.RIGHT,
			1081 => K.DOWN,
			1073 => K.INSERT,
			127 => K.DELETE,
			//K.NUMPAD_0-9
			//K.A-Z
			//K.F1-F12
			1085 => K.NUMPAD_MULT,
			1087 => K.NUMPAD_ADD,
			1088 => K.NUMPAD_ENTER,
			1086 => K.NUMPAD_SUB,
			1099 => K.NUMPAD_DOT,
			1084 => K.NUMPAD_DIV,
		];
		for( sdl in keys.keys() )
			addKey(sdl, keys.get(sdl));
	}

	static var inst : Stage = null;
	public static function getInstance() : Stage {
		return inst;
	}
}
