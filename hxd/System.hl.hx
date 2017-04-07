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

//@:coreApi
class System {

	public static var width(get,never) : Int;
	public static var height(get, never) : Int;
	public static var lang(get, never) : String;
	public static var platform(get, never) : Platform;
	public static var screenDPI(get,never) : Float;
	public static var setCursor = setNativeCursor;

	static var loopFunc : Void -> Void;

	// -- HL
	static var currentNativeCursor : Cursor = Default;
	static var cursorVisible = true;

	public static function getCurrentLoop() : Void -> Void {
		return loopFunc;
	}

	public static function setLoop( f : Void -> Void ) : Void {
		loopFunc = f;
	}

	static function mainLoop() : Void {
		if( loopFunc != null ) loopFunc();
		@:privateAccess hxd.Stage.inst.window.present();
	}

	public static function start( init : Void -> Void ) : Void {
		sdl.Sdl.tick();
		sdl.Sdl.init();
		var width = 800;
		var height = 600;
		var size = haxe.macro.Compiler.getDefine("windowSize");
		var title = haxe.macro.Compiler.getDefine("windowTitle");
		if( title == null )
			title = "";
		if( size != null ) {
			var p = size.split("x");
			width = Std.parseInt(p[0]);
			height = Std.parseInt(p[1]);
		}
		@:privateAccess Stage.initChars();
		@:privateAccess Stage.inst = new Stage(title, width, height);
		init();
		sdl.Sdl.defaultEventHandler = @:privateAccess Stage.inst.onEvent;
		haxe.MainLoop.add(mainLoop);
	}

	public static function setNativeCursor( c : Cursor ) : Void {
		if( c.equals(currentNativeCursor) )
			return;
		currentNativeCursor = c;
		if( c == Hide ) {
			cursorVisible = false;
			sdl.Cursor.show(false);
			return;
		}
		var cur : sdl.Cursor;
		switch( c ) {
		case Default:
			cur = sdl.Cursor.createSystem(Arrow);
		case Button:
			cur = sdl.Cursor.createSystem(Hand);
		case Move:
			throw "Cursor not supported";
		case TextInput:
			cur = sdl.Cursor.createSystem(IBeam);
		case Hide:
			throw "assert";
		case Custom(c):
			if( c.alloc == null ) {
				if( c.frames.length > 1 ) throw "Animated cursor not supported";
				var pixels = c.frames[0].getPixels();
				pixels.convert(BGRA);
				var surf = sdl.Surface.fromBGRA(pixels.bytes, pixels.width, pixels.height);
				c.alloc = sdl.Cursor.create(surf, c.offsetX, c.offsetY);
				surf.free();
				pixels.dispose();
			}
			cur = c.alloc;
		}
		cur.set();
		if( !cursorVisible ) {
			cursorVisible = true;
			sdl.Cursor.show(true);
		}
	}

	public static function getDeviceName() : String {
		return "PC/" + sdl.Sdl.getDevices()[0];
	}

	public static function getDefaultFrameRate() : Float {
		return 60.;
	}

	public static function getValue( s : SystemValue ) : Bool {
		return switch( s ) {
		case IsWindowed:
			return true;
		default:
			return false;
		}
	}

	public static function exit() : Void {
		try {
			Sys.exit(0);
		} catch( e : Dynamic ) {
			// access violation sometimes ?
			exit();
		}
	}

	@:hlNative("std","sys_locale") static function getLocale() : hl.Bytes { return null; }

	static var _lang : String;
	static function get_lang() : String {
		if( _lang == null ) {
			var str = @:privateAccess String.fromUCS2(getLocale());
			_lang = ~/[.@_-]/g.split(str)[0];
		}
		return _lang;
	}

	// getters

	static function get_width() : Int return sdl.Sdl.getScreenWidth();
	static function get_height() : Int return sdl.Sdl.getScreenHeight();
	static function get_platform() : Platform return PC;
	static function get_screenDPI() : Int return 72; // TODO : SDL ?

}
