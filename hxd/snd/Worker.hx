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
}

private class WorkerChannel extends NativeChannel {
	var w : Worker;
	public function new(w) {
		this.w = w;
		super(w.bufferSamples);
	}
	override function onSample(out:haxe.io.Float32Array) {
		@:privateAccess w.sampleData(out);
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
	var snd : SoundData;
	var channels : Array<Channel>;
	var tmpBuf : haxe.io.Bytes;
	var channel : NativeChannel;

	public function new( bufferSamples = 4096 ) {
		super(Message);
		this.bufferSamples = bufferSamples;
		this.channels = [];
	}

	override function clone() {
		return new Worker();
	}

	function allocChannel( res, loop : Bool, volume : Float, time : Float ) {
		var c = new Channel(isWorker ? null : this, res, channelID++, loop, volume, time);
		channels.push(c);
		cmap.set(c.id, c);
		return c;
	}

	override function handleMessage( msg : Message ) {
		switch( msg ) {
		case Play(path, loop, volume, time):
			var c = allocChannel(null, loop, volume, time);
			if( c == null )
				return;

			c.res = hxd.Res.loader.load(path).toSound();
			c.snd = c.res.getData();
			c.currentTime = time;

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
				if( channel != null ) return;
				channel = new WorkerChannel(this);
			} else {
				if( channel == null ) return;
				channel.stop();
				channel = null;
			}
		case SetGlobalVolume(v):
			volume = v;
		}
	}

	override function setupMain() {
		#if flash
		// make sure that the sounds system is initialized
		// https://bugbase.adobe.com/index.cfm?event=bug&id=3842828
		var s = new SoundData();
		s.playStream(function() return new haxe.ds.Vector<Float>(bufferSamples * 2)).stop();
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
		tmpBuf = haxe.io.Bytes.alloc(bufferSamples * 4 * 2);
		#if hxsdl
		// we might create our worker before initializing SDL, let's make sure it's done.
		sdl.Sdl.init();
		#end
		channel = new WorkerChannel(this);
	}

	function sampleData( out : haxe.io.Float32Array ) {
		for( i in 0...bufferSamples*2 )
			out[i] = 0;
		var cid = 0;
		var cmax = channels.length;

		while( cid < cmax ) {
			var c = channels[cid++];

			var w = 0;
			var snd = c.snd;
			while( true ) {
				var size = bufferSamples - (w >> 1);
				if( size == 0 ) break;
				var vol = c.vol * this.volume;
				var play = vol > 0 || c.volumeSpeed > 0;
				if( c.position + size >= snd.samples ) {
					size = snd.samples - c.position;
					if( play ) snd.decode(tmpBuf, 0, c.position, size);
					c.position = 0;
				} else {
					if( play ) snd.decode(tmpBuf, 0, c.position, size);
					c.position += size;
				}
				if( !play ) {
					w += size * 2;
				} else {
					#if flash
					flash.Memory.select(tmpBuf.getData());
					#end
					for( i in 0...size * 2 ) {
						out[w++] += #if flash flash.Memory.getFloat #else tmpBuf.getFloat #end(i << 2) * vol;
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
					if( !c.loop ) {
						channels.remove(c);
						cmap.remove(c.id);
						cid--;
						cmax--;
						break;
					}
					send(EndLoop(c.id));
					if( c.next != null ) {
						c.res = c.next.res;
						c.snd = c.next.snd;
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