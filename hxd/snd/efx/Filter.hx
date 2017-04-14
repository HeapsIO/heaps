package hxd.snd.efx;

private typedef AL       = openal.AL;
private typedef EFX      = openal.EFX;
private typedef ALFilter = openal.EFX.Filter;

@:allow(hxd.snd.efx.Effect)
class Filter extends hxd.snd.Effect {
	var changed  : Bool;
	var instance : ALFilter;
	var alBytes  : haxe.io.Bytes;
	var effect   : Effect;

	function new() {
		super();
		changed = true;
		alBytes = haxe.io.Bytes.alloc(4);
	}

	override function onAlloc() {
		EFX.genFilters(1, alBytes);
		instance = ALFilter.ofInt(alBytes.getInt32(0));
		changed = true;
	}

	override function onDelete() {
		EFX.deleteFilters(1, alBytes);
	}

	override function apply(source : Driver.Source) {
		if (effect == null) AL.sourcei(source.inst, EFX.DIRECT_FILTER, instance.toInt()); 
	}

	override function unapply(source : Driver.Source) {
		if (effect == null) AL.sourcei(source.inst, EFX.DIRECT_FILTER, EFX.FILTER_NULL); 
	}
}