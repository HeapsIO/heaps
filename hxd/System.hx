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

	static function get_screenDPI() {
		return flash.system.Capabilities.screenDPI;
	}

	static var loop = null;

	public static function setLoop( f : Void -> Void ) {
		if( loop != null )
			flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, loop);
		if( f == null )
			loop = null;
		else {
			loop = function(_) f();
			flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, loop);
		}
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

	#elseif openfl

	static var VIEW = null;

	public static function setLoop( f : Void -> Void ) {
		if( VIEW == null ) {
			VIEW = new openfl.display.OpenGLView();
			VIEW.name = "glView";
			flash.Lib.current.addChildAt(VIEW,0);
		}
		VIEW.render = function(_) if( f != null ) f();
	}

	public static var setCursor = setNativeCursor;

	public static function setNativeCursor( c : Cursor ) {
		/* not supported by openFL
		flash.ui.Mouse.cursor = switch( c ) {
		case Default: "auto";
		case Button: "button";
		case Move: "hand";
		case TextInput: "ibeam";
		}*/
	}

	static function get_lang() {
		return flash.system.Capabilities.language.split("-")[0];
	}

	static function get_screenDPI() {
		return flash.system.Capabilities.screenDPI;
	}

	static function get_isAndroid() {
		#if android
		return true;
		#else
		return false;
		#end
	}

	static var CACHED_NAME = null;
	public static function getDeviceName() {
		if( CACHED_NAME != null )
			return CACHED_NAME;
		var name;
		if( isAndroid ) {
			try {
				var content = sys.io.File.getContent("/system/build.prop");
				name = StringTools.trim(content.split("ro.product.model=")[1].split("\n")[0]);
			} catch( e : Dynamic ) {
				name = "Android";
			}
		} else
			name = "PC";
		CACHED_NAME = name;
		return name;
	}

	public static function exit() {
		Sys.exit(0);
	}

	static function get_isWindowed() {
		return true;
	}

	static function get_isTouch() {
		return false;
	}

	static function get_width() {
		var Cap = flash.system.Capabilities;
		return isWindowed ? flash.Lib.current.stage.stageWidth : Std.int(Cap.screenResolutionX > Cap.screenResolutionY ? Cap.screenResolutionX : Cap.screenResolutionY);
	}

	static function get_height() {
		var Cap = flash.system.Capabilities;
		return isWindowed ? flash.Lib.current.stage.stageHeight : Std.int(Cap.screenResolutionX > Cap.screenResolutionY ? Cap.screenResolutionY : Cap.screenResolutionX);
	}

	#end

}
