package h3d;

enum Cursor {
	Default;
	Button;
	Hand;
	TextInput;
}

class System {
	
	#if !macro

	public static var width(get,never) : Int;
	public static var height(get,never) : Int;
	public static var isTouch(get,never) : Bool;
	public static var isWindowed(get,never) : Bool;
	
	public static var isAndroid(get, never) : Bool;
	
	public static var screenDPI(get,never) : Float;

	static function get_isWindowed() {
		var p = flash.system.Capabilities.playerType;
		return p == "ActiveX" || p == "PlugIn" || p == "StandAlone" || p == "Desktop";
	}

	static function get_isTouch() {
		return flash.system.Capabilities.touchscreenType == flash.system.TouchscreenType.FINGER;
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
		return flash.system.Capabilities.manufacturer.indexOf('Android') != -1;
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

	static function isAir() {
		return flash.system.Capabilities.playerType == "Desktop";
	}
	
	public static function exit() {
		if( isAir() ) {
			var d : Dynamic = flash.Lib.current.loaderInfo.applicationDomain.getDefinition("flash.desktop.NativeApplication");
			Reflect.field(Reflect.field(d,"nativeApplication"),"exit")();
		} else
			flash.system.System.exit(0);
	}
	
	public static function setCursor( c : Cursor ) {
		flash.ui.Mouse.cursor = switch( c ) {
		case Default: "auto";
		case Button: "button";
		case Hand: "hand";
		case TextInput: "ibeam";
		}
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
			name = "PC";
		CACHED_NAME = name;
		return name;
	}
	

	#end
	
	public static macro function getFileContent( file : String ) {
		var file = haxe.macro.Context.resolvePath(file);
		var m = haxe.macro.Context.getLocalClass().get().module;
		haxe.macro.Context.registerModuleDependency(m, file);
		return macro $v{sys.io.File.getContent(file)};
	}
	
}
