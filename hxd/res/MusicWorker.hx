package hxd.res;

enum MusicMessage {
	Play( path : String, volume : Float, time : Float );
	SetVolume( id : Int, volume : Float );
	Fade( id : Int, uid : Int, volume : Float, time : Float );
	Stop( id : Int );
	Queue( id : Int, ?next : Int );
	Loop( id : Int, b : Bool );
	EndLoop( id : Int );
	SetTime( id : Int, t : Float );
	FadeEnd( id : Int, uid : Int );
}

class Channel {
	var w : MusicWorker;
	var id : Int;
	var snd : flash.media.Sound;
	var samples : Int;
	var position : Int;
	var vol : Float;
	var volumeTarget : Float;
	var volumeSpeed : Float;
	var playTime : Float;
	var onFadeEnd : Void -> Void;
	var fadeUID : Int = 0;

	public var res(default, null) : Sound;
	public var loop(default, set) : Bool;
	public var next(default,set) : Channel;
	public var volume(default, set) : Float;
	public var currentTime(get, set) : Float;

	function new(w, res, id, v, t:Float) {
		this.res = res;
		this.vol = volume = v;
		this.id = id;
		loop = true;
		volumeSpeed = 0;
		playTime = haxe.Timer.stamp() - t;
		this.w = w;
	}

	function set_next( c : Channel ) {
		if( next == c )
			return c;
		if( w != null ) {
			if( c != null && c.id <= id ) throw "Must queue a channel created after";
			w.send(Queue(id, c == null ? null : c.id));
		}
		return next = c;
	}

	function get_currentTime() {
		return haxe.Timer.stamp() - playTime;
	}

	function set_currentTime(v:Float) {
		playTime = haxe.Timer.stamp() - v;
		if( w != null ) {
			throw "assert";
			w.send(SetTime(id, v));
			return v;
		}
		if( samples > 0 ) {
			position = Std.int(v * 44100) % samples;
			if( position < 0 ) position += samples;
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
			w.channels.remove(this);
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

@:access(hxd.res.Channel)
@:allow(hxd.res.Channel)
class MusicWorker extends Worker<MusicMessage> {

	public static var NATIVE_MUSIC = false;
	static inline var INFINITE = 0x7FFFFFFF;

	var channelID = 1;
	var channels : Array<Channel> = [];
	var cmap : Map<Int,Channel> = new Map();
	var snd : flash.media.Sound;
	var channel : flash.media.SoundChannel;
	var tmpBuf : haxe.io.Bytes;
	var out : haxe.ds.Vector<Float>;
	var current : Channel;
	static inline var BUFFER_SIZE = 4096;

	public function new() {
		super(MusicMessage);
	}

	override function clone() {
		return new MusicWorker();
	}

	function makeChannel( res, volume : Float, time : Float ) {
		var c = new Channel(isWorker ? null : this, res, channelID++, volume, time);
		channels.push(c);
		cmap.set(c.id, c);
		return c;
	}

	override function handleMessage( msg : MusicMessage ) {

		switch( msg ) {
		case Play(path, volume, time):
			var c = makeChannel(null, volume, time);
			var bytes = hxd.Res.loader.load(path).entry.getBytes();
			c.snd = new flash.media.Sound();
			c.snd.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);

			if( NATIVE_MUSIC ) {
				if( channel != null ) channel.stop();
				channel = c.snd.play(time, INFINITE);
				if( channel != null ) {
					current = c;
					channel.addEventListener(flash.events.Event.SOUND_COMPLETE, function(_) send(EndLoop(c.id)));
				} else
					current = null;
				return;
			}

			var mp = new format.mp3.Reader(new haxe.io.BytesInput(bytes)).read();
			c.samples = mp.sampleCount;
			var frame = mp.frames[0].data.toString();
			// http://gabriel.mp3-tech.org/mp3infotag.html
			var lame = frame.indexOf("LAME", 32 + 120);
			if( lame >= 0 ) {
				var startEnd = (frame.charCodeAt(lame + 21) << 16) | (frame.charCodeAt(lame + 22) << 8) | frame.charCodeAt(lame + 23);
				var start = startEnd >> 12;
				var end = startEnd & ((1 << 12) - 1);
				c.samples -= start + end + 1152; // first frame is empty
			}
			c.currentTime = time; // update position

		case SetVolume(id, volume):
			var c = cmap.get(id);
			if( c == null ) return;
			c.vol = volume;
			c.volumeSpeed = 0;
		case Stop(id):
			var c = cmap.get(id);
			if( c == null ) return;
			channels.remove(c);
			cmap.remove(c.id);
			if( NATIVE_MUSIC && c == current && channel != null ) {
				channel.stop();
				channel = null;
				current = null;
			}
		case Fade(id, uid, vol, time):
			var c = cmap.get(id);
			if( c == null ) return;
			c.volumeTarget = vol;
			c.fadeUID = uid;
			c.volumeSpeed = (vol - c.vol) / (time * 88200);
		case Queue(id, tid):
			var c = cmap.get(id);
			if( c == null ) return;
			var c2 = cmap.get(tid);
			c.next = c2;
		case Loop(id, b):
			var c = cmap.get(id);
			if( c == null ) return;
			c.loop = b;
		case EndLoop(id):
			var c = cmap.get(id);
			if( c != null ) c.onEnd();
		case FadeEnd(id,uid):
			var c = cmap.get(id);
			if( c != null && c.fadeUID == uid ) c.onFadeEnd();
		case SetTime(id, v):
			var c = cmap.get(id);
			if( c != null ) c.currentTime = v;
		}
	}

	override function setupMain() {
		// make sure that the sounds system is initialized
		// https://bugbase.adobe.com/index.cfm?event=bug&id=3842828
		var s = new flash.media.Sound();
		s.addEventListener(flash.events.SampleDataEvent.SAMPLE_DATA, function(_) { } );
		var c = s.play(0, 0);
		if( c != null ) c.stop();
	}

	override function setupWorker() {
		tmpBuf = haxe.io.Bytes.alloc(BUFFER_SIZE * 4 * 2);
		out = new haxe.ds.Vector(BUFFER_SIZE * 2);
		snd = new flash.media.Sound();
		if( !NATIVE_MUSIC ) {
			snd.addEventListener(flash.events.SampleDataEvent.SAMPLE_DATA, onSample);
			channel = snd.play(0, INFINITE);
		}
		if( hxd.System.isAndroid )
			initActivate();
	}

	function initActivate() {
		var prevPos = 0.;
		flash.desktop.NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, function(_) channel = snd.play(prevPos, INFINITE));
		flash.desktop.NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, function(_) if( channel != null ) { prevPos = NATIVE_MUSIC ? channel.position : 0; channel.stop(); channel = null; } );
	}

	function onSample( e:flash.events.SampleDataEvent ) {
		for( i in 0...BUFFER_SIZE*2 )
			out[i] = 0;
		for( c in channels ) {

			if( c.vol <= 0 && c.volumeSpeed <= 0 ) continue;
			if( !c.loop && c.position == c.samples ) continue;

			var w = 0;
			while( true ) {
				var MAGIC_DELAY = 2257;
				var size = BUFFER_SIZE - (w >> 1);
				if( size == 0 ) break;
				var tmpBytes = tmpBuf.getData();
				tmpBytes.position = 0;
				if( c.position + size >= c.samples ) {
					size = c.samples - c.position;
					c.snd.extract(tmpBytes, size, c.position + MAGIC_DELAY);
					c.position = 0;
				} else {
					c.snd.extract(tmpBytes, size, c.position + MAGIC_DELAY);
					c.position += size;
				}
				tmpBytes.position = 0;
				for( i in 0...size * 2 ) {
					out[w++] += tmpBytes.readFloat() * c.vol;
					if( c.volumeSpeed != 0 ) {
						c.vol += c.volumeSpeed;
						if( (c.volumeSpeed > 0) == (c.vol > c.volumeTarget) ) {
							c.vol = c.volumeTarget;
							c.volumeSpeed = 0;
							if( c.fadeUID > 0 ) send(FadeEnd(c.id, c.fadeUID));
						}
					}
				}
				if( c.position == 0 ) {
					send(EndLoop(c.id));
					if( c.next != null ) {
						c.next.vol = c.vol;
						c.next.volumeSpeed = c.volumeSpeed;
						c.next.volumeTarget = c.volumeTarget;
						c.volume = 0;
						c.volumeSpeed = 0;
						break;
					}
					if( !c.loop ) {
						c.position = c.samples;
						break;
					}
				}
			}
		}

		var bytes = e.data;
		bytes.position = 0;
		for( i in 0...BUFFER_SIZE * 2 )
			bytes.writeFloat(out[i]);
	}

	public static function play( music : Sound, volume = 1., time = 0. ) {
		inst.send(Play(music.entry.path, volume, time));
		return inst.makeChannel(music, volume, time);
	}

	static var inst : MusicWorker;

	public static function init() {
		inst = new MusicWorker();
		return inst.start();
	}

}