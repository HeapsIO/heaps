package hxd.snd;

@:allow(hxd.snd.Driver)
class ChannelBase {

	public var priority : Float = 0.;
	public var mute     : Bool = false;
	public var effects  : Array<Effect> = [];
	public var removedEffects : Array<Effect> = [];

	public var volume(default, set) : Float = 1.;
	var currentFade : { start : Float, duration : Float, startVolume : Float, targetVolume : Float, onEnd : Void -> Void };
	var currentVolume : Float; // global volume

	function new() {
	}

	public function getEffect<T:Effect>( etype : Class<T> ) : T {
		for (e in effects) {
			var e = Std.instance(e, etype);
			if (e != null) return e;
		}
		return null;
	}

	function set_volume(v) {
		currentFade = null;
		return volume = v;
	}

	public function fadeTo( volume : Float, ?time = 1., ?onEnd ) {
		currentFade = { start : haxe.Timer.stamp(), duration : time, startVolume : this.volume, targetVolume : volume, onEnd : onEnd };
	}

	function updateCurrentVolume( now : Float ) {
		if( currentFade != null ) {
			var f = currentFade;
			var dt = now - f.start;
			if( dt >= f.duration ) {
				volume = f.targetVolume;
				if( f.onEnd != null ) f.onEnd();
			} else {
				volume = f.startVolume + (dt / f.duration) * (f.targetVolume - f.startVolume);
				currentFade = f; // restore
			}
		}
		currentVolume = volume;
	}

	public function addEffect<T:Effect>( e : T ) : T {
		if (e == null) throw "Can't add null effect";
		if (effects.indexOf(e) >= 0) throw "effect already added on this channel";

		effects.push(e);
		e.incRefs();
		return e;
	}

	public function removeEffect( e : Effect ) {
		var found = effects.remove(e);
		if (!found) return;

		removedEffects.push(e);
		e.decRefs();
	}

}