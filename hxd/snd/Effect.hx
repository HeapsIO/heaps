package hxd.snd;

import hxd.snd.Driver;

@:allow(hxd.snd.Manager)
class Effect {
	@:noCompletion public var next : Effect;
	var refs       : Int;
	var retainTime : Float;
	var lastStamp  : Float;
	var driver     : EffectDriver<Dynamic>;
	var priority   : Int;

	public function new(type : String) {
		this.refs       = 0;
		this.priority   = 0;
		this.retainTime = 0.0;
		this.lastStamp  = 0.0;

		@:privateAccess
		var managerDriver = hxd.snd.Manager.get().driver;
		if (managerDriver != null) {
			this.driver = managerDriver.getEffectDriver(type); 
		}
	}

	// used to evaluate volume modification for virtualization sorting
	public function applyAudibleVolumeModifier(v : Float) : Float {
		return v;
	}

	// used to tweak channel volume after virtualization sorting
	public function getVolumeModifier() : Float {
		return 1;
	}
}