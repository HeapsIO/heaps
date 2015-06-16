package hxd.snd;

private enum Message {
	Play( path : String, loop : Bool, volume : Float, time : Float );
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
	StopAll;
}

private class WorkerChannel extends NativeChannel {
	var w : Worker;
	var c : NativeChannelData;
	public function new(w,c) {
		this.w = w;
		this.c = c;
		super(w.bufferSamples);
	}
	override function onSample(out:haxe.io.Float32Array) {
		@:privateAccess w.sampleData(out, c);
	}
}

class NativeChannelData {
	public var next = 0.;
	public var tmpBuf : haxe.io.Bytes;
	public var channel : NativeChannel;
	public var channels : Array<Channel>;
	public var busy : Int;
	public function new(w:Worker) {
		channels = [];
		tmpBuf = haxe.io.Bytes.alloc(w.bufferSamples * 4 * 2);
	}
}

@:access(hxd.snd.Channel)
@:allow(hxd.snd.Channel)
class Worker extends hxd.Worker<Message> {

	/**
		The global volume for this worker
	**/
	public var volume(default, set) = 1.0;
	public var bufferSamples(default, null) : Int;

	var channelID = 1;
	var cmap : Map<Int,Channel> = new Map();
	var channels : Array<NativeChannelData>;

	public function new( nativeChannels = 4, bufferSamples = 4096 ) {
		super(Message);
		this.bufferSamples = bufferSamples;
		this.channels = [for( i in 0...nativeChannels ) new NativeChannelData(this)];
	}

	override function clone() {
		return new Worker();
	}

	function allocChannel( res, loop : Bool, volume : Float, time : Float ) {
		var chan = isWorker ? selectChannel() : null;
		var c = new Channel(isWorker ? null : this, chan, res, channelID++, loop, volume, time);
		if( chan != null ) chan.channels.push(c);
		cmap.set(c.id, c);
		return c;
	}

	public function stopAll() {
		if( !isWorker ) {
			send(StopAll);
			return;
		}
		for( c in channels ) {
			if( c.channel == null ) continue;
			c.channel.stop();
			c.channel = null;
			c.channels = [];
		}
	}

	function cleanChannels() {
		for( c in channels )
			if( c.channels.length == 0 && c.channel != null && c.busy <= -2 ) {
				c.channel.stop();
				c.channel = null;
			}
	}

	function selectChannel() {
		cleanChannels();
		var free = -1, best : NativeChannelData = null;
		// select best one to play
		for( i in 0...channels.length ) {
			var c = channels[i];
			if( c.channel == null ) {
				if( free < 0 ) free = i;
				continue;
			}
			if( best == null || best.next > c.next ) best = c;
		}
		if( free >= 0 ) {
			best = channels[free];
			best.next = 0;
		}
		return best;
	}

	override function handleMessage( msg : Message ) {
		switch( msg ) {
		case Play(path, loop, volume, time):
			var res = hxd.Res.loader.load(path).toSound();
			var cid = channelID++;
			var snd = res.getData();
			snd.load(function() {
				var old = channelID;
				channelID = cid;
				var c = allocChannel(null, loop, volume, time);
				channelID = old;
				if( c == null )
					return;
				c.res = res;
				c.snd = snd;
				c.currentTime = time;
				if( c.channel.channel == null ) c.channel.channel = new WorkerChannel(this, c.channel);
			});
		case SetVolume(id, volume):
			var c = cmap.get(id);
			if( c == null ) return;
			c.vol = volume;
			c.volumeSpeed = 0;
		case Stop(id):
			var c = cmap.get(id);
			if( c == null ) return;
			c.channel.channels.remove(c);
			cmap.remove(c.id);
		case Fade(id, uid, vol, time):
			var c = cmap.get(id);
			if( c == null ) return;
			c.volumeTarget = vol;
			c.fadeUID = uid;
			c.volumeSpeed = (vol - c.vol) / (time * 88200);
		case Queue(id, path):
			var c = cmap.get(id);
			if( c == null ) return;
			handleMessage(Play(path, true, 0, 0));
			var c2 = cmap.get(channelID - 1);
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
				for( c in channels )
					if( c != null && c.channel == null && c.channels.length > 0 )
						c.channel = new WorkerChannel(this, c);
			} else {
				for( c in channels )
					if( c.channel != null ) {
						c.channel.stop();
						c.channel = null;
					}
			}
		case SetGlobalVolume(v):
			volume = v;
		case StopAll:
			stopAll();
		}
	}

	override function setupMain() {
		#if flash
		// make sure that the sounds system is initialized
		// https://bugbase.adobe.com/index.cfm?event=bug&id=3842828
		var s = new flash.media.Sound();
		s.addEventListener(flash.events.SampleDataEvent.SAMPLE_DATA, function(e:flash.events.SampleDataEvent) { for( i in 0...bufferSamples * 2) e.data.writeFloat(0); } );
		var chan = s.play();
		if( chan != null ) chan.stop();
		#end
		if( hxd.System.isAndroid )
			initActivate();
	}

	function initActivate() {
		#if air3
		// note : on some devices (Wiko) theses events are not fired inside workers, so catch them only in main thread
		flash.desktop.NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, function(_:Dynamic) send(Active(true)));
		flash.desktop.NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, function(_:Dynamic) send(Active(false)));
		#end
	}

	override function setupWorker() {
		#if hxsdl
		// we might create our worker before initializing SDL, let's make sure it's done.
		sdl.Sdl.init();
		#end
	}

	@:noDebug function sampleData( out : haxe.io.Float32Array, chan : NativeChannelData ) {
		chan.next = haxe.Timer.stamp() + bufferSamples / 44100;
		var cid = 0;
		var cmax = chan.channels.length;
		for( i in 0...bufferSamples*2 )
			out[i] = 0;
		if( cmax == 0 ) {
			if( chan.busy > 0 ) chan.busy = 0 else chan.busy--;
		} else
			chan.busy = cmax;
		while( cid < cmax ) {
			var c = chan.channels[cid++];

			var w = 0;
			var snd = c.snd;
			while( true ) {
				var size = bufferSamples - (w >> 1);
				if( size == 0 ) break;
				var vol = c.vol * this.volume;
				var play = vol > 0 || c.volumeSpeed > 0;
				if( c.position + size >= snd.samples ) {
					size = snd.samples - c.position;
					if( play ) snd.decode(chan.tmpBuf, 0, c.position, size);
					c.position = 0;
				} else {
					if( play ) snd.decode(chan.tmpBuf, 0, c.position, size);
					c.position += size;
				}
				if( !play ) {
					w += size * 2;
				} else {
					#if flash
					flash.Memory.select(chan.tmpBuf.getData());
					#end
					for( i in 0...size * 2 ) {
						var v = #if flash flash.Memory.getFloat #else chan.tmpBuf.getFloat #end(i << 2) * vol;
						out[w++] += v;
						if( c.volumeSpeed != 0 ) {
							c.vol += c.volumeSpeed;
							if( (c.volumeSpeed > 0) == (c.vol > c.volumeTarget) ) {
								c.vol = c.volumeTarget;
								c.volumeSpeed = 0;
								if( c.fadeUID > 0 ) send(FadeEnd(c.id, c.fadeUID));
							}
							vol = c.vol * this.volume;
						}
					}
				}
				if( c.position == 0 ) {
					if( !c.loop && c.next == null ) {
						chan.channels.remove(c);
						cmap.remove(c.id);
						cid--;
						cmax--;
						break;
					}
					send(EndLoop(c.id));
					if( c.next != null ) {
						c.res = c.next.res;
						c.snd = c.next.snd;
						if( c.next.channel == chan )
							cmax--;
						handleMessage(Stop(c.next.id));
						c.next = null;
					}
				}
			}
		}
	}

	function set_volume( v : Float ) {
		if( volume == v )
			return v;
		if( !isWorker ) send(SetGlobalVolume(v));
		return volume = v;
	}

	public function play( snd : hxd.res.Sound, loop = true, volume = 1., time = 0. ) {
		send(Play(snd.entry.path, loop, volume, time));
		return allocChannel(snd, loop, volume, time);
	}

	public static function init() {
		var w = new Worker();
		return w.start() ? null : w;
	}

}