package hxd;

class Stage {

	var resizeEvents : List<Void -> Void>;
	var eventTargets : List<Event -> Void>;

	public var width(get, null) : Int;
	public var height(get, null) : Int;
	public var mouseX(get, null) : Int;
	public var mouseY(get, null) : Int;
	public var mouseLock(get, set) : Bool;
	public var vsync(get, set) : Bool;

	var curMouseX : Float = 0.;
	var curMouseY : Float = 0.;

	@:allow(hxd)
	static function getCanvas() {
		var canvas : js.html.CanvasElement = cast js.Browser.document.getElementById("webgl");
		if( canvas == null ) throw "Missing canvas#webgl";
		return canvas;
	}
	var canvas : js.html.CanvasElement;
	var canvasPos : { var width(default, never) : Float; var height(default, never) : Float; var left(default, never) : Float; var top(default, never) : Float; };

	function new() : Void {
		eventTargets = new List();
		resizeEvents = new List();

		canvas = getCanvas();
		canvasPos = canvas.getBoundingClientRect();
		js.Browser.window.addEventListener("mousedown", onMouseDown);
		js.Browser.window.addEventListener("mousemove", onMouseMove);
		js.Browser.window.addEventListener("mouseup", onMouseUp);
		js.Browser.window.addEventListener("mousewheel", onMouseWheel);
		js.Browser.window.addEventListener("keydown", onKeyDown);
		js.Browser.window.addEventListener("keyup", onKeyUp);
		canvas.addEventListener("mousedown", function(e) {
			onMouseDown(e);
			e.stopPropagation();
			e.preventDefault();
		});
		canvas.oncontextmenu = function(e){
			e.stopPropagation();
			e.preventDefault();
			return false;
		};
		var curW = this.width, curH = this.height;
		var t0 = new haxe.Timer(100);
		t0.run = function() {
			canvasPos = canvas.getBoundingClientRect();
			var cw = this.width, ch = this.height;
			if( curW != cw || curH != ch ) {
				curW = cw;
				curH = ch;
				onResize(null);
			}
		};
	}

	public dynamic function onClose() : Bool {
		return true;
	}

	public function event( e : hxd.Event ) : Void {
		for( et in eventTargets )
			et(e);
	}

	public function addEventTarget( et : Event->Void ) : Void {
		eventTargets.add(et);
	}

	public function removeEventTarget( et : Event->Void ) : Void {
		for( e in eventTargets )
			if( Reflect.compareMethods(e,et) ) {
				eventTargets.remove(e);
				break;
			}
	}

	public function addResizeEvent( f : Void -> Void ) : Void {
		resizeEvents.push(f);
	}

	public function removeResizeEvent( f : Void -> Void ) : Void {
		for( e in resizeEvents )
			if( Reflect.compareMethods(e,f) ) {
				resizeEvents.remove(f);
				break;
			}
	}

	function onResize(e:Dynamic) : Void {
		for( r in resizeEvents )
			r();
	}

	public function resize( width : Int, height : Int ) : Void {
	}

	public function setFullScreen( v : Bool ) : Void {
	}

	static var inst : Stage = null;
	public static function getInstance() : Stage {
		if( inst == null ) inst = new Stage();
		return inst;
	}

	function get_width() {
		return Math.round(canvasPos.width * js.Browser.window.devicePixelRatio);
	}

	function get_height() {
		return Math.round(canvasPos.height * js.Browser.window.devicePixelRatio);
	}

	function get_mouseX() {
		return Math.round((curMouseX - canvasPos.left) * js.Browser.window.devicePixelRatio);
	}

	function get_mouseY() {
		return Math.round((curMouseY - canvasPos.top) * js.Browser.window.devicePixelRatio);
	}

	function get_mouseLock() : Bool {
		return false;
	}

	function set_mouseLock( v : Bool ) : Bool {
		if( v ) throw "Not implemented";
		return false;
	}

	function get_vsync() : Bool return true;

	function set_vsync( b : Bool ) : Bool {
		if( !b ) throw "Can't disable vsync on this platform";
		return true;
	}

	function onMouseDown(e:js.html.MouseEvent) {
		var ev = new Event(EPush, mouseX, mouseY);
		if (e.button == 2) ev.button = 1;
		event(ev);
	}

	function onMouseUp(e:js.html.MouseEvent) {
		var ev = new Event(ERelease, mouseX, mouseY);
		if (e.button == 2) ev.button = 1;
		event(ev);
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
		var ev = new Event(EKeyUp, mouseX, mouseY);
		ev.keyCode = e.keyCode;
		ev.charCode = e.charCode;
		event(ev);
	}

	function onKeyDown(e:js.html.KeyboardEvent) {
		var ev = new Event(EKeyDown, mouseX, mouseY);
		ev.keyCode = e.keyCode;
		ev.charCode = e.charCode;
		event(ev);
	}

}





