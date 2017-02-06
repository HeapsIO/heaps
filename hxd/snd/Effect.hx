package hxd.snd;

class Effect {

	/**
		Audible gain used to estimate wether the channel should be cutoff or not
	**/
	public var gain (get, set) : Float;

	function get_gain() return 1.0;
	function set_gain(v) {
		throw "cannot set the gain on this effect";
		return v;
	}

	function new() { }


	/**
		Actual volume change to be performed on channel.
	**/
	public function getVolumeModifier() : Float {
		return 1;
	}

	function apply( channel : Channel, source : Driver.Source ) {
		throw this+" is not supported on this platform";
	}

}