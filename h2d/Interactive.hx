package h2d;

class Interactive extends Sprite {

	public var width : Float;
	public var height : Float;
	public var useMouseHand(default,set) : Bool;
	public var isEllipse : Bool;
	var scene : Scene;
	
	public function new(width, height, ?parent) {
		super(parent);
		this.width = width;
		this.height = height;
		useMouseHand = true;
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
		if( scene != null )
			scene.removeEventTarget(this);
		super.onDelete();
	}

	@:allow(h2d.Scene)
	function handleEvent( e : Event ) {
		if( isEllipse && (e.kind != EOut && e.kind != ERelease) ) {
			var cx = width * 0.5, cy = height * 0.5;
			var dx = (e.relX - cx) / cx;
			var dy = (e.relY - cy) / cy;
			if( dx * dx + dy * dy > 1 ) {
				e.cancel = true;
				return;
			}
		}
		switch( e.kind ) {
		case EMove:
			onMove(e);
		case EPush:
			onPush(e);
		case ERelease:
			onRelease(e);
		case EOver:
			if( useMouseHand ) flash.ui.Mouse.cursor = flash.ui.MouseCursor.BUTTON;
			onOver(e);
		case EOut:
			if( useMouseHand ) flash.ui.Mouse.cursor = flash.ui.MouseCursor.AUTO;
			onOut(e);
		}
	}
	
	function set_useMouseHand(v) {
		this.useMouseHand = v;
		if( scene != null && scene.currentOver == this )
			flash.ui.Mouse.cursor = v ? flash.ui.MouseCursor.BUTTON : flash.ui.MouseCursor.AUTO;
		return v;
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
	
}