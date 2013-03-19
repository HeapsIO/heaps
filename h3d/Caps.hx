package h3d;

class Caps {

	public static var width(get,null) : Int;
	public static var height(get,null) : Int;
	public static var isTouch(get,null) : Bool;
	public static var isWindowed(get,null) : Bool;

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

}
