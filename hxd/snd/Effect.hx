package hxd.snd;

@:allow(hxd.snd.Driver)
@:allow(hxd.snd.ChannelBase)
class Effect {
	var refs : Int;
	
	var allocated (get, never) : Bool;
	inline function get_allocated() return refs > 0;

	function new() { 
		refs = 0;
	}

	// used to evaluate gain midification for virtualization sorting
	public function applyAudibleGainModifier(v : Float) : Float {
		return v;
	}

	// used to tweak channel volume after virtualization sorting
	public function getVolumeModifier() : Float {
		return 1;
	}

	inline function incRefs() {
		if (refs++ == 0) onAlloc();
	}

	inline function decRefs() {
		if (refs == 0) return;
		if (--refs == 0) onDelete();
	}

	function onAlloc () { }
	function onDelete() { }

	function apply   (source : Driver.Source) { }
	function unapply (source : Driver.Source) { }
}