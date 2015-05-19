package hxd.snd;

class Channel {
	var w : Worker;
	var channel : Worker.NativeChannelData;
	var id : Int;
	var snd : Data;
	var position : Int;
	var vol : Float;
	var volumeTarget : Float;
	var volumeSpeed : Float;
	var playTime : Float;
	var onFadeEnd : Void -> Void;
	var fadeUID : Int = 0;
	var next : Channel;

	public var res(default, null) : hxd.res.Sound;
	public var loop(default, set) : Bool;
	public var volume(default, set) : Float;
	public var currentTime(get, set) : Float;

	function new(w, chan, res, id, loop, v, t:Float) {
		this.res = res;
		this.channel = chan;
		this.vol = volume = v;
		this.id = id;
		this.loop = loop;
		volumeSpeed = 0;
		playTime = haxe.Timer.stamp() - t;
		this.w = w;
	}

	public function queueNext( r : hxd.res.Sound ) {
		if( w != null ) {
			if( r != null ) w.channelID++;
			w.send(Queue(id, r == null ? null : r.entry.path));
		}
	}

	function get_currentTime() {
		return haxe.Timer.stamp() - playTime;
	}

	function set_currentTime(v:Float) {
		playTime = haxe.Timer.stamp() - v;
		if( w != null ) {
			w.send(SetTime(id, v));
			return v;
		}
		if( snd.samples > 0 ) {
			position = Std.int(v * 44100) % snd.samples;
			if( position < 0 ) position += snd.samples;
		}
		return v;
	}

	public function fadeTo( volume : Float, time : Float = 1., ?onEnd : Void -> Void ) {
		if( this.volume == volume ) {
			if( onEnd != null ) haxe.Timer.delay(onEnd, 1+Math.ceil(time * 1000));
			return;
		}
		var old = w;
		w = null;
		this.volume = volume;
		w = old;
		onFadeEnd = onEnd;
		if( w != null ) w.send(Fade(id, onEnd == null ? 0 : ++fadeUID, volume, time));
	}

	public function stop() {
		if( w != null ) {
			w.send(Stop(id));
			if( channel != null ) channel.channels.remove(this);
			w.cmap.remove(id);
			w = null;
		}
	}

	function set_loop(b) {
		if( loop == b )
			return b;
		if( w != null ) w.send(Loop(id, b));
		return loop = b;
	}

	function set_volume(v) {
		if( volume == v )
			return v;
		volume = v;
		if( w != null ) w.send(SetVolume(id, v));
		return v;
	}

	public dynamic function onEnd() {
	}

}
