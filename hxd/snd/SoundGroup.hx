package hxd.snd;

class SoundGroup {
	public var name (default, null) : String;
	public var volume               : Float;
	public var minDelay             : Float;
	public var maxAudible           : Int;
	public var muteFadeSpeed        : Float;
	public var mono					: Bool;

	public function new(name : String) {
		this.name  = name;
		maxAudible = -1;
		muteFadeSpeed = 0;
		minDelay = 0.0;
		volume = 1;
		mono = false;
	}
}