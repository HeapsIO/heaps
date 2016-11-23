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
	var mouseDownButton : Int = -1;

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

	/**
		This can be called during or after a push event in order to prevent the release from triggering a click.
	**/
	public function preventClick() {
		mouseDownButton = -1;
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
				mouseDownButton = e.button;
				onPush(e);
			}
		case ERelease:
			if( enableRightButton || e.button == 0 ) {
				onRelease(e);
				if( mouseDownButton == e.button )
					onClick(e);
			}
			mouseDownButton = -1;
		case EReleaseOutside:
			if( enableRightButton || e.button == 0 ) {
				e.kind = ERelease;
				onRelease(e);
				e.kind = EReleaseOutside;
			}
			mouseDownButton = -1;
		case EOver:
			onOver(e);
			if( !e.cancel )
				hxd.System.setCursor(cursor);
		case EOut:
			mouseDownButton = -1;
			onOut(e);
			if( !e.cancel )
				hxd.System.setCursor(Default);
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
		case ECheck:
			onCheck(e);
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

	public dynamic function onCheck( e : hxd.Event ) {
	}

}