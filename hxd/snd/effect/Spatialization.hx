package hxd.snd.effect;

class Spatialization extends hxd.snd.Effect {
	public var position  : h3d.Vector;
	public var velocity  : h3d.Vector;
	public var direction : h3d.Vector;

	public var referenceDistance : Float;
	public var maxDistance  : Null<Float>;
	public var fadeDistance : Null<Float>;
	public var rollOffFactor : Float;

	public function new() {
		super("spatialization");
		position  = new h3d.Vector();
		velocity  = new h3d.Vector();
		direction = new h3d.Vector();

		referenceDistance = 1.0;
		rollOffFactor =  1.0;
	}

	override function getVolumeModifier() {
		if( fadeDistance == null ) return 1.;
		var dist = Manager.get().listener.position.distance(position);
		if (maxDistance != null) dist -= maxDistance;
		else dist -= referenceDistance;
		var gain = 1 - dist / fadeDistance;
		if (gain > 1) gain = 1;
		if (gain < 0) gain = 0;
		return gain;
	}

	override function applyAudibleGainModifier(v : Float) {
		var dist = Manager.get().listener.position.distance(position);
		dist = Math.max(dist, referenceDistance);
		if (maxDistance != null) dist = Math.min(dist, maxDistance);
		var gain = referenceDistance/(referenceDistance + rollOffFactor * (dist - referenceDistance));
		return v * gain;
	}
}