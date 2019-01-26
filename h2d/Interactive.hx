package h2d;

@:allow(h2d.Scene)
class Interactive extends Drawable implements hxd.SceneEvents.Interactive {

	/**
		Width of the Interactive. Ignored if `shape` is set.
	**/
	public var width : Float;
	/**
		Height of the Interactive. Ignored if `shape` is set.
	**/
	public var height : Float;
	/**
		Cursor used when Interactive is under mouse cursor ( default : Button )
	**/
	public var cursor(default,set) : hxd.Cursor;
	/**
		Should object collision be in rectangle or ellipse form? Ignored if `shape` is set.
	**/
	public var isEllipse : Bool;
	/**
		Set the default `cancel` mode (see `hxd.Event`), default to false.
	**/
	public var cancelEvents : Bool = false;
	/**
		Set the default `propagate` mode (see `hxd.Event`), default to false.
	**/
	public var propagateEvents : Bool = false;
	public var backgroundColor : Null<Int>;
	public var enableRightButton : Bool;
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

	public function new(width, height, ?parent, ?shape) {
		super(parent);
		this.width = width;
		this.height = height;
		this.shape = shape;
		cursor = Button;
	}

	override function onAdd() {
		this.scene = getScene();
		if( scene != null ) scene.addEventTarget(this);
		updateMask();
		super.onAdd();
	}

	override function draw( ctx : RenderContext ) {
		if( backgroundColor != null ) emitTile(ctx, h2d.Tile.fromColor(backgroundColor, width, height, (backgroundColor>>>24)/255 ));
	}

	override function getBoundsRec( relativeTo, out, forSize ) {
		super.getBoundsRec(relativeTo, out, forSize);
		if( backgroundColor != null || forSize ) addBounds(relativeTo, out, 0, 0, width, height);
	}

	override function onParentChanged() {
		super.onParentChanged();
		if( scene != null ) {
			scene.removeEventTarget(this);
			scene.addEventTarget(this);
		}
		updateMask();
	}

	function updateMask() {
		parentMask = null;
		var p = parent;
		while( p != null ) {
			var m = Std.instance(p, Mask);
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
		This can be called during or after a push event in order to prevent the release from triggering a click.
	**/
	public function preventClick() {
		mouseDownButton = -1;
	}

	@:noCompletion public function getInteractiveScene() : hxd.SceneEvents.InteractiveScene {
		return scene;
	}

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
			if( !e.cancel && cursor != null )
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
		if( isOver() && cursor != null )
			hxd.System.setCursor(cursor);
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

	public function startDrag(callb,?onCancel) {
		scene.startDrag(function(event) {
			var x = event.relX, y = event.relY;
			eventToLocal(event);
			callb(event);
			event.relX = x;
			event.relY = y;
		},onCancel);
	}

	public function stopDrag() {
		scene.stopDrag();
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

	/** Sent when mouse enters Interactive hitbox area. **/
	public dynamic function onOver( e : hxd.Event ) {
	}

	/** Sent when mouse exits Interactive hitbox area. **/
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