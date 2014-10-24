package hxd;

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
	#if nme
	static var VIEW = null;
	#end

	public static function setLoop( f : Void -> Void ) {
		#if nme
		if( VIEW == null ) {
			VIEW = new nme.display.OpenGLView();
			VIEW.name = "glView";
			flash.Lib.current.addChildAt(VIEW,0);
		}
		VIEW.render = function(_) if( f != null ) f();
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
            callb();
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
		#else
		callb();
		#end
	}

	#if flash
	static function isAir() {
		return flash.system.Capabilities.playerType == "Desktop";
	}
	#end

	public static function exit() {
		#if flash
		if( isAir() ) {
			var d : Dynamic = flash.Lib.current.loaderInfo.applicationDomain.getDefinition("flash.desktop.NativeApplication");
			Reflect.field(Reflect.field(d,"nativeApplication"),"exit")();
		} else
		#end
			flash.system.System.exit(0);
	}

	public static var setCursor = setNativeCursor;

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

	public static var setCursor = setNativeCursor;

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

	#end

}
