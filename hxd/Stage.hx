package hxd;

class Stage {
	
	#if (flash || openfl)
	var stage : flash.display.Stage;
	var fsDelayed : Bool;
	#end
	var resizeEvents : List < Void -> Void > ;
	var eventTargets : List<Event -> Void>;
	
	public var width(get, null) : Float;
	public var height(get, null) : Float;
	public var mouseX(get, null) : Float;
	public var mouseY(get, null) : Float;
	
	function new() {
		eventTargets = new List();
		resizeEvents = new List();
		#if (flash || openfl)
		stage = flash.Lib.current.stage;
		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.addEventListener(flash.events.Event.RESIZE, onResize);
		if( hxd.System.isTouch ) {
			flash.ui.Multitouch.inputMode = flash.ui.MultitouchInputMode.TOUCH_POINT;
			stage.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, onTouchDown);
			stage.addEventListener(flash.events.TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(flash.events.TouchEvent.TOUCH_END, onTouchUp);
		} else {
			stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(flash.events.KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(flash.events.MouseEvent.RIGHT_MOUSE_DOWN, onRMouseDown);
			stage.addEventListener(flash.events.MouseEvent.RIGHT_MOUSE_UP, onRMouseUp);
		}
		#elseif js
		var canvas: js.html.CanvasElement = cast js.Browser.document.getElementById("webgl");
		if ( canvas != null ) {
            canvas.addEventListener("mousedown", onMouseDown);
            canvas.addEventListener("mousemove", onMouseMove);
            canvas.addEventListener("mouseup", onMouseUp);
            canvas.addEventListener("mousewheel", onMouseWheel);
            canvas.addEventListener("keydown", onKeyDown);
            canvas.addEventListener("keyup", onKeyUp);
            canvas.addEventListener("resize", onResize);
        } else {
            js.Browser.window.addEventListener("mousedown", onMouseDown);
            js.Browser.window.addEventListener("mousemove", onMouseMove);
            js.Browser.window.addEventListener("mouseup", onMouseUp);
            js.Browser.window.addEventListener("mousewheel", onMouseWheel);
            js.Browser.window.addEventListener("keydown", onKeyDown);
            js.Browser.window.addEventListener("keyup", onKeyUp);
            js.Browser.window.addEventListener("resize", onResize);
        }
		#end
		#if flash
		if( untyped hxd.System.isAir() )
			setupOnCloseEvent();
		#end
	}
	
	#if flash
	function setupOnCloseEvent() {
		var nw : flash.events.EventDispatcher = Reflect.field(stage, "nativeWindow");
		nw.addEventListener("closing", function(e:flash.events.Event) {
			if( !onClose() )
				e.preventDefault();
		});
	}
	#end
	
	public dynamic function onClose() {
		return true;
	}
	
	public function event( e : hxd.Event ) {
		for( et in eventTargets )
			et(e);
	}
	
	public function addEventTarget(et) {
		eventTargets.add(et);
	}

	public function removeEventTarget(et) {
		eventTargets.remove(et);
	}
	
	public function addResizeEvent( f : Void -> Void ) {
		resizeEvents.push(f);
	}

	public function removeResizeEvent( f : Void -> Void ) {
		resizeEvents.remove(f);
	}
	
	public function getFrameRate() : Float {
		#if (flash || openfl)
		return stage.frameRate;
		#else
		return 60.;
		#end
	}

	public function setFullScreen( v : Bool ) {
		#if flash
		var isAir = flash.system.Capabilities.playerType == "Desktop";
		var state = v ? (isAir ? flash.display.StageDisplayState.FULL_SCREEN_INTERACTIVE : flash.display.StageDisplayState.FULL_SCREEN) : flash.display.StageDisplayState.NORMAL;
		if( stage.displayState != state ) {
			var t = flash.Lib.getTimer();
			// delay first fullsrceen toggle on OSX/Air to prevent the command window to spawn over
			if( v && isAir && t < 5000 && !fsDelayed && flash.system.Capabilities.os.indexOf("Mac") != -1 ) {
				fsDelayed = true;
				haxe.Timer.delay(function() this.setFullScreen(v), 1000);
				return;
			}
			stage.displayState = state;
		}
		#else
		#end
	}
	
	static var inst = null;
	public static function getInstance() {
		if( inst == null ) inst = new Stage();
		return inst;
	}
	
#if (flash || openfl)

	inline function get_mouseX() {
		return stage.mouseX;
	}

	inline function get_mouseY() {
		return stage.mouseY;
	}

	inline function get_width() {
		return stage.stageWidth;
	}

	inline function get_height() {
		return stage.stageHeight;
	}
	
	function onResize(_) {
		for( e in resizeEvents )
			e();
	}

	function onMouseDown(e:Dynamic) {
		event(new Event(EPush, mouseX, mouseY));
	}
	
	function onRMouseDown(e:Dynamic) {
		var e = new Event(EPush, mouseX, mouseY);
		e.button = 1;
		event(e);
	}
	
	function onMouseUp(e:Dynamic) {
		event(new Event(ERelease, mouseX, mouseY));
	}

	function onRMouseUp(e:Dynamic) {
		var e = new Event(ERelease, mouseX, mouseY);
		e.button = 1;
		event(e);
	}
	
	function onMouseMove(e:Dynamic) {
		event(new Event(EMove, mouseX, mouseY));
	}
	
	function onMouseWheel(e:flash.events.MouseEvent) {
		var ev = new Event(EWheel, mouseX, mouseY);
		ev.wheelDelta = -e.delta / 3.0;
		event(ev);
	}
	
	function onKeyUp(e:flash.events.KeyboardEvent) {
		var ev = new Event(EKeyUp);
		ev.keyCode = e.keyCode;
		ev.charCode = getCharCode(e);
		event(ev);
	}

	function onKeyDown(e:flash.events.KeyboardEvent) {
		var ev = new Event(EKeyDown);
		ev.keyCode = e.keyCode;
		ev.charCode = getCharCode(e);
		event(ev);
		#if flash
		// prevent escaping fullscreen in air
		if( e.keyCode == flash.ui.Keyboard.ESCAPE ) e.preventDefault();
		// prevent back exiting app in mobile
		if( e.keyCode == flash.ui.Keyboard.BACK ) {
			e.preventDefault();
			e.stopImmediatePropagation();
		}
		#end
	}
	
	function getCharCode( e : flash.events.KeyboardEvent ) {
		#if openfl
		return e.charCode;
		#else
		// disable some invalid charcodes
		if( e.keyCode == 27 ) e.charCode = 0;
		// Flash charCode are not valid, they assume an english keyboard. Let's do some manual translation here (to complete with command keyboards)
		switch( flash.system.Capabilities.language ) {
		case "fr":
			return switch( e.keyCode ) {
			case 49: if( e.altKey ) 0 else if( e.shiftKey ) '1'.code else e.charCode;
			case 50: if( e.altKey ) '~'.code else if( e.shiftKey ) '2'.code else e.charCode;
			case 51: if( e.altKey ) '#'.code else if( e.shiftKey ) '3'.code else e.charCode;
			case 52: if( e.altKey ) '{'.code else if( e.shiftKey ) '4'.code else e.charCode;
			case 53: if( e.altKey ) '['.code else if( e.shiftKey ) '5'.code else e.charCode;
			case 54: if( e.altKey ) '|'.code else if( e.shiftKey ) '6'.code else e.charCode;
			case 55: if( e.altKey ) '`'.code else if( e.shiftKey ) '7'.code else e.charCode;
			case 56: if( e.altKey ) '\\'.code else if( e.shiftKey ) '8'.code else e.charCode;
			case 57: if( e.altKey ) '^'.code else if( e.shiftKey ) '9'.code else e.charCode;
			case 48: if( e.altKey ) '@'.code else if( e.shiftKey ) '0'.code else e.charCode;
			case 219: if( e.altKey ) ']'.code else if( e.shiftKey ) '°'.code else e.charCode;
			case 187: if( e.altKey ) '}'.code else if( e.shiftKey ) '+'.code else e.charCode;
			case 188: if( e.altKey ) 0 else if( e.shiftKey ) '?'.code else e.charCode;
			case 190: if( e.altKey ) 0 else if( e.shiftKey ) '.'.code else e.charCode;
			case 191: if( e.altKey ) 0 else if( e.shiftKey ) '/'.code else e.charCode;
			case 223: if( e.altKey ) 0 else if( e.shiftKey ) '§'.code else e.charCode;
			case 192: if( e.altKey ) 0 else if( e.shiftKey ) '%'.code else e.charCode;
			case 220: if( e.altKey ) 0 else if( e.shiftKey ) 'µ'.code else e.charCode;
			case 221: if( e.altKey ) 0 else if( e.shiftKey ) '¨'.code else '^'.code;
			case 186: if( e.altKey ) '¤'.code else if( e.shiftKey ) '£'.code else e.charCode;
			default:
				e.charCode;
			}
		default:
			return e.charCode;
		}
		#end
	}
	
	function onTouchDown(e:flash.events.TouchEvent) {
		var ev = new Event(EPush, e.localX, e.localY);
		ev.touchId = e.touchPointID;
		event(ev);
	}

	function onTouchUp(e:flash.events.TouchEvent) {
		var ev = new Event(ERelease, e.localX, e.localY);
		ev.touchId = e.touchPointID;
		event(ev);
	}
	
	function onTouchMove(e:flash.events.TouchEvent) {
		var ev = new Event(EMove, e.localX, e.localY);
		ev.touchId = e.touchPointID;
		event(ev);
	}
	
#elseif js

	var curMouseX : Float;
	var curMouseY : Float;

	function get_width() {
        return hxd.System.width;
	}

	function get_height() {
        return hxd.System.height;
	}

	function get_mouseX() {
		return curMouseX;
	}

	function get_mouseY() {
		return curMouseY;
	}

	function onMouseDown(e:js.html.MouseEvent) {
        var e = new Event(EPush, mouseX, mouseY);
        e.button = 0;
		event(e);
	}

	function onMouseUp(e:js.html.MouseEvent) {
        var e = new Event(ERelease, mouseX, mouseY);
        e.button = 0;
		event(e);
	}
	
	function onMouseMove(e:js.html.MouseEvent) {
		curMouseX = e.clientX - untyped e.target.offsetLeft;
		curMouseY = e.clientY - untyped e.target.offsetTop;
		event(new Event(EMove, mouseX, mouseY));
	}
	
	function onMouseWheel(e:js.html.MouseEvent) {
		var ev = new Event(EWheel, mouseX, mouseY);
		ev.wheelDelta = untyped -e.wheelDelta / 30.0;
		event(ev);
	}
	
	function onKeyUp(e:js.html.KeyboardEvent) {
		var ev = new Event(EKeyUp);
		ev.keyCode = e.keyCode;
		ev.charCode = e.charCode;
		event(ev);
	}

	function onKeyDown(e:js.html.KeyboardEvent) {
		var ev = new Event(EKeyDown);
		ev.keyCode = e.keyCode;
		ev.charCode = e.charCode;
		event(ev);
	}
	
	function onResize(e) {
		for( r in resizeEvents )
			r();
	}

#else

	function get_mouseX() {
		return 0;
	}

	function get_mouseY() {
		return 0;
	}
	
	function get_width() {
		return 0;
	}

	function get_height() {
		return 0;
	}

#end

#if openfl

	static function openFLBoot(callb) {
		// init done with OpenFL ApplicationMain
		if( flash.Lib.current.stage != null ) {
			callb();
			return;
		}
		// init done by hand
		var width = 750, height = 450, fps = 60, bgColor = 0x808080;
		flash.Lib.create(
			function() {
				flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
				flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
				flash.Lib.current.loaderInfo = flash.display.LoaderInfo.create (null);
				callb();
			},
			width, height, fps, bgColor,
			(true ? flash.Lib.HARDWARE : 0) |
			(true ? flash.Lib.ALLOW_SHADERS : 0) |
			(true ? flash.Lib.REQUIRE_SHADERS : 0) |
			(false ? flash.Lib.DEPTH_BUFFER : 0) |
			(false ? flash.Lib.STENCIL_BUFFER : 0) |
			(true ? flash.Lib.RESIZABLE : 0) |
			(false ? flash.Lib.BORDERLESS : 0) |
			(false ? flash.Lib.VSYNC : 0) |
			(false ? flash.Lib.FULLSCREEN : 0) |
			(0 == 4 ? flash.Lib.HW_AA_HIRES : 0) |
			(0 == 2 ? flash.Lib.HW_AA : 0),
			"h3d", null
			#if mobile
			, null /* ScaledStage : TODO? */
			#end
		);
	}

#end

}
