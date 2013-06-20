package h2d;

class Interactive extends Sprite {

	public var width : Float;
	public var height : Float;
	public var cursor(default,set) : h3d.System.Cursor;
	public var isEllipse : Bool;
	public var blockEvents : Bool = true;
	public var propagateEvents : Bool = false;
	var scene : Scene;
	
	public function new(width, height, ?parent) {
		super(parent);
		this.width = width;
		this.height = height;
		cursor = Button;
	}

	override function onAlloc() {
		var p : Sprite = this;
		while( p.parent != null )
			p = p.parent;
		if( Std.is(p, Scene) ) {
			scene = cast p;
			scene.addEventTarget(this);
		}
		super.onAlloc();
	}
	
	override function onDelete() {
		if( scene != null ) {
			scene.removeEventTarget(this);
			if( scene.currentOver == this ) {
				scene.currentOver = null;
				h3d.System.setCursor(Default);
			}
		}
		super.onDelete();
	}

	function checkBounds( e : Event ) {
		return switch( e.kind ) {
		case EOut, ERelease, EFocus, EFocusLost: false;
		default: true;
		}
	}
	
	@:allow(h2d.Scene)
	function handleEvent( e : Event ) {
		if( isEllipse && checkBounds(e) ) {
			var cx = width * 0.5, cy = height * 0.5;
			var dx = (e.relX - cx) / cx;
			var dy = (e.relY - cy) / cy;
			if( dx * dx + dy * dy > 1 ) {
				e.cancel = true;
				return;
			}
		}
		e.propagate = propagateEvents;
		if( !blockEvents ) e.cancel = true;
		switch( e.kind ) {
		case EMove:
			onMove(e);
		case EPush:
			onPush(e);
		case ERelease:
			onRelease(e);
		case EOver:
			h3d.System.setCursor(cursor);
			onOver(e);
		case EOut:
			h3d.System.setCursor(Default);
			onOut(e);
		case EWheel:
			onWheel(e);
		case EFocusLost:
			onFocusLost(e);
			if( !e.cancel && scene != null && scene.currentFocus == this ) scene.currentFocus = null;
		case EFocus:
			onFocus(e);
			if( !e.cancel && scene != null ) scene.currentFocus = this;
		case EKeyUp:
			onKeyUp(e);
		case EKeyDown:
			onKeyDown(e);
		}
	}
	
	function set_cursor(c) {
		this.cursor = c;
		if( scene != null && scene.currentOver == this )
			h3d.System.setCursor(cursor);
		return c;
	}
	
	function globalToLocal( e : Event ) {
		// convert global event to our local space
		var x = e.relX, y = e.relY;
		var rx = x * scene.matA + y * scene.matB + scene.absX;
		var ry = x * scene.matC + y * scene.matD + scene.absY;
		var r = scene.height / scene.width;
		
		var i = this;
		
		var dx = rx - i.absX;
		var dy = ry - i.absY;
		
		var w1 = i.width * i.matA * r;
		var h1 = i.width * i.matC;
		var ky = h1 * dx - w1 * dy;
		
		var w2 = i.height * i.matB * r;
		var h2 = i.height * i.matD;
		var kx = w2 * dy - h2 * dx;
		
		var max = h1 * w2 - w1 * h2;
		
		e.relX = (kx * r / max) * i.width;
		e.relY = (ky / max) * i.height;
	}
	
	public function startDrag(callb) {
		scene.startDrag(function(event) {
			var x = event.relX, y = event.relY;
			globalToLocal(event);
			callb(event);
			event.relX = x;
			event.relY = y;
		});
	}
	
	public function stopDrag() {
		scene.stopDrag();
	}
	
	public function focus() {
		if( scene == null )
			return;
		var ev = new h2d.Event(null);
		if( scene.currentFocus != null ) {
			if( scene.currentFocus == this )
				return;
			ev.kind = EFocusLost;
			scene.currentFocus.handleEvent(ev);
			if( ev.cancel ) return;
		}
		ev.kind = EFocus;
		handleEvent(ev);
	}
	
	public function hasFocus() {
		return scene != null && scene.currentFocus == this;
	}
	
	public dynamic function onOver( e : Event ) {
	}

	public dynamic function onOut( e : Event ) {
	}
	
	public dynamic function onPush( e : Event ) {
	}

	public dynamic function onRelease( e : Event ) {
	}
	
	public dynamic function onMove( e : Event ) {
	}

	public dynamic function onWheel( e : Event ) {
	}

	public dynamic function onFocus( e : Event ) {
	}
	
	public dynamic function onFocusLost( e : Event ) {
	}

	public dynamic function onKeyUp( e : Event ) {
	}

	public dynamic function onKeyDown( e : Event ) {
	}
	
}