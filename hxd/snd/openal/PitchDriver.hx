package hxd.snd.openal;

import hxd.snd.Driver;
import hxd.snd.openal.AudioTypes;
import hxd.snd.effect.Pitch;

class PitchDriver extends EffectDriver<Pitch> {
	var driver : DriverImpl;

	public function new(driver) {
		super();
		this.driver = driver;
	}

	override function apply(e : Pitch, source : SourceHandle) : Void {
		AL.sourcef(source.inst, AL.PITCH, Std.instance(e, hxd.snd.effect.Pitch).value);
	}

	override function unbind(e : Pitch, source : SourceHandle) : Void {
		AL.sourcef(source.inst, AL.PITCH, 1.);
	}
}