package hxd.snd;

class ChannelBase {

	public var priority : Float = 0.;
	public var volume   : Float = 1.;
	public var pan      : Float = 0.;
	public var mute     : Bool = false;
	public var effects  : Array<Effect> = [];

	function new() {
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

}