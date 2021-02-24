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

	/** If greater than 0, this will reduce loop framerate to reduce CPU usage **/
	public static var fpsLimit = -1;

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
		if( fpsLimit>0 )
			js.Browser.window.setTimeout( ()->rqf(browserLoop), 1000/fpsLimit );
		else
			rqf(browserLoop);

		if( loopFunc != null ) loopFunc();
	}

	public static function start( callb : Void -> Void ) : Void {
		callb();
	}

	public static function setNativeCursor( c : Cursor ) : Void {
		if( currentNativeCursor != null && c.equals(currentNativeCursor) )
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
			case Callback(_): throw "assert";
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
		return switch( s ) {
		case IsWindowed: true;
		case IsTouch: platform==Android || platform==IOS;
		case IsMobile: platform==Android || platform==IOS;
		default: false;
		}
	}

	public static function exit() : Void {
	}

	public static function openURL( url : String ) : Void {
		js.Browser.window.open(url, '_blank');
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
	static function get_platform() : Platform {
		var ua = js.Browser.navigator.userAgent.toLowerCase();
		if( ua.indexOf("android")>=0 )
			return Android;
		else if( ua.indexOf("ipad")>=0 || ua.indexOf("iphone")>=0 || ua.indexOf("ipod")>=0 )
			return IOS;
		else
			return PC;
	}
	static function get_screenDPI() : Int return 72;
	static function get_allowTimeout() return false;
	static function set_allowTimeout(b) return false;

	static function __init__() : Void {
		haxe.MainLoop.add(updateCursor, -1);
	}

}
