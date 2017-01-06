package audiov2.effect;

import openal.AL;

@:keep
class Spatialization extends Effect {
	public var position  : h3d.Vector;
	public var velocity  : h3d.Vector;
	public var direction : h3d.Vector;

	public var referenceDistance : Float;
	public var maxDistance  : Null<Float>;
	public var fadeDistance : Null<Float>;
	public var rollOffFactor : Float;

	private function new() {
		super();
		position  = new h3d.Vector();
		velocity  = new h3d.Vector();
		direction = new h3d.Vector();

		referenceDistance = 1.0;
		rollOffFactor =  1.0;
	}

	function getFadeGain() {
		var dist = audiov2.System.instance.listenerPos.distance(position);
		if (maxDistance != null) dist -= maxDistance;
		else dist -= referenceDistance;
		var gain = 1 - dist / fadeDistance;
		if (gain > 1) gain = 1;
		if (gain < 0) gain = 0;
		return gain;
	}

	override function apply(channel : Channel, source : Source) {
		AL.source3f(source, AL.POSITION,  position.x,  position.y,  position.z);
		AL.source3f(source, AL.VELOCITY,  velocity.x,  velocity.y,  velocity.z);
		AL.source3f(source, AL.DIRECTION, direction.x, direction.y, direction.z);

		AL.sourcef(source, AL.REFERENCE_DISTANCE, referenceDistance);
		AL.sourcef(source, AL.ROLLOFF_FACTOR, rollOffFactor);
		AL.sourcef(source, AL.MIN_GAIN, 0);

		if (maxDistance != null) {
			var md : Float = maxDistance;
			AL.sourcef(source, AL.MAX_DISTANCE, md);
		}

		if (fadeDistance != null) {
			var volume = channel.volume * channel.soundGroup.volume * channel.channelGroup.volume;
			AL.sourcef(source, AL.GAIN, getFadeGain() * volume);
		}
	}

	override function get_gain() {
		var dist = audiov2.System.instance.listenerPos.distance(position);
		dist = Math.max(dist, referenceDistance);
		if (maxDistance != null) dist = Math.min(dist, maxDistance);
		var gain = referenceDistance/(referenceDistance + rollOffFactor * (dist - referenceDistance));
		if (fadeDistance != null) gain *= getFadeGain();
		return gain;
	}
}