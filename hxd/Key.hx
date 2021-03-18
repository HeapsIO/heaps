package hxd;

class Key {

	// SDL note: Because SDL uses different mapping, it should be set accordingly in the Window.hl.hx in `initChars` function.

	public static inline var BACKSPACE	= 8;
	public static inline var TAB		= 9;
	public static inline var ENTER		= 13;
	public static inline var SHIFT		= 16;
	public static inline var CTRL		= 17;
	public static inline var ALT		= 18;
	public static inline var ESCAPE		= 27;
	public static inline var SPACE		= 32;
	public static inline var PGUP		= 33;
	public static inline var PGDOWN		= 34;
	public static inline var END		= 35;
	public static inline var HOME		= 36;
	public static inline var LEFT		= 37;
	public static inline var UP			= 38;
	public static inline var RIGHT		= 39;
	public static inline var DOWN		= 40;
	public static inline var INSERT		= 45;
	public static inline var DELETE		= 46;

	public static inline var QWERTY_EQUALS = 187;
	public static inline var QWERTY_MINUS = 189;
	public static inline var QWERTY_TILDE = 192;
	public static inline var QWERTY_BRACKET_LEFT = 219;
	public static inline var QWERTY_BRACKET_RIGHT = 221;
	public static inline var QWERTY_SEMICOLON = 186;
	public static inline var QWERTY_QUOTE = 222;
	public static inline var QWERTY_BACKSLASH = 220;
	public static inline var QWERTY_COMMA = 188;
	public static inline var QWERTY_PERIOD = 190;
	public static inline var QWERTY_SLASH = 191;
	public static inline var INTL_BACKSLASH = 226; // Backslash located next to left shift on some keyboards. Warning: Not available on HLSDL.
	public static inline var LEFT_WINDOW_KEY = 91;
	public static inline var RIGHT_WINDOW_KEY = 92;
	public static inline var CONTEXT_MENU = 93;
	// public static inline var PRINT_SCREEN = // Only available on SDL

	public static inline var PAUSE_BREAK = 19;
	public static inline var CAPS_LOCK = 20;
	public static inline var NUM_LOCK = 144;
	public static inline var SCROLL_LOCK = 145;

	public static inline var NUMBER_0	= 48;
	public static inline var NUMBER_1	= 49;
	public static inline var NUMBER_2	= 50;
	public static inline var NUMBER_3	= 51;
	public static inline var NUMBER_4	= 52;
	public static inline var NUMBER_5	= 53;
	public static inline var NUMBER_6	= 54;
	public static inline var NUMBER_7	= 55;
	public static inline var NUMBER_8	= 56;
	public static inline var NUMBER_9	= 57;

	public static inline var NUMPAD_0	= 96;
	public static inline var NUMPAD_1	= 97;
	public static inline var NUMPAD_2	= 98;
	public static inline var NUMPAD_3	= 99;
	public static inline var NUMPAD_4	= 100;
	public static inline var NUMPAD_5	= 101;
	public static inline var NUMPAD_6	= 102;
	public static inline var NUMPAD_7	= 103;
	public static inline var NUMPAD_8	= 104;
	public static inline var NUMPAD_9	= 105;

	public static inline var A			= 65;
	public static inline var B			= 66;
	public static inline var C			= 67;
	public static inline var D			= 68;
	public static inline var E			= 69;
	public static inline var F			= 70;
	public static inline var G			= 71;
	public static inline var H			= 72;
	public static inline var I			= 73;
	public static inline var J			= 74;
	public static inline var K			= 75;
	public static inline var L			= 76;
	public static inline var M			= 77;
	public static inline var N			= 78;
	public static inline var O			= 79;
	public static inline var P			= 80;
	public static inline var Q			= 81;
	public static inline var R			= 82;
	public static inline var S			= 83;
	public static inline var T			= 84;
	public static inline var U			= 85;
	public static inline var V			= 86;
	public static inline var W			= 87;
	public static inline var X			= 88;
	public static inline var Y			= 89;
	public static inline var Z			= 90;

	public static inline var F1			= 112;
	public static inline var F2			= 113;
	public static inline var F3			= 114;
	public static inline var F4			= 115;
	public static inline var F5			= 116;
	public static inline var F6			= 117;
	public static inline var F7			= 118;
	public static inline var F8			= 119;
	public static inline var F9			= 120;
	public static inline var F10		= 121;
	public static inline var F11		= 122;
	public static inline var F12		= 123;
	// Extended F keys
	public static inline var F13		= 124;
	public static inline var F14		= 125;
	public static inline var F15		= 126;
	public static inline var F16		= 127;
	public static inline var F17		= 128;
	public static inline var F18		= 129;
	public static inline var F19		= 130;
	public static inline var F20		= 131;
	public static inline var F21		= 132;
	public static inline var F22		= 133;
	public static inline var F23		= 134;
	public static inline var F24		= 135;

	public static inline var NUMPAD_MULT = 106;
	public static inline var NUMPAD_ADD	= 107;
	public static inline var NUMPAD_ENTER = 108;
	public static inline var NUMPAD_SUB = 109;
	public static inline var NUMPAD_DOT = 110;
	public static inline var NUMPAD_DIV = 111;

	public static inline var MOUSE_LEFT = 0;
	public static inline var MOUSE_RIGHT = 1;
	public static inline var MOUSE_MIDDLE = 2;
	public static inline var MOUSE_BACK = 3;
	public static inline var MOUSE_FORWARD = 4;
	/**
	 * Mouse wheel does not have an off signal, and should be checked only through `isPressed` method.
	 * Note that there may be multiple wheel scrolls between 2 frames, and to receive more accurate
	 * results, it is recommended to directly listen to wheel events which also provide OS-generated wheel delta value.
	 * See `Interactive.onWheel` for per-interactive events. For scene-based see `Scene.addEventListener`
	 * when event is `EWheel`. For global hook use `Window.addEventTarget` method.
	 */
	public static inline var MOUSE_WHEEL_UP = 5;
	/**
	 * Mouse wheel does not have an off signal, and should be checked only through `isPressed` method.
	 * Note that there may be multiple wheel scrolls between 2 frames, and to receive more accurate
	 * results, it is recommended to directly listen to wheel events which also provide OS-generated wheel delta value.
	 * See `Interactive.onWheel` for per-interactive events. For scene-based see `Scene.addEventListener`
	 * when event is `EWheel`. For global hook use `Window.addEventTarget` method.
	 */
	public static inline var MOUSE_WHEEL_DOWN = 6;

	/** a bit that is set for left keys **/
	public static inline var LOC_LEFT = 256;
	/** a bit that is set for right keys **/
	public static inline var LOC_RIGHT = 512;

	public static inline var LSHIFT = SHIFT | LOC_LEFT;
	public static inline var RSHIFT = SHIFT | LOC_RIGHT;
	public static inline var LCTRL = CTRL | LOC_LEFT;
	public static inline var RCTRL = CTRL | LOC_RIGHT;
	public static inline var LALT = ALT | LOC_LEFT;
	public static inline var RALT = ALT | LOC_RIGHT;

	static var initDone = false;
	static var keyPressed : Array<Int> = [];

	/**
		This enable the native key repeat behavior, and will
		report several times isPressed() in case a key is kept
		pressed for a long time if this is allowed by the target
		platform.
	**/
	public static var ALLOW_KEY_REPEAT = false;

	public static function isDown( code : Int ) {
		return keyPressed[code] > 0;
	}

	public static inline function getFrame() {
		return hxd.Timer.frameCount + 2;
	}

	public static function isPressed( code : Int ) {
		return keyPressed[code] == getFrame() - 1;
	}

	public static function isReleased( code : Int ) {
		return keyPressed[code] == -getFrame() + 1;
	}

	public static function initialize() {
		if( initDone )
			dispose();
		initDone = true;
		keyPressed = [];
		Window.getInstance().addEventTarget(onEvent);
		#if flash
		flash.Lib.current.stage.addEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
		#end
	}

	public static function dispose() {
		if( initDone ) {
			Window.getInstance().removeEventTarget(onEvent);
			#if flash
			flash.Lib.current.stage.removeEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
			#end
			initDone = false;
			keyPressed = [];
		}
	}

	#if flash
	static function onDeactivate(_) {
		keyPressed = [];
	}
	#end

	static function onEvent( e : Event ) {
		switch( e.kind ) {
		case EKeyDown:
			if( !ALLOW_KEY_REPEAT && keyPressed[e.keyCode] > 0 ) return;
			keyPressed[e.keyCode] = getFrame();
		case EKeyUp:
			keyPressed[e.keyCode] = -getFrame();
		case EPush:
			if( e.button < 5 ) keyPressed[e.button] = getFrame();
		case ERelease:
			if( e.button < 5 ) keyPressed[e.button] = -getFrame();
		case EWheel:
			keyPressed[e.wheelDelta > 0 ? MOUSE_WHEEL_DOWN : MOUSE_WHEEL_UP] = getFrame();
		default:
		}
	}

	public static function getKeyName( keyCode : Int ) {
		var c = keyCode;
		return switch( c ) {
		case BACKSPACE: "Backspace";
		case TAB: "Tab";
		case ENTER: "Enter";
		case SHIFT: "Shift";
		case CTRL: "Ctrl";
		case ALT: "Alt";
		case ESCAPE: "Escape";
		case SPACE: "Space";
		case PGUP: "PageUp";
		case PGDOWN: "PageDown";
		case END: "End";
		case HOME: "Home";
		case LEFT: "Left";
		case UP: "Up";
		case RIGHT: "Right";
		case DOWN: "Down";
		case INSERT: "Insert";
		case DELETE: "Delete";
		case NUMPAD_MULT: "NumPad*";
		case NUMPAD_ADD: "NumPad+";
		case NUMPAD_ENTER: "NumPadEnter";
		case NUMPAD_SUB: "NumPad-";
		case NUMPAD_DOT: "NumPad.";
		case NUMPAD_DIV: "NumPad/";
		case LSHIFT: "LShift";
		case RSHIFT: "RShift";
		case LCTRL: "LCtrl";
		case RCTRL: "RCtrl";
		case LALT: "LAlt";
		case RALT: "RAlt";
		case QWERTY_TILDE: "Tilde";
		case QWERTY_MINUS: "Minus";
		case QWERTY_EQUALS: "Equals";
		case QWERTY_BRACKET_LEFT: "BracketLeft";
		case QWERTY_BRACKET_RIGHT: "BacketRight";
		case QWERTY_SEMICOLON: "Semicolon";
		case QWERTY_QUOTE: "Quote";
		case QWERTY_BACKSLASH: "Backslash";
		case QWERTY_COMMA: "Comma";
		case QWERTY_PERIOD: "Period";
		case QWERTY_SLASH: "Slash";
		case INTL_BACKSLASH: "IntlBackslash";
		case LEFT_WINDOW_KEY: "LeftWindowKey";
		case RIGHT_WINDOW_KEY: "RightWindowKey";
		case CONTEXT_MENU: "ContextMenu";
		case PAUSE_BREAK: "PauseBreak";
		case CAPS_LOCK: "CapsLock";
		case SCROLL_LOCK: "ScrollLock";
		case NUM_LOCK: "NumLock";
		case MOUSE_LEFT: "MouseLeft";
		case MOUSE_MIDDLE: "MouseMiddle";
		case MOUSE_RIGHT: "MouseRight";
		case MOUSE_BACK: "Mouse3";
		case MOUSE_FORWARD: "Mouse4";
		default:
			if( c >= NUMBER_0 && c <= NUMBER_9 )
				""+(c - NUMBER_0);
			else if( c >= NUMPAD_0 && c <= NUMPAD_9 )
				"NumPad"+(c - NUMPAD_0);
			else if( c >= A && c <= Z )
				String.fromCharCode("A".code + c - A);
			else if( c >= F1 && c <= F24 )
				"F" + (c - F1 + 1);
			else
				null;
		}
	}

}

