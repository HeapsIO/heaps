package hxd.snd.effect;

import openal.AL;

class Spatialization extends Effect {

	public var position  : h3d.Vector;
	public var velocity  : h3d.Vector;
	public var direction : h3d.Vector;

	public var referenceDistance : Float;
	public var maxDistance  : Null<Float>;
	public var fadeDistance : Null<Float>;
	public var rollOffFactor : Float;

	public function new() {
		super();
		position  = new h3d.Vector();
		velocity  = new h3d.Vector();
		direction = new h3d.Vector();

		referenceDistance = 1.0;
		rollOffFactor =  1.0;
	}

	function getFadeGain() {
		var dist = System.get().listener.position.distance(position);
		if (maxDistance != null) dist -= maxDistance;
		else dist -= referenceDistance;
		var gain = 1 - dist / fadeDistance;
		if (gain > 1) gain = 1;
		if (gain < 0) gain = 0;
		return gain;
	}

	override function apply(channel : Channel, s : System.Source) {
		AL.source3f(s.inst, AL.POSITION,  position.x,  position.y,  position.z);
		AL.source3f(s.inst, AL.VELOCITY,  velocity.x,  velocity.y,  velocity.z);
		AL.source3f(s.inst, AL.DIRECTION, direction.x, direction.y, direction.z);

		AL.sourcef(s.inst, AL.REFERENCE_DISTANCE, referenceDistance);
		AL.sourcef(s.inst, AL.ROLLOFF_FACTOR, rollOffFactor);
		AL.sourcef(s.inst, AL.MIN_GAIN, 0);

		if (maxDistance != null) {
			var md : Float = maxDistance;
			AL.sourcef(s.inst, AL.MAX_DISTANCE, md);
		}

		if (fadeDistance != null) {
			var volume = channel.volume * channel.soundGroup.volume * channel.channelGroup.volume;
			AL.sourcef(s.inst, AL.GAIN, getFadeGain() * volume);
		}
	}

	override function get_gain() {
		var dist = System.get().listener.position.distance(position);
		dist = Math.max(dist, referenceDistance);
		if (maxDistance != null) dist = Math.min(dist, maxDistance);
		var gain = referenceDistance/(referenceDistance + rollOffFactor * (dist - referenceDistance));
		if (fadeDistance != null) gain *= getFadeGain();
		return gain;
	}

}