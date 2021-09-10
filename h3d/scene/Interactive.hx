package h3d.scene;

class Interactive extends Object implements hxd.SceneEvents.Interactive {

	var debugObj : Object;
	public var showDebug(default, set) : Bool = false;

	public var shape : h3d.col.Collider;

	/**
		If several interactive conflicts, the preciseShape (if defined) can be used to distinguish between the two.
	**/
	public var preciseShape : Null<h3d.col.Collider>;

	/**
		In case of conflicting shapes, usually the one in front of the camera is prioritized, unless you set an higher priority.
	**/
	public var priority : Int;

	public var cursor(default,set) : Null<hxd.Cursor>;
	/**
		Set the default `cancel` mode (see `hxd.Event`), default to false.
	**/
	public var cancelEvents : Bool = false;
	/**
		Set the default `propagate` mode (see `hxd.Event`), default to false.
	**/
	public var propagateEvents : Bool = false;
	public var enableRightButton : Bool;

	/**
		Is it required to find the best hit point in a complex mesh or any hit possible point will be enough (default = false, faster).
	**/
	public var bestMatch : Bool;

	var scene : Scene;
	var mouseDownButton : Int = -1;

	@:allow(h3d.scene.Scene)
	var hitPoint = new h3d.Vector();

	public function new(shape, ?parent) {
		super(parent);
		this.shape = shape;
		cursor = Button;
	}

	public function set_showDebug(val) {
		if( !val ) {
			if( debugObj != null )
				debugObj.remove();
			debugObj = null;
			return false;
		}
		if( debugObj != null )
			return true;
		debugObj = shape.makeDebugObj();
		if( debugObj != null ) {
			setupDebugMaterial(debugObj);

			debugObj.ignoreParentTransform = true;
			this.addChild(debugObj);
		}
		return debugObj != null;
	}

	public static dynamic function setupDebugMaterial(debugObj: Object) {
		var materials = debugObj.getMaterials();
		for( m in materials ) {
			var engine = h3d.Engine.getCurrent();
			if( engine.driver.hasFeature(Wireframe) )
				m.mainPass.wireframe = true;
			m.castShadows = false;
			m.receiveShadows = false;
			m.color.a = 0.7;
			m.blendMode = Alpha;
			// m.mainPass.depth(false, Always);
		}
	}

	override function onAdd() {
		this.scene = getScene();
		if( scene != null ) scene.addEventTarget(this);
		super.onAdd();
	}

	override function onRemove() {
		if( scene != null ) {
			scene.removeEventTarget(this);
			scene = null;
		}
		super.onRemove();
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
				if( e.cancel ) mouseDownButton = -1;
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
				onRelease(e);
				if ( mouseDownButton == e.button )
					onReleaseOutside(e);
			}
			mouseDownButton = -1;
		case EOver:
			onOver(e);
		case EOut:
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
		case ECheck:
			onCheck(e);
		case ETextInput:
			onTextInput(e);
		}
	}

	function set_cursor(c) {
		this.cursor = c;
		if ( scene != null && scene.events != null )
			scene.events.updateCursor(this);
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
		return scene != null && scene.events != null && @:privateAccess scene.events.overList.indexOf(this) != -1;
	}

	public function hasFocus() {
		return scene != null && scene.events != null && @:privateAccess scene.events.currentFocus == this;
	}

	/**
		Sent when mouse enters Interactive hitbox area.
		`event.propagate` and `event.cancel` are ignored during `onOver`.
		Propagation can be set with `onMove` event, as well as cancelling `onMove` will prevent `onOver`.
	**/
	public dynamic function onOver( e : hxd.Event ) {
	}

	/** Sent when mouse exits Interactive hitbox area.
		`event.propagate` and `event.cancel` are ignored during `onOut`.
	**/
	public dynamic function onOut( e : hxd.Event ) {
	}

	/** Sent when Interactive is pressed by user. **/
	public dynamic function onPush( e : hxd.Event ) {
	}

	/**
		Sent on multiple conditions.
		A. Always sent if user releases mouse while it is inside Interactive hitbox area.
			This happends regardless if that Interactive was pressed prior or not.
		B. Sent before `onReleaseOutside` if this Interactive was pressed, but released outside it's bounds.
		For first case `event.kind` will be `ERelease`, for second case - `EReleaseOutside`.
		See `onClick` and `onReleaseOutside` functions for separate events that trigger only when user interacts with this particular Interactive.
	**/
	public dynamic function onRelease( e : hxd.Event ) {
	}

	/**
		Sent when user presses Interactive, moves mouse outside and releases it.
		This event fired only on Interactive that user pressed, but released mouse after moving it outside of Interactive hitbox area.
	**/
	public dynamic function onReleaseOutside( e : hxd.Event ) {
	}

	/**
		Sent when Interactive is clicked by user.
		This event fired only on Interactive that user pressed and released when mouse is inside Interactive hitbox area.
	**/
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

	public dynamic function onTextInput( e : hxd.Event ) {
	}

}
