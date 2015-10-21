package hxd;

#if hxsdl
import hxd.Key in K;
#end

enum Cursor {
	Default;
	Button;
	Move;
	TextInput;
	Hide;
	Custom( frames : Array<hxd.BitmapData>, speed : Float, offsetX : Int, offsetY : Int );
}

class System {

	public static var width(get,never) : Int;
	public static var height(get,never) : Int;
	public static var isTouch(get,never) : Bool;
	public static var isWindowed(get,never) : Bool;
	public static var lang(get,never) : String;
	public static var isAndroid(get, never) : Bool;
	public static var isIOS(get, never) : Bool;

	public static var screenDPI(get,never) : Float;

	public static var setCursor = setNativeCursor;

	#if (flash || nme || openfl)

	static function get_isWindowed() {
		#if cpp
		return true;
		#else
		var p = flash.system.Capabilities.playerType;
		return p == "ActiveX" || p == "PlugIn" || p == "StandAlone" || p == "Desktop";
		#end
	}

	static function get_isTouch() {
		#if cpp
		return false;
		#else
		return flash.system.Capabilities.touchscreenType == flash.system.TouchscreenType.FINGER;
		#end
	}

	static function get_width() {
		var Cap = flash.system.Capabilities;
		return isWindowed ? flash.Lib.current.stage.stageWidth : Std.int(Cap.screenResolutionX > Cap.screenResolutionY ? Cap.screenResolutionX : Cap.screenResolutionY);
	}

	static function get_height() {
		var Cap = flash.system.Capabilities;
		return isWindowed ? flash.Lib.current.stage.stageHeight : Std.int(Cap.screenResolutionX > Cap.screenResolutionY ? Cap.screenResolutionY : Cap.screenResolutionX);
	}

	static function get_isAndroid() {
		#if cpp
		return #if android true #else false #end;
		#else
		return flash.system.Capabilities.manufacturer.indexOf('Android') != -1;
		#end
	}

	static function get_isIOS() {
		#if cpp
		return #if ios true #else false #end;
		#else
		return flash.system.Capabilities.manufacturer.indexOf('iOS') != -1;
		#end
	}

	static function get_screenDPI() {
		return flash.system.Capabilities.screenDPI;
	}

	static var loop = null;
	static var loopFunc = null;
	#if (nme || openfl)
	static var VIEW = null;
	#end

	public static function getCurrentLoop() {
		return loopFunc;
	}

	public static function setLoop( f : Void -> Void ) {
		loopFunc = f;
		#if nme
		if( VIEW == null ) {
			VIEW = new nme.display.OpenGLView();
			VIEW.name = "glView";
			flash.Lib.current.addChildAt(VIEW,0);
		}
		VIEW.render = function(_) if ( f != null ) f();
		#elseif openfl
		if( VIEW == null ) {
			VIEW = new openfl.display.OpenGLView();
			VIEW.name = "glView";
			flash.Lib.current.addChildAt(VIEW,0);
		}
		VIEW.render = function(_) if ( f != null ) f();
		#else
		if( loop != null )
			flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, loop);
		if( f == null )
			loop = null;
		else {
			loop = function(_) f();
			flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, loop);
		}
		#end
	}

	public static function start(callb) {
		#if nme
		var windowSize = haxe.macro.Compiler.getDefine("window");
		if( windowSize == null ) windowSize = "800x600";
		var windowSize = windowSize.split("x");
		var width = Std.parseInt(windowSize[0]), height = Std.parseInt(windowSize[1]);
		if( width < 100 ) width = 100;
		if( height < 100 ) height = 100;
		nme.Lib.create(function() {
            nme.Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
            nme.Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
            nme.Lib.current.loaderInfo = nme.display.LoaderInfo.create(null);
			try {
				callb();
			} catch( e : Dynamic ) {
				Sys.println(e);
				#if debug
				Sys.println(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
				#end
			}
         },
         width, height,
         120, // using 60 FPS with no vsync gives a fps ~= 50
         0xFFFFFF,
         (true ? nme.Lib.HARDWARE : 0) |
         nme.Lib.ALLOW_SHADERS | nme.Lib.REQUIRE_SHADERS |
         (true ? nme.Lib.DEPTH_BUFFER : 0) |
         (false ? nme.Lib.STENCIL_BUFFER : 0) |
         (true ? nme.Lib.RESIZABLE : 0) |
         (false ? nme.Lib.BORDERLESS : 0) |
         (true ? nme.Lib.VSYNC : 0) |
         (false ? nme.Lib.FULLSCREEN : 0) |
         (0 == 4 ? nme.Lib.HW_AA_HIRES : 0) |
         (0 == 2 ? nme.Lib.HW_AA : 0),
         "Heaps Application"
		);
		#elseif openfl
		var windowSize = haxe.macro.Compiler.getDefine("window");
		if( windowSize == null ) windowSize = "800x600";
		var windowSize = windowSize.split("x");
		var width = Std.parseInt(windowSize[0]), height = Std.parseInt(windowSize[1]);
		if( width < 100 ) width = 100;
		if ( height < 100 ) height = 100;
		
		var config = {
			
			build: "1",
			company: "Heaps",
			fps: 60,
			orientation: "",
			packageName: "heaps.application",
			version: "0.0.1",
			windows: [
				
				{
					antialiasing: 0,
					background: 16777215,
					borderless: false,
					depthBuffer: true,
					display: 0,
					fullscreen: false,
					hardware: true,
					height: height,
					parameters: "{}",
					resizable: true,
					stencilBuffer: true,
					title: "Heaps Application",
					vsync: true,
					width: width,
					x: null,
					y: null
				},
			]
			
		};
		
		var app = new openfl.display.Application ();
		app.create (config);
		
		try {
			callb();
		} catch( e : Dynamic ) {
			Sys.println(e);
			#if debug
			Sys.println(haxe.CallStack.toString(haxe.CallStack.exceptionStack()));
			#end
		}
		
		var result = app.exec ();
		
		#if sys
		Sys.exit(result);
		#end
		
		#else
		callb();
		#end
	}

	#if flash
	static function isAir() {
		return flash.system.Capabilities.playerType == "Desktop";
	}
	#end

	public static function getClipboard() : String {
		#if flash
		return flash.desktop.Clipboard.generalClipboard.getData(flash.desktop.ClipboardFormats.TEXT_FORMAT);
		#else
		return "";
		#end
	}

	public static function exit() {
		#if flash
		if( isAir() ) {
			var d : Dynamic = flash.Lib.current.loaderInfo.applicationDomain.getDefinition("flash.desktop.NativeApplication");
			Reflect.field(Reflect.field(d,"nativeApplication"),"exit")();
		} else
		#end
			flash.system.System.exit(0);
	}

	public static function setNativeCursor( c : Cursor ) {
		#if cpp
		// TODO
		#else
		flash.ui.Mouse.cursor = switch( c ) {
		case Default: "auto";
		case Button: "button";
		case Move: "hand";
		case TextInput: "ibeam";
		case Hide: "auto";
		case Custom(frames, speed, offsetX, offsetY):
			#if cpp
				throw "not supported on openFL for now";
			#else
				var customCursor = new flash.ui.MouseCursorData();
				var v = new flash.Vector();
				for( f in frames ) v.push(f.toNative());
				customCursor.data = v;
				customCursor.frameRate = speed;
				customCursor.hotSpot = new flash.geom.Point(offsetX, offsetY);
				flash.ui.Mouse.registerCursor("custom", customCursor);
				"custom";
			#end
		}
		#end
		if( c == Hide ) flash.ui.Mouse.hide() else flash.ui.Mouse.show();
	}


	/**
		Returns the device name:
			"PC" for a desktop computer
			Or the android device name
			(will add iPad/iPhone/iPod soon)
	**/
	static var CACHED_NAME = null;
	public static function getDeviceName() {
		if( CACHED_NAME != null )
			return CACHED_NAME;
		var name;
		#if flash
		if( isAndroid && isAir() ) {
			try {
				var f : Dynamic = Type.createInstance(flash.Lib.current.loaderInfo.applicationDomain.getDefinition("flash.filesystem.File"), ["/system/build.prop"]);
				var fs : flash.utils.IDataInput = Type.createInstance(flash.Lib.current.loaderInfo.applicationDomain.getDefinition("flash.filesystem.FileStream"), []);
				Reflect.callMethod(fs, Reflect.field(fs, "open"), [f, "read"]);
				var content = fs.readUTFBytes(fs.bytesAvailable);
				name = StringTools.trim(content.split("ro.product.model=")[1].split("\n")[0]);
			} catch( e : Dynamic ) {
				name = "Android";
			}
		} else
		#end
		if( isIOS ) {
			name = switch( [width, height, screenDPI] ) {
			case [960, 640, 326]: "iPhone4";
			case [1136, 640, 326]: "iPhone5";
			case [1334, 750, 326]: "iPhone6";
			case [1920, 1080, 401]: "iPhone6+";
			case [2048, 1536, 264]: "iPad"; // 3/4/Air
			case [2048, 1536, 326]: "iPadMini2";
			case [1024, 768, 163]: "iPadMini";
			case [w, h, dpi]: "IOS Unknown " + w + "x" + h + "@" + dpi;
			}
		} else
			name = "PC";
		CACHED_NAME = name;
		return name;
	}

	static function get_lang() {
		return flash.system.Capabilities.language;
	}

	#elseif js

	static var LOOP = null;
	static var LOOP_INIT = false;

	static function loopFunc() {
		var window : Dynamic = js.Browser.window;
		var rqf : Dynamic = window.requestAnimationFrame ||
			window.webkitRequestAnimationFrame ||
			window.mozRequestAnimationFrame;
		rqf(loopFunc);
		if( LOOP != null ) LOOP();
	}

	public static function getCurrentLoop() {
		return LOOP;
	}

	public static function setLoop( f : Void -> Void ) {
		if( !LOOP_INIT ) {
			LOOP_INIT = true;
			loopFunc();
		}
		LOOP = f;
	}

	public static function start( callb ) {
		callb();
	}

	public static function getClipboard() : String {
		return "";
	}

	public static function setNativeCursor( c : Cursor ) {
		var canvas = js.Browser.document.getElementById("webgl");
		if( canvas != null ) {
			canvas.style.cursor = switch( c ) {
			case Default: "default";
			case Button: "pointer";
			case Move: "move";
			case TextInput: "text";
			case Hide: "none";
			case Custom(_): throw "Custom cursor not supported";
			};
		}
	}

	static function get_lang() {
		return "en";
	}

	static function get_screenDPI() {
		return 72.;
	}

	static function get_isAndroid() {
		return false;
	}

	static function get_isIOS() {
		return false;
	}

	static function get_isWindowed() {
		return true;
	}

	static function get_isTouch() {
		return false;
	}

	static function get_width() {
		return Math.round(js.Browser.document.body.clientWidth * js.Browser.window.devicePixelRatio);
	}

	static function get_height() {
		return Math.round(js.Browser.document.body.clientHeight  * js.Browser.window.devicePixelRatio);
	}

	#elseif hxsdl

	public static function setNativeCursor( c : Cursor ) {
		trace("TODO " + c);
	}

	static function get_screenDPI() {
		return 72; // not implemented in SDL ???
	}

	static function get_isIOS() {
		return false;
	}

	static function get_isAndroid() {
		return false;
	}

	static function get_isWindowed() {
		return true;
	}

	static function get_isTouch() {
		return false;
	}

	static function get_lang() {
		return "en";
	}

	static function get_width() {
		return sdl.Sdl.getScreenWidth();
	}

	static function get_height() {
		return sdl.Sdl.getScreenHeight();
	}

	public static function exit() {
		Sys.exit(0);
	}

	public static function getClipboard() : String {
		return "";
	}

	static var win : sdl.Window;
	static var windowWidth = 800;
	static var windowHeight = 600;
	static var mouseX = 0;
	static var mouseY = 0;
	static var currentLoop = null;
	static var CODEMAP = [for( i in 0...2048 ) i];
	static var CHARMAP = [for( i in 0...2048 ) 0];

	public static function setLoop( f : Void -> Void ) {
		currentLoop = f;
	}

	static function mainLoop() {
		if( currentLoop != null ) currentLoop();
		win.present();
	}

	static function onEvent( e : sdl.Event ) {
		var eh = null;
		switch( e.type ) {
		case WindowState:
			switch( e.state ) {
			case Resize:
				windowWidth = win.width;
				windowHeight = win.height;
				@:privateAccess Stage.getInstance().onResize(null);
			default:
			}
		case MouseDown:
			mouseX = e.mouseX;
			mouseY = e.mouseY;
			eh = new Event(EPush, e.mouseX, e.mouseY);
		case MouseUp:
			mouseX = e.mouseX;
			mouseY = e.mouseY;
			eh = new Event(ERelease, e.mouseX, e.mouseY);
		case MouseMove:
			mouseX = e.mouseX;
			mouseY = e.mouseY;
			eh = new Event(EMove, e.mouseX, e.mouseY);
		case KeyDown:
			eh = new Event(EKeyDown);
			if( e.keyCode & (1 << 30) != 0 ) e.keyCode = (e.keyCode & ((1 << 30) - 1)) + 1000;
			eh.keyCode = CODEMAP[e.keyCode];
			eh.charCode = CHARMAP[e.keyCode];
			if( eh.keyCode & (K.LOC_LEFT | K.LOC_RIGHT) != 0 ) {
				e.keyCode = eh.keyCode & 0xFF;
				onEvent(e);
			}
		case KeyUp:
			eh = new Event(EKeyUp);
			if( e.keyCode & (1 << 30) != 0 ) e.keyCode = (e.keyCode & ((1 << 30) - 1)) + 1000;
			eh.keyCode = CODEMAP[e.keyCode];
			eh.charCode = CHARMAP[e.keyCode];
			if( eh.keyCode & (K.LOC_LEFT | K.LOC_RIGHT) != 0 ) {
				e.keyCode = eh.keyCode & 0xFF;
				onEvent(e);
			}
		case MouseWheel:
			eh = new Event(EWheel, mouseX, mouseY);
			eh.wheelDelta = -e.wheelDelta;
		default:
		}
		if( eh != null ) Stage.getInstance().event(eh);
	}

	public static function start( init : Void -> Void ) {
		inline function addKey(sdl, keyCode, charCode=0) {
			CODEMAP[sdl] = keyCode;
			if( charCode != 0 ) CHARMAP[sdl] = charCode;
		}
		var keys = [
			//K.BACKSPACE
			//K.TAB
			//K.ENTER
			1225 => K.LSHIFT,
			1229 => K.RSHIFT,
			1224 => K.LCTRL,
			1228 => K.RCTRL,
			1226 => K.LALT,
			1230 => K.RALT,
			// K.ESCAPE
			// K.SPACE
			1075 => K.PGUP,
			1078 => K.PGDOWN,
			1077 => K.END,
			1074 => K.HOME,
			1080 => K.LEFT,
			1082 => K.UP,
			1079 => K.RIGHT,
			1081 => K.DOWN,
			1073 => K.INSERT,
			127 => K.DELETE,
			//K.NUMBER_0-9
			1098 => K.NUMPAD_0,
			//K.A-Z
			//K.F1-F12
			1085 => K.NUMPAD_MULT,
			1087 => K.NUMPAD_ADD,
			1088 => K.NUMPAD_ENTER,
			1086 => K.NUMPAD_SUB,
			1099 => K.NUMPAD_DOT,
			1084 => K.NUMPAD_DIV,
		];

		/*
			SDL 2.0 does not allow to get the charCode from a key event.
			let's for now do a simple mapping, even if not very efficient
		*/
		CHARMAP[1098] = "0".code;
		CHARMAP[1085] = "*".code;
		CHARMAP[1087] = "+".code;
		CHARMAP[1088] = 13;
		CHARMAP[1086] = "-".code;
		CHARMAP[1084] = "/".code;
		CHARMAP[1099] = ".".code;
		CHARMAP[K.BACKSPACE] = 8;
		CHARMAP[K.TAB] = 9;
		CHARMAP[K.ENTER] = 13;
		CHARMAP[K.SPACE] = 32;

		for( i in 0...10 )
			CHARMAP[K.NUMBER_0 + i] = "0".code + i;

		for( i in 0...9 )
			addKey(1089 + i, K.NUMPAD_1 + i, "1".code + i);
		for( i in 0...26 )
			addKey(97 + i, K.A + i, "a".code + i);
		for( i in 0...12 )
			addKey(1058 + i, K.F1 + i);
		for( sdl in keys.keys() )
			addKey(sdl, keys.get(sdl));
		sdl.Sdl.init();
		var size = haxe.macro.Compiler.getDefine("windowSize");
		if( size != null ) {
			var p = size.split("x");
			windowWidth = Std.parseInt(p[0]);
			windowHeight = Std.parseInt(p[1]);
		}
		win = new sdl.Window("", windowWidth, windowHeight);
		init();
		sdl.Sdl.loop(mainLoop,onEvent);
		sdl.Sdl.quit();
	}


	#end

}
