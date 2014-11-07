package hxd.snd;

enum MusicMessage {
	Play( path : String, volume : Float, time : Float );
	SetGlobalVolume( volume : Float );
	SetVolume( id : Int, volume : Float );
	Fade( id : Int, uid : Int, volume : Float, time : Float );
	Stop( id : Int );
	Queue( id : Int, path : Null<String> );
	Loop( id : Int, b : Bool );
	EndLoop( id : Int );
	SetTime( id : Int, t : Float );
	FadeEnd( id : Int, uid : Int );
	Active( b : Bool );
}

class Channel {
	var w : MusicWorker;
	var id : Int;
	var snd : SoundData;
	var samples : Int;
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

	function new(w, res, id, v, t:Float) {
		this.res = res;
		this.vol = volume = v;
		this.id = id;
		loop = true;
		volumeSpeed = 0;
		playTime = haxe.Timer.stamp() - t;
		this.w = w;
	}

	public function queueNext( r : hxd.res.Sound ) {
		if( w != null )
			w.send(Queue(id, r == null ? null : r.entry.path));
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

@:access(hxd.snd.Channel)
@:allow(hxd.snd.Channel)
class MusicWorker extends Worker<MusicMessage> {

	public static var NATIVE_MUSIC = false;
	public static var volume(default, set) = 1.0;

	var channelID = 1;
	var channels : Array<Channel> = [];
	var cmap : Map<Int,Channel> = new Map();
	var snd : SoundData;
	var channel : SoundChannel;
	var tmpBuf : haxe.io.Bytes;
	var out : haxe.ds.Vector<Float>;
	var current : Channel;
	var prevPos : Float;
	var globalVolume : Float = 1.;
	var waitTimer : haxe.Timer;
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
			c.snd = new SoundData();
			c.snd.loadMP3(bytes);

			if( NATIVE_MUSIC ) {
				if( channel != null ) channel.stop();
				channel = c.snd.playNative(time, true);
				channel.volume = globalVolume;
				channel.onEnd = function() send(EndLoop(c.id));
				current = c;
				return;
			}

			var mp = new format.mp3.Reader(new haxe.io.BytesInput(bytes)).read();
			c.samples = mp.sampleCount;
			var frame = mp.frames[0].data;
			// http://gabriel.mp3-tech.org/mp3infotag.html
			var pos = -1;
			for( i in 32 + 120...frame.length - 24 )
				if( frame.get(i) == "L".code && frame.get(i + 1) == "A".code && frame.get(i + 2) == "M".code && frame.get(i + 3) == "E".code ) {
					pos = i;
					break;
				}
			if( pos >= 0 ) {
				var startEnd = (frame.get(pos + 21) << 16) | (frame.get(pos + 22) << 8) | frame.get(pos + 23);
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
			if( NATIVE_MUSIC && c == current ) {
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
		case Queue(id, path):
			var c = cmap.get(id);
			if( c == null ) return;

			if( NATIVE_MUSIC ) {
				if( current != c || channel == null ) return;
				channel.onEnd = function() {
					send(EndLoop(c.id));
					if( path != null ) {
						handleMessage(Play(path, c.volume, 0));
						var c2 = channels[channels.length - 1];
						send(Stop(c.id));
						// rebind c2 as c
						cmap.remove(c2.id);
						c2.id = c.id;
						cmap.set(c2.id, c2);
					}
				};
				return;
			}

			handleMessage(Play(path, 0, 0));
			var c2 = channels[channels.length - 1];
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
		case Active(b):
			if( b ) {
				if( channel != null ) return;
				channel = NATIVE_MUSIC ? (current == null ? null : current.snd.playNative(prevPos,true)) : snd.playStream(sampleData);
				handleMessage(SetGlobalVolume(globalVolume));
			} else {
				if( channel == null ) return;
				prevPos = NATIVE_MUSIC ? channel.position : 0;
				channel.stop();
				channel = null;
			}
		case SetGlobalVolume(v):
			globalVolume = v;
			if( channel != null ) channel.volume = v;
		}
	}

	override function setupMain() {
		// make sure that the sounds system is initialized
		// https://bugbase.adobe.com/index.cfm?event=bug&id=3842828
		var s = new SoundData();
		s.playStream(function() return new haxe.ds.Vector<Float>(BUFFER_SIZE * 2)).stop();

		if( hxd.System.isAndroid )
			initActivate();
		if( volume != 1 )
			send(SetGlobalVolume(volume));
	}

	function initActivate() {
		#if air3
		// note : on some devices (Wiko) theses events are not fired inside workers, so catch them only in main thread
		flash.desktop.NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, function(_:Dynamic) send(Active(true)));
		flash.desktop.NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, function(_:Dynamic) send(Active(false)));
		#end
	}

	override function setupWorker() {
		tmpBuf = haxe.io.Bytes.alloc(BUFFER_SIZE * 4 * 2);
		out = new haxe.ds.Vector(BUFFER_SIZE * 2);
		if( !NATIVE_MUSIC ) {
			snd = new SoundData();
			channel = snd.playStream(sampleData);
		}
	}

	function sampleData() {
		for( i in 0...BUFFER_SIZE*2 )
			out[i] = 0;
		for( c in channels ) {

			if( c.vol <= 0 && c.volumeSpeed <= 0 ) continue;
			if( !c.loop && c.position == c.samples ) continue;

			var w = 0;
			while( true ) {
				var size = BUFFER_SIZE - (w >> 1);
				if( size == 0 ) break;
				if( c.position + size >= c.samples ) {
					size = c.samples - c.position;
					c.snd.extract(tmpBuf, 0, c.position, size);
					c.position = 0;
				} else {
					c.snd.extract(tmpBuf, 0, c.position, size);
					c.position += size;
				}
				#if flash
				flash.Memory.select(tmpBuf.getData());
				#end
				for( i in 0...size * 2 ) {
					out[w++] += #if flash flash.Memory.getFloat #else tmpBuf.getFloat #end(i << 2) * c.vol;
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
						c.snd = c.next.snd;
						c.samples = c.next.samples;
						handleMessage(Stop(c.next.id));
						c.next = null;
					} else if( !c.loop ) {
						c.position = c.samples;
						break;
					}
				}
			}
		}
		return out;
	}

	static function set_volume( v : Float ) {
		if( volume == v )
			return v;
		if( inst != null )
			inst.send(SetGlobalVolume(v));
		return volume = v;
	}

	public static function play( music : hxd.res.Sound, volume = 1., time = 0. ) {
		inst.send(Play(music.entry.path, volume, time));
		return inst.makeChannel(music, volume, time);
	}

	static var inst : MusicWorker;

	public static function init() {
		inst = new MusicWorker();
		return inst.start();
	}

}