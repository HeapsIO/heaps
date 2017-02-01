package hxd.snd;

class Effect {
	public var gain (get, set) : Float;

	function get_gain() return 1.0;
	function set_gain(v) {
		throw "cannot set the gain on this effect";
		return v;
	}

	function new() { }

	function apply( channel : Channel, source : Driver.Source ) {
		throw this+" is not supported on this platform";
	}

}