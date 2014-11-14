package hxd.snd;

class SoundChannel {

	var snd : SoundData;
	#if flash
	var channel : flash.media.SoundChannel;
	var endTimer : haxe.Timer;
	#end

	public var loop(default, null) : Bool;
	public var volume(default, set) : Float;
	public var position(get, never) : Float;
	public var playing(default, null) : Bool;

	function new(snd, loop) {
		this.snd = snd;
		this.loop = loop;
		volume = 1;
		playing = true;
	}

	function init( startTime : Float ) {
		#if flash
		startTime = (startTime * 1000) % @:privateAccess snd.snd.length;
		channel = @:privateAccess snd.snd.play(startTime, startTime == 0 && loop ? 0x7FFFFFFF : 1);
		if( !loop && channel != null ) {
			channel.addEventListener(flash.events.Event.SOUND_COMPLETE, function(_) { playing = false; onEnd(); });
		} else if( loop && startTime != 0 && channel != null ) {
			channel.addEventListener(flash.events.Event.SOUND_COMPLETE, function(_) { stop(); init(0); playing = true; onEnd(); } );
		} else {
			var t = @:privateAccess (snd.snd.length - (channel == null ? 0 : channel.position));
			endTimer = new haxe.Timer(Std.int(t));
			endTimer.run = function() {
				if( channel == null ) stop();
				onEnd();
			};
		}
		#end
	}

	function get_position() {
		#if flash
		if( channel != null )
			return (channel.position / 1000) % @:privateAccess snd.snd.length;
		#end
		return 0.;
	}

	function set_volume(v) {
		#if flash
		if( channel != null ) {
			var st = channel.soundTransform;
			st.volume = v;
			channel.soundTransform = st;
		}
		#end
		return volume = v;
	}

	public function stop() {
		playing = false;
		#if flash
		if( channel != null ) {
			channel.stop();
			channel = null;
		}
		if( endTimer != null ) {
			endTimer.stop();
			endTimer = null;
		}
		#end
	}

	public dynamic function onEnd() {
	}

}