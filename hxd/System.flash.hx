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

	// FLASH
	static var hasLoop : Bool;

	public static function getCurrentLoop() : Void -> Void {
		return loopFunc;
	}

	public static function setLoop( f : Void -> Void ) : Void {
		loopFunc = f;
		if( hasLoop ) {
			hasLoop = false;
			flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, onLoop);
		}
		if( f != null ) {
			hasLoop = true;
			flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, onLoop);
		}
	}

	static function onLoop(_) {
		loopFunc();
		var e = h3d.Engine.getCurrent();
		if( e != null ) e.driver.present();
	}

	public static function start( callb : Void -> Void ) : Void {
		callb();
	}

	public static function setNativeCursor( c : Cursor ) : Void {
		flash.ui.Mouse.cursor = switch( c ) {
		case Default: "auto";
		case Button: "button";
		case Move: "hand";
		case TextInput: "ibeam";
		case Hide: "auto";
		case Custom(cursor):
			if( cursor.alloc == null ) {
				var c = new flash.ui.MouseCursorData();
				var v = new flash.Vector();
				for( f in cursor.frames ) v.push(f.toNative());
				c.data = v;
				c.frameRate = cursor.speed;
				c.hotSpot = new flash.geom.Point(cursor.offsetX, cursor.offsetY);
				cursor.alloc = c;
				flash.ui.Mouse.registerCursor(cursor.name, cursor.alloc);
			}
			cursor.name;
		case Callback(_): throw "assert";
		}
		if( c == Hide ) flash.ui.Mouse.hide() else flash.ui.Mouse.show();
	}

	static var CACHED_NAME = null;
	public static function getDeviceName() : String {
		if( CACHED_NAME != null )
			return CACHED_NAME;
		var name;
		switch( platform ) {
		case Android if( isAir() ):
			try {
				var f : Dynamic = Type.createInstance(flash.Lib.current.loaderInfo.applicationDomain.getDefinition("flash.filesystem.File"), ["/system/build.prop"]);
				var fs : flash.utils.IDataInput = Type.createInstance(flash.Lib.current.loaderInfo.applicationDomain.getDefinition("flash.filesystem.FileStream"), []);
				Reflect.callMethod(fs, Reflect.field(fs, "open"), [f, "read"]);
				var content = fs.readUTFBytes(fs.bytesAvailable);
				name = StringTools.trim(content.split("ro.product.model=")[1].split("\n")[0]);
			} catch( e : Dynamic ) {
				name = "Android";
			}
		case IOS:
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
		default:
			name = "PC";
		}
		return name;
	}

	public static function getDefaultFrameRate() : Float {
		return flash.Lib.current.stage.frameRate;
	}

	public static function getValue( s : SystemValue ) : Bool {
		switch( s ) {
		case IsWindowed:
			var p = flash.system.Capabilities.playerType;
			return p == "ActiveX" || p == "PlugIn" || p == "StandAlone" || p == "Desktop";
		case IsMobile:
			return platform == IOS || platform == Android;
		case IsTouch:
			return flash.system.Capabilities.touchscreenType == flash.system.TouchscreenType.FINGER;
		}
	}

	public static function exit() : Void {
		if( isAir() ) {
			var d : Dynamic = flash.Lib.current.loaderInfo.applicationDomain.getDefinition("flash.desktop.NativeApplication");
			Reflect.field(Reflect.field(d,"nativeApplication"),"exit")();
		} else
			flash.system.System.exit(0);
	}

	public static function openURL( url : String ) : Void {
		throw 'Not implemented';
	}

	// getters

	static function get_width() {
		var Cap = flash.system.Capabilities;
		return getValue(IsWindowed) ? flash.Lib.current.stage.stageWidth : Std.int(Cap.screenResolutionX > Cap.screenResolutionY ? Cap.screenResolutionX : Cap.screenResolutionY);
	}

	static function get_height() {
		var Cap = flash.system.Capabilities;
		return getValue(IsWindowed) ? flash.Lib.current.stage.stageHeight : Std.int(Cap.screenResolutionX > Cap.screenResolutionY ? Cap.screenResolutionY : Cap.screenResolutionX);
	}

	static function get_lang() : String {
		return flash.system.Capabilities.language;
	}

	static function get_platform() : Platform {
		if( flash.system.Capabilities.manufacturer.indexOf('Android') != -1 )
			return Android;
		if( flash.system.Capabilities.manufacturer.indexOf('iOS') != -1 )
			return IOS;
		return FlashPlayer;
	}

	static function isAir() : Bool {
		return flash.system.Capabilities.playerType == "Desktop";
	}

	static function get_screenDPI() : Int {
		return Std.int(flash.system.Capabilities.screenDPI);
	}

	static function get_allowTimeout() return true;
	static function set_allowTimeout(b) return true; // can't be disabled

}

