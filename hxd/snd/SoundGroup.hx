package hxd.snd;

@:allow(hxd.snd.Manager)
class SoundGroup {
	public var name (default, null) : String;
	public var volume               : Float;
	public var maxAudible           : Int;
	public var mono					: Bool;
	
	var numAudible : Int; // only used when maxAudible >= 0

	public function new(name : String) {
		this.name  = name;
		maxAudible = -1;
		volume = 1;
		mono = false;
	}
}