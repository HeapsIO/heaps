package hxd.snd.openal;

import hxd.snd.Driver;
import hxd.snd.openal.AudioTypes;
import hxd.snd.effect.Spatialization;

class SpatializationDriver extends EffectDriver<Spatialization> {
	var driver : Driver;

	public function new(driver) {
		super();
		this.driver = driver;
	}

	override function bind(e : Spatialization, s : SourceHandle) : Void {
		AL.sourcei(s.inst,  AL.SOURCE_RELATIVE, AL.FALSE);
	}

	override function apply(e : Spatialization, s : SourceHandle) : Void {
		var e = hxd.impl.Api.downcast(e, hxd.snd.effect.Spatialization);

		AL.source3f(s.inst, AL.POSITION,  -e.position.x,  e.position.y,  e.position.z);
		AL.source3f(s.inst, AL.VELOCITY,  -e.velocity.x,  e.velocity.y,  e.velocity.z);
		AL.source3f(s.inst, AL.DIRECTION, -e.direction.x, e.direction.y, e.direction.z);
		AL.sourcef(s.inst, AL.REFERENCE_DISTANCE, e.referenceDistance);
		AL.sourcef(s.inst, AL.ROLLOFF_FACTOR, e.rollOffFactor);
		var maxDist : Float = e.maxDistance == null ? 3.40282347e38 : e.maxDistance;
		AL.sourcef(s.inst, AL.MAX_DISTANCE, maxDist );
	}

	override function unbind(e : Spatialization, s : SourceHandle) : Void {
		AL.sourcei (s.inst, AL.SOURCE_RELATIVE, AL.TRUE);
		AL.source3f(s.inst, AL.POSITION,  0, 0, 0);
		AL.source3f(s.inst, AL.VELOCITY,  0, 0, 0);
		AL.source3f(s.inst, AL.DIRECTION, 0, 0, 0);
	}
}