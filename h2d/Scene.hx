package h2d;

class Scene extends Sprite {

	public var width(default,null) : Int;
	public var height(default, null) : Int;
	
	public var mouseX(get, null) : Float;
	public var mouseY(get, null) : Float;
	
	var fixedSize : Bool;
	var interactive : flash.Vector<Interactive>;
	var pendingEvents : flash.Vector<Event>;
	var stage : flash.display.Stage;
	
	
	@:allow(h2d.Interactive)
	var currentOver : Interactive;
	var pushList : Array<Interactive>;
	var currentDrag : Event -> Void;
	
	public function new() {
		super(null);
		var e = h3d.Engine.getCurrent();
		width = e.width;
		height = e.height;
		interactive = new flash.Vector();
		pushList = new Array();
		stage = flash.Lib.current.stage;
	}
	
	public function setFixedSize( w, h ) {
		width = w;
		height = h;
		fixedSize = true;
		posChanged = true;
	}

	override function onDelete() {
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
		super.onDelete();
	}
	
	override function onAlloc() {
		stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
		super.onAlloc();
	}
	
	function get_mouseX() {
		return (stage.mouseX - x) * width / (stage.stageWidth * scaleX);
	}

	function get_mouseY() {
		return (stage.mouseY - y) * height / (stage.stageHeight * scaleY);
	}
	
	function onMouseDown(e:flash.events.MouseEvent) {
		if( pendingEvents != null )
			pendingEvents.push(new Event(EPush, mouseX, mouseY));
	}

	function onMouseUp(e:flash.events.MouseEvent) {
		if( pendingEvents != null )
			pendingEvents.push(new Event(ERelease, mouseX, mouseY));
	}
	
	function onMouseMove(e:flash.events.MouseEvent) {
		if( pendingEvents != null )
			pendingEvents.push(new Event(EMove, mouseX, mouseY));
	}
	
	function emitEvent( event : Event ) {
		var x = event.relX, y = event.relY;
		var rx = x * matA + y * matB + absX;
		var ry = x * matC + y * matD + absY;
		var r = height / width;
		var checkOver = false, checkPush = false;
		switch( event.kind ) {
		case EMove: checkOver = true;
		case EPush, ERelease: checkPush = true;
		default:
		}
		for( i in interactive ) {
			// TODO : we are not sure that the positions are correctly updated !
			
			// this is a bit tricky since we are not in the not-euclide viewport space
			// (r = ratio correction)
			var dx = rx - i.absX;
			var dy = ry - i.absY;
			
			var w1 = i.width * i.matA * r;
			var h1 = i.width * i.matC;
			var ky = h1 * dx - w1 * dy;
			// up line
			if( ky < 0 )
				continue;
				
			var w2 = i.height * i.matB * r;
			var h2 = i.height * i.matD;
			var kx = w2 * dy - h2 * dx;
				
			// left line
			if( kx < 0 )
				continue;
			
			var max = h1 * w2 - w1 * h2;
			// bottom/right
			if( ky >= max || kx * r >= max )
				continue;

						
			event.relX = (kx * r / max) * i.width;
			event.relY = (ky / max) * i.height;
			
			i.handleEvent(event);
			if( event.cancel )
				event.cancel = false;
			else if( checkOver ) {
				if( currentOver != i ) {
					var old = event.propagate;
					if( currentOver != null ) {
						event.kind = EOut;
						// relX/relY is not correct here
						currentOver.handleEvent(event);
					}
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
				} else
					checkOver = false;
			} else if( checkPush ) {
				if( event.kind == EPush )
					pushList.push(i);
				else
					pushList.remove(i);
			}
				
			if( event.propagate ) {
				event.propagate = false;
				continue;
			}
			break;
		}
		if( checkOver && currentOver != null ) {
			event.kind = EOut;
			currentOver.handleEvent(event);
			event.kind = EMove;
			currentOver = null;
		}
	}
	
	public function checkEvents() {
		if( pendingEvents == null ) {
			if( interactive.length == 0 )
				return;
			pendingEvents = new flash.Vector();
		}
		var old = pendingEvents;
		if( old.length == 0 )
			return;
		pendingEvents = null;
		for( e in old ) {
			if( currentDrag != null ) {
				currentDrag(e);
				if( e.cancel )
					continue;
			}
			emitEvent(e);
			if( e.kind == ERelease && pushList.length > 0 ) {
				for( i in pushList ) {
					// relX/relY is not correct here
					i.handleEvent(e);
				}
				pushList = new Array();
			}
		}
		if( interactive.length > 0 )
			pendingEvents = new flash.Vector();
	}
	
	public function startDrag( f : Event -> Void ) {
		currentDrag = f;
	}
	
	public function stopDrag() {
		currentDrag = null;
	}
	
	@:allow(h2d)
	function addEventTarget(i) {
		interactive.push(i);
	}
	
	@:allow(h2d)
	function removeEventTarget(i) {
		for( k in 0...interactive.length )
			if( interactive[k] == i ) {
				interactive.splice(k, 1);
				break;
			}
	}

	override function updatePos() {
		// don't take the parent into account
		if( !posChanged )
			return;
			
		// init matrix without rotation
		matA = scaleX;
		matB = 0;
		matC = 0;
		matD = scaleY;
		absX = x;
		absY = y;
		
		// adds a pixels-to-viewport transform
		var w = 2 / width;
		var h = -2 / height;
		absX = absX * w - 1;
		absY = absY * h + 1;
		matA *= w;
		matB *= h;
		matC *= w;
		matD *= h;
		
		// perform final rotation around center
		if( rotation != 0 ) {
			var cr = Math.cos(rotation * Sprite.ROT2RAD);
			var sr = Math.sin(rotation * Sprite.ROT2RAD);
			var tmpA = matA * cr + matB * sr;
			var tmpB = matA * -sr + matB * cr;
			var tmpC = matC * cr + matD * sr;
			var tmpD = matC * -sr + matD * cr;
			var tmpX = absX * cr + absY * sr;
			var tmpY = absX * -sr + absY * cr;
			matA = tmpA;
			matB = tmpB;
			matC = tmpC;
			matD = tmpD;
			absX = tmpX;
			absY = tmpY;
		}
	}
	
	public function dispose() {
		if( allocated )
			onDelete();
	}
	
	override public function render( engine : h3d.Engine ) {
		if( !allocated )
			onAlloc();
		if( !fixedSize && (width != engine.width || height != engine.height) ) {
			width = engine.width;
			height = engine.height;
			posChanged = true;
		}
		super.render(engine);
	}
	
	
}