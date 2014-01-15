package hxd;

enum EventKind {
	EPush;
	ERelease;
	EMove;
	EOver;
	EOut;
	EWheel;
	EFocus;
	EFocusLost;
	EKeyDown;
	EKeyUp;
}

class Event {

	public var kind : EventKind;
	public var relX : Float;
	public var relY : Float;
	public var propagate : Bool;
	public var cancel : Bool;
	public var button : Int = 0;
	public var touchId : Int;
	public var keyCode : Int;
	public var charCode : Int;
	public var wheelDelta : Float;
	
	public function new(k,x=0.,y=0.) {
		kind = k;
		this.relX = x;
		this.relY = y;
	}
	
	public function toString() {
		return kind + "[" + Std.int(relX) + "," + Std.int(relY) + "]";
	}
	
}