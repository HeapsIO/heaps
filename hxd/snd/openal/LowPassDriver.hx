package hxd.snd.openal;

import hxd.snd.openal.AudioTypes;
import hxd.snd.effect.LowPass;

class LowPassDriver extends hxd.snd.Driver.EffectDriver<LowPass> {
	var driver : Driver;
	var inst   : openal.EFX.Filter;

	public function new(driver) {
		super();
		this.driver = driver;
	}

	override function acquire() : Void {
		var bytes = driver.getTmpBytes(4);
		EFX.genFilters(1, bytes);
		inst = openal.EFX.Filter.ofInt(bytes.getInt32(0));
		EFX.filteri(inst, EFX.FILTER_TYPE, EFX.FILTER_LOWPASS);
	}

	override function release() : Void {
		var bytes = driver.getTmpBytes(4);
		bytes.setInt32(0, inst.toInt());
		EFX.deleteFilters(1, bytes);
	}

	override function update(e : LowPass) : Void {
		EFX.filterf(inst, EFX.LOWPASS_GAIN,   1.0);
		EFX.filterf(inst, EFX.LOWPASS_GAINHF, e.gainHF);
	}

	override function apply(e : LowPass, source : SourceHandle) : Void {
		AL.sourcei(source.inst, EFX.DIRECT_FILTER, inst.toInt());
	}

	override function unbind(e : LowPass, source : SourceHandle) : Void {
		AL.sourcei(source.inst, EFX.DIRECT_FILTER, EFX.FILTER_NULL);
	}
}