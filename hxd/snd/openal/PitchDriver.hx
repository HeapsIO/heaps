package hxd.snd.openal;

import hxd.snd.Driver;
import hxd.snd.openal.AudioTypes;
import hxd.snd.effect.Pitch;

class PitchDriver extends EffectDriver<Pitch> {

	override function apply(e : Pitch, source : SourceHandle) : Void {
		AL.sourcef(source.inst, AL.PITCH, hxd.impl.Api.downcast(e, hxd.snd.effect.Pitch).value);
	}

	override function unbind(e : Pitch, source : SourceHandle) : Void {
		AL.sourcef(source.inst, AL.PITCH, 1.);
	}
}