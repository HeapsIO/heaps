package h3d;

class System {
	
	#if !macro

	public static var width(get,never) : Int;
	public static var height(get,never) : Int;
	public static var isTouch(get,never) : Bool;
	public static var isWindowed(get,never) : Bool;
	
	public static var isAndroid(get,never) : Bool;

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
	
	static var loop = null;
	
	public static function setLoop( f : Void -> Void ) {
		if( loop != null )
			flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, loop);
		loop = function(_) f();
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, loop);
	}

	public static function exit() {
		var isAir = flash.system.Capabilities.playerType == "Desktop";
		if( isAir ) {
			var d : Dynamic = flash.Lib.current.loaderInfo.applicationDomain.getDefinition("flash.desktop.NativeApplication");
			Reflect.field(Reflect.field(d,"nativeApplication"),"exit")();
		} else
			flash.system.System.exit(0);
	}

	#end
	
	public static macro function getFileContent( file : String ) {
		var file = haxe.macro.Context.resolvePath(file);
		var m = haxe.macro.Context.getLocalClass().get().module;
		haxe.macro.Context.registerModuleDependency(m, file);
		return macro $v{sys.io.File.getContent(file)};
	}
	
}
