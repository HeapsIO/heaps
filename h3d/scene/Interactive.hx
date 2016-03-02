package h3d.scene;

class Interactive extends Object implements hxd.SceneEvents.Interactive {

	public var shape : h3d.col.Collider;
	public var cursor(default,set) : hxd.System.Cursor;
	/**
		Set the default `cancel` mode (see `hxd.Event`), default to false.
	**/
	public var cancelEvents : Bool = false;
	/**
		Set the default `propagate` mode (see `hxd.Event`), default to false.
	**/
	public var propagateEvents : Bool = false;
	public var enableRightButton : Bool;
	var scene : Scene;
	var isMouseDown : Int;

	@:allow(h3d.scene.Scene)
	var hitPoint = new h3d.Vector();

	public function new(shape, ?parent) {
		super(parent);
		this.shape = shape;
		cursor = Button;
	}

	override function onAlloc() {
		this.scene = getScene();
		if( scene != null ) scene.addEventTarget(this);
		super.onAlloc();
	}

	override function onDelete() {
		if( scene != null ) {
			scene.removeEventTarget(this);
			scene = null;
		}
		super.onDelete();
	}

	@:noCompletion public function getInteractiveScene() : hxd.SceneEvents.InteractiveScene {
		return scene;
	}

	@:noCompletion public function handleEvent( e : hxd.Event ) {
		if( propagateEvents ) e.propagate = true;
		if( cancelEvents ) e.cancel = true;
		switch( e.kind ) {
		case EMove:
			onMove(e);
		case EPush:
			if( enableRightButton || e.button == 0 ) {
				isMouseDown = e.button;
				onPush(e);
			}
		case ERelease:
			if( enableRightButton || e.button == 0 ) {
				onRelease(e);
				if( isMouseDown == e.button )
					onClick(e);
			}
			isMouseDown = -1;
		case EReleaseNoClick:
			if( enableRightButton || e.button == 0 ) {
				e.kind = ERelease;
				onRelease(e);
				e.kind = EReleaseNoClick;
			}
			isMouseDown = -1;
		case EOver:
			hxd.System.setCursor(cursor);
			onOver(e);
		case EOut:
			isMouseDown = -1;
			hxd.System.setCursor(Default);
			onOut(e);
		case EWheel:
			onWheel(e);
		case EFocusLost:
			onFocusLost(e);
		case EFocus:
			onFocus(e);
		case EKeyUp:
			onKeyUp(e);
		case EKeyDown:
			onKeyDown(e);
		}
	}

	function set_cursor(c) {
		this.cursor = c;
		if( isOver() )
			hxd.System.setCursor(cursor);
		return c;
	}

	public function focus() {
		if( scene == null || scene.events == null )
			return;
		scene.events.focus(this);
	}

	public function blur() {
		if( hasFocus() ) scene.events.blur();
	}

	public function isOver() {
		return scene != null && scene.events != null && @:privateAccess scene.events.currentOver == this;
	}

	public function hasFocus() {
		return scene != null && scene.events != null && @:privateAccess scene.events.currentFocus == this;
	}

	public dynamic function onOver( e : hxd.Event ) {
	}

	public dynamic function onOut( e : hxd.Event ) {
	}

	public dynamic function onPush( e : hxd.Event ) {
	}

	public dynamic function onRelease( e : hxd.Event ) {
	}

	public dynamic function onClick( e : hxd.Event ) {
	}

	public dynamic function onMove( e : hxd.Event ) {
	}

	public dynamic function onWheel( e : hxd.Event ) {
	}

	public dynamic function onFocus( e : hxd.Event ) {
	}

	public dynamic function onFocusLost( e : hxd.Event ) {
	}

	public dynamic function onKeyUp( e : hxd.Event ) {
	}

	public dynamic function onKeyDown( e : hxd.Event ) {
	}

}