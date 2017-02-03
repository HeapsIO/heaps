package hxd;

interface InteractiveScene {
	public function setEvents( s : SceneEvents ) : Void;
	public function handleEvent( e : Event, last : Interactive ) : Interactive;
	public function dispatchEvent( e : Event, to : Interactive ) : Void;
	public function dispatchListeners( e : Event ) : Void;
	public function isInteractiveVisible( i : Interactive ) : Bool;
}

interface Interactive {
	public function handleEvent( e : Event ) : Void;
	public function getInteractiveScene() : InteractiveScene;
}

class SceneEvents {

	var scenes : Array<InteractiveScene>;

	var currentOver : Interactive;
	var currentFocus : Interactive;

	var pendingEvents : Array<hxd.Event>;
	var pushList : Array<Interactive>;
	var currentDrag : { f : hxd.Event -> Void, onCancel : Void -> Void, ref : Null<Int> };
	var mouseX = -1.;
	var mouseY = -1.;
	var lastTouch = 0;

	var focusLost = new hxd.Event(EFocusLost);
	var checkPos = new hxd.Event(ECheck);
	var onOut = new hxd.Event(EOut);

	public function new() {
		scenes = [];
		pendingEvents = [];
		pushList = [];
		hxd.Stage.getInstance().addEventTarget(onEvent);
	}

	function onRemove(i) {
		if( i == currentFocus )
			currentFocus = null;
		if( i == currentOver ) {
			currentOver = null;
			hxd.System.setCursor(Default);
		}
		pushList.remove(i);
	}

	public function addScene( s : InteractiveScene, ?index : Int ) {
		s.setEvents(this);
		if( index == null ) scenes.push(s) else scenes.insert(index, s);
	}

	public function removeScene( s : InteractiveScene ) {
		if( scenes.remove(s) ) s.setEvents(null);
	}

	public function dispose() {
		hxd.Stage.getInstance().removeEventTarget(onEvent);
	}

	public function focus( i : Interactive ) {
		if( currentFocus == i )
			return;
		if( i == null ) {
			blur();
			return;
		}
		if( currentFocus != null ) {
			blur();
			if( currentFocus != null ) return;
		}
		var e = new hxd.Event(EFocus);
		i.handleEvent(e);
		if( !e.cancel )
			currentFocus = i;
	}

	public function blur() {
		if( currentFocus == null )
			return;
		focusLost.cancel = false;
		currentFocus.handleEvent(focusLost);
		if( !focusLost.cancel )
			currentFocus = null;
	}

	function checkFocus() {
		if( currentFocus == null ) return;
		var s = currentFocus.getInteractiveScene();
		if( s == null ) {
			currentFocus = null;
			return;
		}
		if( !s.isInteractiveVisible(currentFocus) )
			blur();
	}

	function emitEvent( event : hxd.Event ) {
		var oldX = event.relX, oldY = event.relY;
		var handled = false;
		var checkOver = false, checkPush = false, cancelFocus = false;
		switch( event.kind ) {
		case EMove, ECheck: checkOver = true;
		case EPush: cancelFocus = true; checkPush = true;
		case ERelease: checkPush = true;
		case EKeyUp, EKeyDown, EWheel:
			if( currentFocus != null ) {
				event.relX = event.relY = 0;
				currentFocus.handleEvent(event);
				event.relX = oldX;
				event.relY = oldY;
				if( !event.propagate )
					return;
			}
		default:
		}

		for( s in scenes ) {
			var last = null;
			while( true ) {
				var i = s.handleEvent(event, last);

				if( i == null ) break;

				if( checkOver ) {
					if( currentOver != i ) {
						onOut.cancel = false;
						if( currentOver != null )
							currentOver.handleEvent(onOut);
						if( !onOut.cancel ) {
							var old = event.propagate;
							event.kind = EOver;
							event.cancel = false;
							i.handleEvent(event);
							if( event.cancel )
								currentOver = null;
							else {
								currentOver = i;
								checkOver = false;
							}
							event.kind = EMove;
							event.cancel = false;
							event.propagate = old;
						}
					} else
						checkOver = false;
				} else {
					if( checkPush ) {
						if( event.kind == EPush )
							pushList.push(i);
						else
							pushList.remove(i);
					}
					if( cancelFocus && i == currentFocus )
						cancelFocus = false;
				}

				event.relX = oldX;
				event.relY = oldY;

				if( !event.propagate ) {
					handled = true;
					break;
				}

				last = i;
				event.propagate = false;
			}
			if( handled )
				break;
		}

		if( cancelFocus && currentFocus != null )
			blur();

		if( checkOver && currentOver != null ) {
			onOut.cancel = false;
			currentOver.handleEvent(onOut);
			if( !onOut.cancel )
				currentOver = null;
		}

		if( !handled && event != checkPos ) {
			if( event.kind == EPush )
				pushList.push(null);
			else if( event.kind == ERelease )
				pushList.remove(null);
			dispatchListeners(event);
		}

		/*
			We want to make sure that after we have pushed, we send a release even if the mouse
			has been outside of the Interactive (release outside). We don't generate a click in that case.
		*/
		if( event.kind == ERelease && pushList.length > 0 ) {
			for( i in pushList ) {
				if( i == null )
					dispatchListeners(event);
				else {
					var s = i.getInteractiveScene();
					if( s == null ) continue;
					event.kind = EReleaseOutside;
					s.dispatchEvent(event,i);
					event.kind = ERelease;
					event.relX = oldX;
					event.relY = oldY;
				}
			}
			pushList = new Array();
		}
	}

	public function checkEvents() {
		var old = pendingEvents;
		var checkMoved = false;
		var checkFocused = currentFocus == null;
		if( old.length > 0 ) {
			pendingEvents = [];
			for( e in old ) {
				var ox = e.relX, oy = e.relY;

				switch( e.kind ) {
				case EMove:
					checkMoved = true;
					mouseX = e.relX;
					mouseY = e.relY;
					lastTouch = e.touchId;
				case EPush, ERelease:
					// on mobile, the mouse teleports
					mouseX = e.relX;
					mouseY = e.relY;
					lastTouch = e.touchId;
				case EKeyUp, EKeyDown, EWheel:
					if( !checkFocused ) {
						checkFocused = true;
						checkFocus();
					}
				default:
				}

				if( currentDrag != null && (currentDrag.ref == null || currentDrag.ref == e.touchId) ) {
					currentDrag.f(e);
					e.relX = ox;
					e.relY = oy;
					if( e.cancel )
						continue;
				}

				emitEvent(e);
			}
		}

		if( !checkFocused )
			checkFocus();

		if( !checkMoved && currentDrag == null ) {
			checkPos.relX = mouseX;
			checkPos.relY = mouseY;
			checkPos.touchId = lastTouch;
			checkPos.cancel = false;
			checkPos.propagate = false;
			emitEvent(checkPos);
		}
	}

	public function startDrag( f : hxd.Event -> Void, ?onCancel : Void -> Void, ?refEvent : hxd.Event ) {
		if( currentDrag != null && currentDrag.onCancel != null )
			currentDrag.onCancel();
		currentDrag = { f : f, ref : refEvent == null ? null : refEvent.touchId, onCancel : onCancel };
	}

	public function stopDrag() {
		currentDrag = null;
	}

	public function getFocus() {
		return currentFocus;
	}

	function onEvent( e : hxd.Event ) {
		pendingEvents.push(e);
	}

	function dispatchListeners( event : hxd.Event ) {
		var ox = event.relX, oy = event.relY;
		event.propagate = true;
		for( s in scenes ) {
			event.cancel = false;
			s.dispatchListeners(event);
			event.relX = ox;
			event.relY = oy;
			if( !event.propagate ) break;
		}
	}

}