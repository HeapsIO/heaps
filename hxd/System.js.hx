package hxd;

enum Platform {
	IOS;
	Android;
	WebGL;
	PC;
	Console;
	FlashPlayer;
}

enum SystemValue {
	IsTouch;
	IsWindowed;
	IsMobile;
}

class System {

	public static var width(get,never) : Int;
	public static var height(get, never) : Int;
	public static var lang(get, never) : String;
	public static var platform(get, never) : Platform;
	public static var screenDPI(get,never) : Float;
	public static var setCursor = setNativeCursor;
	public static var allowTimeout(get, set) : Bool;

	public static function timeoutTick() : Void {
	}

	static var loopFunc : Void -> Void;

	// JS
	static var loopInit = false;
	static var currentNativeCursor:hxd.Cursor;
	static var currentCustomCursor:hxd.Cursor.CustomCursor;

	public static function getCurrentLoop() : Void -> Void {
		return loopFunc;
	}

	public static function setLoop( f : Void -> Void ) : Void {
		if( !loopInit ) {
			loopInit = true;
			browserLoop();
		}
		loopFunc = f;
	}

	static function browserLoop() {
		var window : Dynamic = js.Browser.window;
		var rqf : Dynamic = window.requestAnimationFrame ||
			window.webkitRequestAnimationFrame ||
			window.mozRequestAnimationFrame;
		rqf(browserLoop);
		if( loopFunc != null ) loopFunc();
	}

	public static function start( callb : Void -> Void ) : Void {
		callb();
	}

	public static function setNativeCursor( c : Cursor ) : Void {
		if( c.equals(currentNativeCursor) )
			return;
		currentNativeCursor = c;
		currentCustomCursor = null;
		var canvas = @:privateAccess hxd.Window.getInstance().canvas;
		if( canvas != null ) {
			canvas.style.cursor = switch( c ) {
			case Default: "default";
			case Button: "pointer";
			case Move: "move";
			case TextInput: "text";
			case Hide: "none";
			case Custom(cur):
				if ( cur.alloc == null ) {
					cur.alloc = new Array();
					for ( frame in cur.frames ) {
						cur.alloc.push("url(\"" + frame.toNative().canvas.toDataURL("image/png") + "\") " + cur.offsetX + " " + cur.offsetY + ", default");
					}
				}
				if ( cur.frames.length > 1 ) {
					currentCustomCursor = cur;
					cur.reset();
				}
				cur.alloc[cur.frameIndex];
			};
		}
	}

	public static function getDeviceName() : String {
		return "Unknown";
	}

	public static function getDefaultFrameRate() : Float {
		return 60.;
	}

	public static function getValue( s : SystemValue ) : Bool {
		return false;
	}

	public static function exit() : Void {
	}

	static function updateCursor() : Void {
		if ( currentCustomCursor != null ) {
			var change = currentCustomCursor.update(hxd.Timer.elapsedTime);
			if ( change != -1 ) {
				var canvas = @:privateAccess hxd.Window.getInstance().canvas;
				if ( canvas != null ) {
					canvas.style.cursor = currentCustomCursor.alloc[change];
				}
			}
		}
	}

	// getters

	static function get_width() : Int return Math.round(js.Browser.document.body.clientWidth * js.Browser.window.devicePixelRatio);
	static function get_height() : Int return Math.round(js.Browser.document.body.clientHeight  * js.Browser.window.devicePixelRatio);
	static function get_lang() : String return "en";
	static function get_platform() : Platform return PC;
	static function get_screenDPI() : Int return 72;
	static function get_allowTimeout() return false;
	static function set_allowTimeout(b) return false;

	static function __init__() : Void {
		@:privateAccess Window.initChars();
		haxe.MainLoop.add(updateCursor, -1);
	}

}
