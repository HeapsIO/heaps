package hxd.snd;

@:allow(audiov2.System)
class Effect {
	public var gain (get, set) : Float;

	function get_gain() return 1.0;
	function set_gain(v) {
		throw "cannot set the gain on this effect";
		return v;
	}

	private function new() { }

	#if hl
	function apply(channel : Channel, source : openal.AL.Source) {
	}
	#end

}