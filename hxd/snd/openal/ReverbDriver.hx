package hxd.snd.openal;

import hxd.snd.openal.AudioTypes;
import hxd.snd.effect.*;

@:access(hxd.snd.effect.LowPass)
@:access(hxd.snd.openal.LowPassDriver)
class ReverbDriver extends hxd.snd.Driver.EffectDriver<Reverb> {
	var driver    : Driver;
	var inst      : openal.EFX.Effect;
	var slot      : openal.EFX.EffectSlot;
	var dryFilter : LowPass;
	var dryGain   : Float;

	public function new(driver) {
		super();
		this.driver = driver;
		this.dryFilter = new LowPass();
	}

	override function acquire() : Void {
		// create effect
		var bytes = driver.getTmpBytes(4);
		EFX.genEffects(1, bytes);
		inst = openal.EFX.Effect.ofInt(bytes.getInt32(0));
		if (AL.getError() != AL.NO_ERROR) throw "could not create an ALEffect instance";
		EFX.effecti(inst, EFX.EFFECT_TYPE, EFX.EFFECT_REVERB);

		// create effect slot
		var bytes = driver.getTmpBytes(4);
		EFX.genAuxiliaryEffectSlots(1, bytes);
		slot = openal.EFX.EffectSlot.ofInt(bytes.getInt32(0));
		if (AL.getError() != AL.NO_ERROR) throw "could not create an ALEffectSlot instance";

		dryFilter.driver.acquire();
		dryFilter.gainHF = 1.0;
	}

	override function release() : Void {
		EFX.auxiliaryEffectSloti(slot, EFX.EFFECTSLOT_EFFECT, EFX.EFFECTSLOT_NULL);

		var bytes = driver.getTmpBytes(4);
		bytes.setInt32(0, slot.toInt());
		EFX.deleteAuxiliaryEffectSlots(1, bytes);

		var bytes = driver.getTmpBytes(4);
		bytes.setInt32(0, inst.toInt());
		EFX.deleteEffects(1, bytes);

		dryFilter.driver.release();
	}

	override function update(e : Reverb) : Void {
		// millibels to gain
		inline function mbToNp(mb : Float) { return Math.pow(10, mb / 100 / 20); }

		EFX.effectf(inst, EFX.REVERB_GAIN,                mbToNp(e.room));
		EFX.effectf(inst, EFX.REVERB_GAINHF,              mbToNp(e.roomHF));
		EFX.effectf(inst, EFX.REVERB_ROOM_ROLLOFF_FACTOR, e.roomRolloffFactor);
		EFX.effectf(inst, EFX.REVERB_DECAY_TIME,          e.decayTime);
		EFX.effectf(inst, EFX.REVERB_DECAY_HFRATIO,       e.decayHFRatio);
		EFX.effectf(inst, EFX.REVERB_REFLECTIONS_GAIN,    mbToNp(e.reflections));
		EFX.effectf(inst, EFX.REVERB_REFLECTIONS_DELAY,   e.reflectionsDelay);
		EFX.effectf(inst, EFX.REVERB_LATE_REVERB_GAIN,    mbToNp(e.reverb));
		EFX.effectf(inst, EFX.REVERB_LATE_REVERB_DELAY,   e.reverbDelay);
		EFX.effectf(inst, EFX.REVERB_DIFFUSION,           e.diffusion / 100.0);
		EFX.effectf(inst, EFX.REVERB_DENSITY,             e.density   / 100.0);
		// no hf reference, hope for the best :( should be 5000.0

		EFX.auxiliaryEffectSloti(slot, EFX.EFFECTSLOT_EFFECT, inst.toInt());
		EFX.auxiliaryEffectSlotf(slot, EFX.EFFECTSLOT_GAIN, e.wetDryMix / 100.0);

		@:privateAccess
		e.retainTime = e.decayTime + e.reflectionsDelay + e.reverbDelay;
	}

	override function bind(e : Reverb, s : SourceHandle) : Void {
		var send = s.acquireAuxiliarySend(e);
		if (send + 1 > driver.maxAuxiliarySends) throw "too many auxiliary sends";
	}

	override function apply(e : Reverb, s : SourceHandle) : Void {
		var e = hxd.impl.Api.downcast(e, hxd.snd.effect.Reverb);
		var send = s.getAuxiliarySend(e);
		AL.source3i(s.inst, EFX.AUXILIARY_SEND_FILTER, slot.toInt(), send, EFX.FILTER_NULL);
	}

	override function unbind(e : Reverb, s : SourceHandle) : Void {
		var send = s.releaseAuxiliarySend(e);
		AL.source3i(s.inst, EFX.AUXILIARY_SEND_FILTER, EFX.EFFECTSLOT_NULL, send, EFX.FILTER_NULL);
	}
}