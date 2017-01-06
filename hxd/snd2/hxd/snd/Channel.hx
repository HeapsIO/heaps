package hxd.snd;

@:allow(hxd.snd.System)
class Channel extends ChannelBase {
	static var ID = 0;

	@:noCompletion public var next     : Channel;
	@:noCompletion public var nextFree : Channel;

	public var id           (default, null) : Int;
	public var soundRes     (default, null) : hxd.res.Sound;
	public var soundData    (default, null) : hxd.snd.Data;
	public var soundGroup   (default, null) : SoundGroup;
	public var channelGroup (default, null) : ChannelGroup;
	public var duration     (default, null) : Float;
	public var position     (default, set)  : Float;

	public var pause (default, set) : Bool;
	public var loop  : Bool;
	var audibleGain : Float;
	var initStamp   : Float;
	var lastStamp   : Float;
	var isVirtual   : Bool;
	var positionChanged : Bool;


	private function new() {
		super();
		id = ++ID;
	}

	function set_position(v : Float) {
		lastStamp = haxe.Timer.stamp();
		positionChanged = true;
		return position = v;
	}

	function set_pause(v : Bool) {
		if (!v) lastStamp = haxe.Timer.stamp();
		return pause = v;
	}

	function init(sound : hxd.res.Sound) {
		reset();
		pause     = false;
		isVirtual = false;
		loop      = false;
		lastStamp = haxe.Timer.stamp();

		soundRes  = sound;
		soundData = sound.getData();
		duration  = soundData.samples / 44100;
		position  = 0.0;
		audibleGain = 1.0;
		initStamp = haxe.Timer.stamp();
	}

	public function calcAudibleGain() {
		audibleGain = volume * channelGroup.volume * soundGroup.volume;
		for (e in effects) audibleGain *= e.gain;
		return audibleGain;
	}

	public function stop() {
		@:privateAccess System.instance.releaseChannel(this);
	}
}