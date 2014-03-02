package hxd;

class Key {
	
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
	
	public static inline var NUMBER_0	= 48;
	public static inline var NUMPAD_0	= 96;
	public static inline var A			= 65;
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
	
	public static inline var NUMPAD_MULT = 106;
	public static inline var NUMPAD_ADD	= 107;
	public static inline var NUMPAD_ENTER = 108;
	public static inline var NUMPAD_SUB = 109;
	public static inline var NUMPAD_DOT = 110;
	public static inline var NUMPAD_DIV = 111;
	
	public static inline var MOUSE_LEFT = 0;
	public static inline var MOUSE_RIGHT = 1;
	
	static var initDone = false;
	static var keyPressed : Array<Int> = [];
	
	public static function isDown( code : Int ) {
		return keyPressed[code] > 0;
	}

	public static function isPressed( code : Int ) {
		return keyPressed[code] == h3d.Engine.getCurrent().frameCount+1;
	}

	public static function isReleased( code : Int ) {
		return keyPressed[code] == -(h3d.Engine.getCurrent().frameCount+1);
	}

	public static function initialize() {
		if( initDone )
			dispose();
		initDone = true;
		keyPressed = [];
		Stage.getInstance().addEventTarget(onEvent);
		#if flash
		flash.Lib.current.stage.addEventListener(flash.events.Event.DEACTIVATE, onDeactivate);
		#end
	}
	
	public static function dispose() {
		if( initDone ) {
			Stage.getInstance().removeEventTarget(onEvent);
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
			keyPressed[e.keyCode] = h3d.Engine.getCurrent().frameCount+1;
		case EKeyUp:
			keyPressed[e.keyCode] = -(h3d.Engine.getCurrent().frameCount+1);
		case EPush:
			keyPressed[e.button] = h3d.Engine.getCurrent().frameCount+1;
		case ERelease:
			keyPressed[e.button] = -(h3d.Engine.getCurrent().frameCount+1);
		default:
		}
	}

}

