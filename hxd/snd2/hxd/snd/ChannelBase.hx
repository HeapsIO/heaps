package hxd.snd;

class ChannelBase {
	public var priority : Float;
	public var volume   : Float;
	public var pan      : Float;
	public var mute     : Bool;
	public var effects  : Array<Effect>;

	public function new() {
		reset();
	}

	public function getEffect<T:Effect>( etype : Class<T> ) : T {
		for (e in effects) {
			var e = Std.instance(e, etype);
			if (e != null) return e;
		}
		return null;
	}

	public function addEffect<T:Effect>( e : T ) : T {
		if( e == null ) throw "Can't add null effect";
		effects.push(e);
		return e;
	}

	public function removeEffect( e : Effect ) {
		effects.remove(e);
	}

	public function reset() {
		effects  = [];
		priority = 0.0;
		volume   = 1.0;
		pan      = 0.0;
		mute     = false;
	}
}