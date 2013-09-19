package hxd;

class Stage {
	
	#if flash
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
		#if flash
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
		}
		#elseif js
		js.Browser.window.addEventListener("mousedown", onMouseDown);
		js.Browser.window.addEventListener("mousemove", onMouseMove);
		js.Browser.window.addEventListener("mouseup", onMouseUp);
		js.Browser.window.addEventListener("mousewheel", onMouseWheel);
		js.Browser.window.addEventListener("keydown", onKeyDown);
		js.Browser.window.addEventListener("keyup", onKeyUp);
		js.Browser.window.addEventListener("resize", onResize);
		#end
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
		#if flash
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
	
#if flash

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

	function onMouseUp(e:Dynamic) {
		event(new Event(ERelease, mouseX, mouseY));
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
		ev.charCode = e.charCode;
		event(ev);
	}

	function onKeyDown(e:flash.events.KeyboardEvent) {
		var ev = new Event(EKeyDown);
		ev.keyCode = e.keyCode;
		ev.charCode = e.charCode;
		event(ev);
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
		return js.Browser.document.width;
	}

	function get_height() {
		return js.Browser.document.height;
	}

	function get_mouseX() {
		return curMouseX;
	}

	function get_mouseY() {
		return curMouseY;
	}

	function onMouseDown(e:js.html.MouseEvent) {
		event(new Event(EPush, mouseX, mouseY));
	}

	function onMouseUp(e:js.html.MouseEvent) {
		event(new Event(ERelease, mouseX, mouseY));
	}
	
	function onMouseMove(e:js.html.MouseEvent) {
		curMouseX = e.clientX;
		curMouseY = e.clientY;
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

#end

}