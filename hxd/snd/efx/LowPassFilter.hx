package hxd.snd.efx;

import openal.AL;
import openal.EFX;

class LowPassFilter extends hxd.snd.efx.Filter {
	public var gain   (default, set) : Float;
	public var gainHF (default, set) : Float;

	inline function set_gain(v)   { changed = true; return gain = v; }
	inline function set_gainHF(v) { changed = true; return gainHF = v; }

	public function new() {
		super();
		gain   = 1.0;
		gainHF = 1.0;
	}

	override function onAlloc() {
		super.onAlloc();
		EFX.filteri(instance, EFX.FILTER_TYPE, EFX.FILTER_LOWPASS);
	}

	override function apply(source : Driver.Source) {
		if (changed) {
			EFX.filterf(instance, EFX.LOWPASS_GAIN,   gain);
			EFX.filterf(instance, EFX.LOWPASS_GAINHF, gainHF);
			changed = false;
		}
		super.apply(source);
	}

	override function applyAudibleGainModifier(v : Float) {
		return v * gain;
	}
}