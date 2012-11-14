package h2d;

enum EventKind {
	EPush;
	ERelease;
	EMove;
	EOver;
	EOut;
}

class Event {

	public var kind : EventKind;
	public var relX : Float;
	public var relY : Float;
	public var propagate : Bool;
	public var cancel : Bool;
	public var touchId : Int;
	
	public function new(k,x=0.,y=0.) {
		kind = k;
		this.relX = x;
		this.relY = y;
	}
	
	public function toString() {
		return kind + "[" + Std.int(relX) + "," + Std.int(relY) + "]";
	}
	
}