package hxd.snd;

class Channel extends ChannelBase {
	static var ID = 0;

	@:noCompletion public var next     : Channel;
	var driver : Driver;
	var source : Driver.Source;
	var id : Int;

	public var sound     	(default, null) : hxd.res.Sound;
	public var soundGroup   (default, null) : SoundGroup;
	public var channelGroup (default, null) : ChannelGroup;
	public var duration     (default, null) : Float;
	public var position     (default, set)  : Float;

	public var pause (default, set) : Bool;
	public var loop  : Bool;
	var audibleGain : Float;
	var lastStamp   : Float;
	var isVirtual   : Bool;
	var positionChanged : Bool;
	var queue : Array<hxd.res.Sound> = [];

	function new() {
		super();
		id = ID++;
		pause     = false;
		isVirtual = false;
		loop      = false;
		position  = 0.0;
		audibleGain = 1.0;
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
		return position = v;
	}

	function set_pause(v : Bool) {
		if (!v) lastStamp = haxe.Timer.stamp();
		return pause = v;
	}

	public function calcAudibleGain() {
		audibleGain = volume * channelGroup.volume * soundGroup.volume;
		for (e in effects) audibleGain *= e.gain;
		return audibleGain;
	}

	/**
		Add a sound to the queue. When the current sound is finished playing, the next one will seamlessly continue.
		This will also trigger an onEnd() event.
	**/
	public function queueSound( sound : hxd.res.Sound ) {
		queue.push(sound);
		if( driver != null && source != null )
			@:privateAccess driver.syncBuffers(source, this);
	}

	public function stop() {
		if( driver != null ) {
			@:privateAccess driver.releaseChannel(this);
			driver = null;
		}
	}

}