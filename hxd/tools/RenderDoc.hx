package hxd.tools;

#if (hl && hl_ver >= version("1.16.0"))
enum abstract RenderDocInputButton(Int) {
	// '0' - '9' matches ASCII values
	var Key_0 = 0x30;
	var Key_1 = 0x31;
	var Key_2 = 0x32;
	var Key_3 = 0x33;
	var Key_4 = 0x34;
	var Key_5 = 0x35;
	var Key_6 = 0x36;
	var Key_7 = 0x37;
	var Key_8 = 0x38;
	var Key_9 = 0x39;

	// 'A' - 'Z' matches ASCII values
	var Key_A = 0x41;
	var Key_B = 0x42;
	var Key_C = 0x43;
	var Key_D = 0x44;
	var Key_E = 0x45;
	var Key_F = 0x46;
	var Key_G = 0x47;
	var Key_H = 0x48;
	var Key_I = 0x49;
	var Key_J = 0x4A;
	var Key_K = 0x4B;
	var Key_L = 0x4C;
	var Key_M = 0x4D;
	var Key_N = 0x4E;
	var Key_O = 0x4F;
	var Key_P = 0x50;
	var Key_Q = 0x51;
	var Key_R = 0x52;
	var Key_S = 0x53;
	var Key_T = 0x54;
	var Key_U = 0x55;
	var Key_V = 0x56;
	var Key_W = 0x57;
	var Key_X = 0x58;
	var Key_Y = 0x59;
	var Key_Z = 0x5A;

	// leave the rest of the ASCII range free
	// in case we want to use it later
	var Key_NonPrintable = 0x100;

	var Key_Divide;
	var Key_Multiply;
	var Key_Subtract;
	var Key_Plus;

	var Key_F1;
	var Key_F2;
	var Key_F3;
	var Key_F4;
	var Key_F5;
	var Key_F6;
	var Key_F7;
	var Key_F8;
	var Key_F9;
	var Key_F10;
	var Key_F11;
	var Key_F12;

	var Key_Home;
	var Key_End;
	var Key_Insert;
	var Key_Delete;
	var Key_PageUp;
	var Key_PageDn;

	var Key_Backspace;
	var Key_Tab;
	var Key_PrtScrn;
	var Key_Pause;

	var Key_Max;
}

@:hlNative("?heaps", "rdoc_")
class RenderDocNative {
	static function init() : Bool {
		return false;
	}

	static function setCaptureKeys(keys:hl.Bytes, num:Int) : Bool {
		return false;
	}

	static function setCaptureFilePathTemplate(pathTemplate:hl.Bytes) : Bool {
		return false;
	}

	static function getCaptureFilePathTemplate() : hl.Bytes {
		return null;
	}

	static function getNumCaptures() : Int {
		return -1;
	}

	static function getCapture(index:Int, filename:hl.Bytes, pathlength:hl.Ref<Int>, timestamp:hl.Ref<haxe.Int64>) : Bool {
		return false;
	}

	static function triggerCapture() : Bool {
		return false;
	}

	static function isTargetControlConnected() : Bool {
		return false;
	}

	static function launchReplayUi(connectTargetControl:Int, cmdline:hl.Bytes) : Bool {
		return false;
	}

	static function startFrameCapture(device:Dynamic, wndHandle:Dynamic) : Bool {
		return false;
	}

	static function isFrameCapturing() : Bool {
		return false;
	}

	static function endFrameCapture(device:Dynamic, wndHandle:Dynamic) : Bool {
		return false;
	}
}

/**
	RenderDoc In-application API

	Usage: Install RenderDoc and place/copy it's lib file in your PATH (e.g. `renderdoc.dll` for Windows).
**/
@:access(hxd.tools.RenderDocNative)
class RenderDoc {

	public static function init() : Bool {
		return RenderDocNative.init();
	}

	public static function setCaptureKeys(keys:Array<RenderDocInputButton>) : Bool {
		var bytes = hl.Bytes.getArray(keys);
		return RenderDocNative.setCaptureKeys(bytes, keys.length);
	}

	public static function setCaptureFilePathTemplate(pathTemplate:String) : Bool {
		return RenderDocNative.setCaptureFilePathTemplate(pathTemplate == null ? null : @:privateAccess pathTemplate.toUtf8());
	}

	public static function getCaptureFilePathTemplate() : String {
		var bytes = RenderDocNative.getCaptureFilePathTemplate();
		return bytes == null ? null : @:privateAccess String.fromUTF8(bytes);
	}

	public static function getNumCaptures() {
		return RenderDocNative.getNumCaptures();
	}

	public static function getCapture(index:Int) : String {
		var length = 0;
		if( RenderDocNative.getCapture(index, null, length, null) ) {
			var bytes = new hl.Bytes(length);
			RenderDocNative.getCapture(index, bytes, null, null);
			return @:privateAccess String.fromUTF8(bytes);
		}
		return null;
	}

	public static function triggerCapture() : Bool {
		return RenderDocNative.triggerCapture();
	}

	public static function isTargetControlConnected() : Bool {
		return RenderDocNative.isTargetControlConnected();
	}

	public static function launchReplayUi(connectTargetControl:Bool, cmdline:String) : Bool {
		var cmd = cmdline == null ? null : @:privateAccess cmdline.toUtf8();
		return RenderDocNative.launchReplayUi(connectTargetControl ? 1 : 0, cmd);
	}

	/**
		Pass `null` to use default
	**/
	public static function startFrameCapture(device:Dynamic, wndHandle:Dynamic) : Bool {
		return RenderDocNative.startFrameCapture(device, wndHandle);
	}

	public static function isFrameCapturing() : Bool {
		return RenderDocNative.isFrameCapturing();
	}

	public static function endFrameCapture(device:Dynamic, wndHandle:Dynamic) : Bool {
		return RenderDocNative.endFrameCapture(device, wndHandle);
	}
}
#end
