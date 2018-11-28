package hxd;
import hxd.Key in K;

#if (hlsdl && hldx)
#error "You shouldn't use both -lib hlsdl and -lib hldx"
#end

//@:coreApi
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

	#if hlsdl
	var window : sdl.Window;
	var fullScreenMode : sdl.Window.DisplayMode = Borderless;
	#elseif hldx
	var window : dx.Window;
	var fullScreenMode : dx.Window.DisplayMode = Borderless;
	#end
	var windowWidth = 800;
	var windowHeight = 600;
	var curMouseX = 0;
	var curMouseY = 0;

	static var CODEMAP = [for( i in 0...2048 ) i];

	function new(title:String, width:Int, height:Int) {
		this.windowWidth = width;
		this.windowHeight = height;
		eventTargets = new List();
		resizeEvents = new List();
		#if hlsdl
		window = new sdl.Window(title, width, height);
		#elseif hldx
		window = new dx.Window(title, width, height);
		#end
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
		#if (hldx || hlsdl)
		window.resize(width, height);
		#end
	}

	public function setFullScreen( v : Bool ) : Void {
		#if (hldx || hlsdl)
		window.displayMode = v ? fullScreenMode : Windowed;
		#end
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

	function set_mouseLock(v:Bool) : Bool {
		if( v ) throw "Not implemented";
		return false;
	}

	#if (hldx||hlsdl)

	function get_vsync() : Bool return window.vsync;

	function set_vsync( b : Bool ) : Bool {
		window.vsync = b;
		return b;
	}

	function get_isFocused() : Bool return !wasBlurred;

	var wasBlurred : Bool;

	function onEvent( e : #if hldx dx.Event #else sdl.Event #end ) : Bool {
		var eh = null;
		switch( e.type ) {
		case WindowState:
			switch( e.state ) {
			case Resize:
				windowWidth = window.width;
				windowHeight = window.height;
				onResize(null);
			case Focus:
				#if hldx
				// return to exclusive mode
				if( window.displayMode == Fullscreen && wasBlurred ) {
					window.displayMode = Borderless;
					window.displayMode = Fullscreen;
				}
				#end
				wasBlurred = false;
				event(new Event(EFocus));
			case Blur:
				wasBlurred = true;
				event(new Event(EFocusLost));
				#if hldx
				// release all keys
				var ev = new Event(EKeyUp);
				for( i in 0...@:privateAccess hxd.Key.keyPressed.length )
					if( hxd.Key.isDown(i) ) {
						ev.keyCode = i;
						event(ev);
					}
				#end
			case Enter:
				#if hldx
				// reset cursor to default
				dx.Cursor.createSystem(Arrow).set();
				#end
				event(new Event(EOver));
			case Leave:
				event(new Event(EOut));
			default:
			}
		case MouseDown if (!hxd.System.getValue(IsTouch)):
			curMouseX = e.mouseX;
			curMouseY = e.mouseY;
			eh = new Event(EPush, e.mouseX, e.mouseY);
			// middle button -> 2 / right button -> 1
			eh.button = switch( e.button - 1 ) {
			case 0: 0;
			case 1: 2;
			case 2: 1;
			case x: x;
			}
		case MouseUp if (!hxd.System.getValue(IsTouch)):
			curMouseX = e.mouseX;
			curMouseY = e.mouseY;
			eh = new Event(ERelease, e.mouseX, e.mouseY);
			eh.button = switch( e.button - 1 ) {
			case 0: 0;
			case 1: 2;
			case 2: 1;
			case x: x;
			};
		case MouseMove if (!hxd.System.getValue(IsTouch)):
			curMouseX = e.mouseX;
			curMouseY = e.mouseY;
			eh = new Event(EMove, e.mouseX, e.mouseY);
		case MouseWheel:
			eh = new Event(EWheel, mouseX, mouseY);
			eh.wheelDelta = -e.wheelDelta;
		#if hlsdl
		case GControllerAdded, GControllerRemoved, GControllerUp, GControllerDown, GControllerAxis:
			@:privateAccess hxd.Pad.onEvent( e );
		case KeyDown:
			eh = new Event(EKeyDown);
			if( e.keyCode & (1 << 30) != 0 ) e.keyCode = (e.keyCode & ((1 << 30) - 1)) + 1000;
			eh.keyCode = CODEMAP[e.keyCode];
			if( eh.keyCode & (K.LOC_LEFT | K.LOC_RIGHT) != 0 ) {
				e.keyCode = eh.keyCode & 0xFF;
				onEvent(e);
			}
		case KeyUp:
			eh = new Event(EKeyUp);
			if( e.keyCode & (1 << 30) != 0 ) e.keyCode = (e.keyCode & ((1 << 30) - 1)) + 1000;
			eh.keyCode = CODEMAP[e.keyCode];
			if( eh.keyCode & (K.LOC_LEFT | K.LOC_RIGHT) != 0 ) {
				e.keyCode = eh.keyCode & 0xFF;
				onEvent(e);
			}
		case TextInput:
			eh = new Event(ETextInput, mouseX, mouseY);
			var c = e.keyCode & 0xFF;
			eh.charCode = if( c < 0x7F )
				c;
			else if( c < 0xE0 )
				((c & 0x3F) << 6) | ((e.keyCode >> 8) & 0x7F);
			else if( c < 0xF0 )
				((c & 0x1F) << 12) | (((e.keyCode >> 8) & 0x7F) << 6) | ((e.keyCode >> 16) & 0x7F);
			else
				((c & 0x0F) << 18) | (((e.keyCode >> 8) & 0x7F) << 12) | (((e.keyCode >> 16) & 0x7F) << 6) | ((e.keyCode >> 24) & 0x7F);
		case TouchDown:
			eh = new Event(EPush, e.mouseX, e.mouseY);
			eh.touchId = e.fingerId;
		case TouchMove:
			eh = new Event(EMove, e.mouseX, e.mouseY);
			eh.touchId = e.fingerId;
		case TouchUp:
			eh = new Event(ERelease, e.mouseX, e.mouseY);
			eh.touchId = e.fingerId;
		#elseif hldx
		case KeyDown:
			eh = new Event(EKeyDown);
			eh.keyCode = e.keyCode;
			if( eh.keyCode & (K.LOC_LEFT | K.LOC_RIGHT) != 0 ) {
				e.keyCode = eh.keyCode & 0xFF;
				onEvent(e);
			}
		case KeyUp:
			eh = new Event(EKeyUp);
			eh.keyCode = CODEMAP[e.keyCode];
			if( eh.keyCode & (K.LOC_LEFT | K.LOC_RIGHT) != 0 ) {
				e.keyCode = eh.keyCode & 0xFF;
				onEvent(e);
			}
		case TextInput:
			eh = new Event(ETextInput, mouseX, mouseY);
			eh.charCode = e.keyCode;
		#end
		case Quit:
			return onClose();
		default:
		}
		if( eh != null ) event(eh);
		return true;
	}

	static function initChars() : Void {

		inline function addKey(sdl, keyCode) {
			CODEMAP[sdl] = keyCode;
		}

		// ASCII
		for( i in 0...26 )
			addKey(97 + i, K.A + i);
		for( i in 0...12 )
			addKey(1058 + i, K.F1 + i);

		// NUMPAD
		addKey(1084, K.NUMPAD_DIV);
		addKey(1085, K.NUMPAD_MULT);
		addKey(1086, K.NUMPAD_SUB);
		addKey(1087, K.NUMPAD_ADD);
		addKey(1088, K.NUMPAD_ENTER);
		for( i in 0...9 )
			addKey(1089 + i, K.NUMPAD_1 + i);
		addKey(1098, K.NUMPAD_0);
		addKey(1099, K.NUMPAD_DOT);

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

	#elseif usesys

	function get_vsync() : Bool return haxe.System.vsync;

	function set_vsync( b : Bool ) : Bool {
		return haxe.System.vsync = b;
	}

	function get_isFocused() : Bool return false;

	#else

	function get_vsync() : Bool return true;

	function set_vsync( b : Bool ) : Bool {
		return true;
	}

	function get_isFocused() : Bool return false;

	#end

	static var inst : Window = null;
	public static function getInstance() : Window {
		return inst;
	}
}
