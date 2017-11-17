package hxd;

#if hlsdl
import sdl.Cursor;
#elseif hldx
import dx.Cursor;
#end

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
	public static var allowTimeout(get, set) : Bool;

	static var loopFunc : Void -> Void;


	// -- HL
	static var currentNativeCursor : hxd.Cursor = Default;
	static var cursorVisible = true;

	public static function getCurrentLoop() : Void -> Void {
		return loopFunc;
	}

	public static function setLoop( f : Void -> Void ) : Void {
		loopFunc = f;
	}

	static function mainLoop() : Void {
		if( loopFunc != null ) loopFunc();
		#if usesys
		haxe.System.present();
		#elseif hlsdl
		@:privateAccess hxd.Stage.inst.window.present();
		#end
	}

	public static function start( init : Void -> Void ) : Void {
		#if usesys
		if( !haxe.System.init() ) return;
		@:privateAccess Stage.inst = new Stage("", haxe.System.width, haxe.System.height);
		init();
		#else
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
		#if hlsdl
			sdl.Sdl.tick();
			sdl.Sdl.init();
			@:privateAccess Stage.initChars();
			@:privateAccess Stage.inst = new Stage(title, width, height);
			init();
			sdl.Sdl.defaultEventHandler = @:privateAccess Stage.inst.onEvent;
		#elseif hldx
			@:privateAccess Stage.inst = new Stage(title, width, height);
			init();
			dx.Loop.defaultEventHandler = @:privateAccess Stage.inst.onEvent;
		#else
			@:privateAccess Stage.inst = new Stage(title, width, height);
			init();
		#end

		#end
		haxe.MainLoop.add(mainLoop);
	}

	public static function setNativeCursor( c : hxd.Cursor ) : Void {
		#if (hlsdl || hldx)
		if( c.equals(currentNativeCursor) )
			return;
		currentNativeCursor = c;
		if( c == Hide ) {
			cursorVisible = false;
			Cursor.show(false);
			return;
		}
		var cur : Cursor;
		switch( c ) {
		case Default:
			cur = Cursor.createSystem(Arrow);
		case Button:
			cur = Cursor.createSystem(Hand);
		case Move:
			cur = Cursor.createSystem(SizeALL);
		case TextInput:
			cur = Cursor.createSystem(IBeam);
		case Hide:
			throw "assert";
		case Custom(c):
			if( c.alloc == null ) {
				if( c.frames.length > 1 ) throw "Animated cursor not supported";
				var pixels = c.frames[0].getPixels();
				pixels.convert(BGRA);
				#if hlsdl
				var surf = sdl.Surface.fromBGRA(pixels.bytes, pixels.width, pixels.height);
				c.alloc = sdl.Cursor.create(surf, c.offsetX, c.offsetY);
				surf.free();
				#elseif hldx
				c.alloc = dx.Cursor.createCursor(pixels.width, pixels.height, pixels.bytes, c.offsetX, c.offsetY);
				#end
				pixels.dispose();
			}
			cur = c.alloc;
		}
		cur.set();
		if( !cursorVisible ) {
			cursorVisible = true;
			Cursor.show(true);
		}
		#end
	}

	public static function getDeviceName() : String {
		#if usesys
		return haxe.System.name;
		#elseif hlsdl
		return "PC/" + sdl.Sdl.getDevices()[0];
		#elseif hldx
		return "PC/" + dx.Driver.getDeviceName();
		#else
		return "PC/Commandline";
		#end
	}

	public static function getDefaultFrameRate() : Float {
		return 60.;
	}

	public static function getValue( s : SystemValue ) : Bool {
		return switch( s ) {
		#if !usesys
		case IsWindowed:
			return true;
		#end
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

	#if usesys
	static function get_width() : Int return haxe.System.width;
	static function get_height() : Int return haxe.System.height;
	static function get_platform() : Platform return Console;
	#elseif hldx
	static function get_width() : Int return dx.Window.getScreenWidth();
	static function get_height() : Int return dx.Window.getScreenHeight();
	static function get_platform() : Platform return PC; // TODO : Xbox ?
	#elseif hlsdl
	static function get_width() : Int return sdl.Sdl.getScreenWidth();
	static function get_height() : Int return sdl.Sdl.getScreenHeight();
	static function get_platform() : Platform return PC; // TODO : Xbox ?
	#else
	static function get_width() : Int return 800;
	static function get_height() : Int return 600;
	static function get_platform() : Platform return PC;
	#end

	static function get_screenDPI() : Int return 72; // TODO

	public static function timeoutTick() : Void @:privateAccess {
		#if hldx
		dx.Loop.sentinel.tick();
		#elseif hlsdl
		sdl.Sdl.sentinel.tick();
		#end
	}

	static function get_allowTimeout() @:privateAccess {
		#if hldx
		return !dx.Loop.sentinel.pause;
		#elseif hlsdl
		return !sdl.Sdl.sentinel.pause;
		#else
		return false;
		#end
	}

	static function set_allowTimeout(b) @:privateAccess {
		#if hldx
		return dx.Loop.sentinel.pause = !b;
		#elseif hlsdl
		return sdl.Sdl.sentinel.pause = !b;
		#else
		return false;
		#end
	}

}
