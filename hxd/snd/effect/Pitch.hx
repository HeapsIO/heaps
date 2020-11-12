package hxd.snd.effect;

class Pitch extends hxd.snd.Effect {
	public var value : Float;

	public function new(value = 1.0) {
		super("pitch");
		this.value =  value;
	}
}