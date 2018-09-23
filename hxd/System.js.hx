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
	static var customCursor:hxd.Cursor.CustomCursor;
	static var customCursorFrame:Int;
	static var customCursorDelay:Float;
	static var customCursorTime:Float;

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
		if ( customCursor != null ) {
			var newTime : Float = customCursorTime + hxd.Timer.deltaT;
			var delay : Float = customCursorDelay;
			var index : Int = customCursorFrame;
			while( newTime >= delay )
			{
				newTime -= delay;
				index++;
			}
			customCursorTime = newTime;
			
			if ( index >= customCursor.frames.length ) index %= customCursor.frames.length;
			if ( index != customCursorFrame ) {
				customCursorFrame = index;
				var canvas = @:privateAccess hxd.Stage.getInstance().canvas;
				if ( canvas != null ) {
					canvas.style.cursor = customCursor.alloc[index];
				}
			}
		}
	}

	public static function start( callb : Void -> Void ) : Void {
		callb();
	}

	public static function setNativeCursor( c : Cursor ) : Void {
		var canvas = @:privateAccess hxd.Stage.getInstance().canvas;
		customCursor = null;
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
				if (cur.frames.length > 1)
				{
					customCursor = cur;
					customCursorDelay = cur.speed == 0 ? 0.1 : 1 / cur.speed;
					customCursorFrame = 0;
					customCursorTime = 0;
				}
				cur.alloc[0];
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

	// getters

	static function get_width() : Int return Math.round(js.Browser.document.body.clientWidth * js.Browser.window.devicePixelRatio);
	static function get_height() : Int return Math.round(js.Browser.document.body.clientHeight  * js.Browser.window.devicePixelRatio);
	static function get_lang() : String return "en";
	static function get_platform() : Platform return PC;
	static function get_screenDPI() : Int return 72;
	static function get_allowTimeout() return false;
	static function set_allowTimeout(b) return false;

}
