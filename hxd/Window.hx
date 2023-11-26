package hxd;

import hxd.impl.MouseMode;

enum DisplayMode {
	Windowed;
	Borderless;
	Fullscreen;
}

class Window {

	var resizeEvents : List<Void -> Void>;
	var eventTargets : List<Event -> Void>;

	public var width(get, never) : Int;
	public var height(get, never) : Int;
	public var mouseX(get, never) : Int;
	public var mouseY(get, never) : Int;
	@:deprecated("Use mouseMode = AbsoluteUnbound(true)")
	public var mouseLock(get, set) : Bool;
	/**
		If set, will restrain the mouse cursor within the window boundaries.
	**/
	public var mouseClip(get, set) : Bool;
	/**
		Set the mouse movement input handling mode.

		@see `hxd.impl.MouseMode` for more details on each mode.
	**/
	public var mouseMode(default, set) : MouseMode = Absolute;
	public var vsync(get, set) : Bool;
	public var isFocused(get, never) : Bool;

	public var title(get, set) : String;
	public var displayMode(get, set) : DisplayMode;

	function new() : Void {
		eventTargets = new List();
		resizeEvents = new List();
	}

	public dynamic function onClose() : Bool {
		return true;
	}

	/**
		An event called when `mouseMode` is changed.

		Note that changing from `Relative(callbackA)` to `Relative(callbackB)` would also cause this event as any other parameter changes.

		@returns Force-override of the mouse mode that will be used as an active mode or null.
	**/
	public dynamic function onMouseModeChange( from : MouseMode, to : MouseMode ) : Null<MouseMode> {
		return null;
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

	/**
		Add a drag&drop events callback.
	**/
	public function addDragAndDropTarget( f : ( event : DropFileEvent ) -> Void ) : Void {
	}

	/**
		Remove a drag&drop events callback.
	**/
	public function removeDragAndDropTarget( f : ( event : DropFileEvent ) -> Void ) : Void {
	}

	@:deprecated("Use the displayMode property instead")
	public function setFullScreen( v : Bool ) : Void {
	}

	/**
		Set the hardware mouse cursor position relative to window boundaries.
	**/
	public function setCursorPos( x : Int, y : Int, emitEvent : Bool = false ) : Void {
		throw "Not implemented";
	}

	static var inst : Window = null;
	public static function getInstance() : Window {
		if( inst == null ) inst = new Window();
		return inst;
	}

	function get_mouseX() : Int {
		return 0;
	}

	function get_mouseY() : Int {
		return 0;
	}

	function get_width() : Int {
		return 0;
	}

	function get_height() : Int {
		return 0;
	}

	function get_mouseLock() : Bool {
		return switch (mouseMode) { case AbsoluteUnbound(_): true; default: false; };
	}

	function set_mouseLock(v:Bool) : Bool {
		return set_mouseMode(v ? AbsoluteUnbound(true) : Absolute).equals(AbsoluteUnbound(true));
	}

	function get_mouseClip() : Bool {
		return false;
	}

	function set_mouseClip( v : Bool ) : Bool {
		if ( v ) throw "Not implemented";
		return false;
	}

	function set_mouseMode( v : MouseMode ) : MouseMode {
		if ( v != Absolute ) throw "Not implemented";
		return Absolute;
	}

	function get_vsync() : Bool return true;

	function set_vsync( b : Bool ) : Bool {
		if( !b ) throw "Can't disable vsync on this platform";
		return true;
	}

	function get_isFocused() : Bool return true;

	function get_displayMode() : DisplayMode {
		return Windowed;
	}
	function set_displayMode( m : DisplayMode ) : DisplayMode {
		return m;
	}

	function get_title() : String {
		return "";
	}
	function set_title( t : String ) : String {
		return t;
	}
}
