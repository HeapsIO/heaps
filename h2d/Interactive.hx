package h2d;

class Interactive extends Sprite {

	public var width : Float;
	public var height : Float;
	public var useMouseHand : Bool;
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
		switch( e.kind ) {
		case EMove:
			onMove(e);
		case EPush:
			onPush(e);
		case ERelease:
			onRelease(e);
		}
	}
	
	public dynamic function onPush( e : Event ) {
	}

	public dynamic function onRelease( e : Event ) {
	}
	
	public dynamic function onMove( e : Event ) {
	}
	
}