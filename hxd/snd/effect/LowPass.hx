package hxd.snd.effect;

class LowPass extends hxd.snd.Effect {
	public var gainHF : Float;

	public function new() {
		super("lowpass");
		priority = 100;
		gainHF = 1.0;
	}
}