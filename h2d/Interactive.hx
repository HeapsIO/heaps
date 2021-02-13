package h2d;

/**
	A user input handler.

	Hitbox area can be a rectangle, an ellipse or an arbitrary shape (`h2d.col.Collider`).

	Note that Interactive does not reports its hitbox bounds in `Object.getBounds`
	unless `Interactive.backgroundColor` is set, in which case `width` and `height` are reported.

	By default, Interactive only reacts to primary (left) mouse button for actions, see `Interactive.enableRightButton` for details.
**/
@:allow(h2d.Scene)
class Interactive extends Drawable implements hxd.SceneEvents.Interactive {

	/**
		Width of the Interactive. Ignored if `Interactive.shape` is set.
	**/
	public var width : Float;
	/**
		Height of the Interactive. Ignored if `Interactive.shape` is set.
	**/
	public var height : Float;
	/**
		Cursor used when Interactive is under mouse cursor.
	**/
	public var cursor(default,set) : Null<hxd.Cursor> = Button;
	/**
		Performs an elliptic hit-test instead of rectangular one based on `Interactive.width` and `height`. Ignored if `Interactive.shape` is set.
	**/
	public var isEllipse : Bool;
	/**
		Set the default `hxd.Event.cancel` mode.
	**/
	public var cancelEvents : Bool = false;
	/**
		Set the default `hxd.Event.propagate` mode.
	**/
	public var propagateEvents : Bool = false;
	/**
		If set, Interactive will draw a `Tile` with `[width, height]` dimensions of specified color (including alpha).
	**/
	public var backgroundColor : Null<Int>;
	/**
		When enabled, interacting with secondary mouse buttons (right button/wheel) will cause `onPush`, `onClick`, `onRelease` and `onReleaseOutside` callbacks.
		Otherwise those callbacks will only be triggered with primary mouse button (left button).

		Note that Interactive remembers only the last pressed button when pressing on it, hence pressing Interactive with the left button and then the right button
		would not cause `onClick` on either when releasing left button first, as pressed state is reset internally.
	**/
	public var enableRightButton : Bool = false;
	var scene : Scene;
	var mouseDownButton : Int = -1;
	var parentMask : Mask;
	var invDet : Float;

	/**
		Detailed shape collider for Interactive.
		If set, `width` and `height` properties are ignored for collision checks.
	**/
	public var shape : h2d.col.Collider;
	/**
		Detailed shape X offset from Interactive.
	**/
	public var shapeX : Float = 0;
	/**
		Detailed shape Y offset from Interactive.
	**/
	public var shapeY : Float = 0;

	/**
		Create a new Interactive with specified parameters. `width`, `height` and `parent` with optional detailed `shape`.
		@param width The width of the Interactive hitbox.
		@param height The height of the Interactive hitbox.
		@param parent An optional parent `h2d.Object` instance to which Interactive adds itself if set.
		@param shape An optional detailed Interactive hitbox.
	**/
	public function new( width, height, ?parent, ?shape ) {
		super(parent);
		this.width = width;
		this.height = height;
		this.shape = shape;
	}

	override function onAdd() {
		this.scene = getScene();
		if( scene != null ) scene.addEventTarget(this);
		updateMask();
		super.onAdd();
	}

	override function draw( ctx : RenderContext ) {
		if( backgroundColor != null ) emitTile(ctx, h2d.Tile.fromColor(backgroundColor, Std.int(width), Std.int(height), (backgroundColor>>>24)/255 ));
	}

	override function getBoundsRec( relativeTo, out, forSize ) {
		super.getBoundsRec(relativeTo, out, forSize);
		if( backgroundColor != null || forSize ) addBounds(relativeTo, out, 0, 0, Std.int(width), Std.int(height));
	}

	override private function onHierarchyMoved(parentChanged:Bool)
	{
		super.onHierarchyMoved(parentChanged);
		if( scene != null ) {
			scene.removeEventTarget(this);
			scene = getScene();
			if( scene != null )
				scene.addEventTarget(this);
		}
		if ( parentChanged )
			updateMask();
	}

	function updateMask() {
		parentMask = null;
		var p = parent;
		while( p != null ) {
			var m = hxd.impl.Api.downcast(p, Mask);
			if( m != null ) {
				parentMask = m;
				break;
			}
			p = p.parent;
		}
	}

	override function onRemove() {
		if( scene != null ) {
			scene.removeEventTarget(this, true);
			scene = null;
		}
		super.onRemove();
	}

	function checkBounds( e : hxd.Event ) {
		return switch( e.kind ) {
		case EOut, EFocus, EFocusLost, EReleaseOutside: false;
		default: true;
		}
	}

	/**
		Reset current pressed state of the Interactive, preventing the `onClick` or `onReleaseOutside` being triggered when user releases mouse button.
	**/
	public function preventClick() {
		mouseDownButton = -1;
	}

	@:dox(hide)
	@:noCompletion public function getInteractiveScene() : hxd.SceneEvents.InteractiveScene {
		return scene;
	}

	@:dox(hide)
	@:noCompletion public function handleEvent( e : hxd.Event ) {
		if( parentMask != null && checkBounds(e) ) {
			var p = parentMask;
			var pt = new h2d.col.Point(e.relX, e.relY);
			localToGlobal(pt);
			var saveX = pt.x, saveY = pt.y;
			while( p != null ) {
				pt.x = saveX;
				pt.y = saveY;
				var pt = p.globalToLocal(pt);
				if( pt.x < 0 || pt.y < 0 || pt.x > p.width || pt.y > p.height ) {
					e.cancel = true;
					return;
				}
				p = @:privateAccess p.parentMask;
			}
		}
		if(shape == null && isEllipse && checkBounds(e) ) {
			var cx = width * 0.5, cy = height * 0.5;
			var dx = (e.relX - cx) / cx;
			var dy = (e.relY - cy) / cy;
			if( dx * dx + dy * dy > 1 ) {
				e.cancel = true;
				return;
			}
		}
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

	override private function calcAbsPos()
	{
		super.calcAbsPos();
		invDet = 1 / (matA * matD - matB * matC);
	}

	function set_cursor(c) {
		this.cursor = c;
		if ( scene != null && scene.events != null )
			scene.events.updateCursor(this);
		return c;
	}

	function eventToLocal( e : hxd.Event ) {
		// convert scene event to our local space
		var i = this;

		var dx = e.relX - i.absX;
		var dy = e.relY - i.absY;

		e.relX = ( dx * i.matD - dy * i.matC) * i.invDet;
		e.relY = (-dx * i.matB + dy * i.matA) * i.invDet;
	}

	/**
		Starts input events capture and redirects them to `callb` method until `Interactive.stopCapture` is called.
		While the method name may imply that only mouse events would be captured: This is not the case,
		as it will also capture all other input events, including keyboard events.

		Starting event capture through `Interactive.startCapture` will convert `Event.relX` and `relY` to local coordinates
		of the Interactive and will restore them after invoking `callb`.
		In order to receive coordinates in scene coordinate space use `Scene.startCapture`.

		@param callb A callback method that receives `hxd.Event` when input event happens.
		Unless `callb` sets `Event.propagate` to `true`, event won't be sent to other Interactives.
		@param onCancel An optional callback that is invoked when `Interactive.stopCapture` is called.
	**/
	public function startCapture(callb : hxd.Event -> Void, ?onCancel : Void -> Void, ?touchId : Int) {
		scene.startCapture(function(event) {
			var x = event.relX, y = event.relY;
			eventToLocal(event);
			callb(event);
			event.relX = x;
			event.relY = y;
		}, onCancel, touchId);
	}

	/**
		Stops current input event capture.
	**/
	public function stopCapture() {
		scene.stopCapture();
	}

	@:deprecated("Renamed to startCapture") @:dox(hide)
	public inline function startDrag(callb,?onCancel) {
		startCapture(callb, onCancel);
	}

	@:deprecated("Renamed to stopCapture") @:dox(hide)
	public inline function stopDrag() {
		stopCapture();
	}

	/**
		Sets focus on this `Interactive`.
		If Interactive was not already focused and it receives focus - `onFocus` event is sent.
		Interactive won't become focused if during `onFocus` call it will set `Event.cancel` to `true`.
	**/
	public function focus() {
		if( scene == null || scene.events == null )
			return;
		scene.events.focus(this);
	}

	/**
		Removes focus from interactive if it's focused.
		If Interactive is currently focused - `onFocusLost` event will be sent.
		Interactive won't lose focus if during `onFocusLost` call it will set `Event.cancel` to `true`.
	**/
	public function blur() {
		if( hasFocus() ) scene.events.blur();
	}

	/**
		Checks if Interactive is currently hovered by the mouse.
	**/
	public function isOver() {
		return scene != null && scene.events != null && @:privateAccess scene.events.overList.indexOf(this) != -1;
	}

	/**
		Checks if Interactive is currently focused.
	**/
	public function hasFocus() {
		return scene != null && scene.events != null && @:privateAccess scene.events.currentFocus == this;
	}

	/**
		Sent when mouse enters Interactive hitbox area.

		`Event.propagate` and `Event.cancel` are ignored during `onOver`.
		Propagation can be set with `onMove` event, as well as cancelling `onMove` will prevent `onOver`.
	**/
	public dynamic function onOver( e : hxd.Event ) {
	}

	/**
		Sent when mouse exits Interactive hitbox area.
		`Event.propagate` and `Event.cancel` are ignored during `onOut`.
	**/
	public dynamic function onOut( e : hxd.Event ) {
	}

	/**
		Sent when Interactive is pressed by the user.
	**/
	public dynamic function onPush( e : hxd.Event ) {
	}

	/**
		Sent when Interactive is unpressed under multiple circumstances.
		* Always sent if user releases mouse while it is inside Interactive hitbox area.
			This happens regardless if that Interactive was pressed prior or not,
			and due to that it's not guaranteed that `Interactive.onPush` would precede this event.
			`Event.kind` is set to `ERelease` during this event.
		* Sent before `Interactive.onReleaseOutside` if this Interactive was pressed, but released outside its hitbox area.
			`Event.kind` is set to `EReleaseOutside` during this event.

		See `Interactive.onClick` and `Interactive.onReleaseOutside` methods for separate events that trigger only when user interacts with this particular Interactive.
	**/
	public dynamic function onRelease( e : hxd.Event ) {
	}

	/**
		Sent when user presses the Interactive, moves the mouse outside its hitbox area and releases the mouse button.

		Can be prevented to fire by calling `Interactive.preventClick` during or after `Interactive.onPush` event.

		`Interactive.onRelease` is sent with `Event.kind` being `EReleaseOutside` just before this event.
	**/
	public dynamic function onReleaseOutside( e : hxd.Event ) {
	}

	/**
		Sent when the Interactive is clicked by the user.

		Can be prevented to fire by calling `Interactive.preventClick` during or after `Interactive.onPush` event.

		`Interactive.onRelease` is sent with `Event.kind` being `ERelease` just before this event.
	**/
	public dynamic function onClick( e : hxd.Event ) {
	}

	/**
		Sent when user moves within the Interactive hitbox area.
		See `Interactive.onCheck` for event when user does not move the mouse.

		Cancelling the `Event` will prevent interactive from becoming overed,
		causing `Interactive.onOut` if it was overed previously.
		Interactive would be treated as not overed as long as event is cancelled even if mouse is within the hitbox area.
	**/
	public dynamic function onMove( e : hxd.Event ) {
	}

	/**
		Sent when user scrolls mouse wheel above the Interactive. Wheel delta can be obtained through the `Event.wheelDelta`.
	**/
	public dynamic function onWheel( e : hxd.Event ) {
	}

	/**
		Sent when Interactive receives focus during `Interactive.focus` call.

		Cancelling the `Event` will prevent the Interactive from becoming focused.
	**/
	public dynamic function onFocus( e : hxd.Event ) {
	}

	/**
		Sent when Interactive lost focus either via `Interactive.blur` call or when user clicks on another Interactive/outside this Interactive hitbox area.

		Cancelling the `Event` will prevent the Interactive from losing focus.
	**/
	public dynamic function onFocusLost( e : hxd.Event ) {
	}

	/**
		Sent when this Interactive is focused and user unpressed a keyboard key.
		Unpressed key can be accessed through `Event.keyCode`.
	**/
	public dynamic function onKeyUp( e : hxd.Event ) {
	}

	/**
		Sent when this Interactive is focused and user pressed a keyboard key.
		Pressed key can be accessed through `Event.keyCode`.
	**/
	public dynamic function onKeyDown( e : hxd.Event ) {
	}

	/**
		Sent every frame when user hovers an Interactive but does not move the mouse.
		See `Interactive.onMove` for event when user moves the mouse.

		Cancelling the `Event` will prevent interactive from becoming overed,
		causing `Interactive.onOut` if it was overed previously.
		Interactive would be treated as not overed as long as event is cancelled even if mouse is within the hitbox area.
	**/
	public dynamic function onCheck( e : hxd.Event ) {
	}

	/**
		Sent when this Interactive is focused and user inputs text. Character added can be accessed through `Event.charCode`.
	**/
	public dynamic function onTextInput( e : hxd.Event ) {
	}

}