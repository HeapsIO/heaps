package hxd.snd;

@:allow(hxd.snd.Manager)
class Channel extends ChannelBase {
	static var ID = 0;

	@:noCompletion public var next : Channel;
	var manager : Manager;
	var source : Manager.Source;
	var id : Int;

	public var sound(default, null) : hxd.res.Sound;
	public var duration(default, null) : Float;
	public var soundGroup(default, null) : SoundGroup;
	public var channelGroup(default, null) : ChannelGroup;

	public var position(default, set) = 0.0;
	public var pause(default, set) = false;
	public var loop = false;
	public var allowVirtual = true;

	var audibleVolume = 1.0;
	var lastStamp = 0.0;
	var isVirtual = false;
	var isLoading = false;
	var positionChanged = false;
	var queue : Array<hxd.res.Sound> = [];

	function new() {
		super();
		id = ID++;
	}

	/**
		onEnd() is called when a sound which does not loop has finished playing
		or when we switch buffer in a queue
		or when a sound which is streamed loops.
	**/
	public dynamic function onEnd() {
	}

	function set_position(v : Float) {
		lastStamp = haxe.Timer.stamp();
		positionChanged = true;
		if (v > duration) v = duration;
		else if (v < 0) v = 0;
		return position = v;
	}

	function set_pause(v : Bool) {
		if (!v) lastStamp = haxe.Timer.stamp();
		return pause = v;
	}

	override function updateCurrentVolume( now : Float ) {
		if (pause && currentFade != null) {
			var f = currentFade;
			currentFade = null;
			updateCurrentVolume(now);
			currentFade = f;
		}
		super.updateCurrentVolume(now);
		channelGroup.updateCurrentVolume(now);
		currentVolume *= channelGroup.currentVolume * soundGroup.volume;

		if (manager != null) { // fader may have stopped the sound
			for (e in channelGroup.effects) currentVolume *= e.getVolumeModifier();
			for (e in effects) currentVolume *= e.getVolumeModifier();
		}
	}

	public function calcAudibleVolume( now : Float ) {
		updateCurrentVolume(now);
		audibleVolume = currentVolume;

		if (manager != null) { // fader may have stopped the sound
			for (e in channelGroup.effects) audibleVolume = e.applyAudibleVolumeModifier(audibleVolume);
			for (e in effects) audibleVolume = e.applyAudibleVolumeModifier(audibleVolume);
		}
	}

	/**
		Add a sound to the queue. When the current sound is finished playing, the next one will seamlessly continue.
		This will also trigger an onEnd() event.
	**/
	public function queueSound( sound : hxd.res.Sound ) {
		queue.push(sound);
	}

	public function stop() {
		if (manager != null) @:privateAccess manager.releaseChannel(this);
	}

	public function isReleased() {
		return manager == null;
	}
}