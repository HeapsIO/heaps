package h2d;

class Interactive extends Drawable {

	public var width : Float;
	public var height : Float;
	public var cursor(default,set) : hxd.System.Cursor;
	public var isEllipse : Bool;
	public var blockEvents : Bool = true;
	public var propagateEvents : Bool = false;
	public var backgroundColor : Null<Int>;
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
	
	override function draw( ctx : RenderContext ) {
		if( backgroundColor != null ) drawTile(ctx.engine,h2d.Tile.fromColor(backgroundColor,Std.int(width),Std.int(height)));
	}
	
	override function onParentChanged() {
		if( scene != null ) {
			scene.removeEventTarget(this);
			scene.addEventTarget(this);
		}
	}
	
	override function onDelete() {
		if( scene != null ) {
			scene.removeEventTarget(this);
			if( scene.currentOver == this ) {
				scene.currentOver = null;
				hxd.System.setCursor(Default);
			}
		}
		super.onDelete();
	}

	function checkBounds( e : hxd.Event ) {
		return switch( e.kind ) {
		case EOut, ERelease, EFocus, EFocusLost: false;
		default: true;
		}
	}
	
	@:allow(h2d.Scene)
	function handleEvent( e : hxd.Event ) {
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
			hxd.System.setCursor(cursor);
			onOver(e);
		case EOut:
			hxd.System.setCursor(Default);
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
			hxd.System.setCursor(cursor);
		return c;
	}
	
	function globalToLocal( e : hxd.Event ) {
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
		var ev = new hxd.Event(null);
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
	
	public function blur() {
		if( scene == null )
			return;
		if( scene.currentFocus == this ) {
			var ev = new hxd.Event(null);
			ev.kind = EFocusLost;
			scene.currentFocus.handleEvent(ev);
		}
	}
	
	public function hasFocus() {
		return scene != null && scene.currentFocus == this;
	}
	
	public dynamic function onOver( e : hxd.Event ) {
	}

	public dynamic function onOut( e : hxd.Event ) {
	}
	
	public dynamic function onPush( e : hxd.Event ) {
	}

	public dynamic function onRelease( e : hxd.Event ) {
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