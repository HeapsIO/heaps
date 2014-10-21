package hxd.res;

enum MusicMessage {
	Play( path : String, volume : Float );
	SetVolume( id : Int, volume : Float );
	Fade( id : Int, volume : Float, time : Float );
	Stop( id : Int );
	Queue( id : Int, ?next : Int );
	Loop( id : Int, b : Bool );
	EndLoop( id : Int );
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
	public var res(default, null) : Sound;
	public var loop(default, set) : Bool;
	public var next(default,set) : Channel;
	public var volume(default, set) : Float;

	public function new(res, id, v) {
		this.res = res;
		this.vol = volume = v;
		this.id = id;
		loop = true;
		volumeSpeed = 0;
		w = MusicWorker.inst;
		if( @:privateAccess w.isWorker ) w = null;
	}

	function set_next( c : Channel ) {
		if( w != null ) {
			if( c != null && c.id <= id ) throw "Must queue a channel created after";
			w.send(Queue(id, c == null ? null : c.id));
		}
		return next = c;
	}

	public function fadeTo( volume : Float, time : Float = 1. ) {
		var old = w;
		w = null;
		this.volume = volume;
		w = old;
		if( w != null ) w.send(Fade(id, volume, time));
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
		if( w != null ) w.send(Loop(id, b));
		return loop = b;
	}

	function set_volume(v) {
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

	var channelID = 1;
	var channels : Array<Channel> = [];
	var cmap : Map<Int,Channel> = new Map();
	var snd : flash.media.Sound;
	var channel : flash.media.SoundChannel;
	var tmpBuf : haxe.io.Bytes;
	var out : haxe.ds.Vector<Float>;
	static inline var BUFFER_SIZE = 4096;

	public function new() {
		super(MusicMessage);
	}

	override function clone() {
		return new MusicWorker();
	}

	function makeChannel( res, volume : Float ) {
		var c = new Channel(res, channelID++, volume);
		channels.push(c);
		cmap.set(c.id, c);
		return c;
	}

	override function handleMessage( msg : MusicMessage ) {
		switch( msg ) {
		case Play(path, volume):
			var c = makeChannel(null, volume);
			var bytes = hxd.Res.loader.load(path).entry.getBytes();
			c.snd = new flash.media.Sound();
			c.snd.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);

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
		case Fade(id, vol, time):
			var c = cmap.get(id);
			if( c == null ) return;
			c.volumeTarget = vol;
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
		}
	}

	override function setupWorker() {
		tmpBuf = haxe.io.Bytes.alloc(BUFFER_SIZE * 4 * 2);
		out = new haxe.ds.Vector(BUFFER_SIZE * 2);
		snd = new flash.media.Sound();
		snd.addEventListener(flash.events.SampleDataEvent.SAMPLE_DATA, onSample);
		channel = snd.play(0, 0x7FFFFFFF);
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

	public static function play( music : Sound, volume = 1. ) {
		inst.send(Play(music.entry.path, volume));
		return inst.makeChannel(music, volume);
	}

	static var inst : MusicWorker;

	public static function init() {
		inst = new MusicWorker();
		return inst.start();
	}

}