package hxd.snd;

class Channel extends ChannelBase {
	static var ID = 0;

	@:noCompletion public var next     : Channel;
	var driver : Driver;
	var source : Driver.Source;

	public var id           (default, null) : Int;
	public var sound     	(default, null) : hxd.res.Sound;
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

	public dynamic function onEnd() {
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

	function init(driver, sound : hxd.res.Sound) {
		reset();
		this.driver = driver;
		pause     = false;
		isVirtual = false;
		loop      = false;
		lastStamp = haxe.Timer.stamp();

		this.sound  = sound;
		duration  = sound.getData().duration;
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
		if( driver != null ) {
			@:privateAccess driver.releaseChannel(this);
			driver = null;
		}
	}

}