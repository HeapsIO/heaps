package h2d;

enum EventKind {
	EPush;
	ERelease;
	EMove;
}

class Event {

	public var kind : EventKind;
	public var relX : Float;
	public var relY : Float;
	
	public function new(k,x=0.,y=0.) {
		kind = k;
		this.relX = x;
		this.relY = y;
	}
	
}