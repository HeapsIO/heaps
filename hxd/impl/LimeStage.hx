package hxd.impl;
import hxd.Event;

@:allow(hxd.Stage)
@:access(hxd.Stage)
class LimeStage implements lime.app.IModule {
	
	var stage : hxd.Stage;

	var width : Int;
	var height : Int;
	
	var enableMouse : Bool;

	var mouseX : Int = 0;
	var mouseY : Int = 0;

	public function new( s : hxd.Stage ){
		stage = s;
		enableMouse = !hxd.System.isTouch;
		width = hxd.System.width;
		height = hxd.System.height;
	}

	public function render(renderer){
		if( hxd.System.loopFunc != null )
			hxd.System.loopFunc();
	}

	public function onWindowResize(win, w, h){
		width = w;
		height = h;
		stage.onResize(null);
	}

	public function onMouseMove(win, x : Float, y : Float){
		if( !enableMouse ) return;
		mouseX = Std.int(x);
		mouseY = Std.int(y);
		stage.event(new Event(EMove, mouseX, mouseY));
	}

	public function onMouseDown(win, x : Float, y : Float, button : Int ){
		if( !enableMouse ) return;
		var e = new Event(EPush, x, y);
		e.button = button;
		stage.event(e);
	}

	public function onMouseUp(win, x : Float, y : Float, button : Int){
		if( !enableMouse ) return;
		var e = new Event(ERelease, x, y);
		e.button = button;
		stage.event(e);
	}
	
	public function onMouseWheel( win, dx : Float, dy : Float ){
		if( dy != 0 ){
			var ev = new Event(EWheel, mouseX, mouseY);
			ev.wheelDelta = dy;
			stage.event(ev);
		}
	}

	public function onTouchEnd( touch : lime.ui.Touch ){
		if( !hxd.Stage.ENABLE_TOUCH ) return;
		var e = new Event( ERelease, touch.x*width, touch.y*height );
		e.touchId = touch.id;
		stage.event(e);
	}

	public function onTouchMove( touch : lime.ui.Touch ){
		if( !hxd.Stage.ENABLE_TOUCH ) return;
		var e = new Event( EMove, touch.x*width, touch.y*height );
		e.touchId = touch.id;
		stage.event(e);
	}

	public function onTouchStart( touch : lime.ui.Touch ){
		if( !hxd.Stage.ENABLE_TOUCH ) return;
		var e = new Event( EPush, touch.x*width, touch.y*height );
		e.touchId = touch.id;
		stage.event(e);
	}

	public function onKeyDown( window, keyCode:lime.ui.KeyCode, modifier:lime.ui.KeyModifier ){
		var ev = new Event(EKeyDown, mouseX, mouseY);
		ev.keyCode = Keyboard.convertKeyCode(keyCode);
		ev.charCode = Keyboard.getCharCode(ev.keyCode, modifier.shiftKey);
		stage.event(ev);
	}

	public function onKeyUp( window, keyCode:lime.ui.KeyCode, modifier:lime.ui.KeyModifier ){
		var ev = new Event(EKeyUp, mouseX, mouseY);
		ev.keyCode = Keyboard.convertKeyCode(keyCode);
		ev.charCode = Keyboard.getCharCode(ev.keyCode, modifier.shiftKey);
		stage.event(ev);
	}

	public function onGamepadAxisMove( gamepad, axis, value:Float ){ }
	
	public function onGamepadButtonDown( gamepad, button ){ }
	
	public function onGamepadButtonUp( gamepad, button ){ }
	
	public function onGamepadConnect( gamepad ){}

	public function onGamepadDisconnect( gamepad ){ }
	
	public function onJoystickAxisMove( joystick, axis:Int, value:Float ){ }

	public function onJoystickButtonDown( joystick, button:Int ){ }

	public function onJoystickButtonUp( joystick, button:Int ){ }

	public function onJoystickConnect( joystick ){ }

	public function onJoystickDisconnect( joystick ){ }

	public function onJoystickHatMove( joystick, hat:Int, position ){ }
	
	public function onJoystickTrackballMove( joystick, trackball:Int, value:Float ){ }

	public function onModuleExit( code:Int ){ }
	
	public function onMouseMoveRelative( window, x:Float, y:Float ){ }
	
	public function onPreloadComplete(  ){ }
	
	public function onPreloadProgress( loaded:Int, total:Int ){ }

	public function onRenderContextLost( renderer ){ }

	public function onRenderContextRestored( renderer, context ){ }

	public function onTextEdit( window, text:String, start:Int, length:Int ){ }

	public function onTextInput( window, text:String ){ }

	public function onWindowActivate( window ){ }

	public function onWindowClose( window ){ }
	
	public function onWindowCreate( window ){ }
	
	public function onWindowDeactivate( window ){ }

	public function onWindowEnter( window ){ }
	
	public function onWindowFocusIn( window ){ }

	public function onWindowFocusOut( window ){ }

	public function onWindowFullscreen( window ){ }
	
	public function onWindowLeave( window ){ }
	
	public function onWindowMove( window, x:Float, y:Float ){ }
	
	public function onWindowMinimize( window ){ }
	
	public function onWindowRestore( window ){ }

	public function update( dt ){ }
		
}

@:allow(hxd.impl.LimeStage)
class Keyboard {
		
	static inline var NUMBER_0 = 48;
	static inline var NUMBER_1 = 49;
	static inline var NUMBER_2 = 50;
	static inline var NUMBER_3 = 51;
	static inline var NUMBER_4 = 52;
	static inline var NUMBER_5 = 53;
	static inline var NUMBER_6 = 54;
	static inline var NUMBER_7 = 55;
	static inline var NUMBER_8 = 56; 
	static inline var NUMBER_9 = 57;
	static inline var A = 65;
	static inline var B = 66;
	static inline var C = 67;
	static inline var D = 68;
	static inline var E = 69;
	static inline var F = 70;
	static inline var G = 71;
	static inline var H = 72;
	static inline var I = 73;
	static inline var J = 74;
	static inline var K = 75;
	static inline var L = 76;
	static inline var M = 77;
	static inline var N = 78;
	static inline var O = 79;
	static inline var P = 80;
	static inline var Q = 81;
	static inline var R = 82;
	static inline var S = 83;
	static inline var T = 84;
	static inline var U = 85;
	static inline var V = 86;
	static inline var W = 87;
	static inline var X = 88;
	static inline var Y = 89;
	static inline var Z = 90;
	static inline var NUMPAD_0 = 96;
	static inline var NUMPAD_1 = 97;
	static inline var NUMPAD_2 = 98;
	static inline var NUMPAD_3 = 99;
	static inline var NUMPAD_4 = 100;
	static inline var NUMPAD_5 = 101;
	static inline var NUMPAD_6 = 102;
	static inline var NUMPAD_7 = 103;
	static inline var NUMPAD_8 = 104;
	static inline var NUMPAD_9 = 105;
	static inline var NUMPAD_MULTIPLY = 106;
	static inline var NUMPAD_ADD = 107;
	static inline var NUMPAD_ENTER = 108;
	static inline var NUMPAD_SUBTRACT = 109;
	static inline var NUMPAD_DECIMAL = 110;
	static inline var NUMPAD_DIVIDE = 111;
	static inline var F1 = 112;
	static inline var F2 = 113;
	static inline var F3 = 114;
	static inline var F4 = 115;
	static inline var F5 = 116;
	static inline var F6 = 117;
	static inline var F7 = 118;
	static inline var F8 = 119;
	static inline var F9 = 120;
	static inline var F10 = 121; //  F10 is used by browser.
	static inline var F11 = 122;
	static inline var F12 = 123;
	static inline var F13 = 124;
	static inline var F14 = 125;
	static inline var F15 = 126;
	static inline var BACKSPACE = 8;
	static inline var TAB = 9;
	static inline var ALTERNATE = 18;
	static inline var ENTER = 13;
	static inline var COMMAND = 15;
	static inline var SHIFT = 16;
	static inline var CONTROL = 17;
	static inline var BREAK = 19;
	static inline var CAPS_LOCK = 20;
	static inline var NUMPAD = 21;
	static inline var ESCAPE = 27;
	static inline var SPACE = 32;
	static inline var PAGE_UP = 33;
	static inline var PAGE_DOWN = 34;
	static inline var END = 35;
	static inline var HOME = 36;
	static inline var LEFT = 37;
	static inline var RIGHT = 39;
	static inline var UP = 38;
	static inline var DOWN = 40;
	static inline var INSERT = 45;
	static inline var DELETE = 46;
	static inline var NUMLOCK = 144;
	static inline var SEMICOLON = 186;
	static inline var EQUAL = 187;
	static inline var COMMA = 188;
	static inline var MINUS = 189;
	static inline var PERIOD = 190;
	static inline var SLASH = 191;
	static inline var BACKQUOTE = 192;
	static inline var LEFTBRACKET = 219;
	static inline var BACKSLASH = 220;
	static inline var RIGHTBRACKET = 221;
	static inline var QUOTE = 222;
	
	static function convertKeyCode (key:lime.ui.KeyCode):Int {
		return switch (key) {
			case BACKSPACE: Keyboard.BACKSPACE;
			case TAB: Keyboard.TAB;
			case RETURN: Keyboard.ENTER;
			case ESCAPE: Keyboard.ESCAPE;
			case SPACE: Keyboard.SPACE;
			case EXCLAMATION: Keyboard.NUMBER_1;
			case QUOTE: Keyboard.QUOTE;
			case HASH: Keyboard.NUMBER_3;
			case DOLLAR: Keyboard.NUMBER_4;
			case PERCENT: Keyboard.NUMBER_5;
			case AMPERSAND: Keyboard.NUMBER_7;
			case SINGLE_QUOTE: Keyboard.QUOTE;
			case LEFT_PARENTHESIS: Keyboard.NUMBER_9;
			case RIGHT_PARENTHESIS: Keyboard.NUMBER_0;
			case ASTERISK: Keyboard.NUMBER_8;
			case COMMA: Keyboard.COMMA;
			case MINUS: Keyboard.MINUS;
			case PERIOD: Keyboard.PERIOD;
			case SLASH: Keyboard.SLASH;
			case NUMBER_0: Keyboard.NUMBER_0;
			case NUMBER_1: Keyboard.NUMBER_1;
			case NUMBER_2: Keyboard.NUMBER_2;
			case NUMBER_3: Keyboard.NUMBER_3;
			case NUMBER_4: Keyboard.NUMBER_4;
			case NUMBER_5: Keyboard.NUMBER_5;
			case NUMBER_6: Keyboard.NUMBER_6;
			case NUMBER_7: Keyboard.NUMBER_7;
			case NUMBER_8: Keyboard.NUMBER_8;
			case NUMBER_9: Keyboard.NUMBER_9;
			case COLON: Keyboard.SEMICOLON;
			case SEMICOLON: Keyboard.SEMICOLON;
			case LESS_THAN: 60;
			case EQUALS: Keyboard.EQUAL;
			case GREATER_THAN: Keyboard.PERIOD;
			case QUESTION: Keyboard.SLASH;
			case AT: Keyboard.NUMBER_2;
			case LEFT_BRACKET: Keyboard.LEFTBRACKET;
			case BACKSLASH: Keyboard.BACKSLASH;
			case RIGHT_BRACKET: Keyboard.RIGHTBRACKET;
			case CARET: Keyboard.NUMBER_6;
			case UNDERSCORE: Keyboard.MINUS;
			case GRAVE: Keyboard.BACKQUOTE;
			case A: Keyboard.A;
			case B: Keyboard.B;
			case C: Keyboard.C;
			case D: Keyboard.D;
			case E: Keyboard.E;
			case F: Keyboard.F;
			case G: Keyboard.G;
			case H: Keyboard.H;
			case I: Keyboard.I;
			case J: Keyboard.J;
			case K: Keyboard.K;
			case L: Keyboard.L;
			case M: Keyboard.M;
			case N: Keyboard.N;
			case O: Keyboard.O;
			case P: Keyboard.P;
			case Q: Keyboard.Q;
			case R: Keyboard.R;
			case S: Keyboard.S;
			case T: Keyboard.T;
			case U: Keyboard.U;
			case V: Keyboard.V;
			case W: Keyboard.W;
			case X: Keyboard.X;
			case Y: Keyboard.Y;
			case Z: Keyboard.Z;
			case DELETE: Keyboard.DELETE;
			case CAPS_LOCK: Keyboard.CAPS_LOCK;
			case F1: Keyboard.F1;
			case F2: Keyboard.F2;
			case F3: Keyboard.F3;
			case F4: Keyboard.F4;
			case F5: Keyboard.F5;
			case F6: Keyboard.F6;
			case F7: Keyboard.F7;
			case F8: Keyboard.F8;
			case F9: Keyboard.F9;
			case F10: Keyboard.F10;
			case F11: Keyboard.F11;
			case F12: Keyboard.F12;
			case PRINT_SCREEN: 301;
			case SCROLL_LOCK: 145;
			case PAUSE: Keyboard.BREAK;
			case INSERT: Keyboard.INSERT;
			case HOME: Keyboard.HOME;
			case PAGE_UP: Keyboard.PAGE_UP;
			case END: Keyboard.END;
			case PAGE_DOWN: Keyboard.PAGE_DOWN;
			case RIGHT: Keyboard.RIGHT;
			case LEFT: Keyboard.LEFT;
			case DOWN: Keyboard.DOWN;
			case UP: Keyboard.UP;
			case NUM_LOCK: Keyboard.NUMLOCK;
			case NUMPAD_DIVIDE: Keyboard.NUMPAD_DIVIDE;
			case NUMPAD_MULTIPLY: Keyboard.NUMPAD_MULTIPLY;
			case NUMPAD_MINUS: Keyboard.NUMPAD_SUBTRACT;
			case NUMPAD_PLUS: Keyboard.NUMPAD_ADD;
			case NUMPAD_ENTER: Keyboard.NUMPAD_ENTER;
			case NUMPAD_1: Keyboard.NUMPAD_1;
			case NUMPAD_2: Keyboard.NUMPAD_2;
			case NUMPAD_3: Keyboard.NUMPAD_3;
			case NUMPAD_4: Keyboard.NUMPAD_4;
			case NUMPAD_5: Keyboard.NUMPAD_5;
			case NUMPAD_6: Keyboard.NUMPAD_6;
			case NUMPAD_7: Keyboard.NUMPAD_7;
			case NUMPAD_8: Keyboard.NUMPAD_8;
			case NUMPAD_9: Keyboard.NUMPAD_9;
			case NUMPAD_0: Keyboard.NUMPAD_0;
			case NUMPAD_PERIOD: Keyboard.NUMPAD_DECIMAL;
			case APPLICATION: 302;
			case F13: Keyboard.F13;
			case F14: Keyboard.F14;
			case F15: Keyboard.F15;
			case NUMPAD_DECIMAL: Keyboard.NUMPAD_DECIMAL;
			case LEFT_CTRL: Keyboard.CONTROL;
			case LEFT_SHIFT: Keyboard.SHIFT;
			case LEFT_ALT: Keyboard.ALTERNATE;
			case LEFT_META: Keyboard.COMMAND;
			case RIGHT_CTRL: Keyboard.CONTROL;
			case RIGHT_SHIFT: Keyboard.SHIFT;
			case RIGHT_ALT: Keyboard.ALTERNATE;
			case RIGHT_META: Keyboard.COMMAND;
			default: key;
		}
	}

	static function getCharCode (key:Int, shift:Bool = false):Int {
		if (!shift) {
			switch (key) {
				case Keyboard.BACKSPACE: return 8;
				case Keyboard.TAB: return 9;
				case Keyboard.ENTER: return 13;
				case Keyboard.ESCAPE: return 27;
				case Keyboard.SPACE: return 32;
				case Keyboard.SEMICOLON: return 59;
				case Keyboard.EQUAL: return 61;
				case Keyboard.COMMA: return 44;
				case Keyboard.MINUS: return 45;
				case Keyboard.PERIOD: return 46;
				case Keyboard.SLASH: return 47;
				case Keyboard.BACKQUOTE: return 96;
				case Keyboard.LEFTBRACKET: return 91;
				case Keyboard.BACKSLASH: return 92;
				case Keyboard.RIGHTBRACKET: return 93;
				case Keyboard.QUOTE: return 39;
			}
			
			if (key >= Keyboard.NUMBER_0 && key <= Keyboard.NUMBER_9) 
				return key - Keyboard.NUMBER_0 + 48;
			
			if (key >= Keyboard.A && key <= Keyboard.Z)
				return key - Keyboard.A + 97;
		}else{
			switch (key) {
				case Keyboard.NUMBER_0: return 41;
				case Keyboard.NUMBER_1: return 33;
				case Keyboard.NUMBER_2: return 64;
				case Keyboard.NUMBER_3: return 35;
				case Keyboard.NUMBER_4: return 36;
				case Keyboard.NUMBER_5: return 37;
				case Keyboard.NUMBER_6: return 94;
				case Keyboard.NUMBER_7: return 38;
				case Keyboard.NUMBER_8: return 42;
				case Keyboard.NUMBER_9: return 40;
				case Keyboard.SEMICOLON: return 58;
				case Keyboard.EQUAL: return 43;
				case Keyboard.COMMA: return 60;
				case Keyboard.MINUS: return 95;
				case Keyboard.PERIOD: return 62;
				case Keyboard.SLASH: return 63;
				case Keyboard.BACKQUOTE: return 126;
				case Keyboard.LEFTBRACKET: return 123;
				case Keyboard.BACKSLASH: return 124;
				case Keyboard.RIGHTBRACKET: return 125;
				case Keyboard.QUOTE: return 34;
			}
			
			if (key >= Keyboard.A && key <= Keyboard.Z) 
				return key - Keyboard.A + 65;
		}
		
		if (key >= Keyboard.NUMPAD_0 && key <= Keyboard.NUMPAD_9)
			return key - Keyboard.NUMPAD_0 + 48;
		
		switch (key) {
			case Keyboard.NUMPAD_MULTIPLY: return 42;
			case Keyboard.NUMPAD_ADD: return 43;
			case Keyboard.NUMPAD_ENTER: return 44;
			case Keyboard.NUMPAD_DECIMAL: return 45;
			case Keyboard.NUMPAD_DIVIDE: return 46;
			case Keyboard.DELETE: return 127;
			case Keyboard.ENTER: return 13;
			case Keyboard.BACKSPACE: return 8;
		}
		
		return 0;
		
	}
}
