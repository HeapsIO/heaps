package h2d;

class Scene extends Sprite {

	public var width(default,null) : Int;
	public var height(default,null) : Int;
	var fixedSize : Bool;
	var interactive : flash.Vector<Interactive>;
	var pendingEvents : flash.Vector<Event>;
	
	public function new() {
		super(null);
		interactive = new flash.Vector();
	}
	
	public function setFixedSize( w, h ) {
		width = w;
		height = h;
		fixedSize = true;
		posChanged = true;
	}

	override function onDelete() {
		var stage = flash.Lib.current.stage;
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
		super.onDelete();
	}
	
	override function onAlloc() {
		var stage = flash.Lib.current.stage;
		stage.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, onMouseUp);
		super.onAlloc();
	}
	
	function onMouseDown(e:flash.events.MouseEvent) {
		if( pendingEvents != null )
			pendingEvents.push(new Event(EPush, e.localX, e.localY));
	}

	function onMouseUp(e:flash.events.MouseEvent) {
		if( pendingEvents != null )
			pendingEvents.push(new Event(ERelease, e.localX, e.localY));
	}
	
	function onMouseMove(e:flash.events.MouseEvent) {
		if( pendingEvents != null )
			pendingEvents.push(new Event(EMove, e.localX, e.localY));
	}
	
	function emitEvent( event : Event ) {
		var x = event.relX, y = event.relY;
		var rx = x * matA + y * matB + absX;
		var ry = x * matC + y * matD + absY;
		var r = height / width;
		
		for( i in interactive ) {
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
			if( ky > max || kx * r > max )
				continue;
						
			event.relX = (kx * r / max) * i.width;
			event.relY = (ky / max) * i.height;
			i.handleEvent(event);
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
		for( e in old )
			emitEvent(e);
		if( interactive.length > 0 )
			pendingEvents = new flash.Vector();
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