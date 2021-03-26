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
	public static var platform(get, null) : Platform;
	public static var screenDPI(get,never) : Float;
	public static var setCursor = setNativeCursor;
	public static var allowTimeout(get, set) : Bool;

	static var loopFunc : Void -> Void;
	static var dismissErrors = false;

	#if !usesys
	static var sentinel : hl.UI.Sentinel;
	#end
	#if ( target.threaded && (haxe_ver >= 4.2) )
	static var mainThread : sys.thread.Thread;
	#end

	// -- HL
	static var currentNativeCursor : hxd.Cursor = Default;
	static var currentCustomCursor : hxd.Cursor.CustomCursor;
	static var cursorVisible = true;

	public static function getCurrentLoop() : Void -> Void {
		return loopFunc;
	}

	public static function setLoop( f : Void -> Void ) : Void {
		loopFunc = f;
	}

	static function mainLoop() : Bool {
		// process events
		#if usesys
		if( !haxe.System.emitEvents(@:privateAccess hxd.Window.inst.event) )
			return false;
		#elseif hldx
		if( !dx.Loop.processEvents(@:privateAccess hxd.Window.inst.onEvent) )
			return false;
		#elseif hlsdl
		if( !sdl.Sdl.processEvents(@:privateAccess hxd.Window.inst.onEvent) )
			return false;
		#end

		// loop
		timeoutTick();
		if( loopFunc != null ) loopFunc();

		// present
		var cur = h3d.Engine.getCurrent();
		if( cur != null && cur.ready ) {
			#if hl_profile
			hl.Profile.event(-1); // pause
			#end
			cur.driver.present();
			#if hl_profile
			hl.Profile.event(0); // next frame
			hl.Profile.event(-2); // resume
			#end
		}
		return true;
	}

	public static function start( init : Void -> Void ) : Void {
		#if usesys

		if( !haxe.System.init() ) return;
		@:privateAccess Window.inst = new Window("", haxe.System.width, haxe.System.height);
		init();

		#else
		var width = 800;
		var height = 600;
		var size = haxe.macro.Compiler.getDefine("windowSize");
		var title = haxe.macro.Compiler.getDefine("windowTitle");
		var fixed = haxe.macro.Compiler.getDefine("windowFixed") == "1";
		if( title == null )
			title = "";
		if( size != null ) {
			var p = size.split("x");
			width = Std.parseInt(p[0]);
			height = Std.parseInt(p[1]);
		}
		timeoutTick();
		#if hlsdl
			sdl.Sdl.init();
			@:privateAccess Window.initChars();
			@:privateAccess Window.inst = new Window(title, width, height, fixed);
			init();
		#elseif hldx
			@:privateAccess Window.inst = new Window(title, width, height, fixed);
			init();
		#else
			@:privateAccess Window.inst = new Window(title, width, height);
			init();
		#end
		#end

		timeoutTick();
		haxe.Timer.delay(runMainLoop, 0);
	}

	static function runMainLoop() {
		#if (haxe_ver >= 4.1)
		var reportError = function(e:Dynamic) reportError(Std.isOfType(e,haxe.Exception)?e:new haxe.Exception(Std.string(e),null,e));
		#else
		var reportError = function(e) reportError(e);
		#end
		#if ( target.threaded && (haxe_ver >= 4.2) && heaps_unsafe_events)
		var eventRecycle = [];
		#end
		while( true ) {
			try {
				hl.Api.setErrorHandler(reportError); // set exception trap

				#if ( target.threaded && (haxe_ver >= 4.2) )
				// Due to how 4.2+ timers work, instead of MainLoop, thread events have to be updated.
				// Unsafe events rely on internal implementation of EventLoop, but utilize the recycling feature
				// which in turn provides better optimization.
				#if heaps_unsafe_events
				@:privateAccess mainThread.events.__progress(Sys.time(), eventRecycle);
				#else
				mainThread.events.progress();
				#end
				#else
				@:privateAccess haxe.MainLoop.tick();
				#end

				if( !mainLoop() ) break;
			} catch( e : Dynamic ) {
				hl.Api.setErrorHandler(null);
				reportError(e);
			}
			#if hot_reload
			check_reload();
			#end
		}
		Sys.exit(0);
	}

	#if hot_reload
	@:hlNative("std","sys_check_reload")
	static function check_reload() return false;
	#end

	public dynamic static function reportError( e : Dynamic ) {
		#if (haxe_ver >= 4.1)
		var exc = Std.downcast(e, haxe.Exception);
		var stack = haxe.CallStack.toString(exc != null ? exc.stack : haxe.CallStack.exceptionStack());
		#else
		var stack = haxe.CallStack.toString(haxe.CallStack.exceptionStack());
		#end

		var err = try Std.string(e) catch( _ : Dynamic ) "????";
		#if usesys
		haxe.System.reportError(err + stack);
		#else
		Sys.stderr().writeString(err + stack + "\n");

		if ( Sys.systemName() != 'Windows' )
			return;

		if( dismissErrors )
			return;

		var f = new hl.UI.WinLog("Uncaught Exception", 500, 400);
		f.setTextContent(err+"\n"+stack);
		var but = new hl.UI.Button(f, "Continue");
		but.onClick = function() {
			hl.UI.stopLoop();
		};

		var but = new hl.UI.Button(f, "Dismiss all");
		but.onClick = function() {
			dismissErrors = true;
			hl.UI.stopLoop();
		};

		var but = new hl.UI.Button(f, "Exit");
		but.onClick = function() {
			Sys.exit(0);
		};

		while( hl.UI.loop(true) != Quit )
			timeoutTick();
		f.destroy();
		#end
	}

	public static function setNativeCursor( c : hxd.Cursor ) : Void {
		#if (hlsdl || hldx)
		if( c.equals(currentNativeCursor) )
			return;
		currentNativeCursor = c;
		currentCustomCursor = null;
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
		case Callback(_), Hide:
			throw "assert";
		case Custom(c):
			if( c.alloc == null ) {
				c.alloc = new Array();
				for ( frame in c.frames ) {
					var pixels = frame.getPixels();
					pixels.convert(BGRA);
					#if hlsdl
					if (c.offsetX < 0 || c.offsetX >= pixels.width || c.offsetY < 0 || c.offsetY >= pixels.height) {
						throw "SDL2 does not allow creation of cursors with offset outside of cursor image bounds.";
					}
					var surf = sdl.Surface.fromBGRA(pixels.bytes, pixels.width, pixels.height);
					c.alloc.push(sdl.Cursor.create(surf, c.offsetX, c.offsetY));
					surf.free();
					#elseif hldx
					c.alloc.push(dx.Cursor.createCursor(pixels.width, pixels.height, pixels.bytes, c.offsetX, c.offsetY));
					#end
					pixels.dispose();
				}
			}
			if ( c.frames.length > 1 ) {
				currentCustomCursor = c;
				c.reset();
			}
			cur = c.alloc[c.frameIndex];
		}
		cur.set();
		if( !cursorVisible ) {
			cursorVisible = true;
			Cursor.show(true);
		}
		#end
	}

	#if (hlsdl || hldx)
	static function updateCursor() : Void {
		if (currentCustomCursor != null)
		{
			var change = currentCustomCursor.update(hxd.Timer.elapsedTime);
			if (change != -1) {
				currentCustomCursor.alloc[change].set();
			}
		}
	}
	#end

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
			platform == PC;
		case IsMobile:
			platform == IOS || platform == Android;
		case IsTouch:
			// TODO: check PC touch screens?
			platform == IOS || platform == Android;
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

	public static function openURL( url : String ) : Void {
		switch Sys.systemName() {
			case 'Windows': Sys.command('start ${url}');
			case 'Linux': Sys.command('xdg-open ${url}');
			case 'Mac': Sys.command('open ${url}');
			case 'Android' | 'iOS' | 'tvOS':
			default:
		}
	}

	@:hlNative("std","sys_locale") static function sys_locale() : hl.Bytes { return null; }

	static var _lang : String;
	static function get_lang() : String {
		if( _lang == null ) {
			var str = getLocale();
			_lang = str.split("-").shift();
		}
		return _lang;
	}

	/**
	 * Returns the locale including region code ()
	**/
	static var _loc : String;
	public static function getLocale() {
		if( _loc == null ) {
			var str = @:privateAccess Sys.makePath(sys_locale());
			if( str == null ) str = "en";
			_loc = ~/[.@_]/g.split(str)[0];
		}
		return _loc;
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
	static function get_platform() : Platform {
		if (platform == null)
			platform = switch Sys.systemName() {
						case 'Windows' | 'Linux'| 'Mac': PC;
						case 'iOS' | 'tvOS': IOS;
						case 'Android': Android;
						default: PC;
					}
		return platform;
	}
	#else
	static function get_width() : Int return 800;
	static function get_height() : Int return 600;
	static function get_platform() : Platform return PC;
	#end

	static function get_screenDPI() : Int return 72; // TODO

	public static function timeoutTick() : Void @:privateAccess {
		#if !usesys
		sentinel.tick();
		#end
	}

	static function get_allowTimeout() @:privateAccess {
		#if (usesys || (haxe_ver < 4))
		return false;
		#else
		return !sentinel.pause;
		#end
	}

	static function set_allowTimeout(b) @:privateAccess {
		#if (usesys || (haxe_ver < 4))
		return false;
		#else
		return sentinel.pause = !b;
		#end
	}

	static function __init__() {
		#if !usesys
		hl.Api.setErrorHandler(function(e) reportError(e)); // initialization error
		sentinel = new hl.UI.Sentinel(30, function() throw "Program timeout (infinite loop?)");
		#end
		#if ( target.threaded && (haxe_ver >= 4.2) )
		mainThread = sys.thread.Thread.current();
		#end
	}

	#if (hlsdl || hldx)
	@:keep static var _ = {
		haxe.MainLoop.add(timeoutTick, -1) #if (haxe_ver >= 4) .isBlocking = false #end;
		haxe.MainLoop.add(updateCursor, -1) #if (haxe_ver >= 4) .isBlocking = false #end;
	}
	#end

}
