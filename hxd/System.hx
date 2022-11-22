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
	/**
		Sets current cursor and can be replaced by custom function to manually operate displayed cursor.
		When called, it should call `hxd.System.setNativeCursor` and pass desired `hxd.Cursor` to it.
	**/
	public static var setCursor : Cursor -> Void = setNativeCursor;

	/**
		Can be used to temporarly disable infinite loop check
	**/
	public static var allowTimeout(get, set) : Bool;

	/**
		If you have a time consuming calculus that might trigger a timeout, you can either disable timeouts with [allowTimeout] or call timeoutTick() frequently.
	**/
	public static function timeoutTick() : Void {
	}

	static var loopFunc : Void -> Void;

	public static function getCurrentLoop() : Void -> Void {
		return loopFunc;
	}

	public static function setLoop( f : Void -> Void ) : Void {
		loopFunc = f;
	}

	public static function start( callb : Void -> Void ) : Void {
	}

	/**
		Sets currently shown cursor.
		This method is designated to be used by custom `hxd.System.setCursor`.
		Calling it outside of automated Interactive cursor update system leads to undefined behavior, and not advised.
	**/
	public static function setNativeCursor( c : Cursor ) : Void {
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

	public static function openURL( url : String ) : Void {}

	public static function setClipboardText( text : String ) : Bool {
		return false;
	}

	public static function getClipboardText() : String {
		return null;
	}

	public static function getLocale() : String {
		return "en_EN";
	}

	// getters

	static function get_width() : Int return 0;
	static function get_height() : Int return 0;
	static function get_lang() : String return "en";
	static function get_platform() : Platform return PC;
	static function get_screenDPI() : Int return 72;
	static function get_allowTimeout() return false;
	static function set_allowTimeout(b) return false;

}
