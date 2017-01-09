package hxd.snd;

#if hl
typedef AL = openal.AL;
private typedef ALC = openal.ALC;
private typedef ALSource = openal.AL.Source;
private typedef ALBuffer = openal.AL.Buffer;
private typedef ALDevice = openal.ALC.Device;
private typedef ALContext = openal.ALC.Context;
#else
typedef AL = hxd.snd.ALEmulator;
private typedef ALC = hxd.snd.ALEmulator.ALCEmulator;
private typedef ALSource = hxd.snd.ALEmulator.ALSource;
private typedef ALBuffer = hxd.snd.ALEmulator.ALBuffer;
private typedef ALDevice = hxd.snd.ALEmulator.ALDevice;
private typedef ALContext = hxd.snd.ALEmulator.ALContext;
#end

class Source {
	public var inst : ALSource;
	public var channel : Channel;
	public var buffer : Buffer;

	public var loop = false;
	public var volume = 1.;
	public var playing = false;

	public var nextSound : hxd.res.Sound;
	public var nextBuffer : Buffer;

	public function new(inst) {
		this.inst = inst;
	}
}

class Buffer {
	public var inst : ALBuffer;
	public var sound : hxd.res.Sound;
	public var playCount : Int;
	public var lastStop : Float;

	public function new(inst) {
		this.inst = inst;
	}

	public function unref() {
		playCount--;
		if( playCount == 0 ) lastStop = haxe.Timer.stamp();
	}
}

@:access(hxd.snd.Channel)
@:access(hxd.snd.Effect)
class Driver {
	static var instance : Driver;

	public var masterVolume	: Float;
	public var masterSoundGroup   (default, null) : SoundGroup;
	public var masterChannelGroup (default, null) : ChannelGroup;

	public var listener : Listener;

	var channels : Channel;

	// ------------------------------------------------------------------------
	// AL SHIT
	// ------------------------------------------------------------------------

	static inline var AL_NUM_SOURCES = 16;

	var tmpBytes : haxe.io.Bytes;

	var alDevice      : ALDevice;
	var alContext     : ALContext;

	var buffers       : Array<Buffer>;
	var sources       : Array<Source>;
	var bufferMap     : Map<hxd.res.Sound, Buffer>;

	// ------------------------------------------------------------------------

	private function new() {
		masterVolume       = 1.0;
		masterSoundGroup   = new SoundGroup  ("master");
		masterChannelGroup = new ChannelGroup("master");
		listener = new Listener();

		buffers = [];
		bufferMap = new Map();

		// al init
		alDevice  = ALC.openDevice(null);
		alContext = ALC.createContext(alDevice, null);
		ALC.makeContextCurrent(alContext);

		// alloc sources
		var bytes = haxe.io.Bytes.alloc(4 * AL_NUM_SOURCES);
		AL.genSources(AL_NUM_SOURCES, bytes);
		sources = [for (i in 0...AL_NUM_SOURCES) new Source(ALSource.ofInt(bytes.getInt32(i * 4)))];

		tmpBytes = haxe.io.Bytes.alloc(4 * 3 * 2);
	}

	static function soundUpdate() {
		if( instance != null ) instance.update();
	}

	public static function get() {
		if( instance == null ) {
			instance = new Driver();
			haxe.MainLoop.add(soundUpdate);
		}
		return instance;
	}

	public function stopAll() {
		while( channels != null )
			channels.stop();
	}

	public function dispose() {
		stopAll();

		inline function arrayBytes(a:Array<Int>) {
			#if hl
			return hl.Bytes.getArray(a);
			#else
			var b = haxe.io.Bytes.alloc(a.length * 4);
			for( i in 0...a.length )
				b.setInt32(i << 2, a[i]);
			return b;
			#end
		}

		AL.deleteSources(sources.length, arrayBytes([for( s in sources ) s.inst.toInt()]));
		AL.deleteBuffers(buffers.length, arrayBytes([for( b in buffers ) b.inst.toInt()]));
		sources = [];
		buffers = [];

		ALC.makeContextCurrent(null);
		ALC.destroyContext(alContext);
		ALC.closeDevice(alDevice);
	}

	public function play(sound : hxd.res.Sound, ?soundGroup : SoundGroup, ?channelGroup : ChannelGroup) {
		if (soundGroup   == null) soundGroup   = masterSoundGroup;
		if (channelGroup == null) channelGroup = masterChannelGroup;
		var c = new Channel();
		c.driver = this;
		c.sound = sound;
		c.duration = c.sound.getData().duration;
		c.soundGroup   = soundGroup;
		c.channelGroup = channelGroup;
		c.next = channels;
		channels = c;
		return c;
	}

	public function update() {
		// update playing channels from sources & release stopped channels
		var now = haxe.Timer.stamp();

		for( s in sources ) {
			var c = s.channel;
			if( c == null ) continue;
			var state = AL.getSourcei(s.inst, AL.SOURCE_STATE);
			switch (state) {
			case AL.STOPPED:
				releaseChannel(c);
				c.onEnd();
			case AL.PLAYING:
				if (!c.positionChanged) {
					var position = AL.getSourcef(s.inst, AL.SEC_OFFSET);
					var prev = c.position;
					c.position = position;
					c.lastStamp = now;
					c.positionChanged = false;
					if( position < prev ) c.onEnd();
				}
			default:
			}
		}

		// calc audible gain & virtualize inaudible channels
		var c = channels;
		while (c != null) {
			c.isVirtual = false;
			c.calcAudibleGain();
			if (c.pause || c.mute || c.channelGroup.mute || c.audibleGain < 1e-5 ) c.isVirtual = true;
			c = c.next;
		}

		// sort channels by priority
		channels = haxe.ds.ListSort.sortSingleLinked(channels, sortChannel);

		{	// virtualize sounds that puts the put the audible count over the maximum number of sources
			var sgroupRefs = new Map<SoundGroup, Int>();

			var audibleCount = 0;
			var c = channels;
			while (c != null && !c.isVirtual) {
				if (++audibleCount > sources.length) c.isVirtual = true;
				else if (c.soundGroup.maxAudible >= 0) {
					var sgRefs = sgroupRefs.get(c.soundGroup);
					if (sgRefs == null) sgRefs = 0;
					if (++sgRefs > c.soundGroup.maxAudible) {
						c.isVirtual = true;
						--audibleCount;
					}
					sgroupRefs.set(c.soundGroup, sgRefs);
				}
				c = c.next;
			}
		}


		// free sources that points to virtualized channels
		for ( s in sources ) {
			if ( s.channel == null || !s.channel.isVirtual) continue;
			releaseSource(s);
		}

		// update listener parameters
		AL.listenerf(AL.GAIN, masterVolume);
		AL.listener3f(AL.POSITION, listener.position.x, listener.position.y, listener.position.z);

		listener.direction.normalize();
		tmpBytes.setFloat(0,  listener.direction.x);
		tmpBytes.setFloat(4,  listener.direction.y);
		tmpBytes.setFloat(8,  listener.direction.z);

		listener.up.normalize();
		tmpBytes.setFloat(12, listener.up.x);
		tmpBytes.setFloat(16, listener.up.y);
		tmpBytes.setFloat(20, listener.up.z);

		AL.listenerfv(AL.ORIENTATION, tmpBytes);

		// bind sources to non virtual channels
		var c = channels;
		while (c != null) {
			if( c.source != null || c.isVirtual ) {
				c = c.next;
				continue;
			}

			// look for a free source
			var s = null;
			for( s2 in sources )
				if( s2.channel == null ) {
					s = s2;
					break;
				}
			if( s == null ) throw "assert";
			s.channel = c;
			c.source = s;

			// bind buf and force full sync
			setBuffer(s, getBuffer(c.sound, c.soundGroup));
			c.positionChanged = true;
			c = c.next;
		}

		// update source parameters
		for ( s in sources ) {
			var c = s.channel;
			if( c == null) continue;
			syncSource(s);
		}

		// update virtual channels
		var c = channels;
		while (c != null) {
			var next = c.next;
			if (!c.pause && c.isVirtual) {
				c.position += now - c.lastStamp;
				c.lastStamp = now;
				if( c.position >= c.duration && !queueNext(c) && !c.loop ) {
					releaseChannel(c);
					c.onEnd();
				}
			}
			c = next;
		}
	}

	function syncSource( s : Source ) {
		var c = s.channel;
		if( c == null ) return;
		if( c.positionChanged ) {
			AL.sourcef(s.inst, AL.SEC_OFFSET, c.position);
			c.positionChanged = false;
		}
		if( s.loop != c.loop ) {
			s.loop = c.loop;
			AL.sourcei(s.inst, AL.LOOPING, c.loop ? AL.TRUE : AL.FALSE);
		}
		var v = c.volume * c.channelGroup.volume * c.soundGroup.volume;
		if( s.volume != v ) {
			s.volume = v;
			AL.sourcef(s.inst, AL.GAIN, v);
		}
		for(e in c.effects)
			e.apply(c, s);
		if( !s.playing ) {
			s.playing = true;
			AL.sourcePlay(s.inst);
		}

		// sync queuing
		var nextSound = c.queue[0];
		if( s.nextSound != nextSound ) {
			if( s.nextSound != null ) {
				tmpBytes.setInt32(0, s.nextBuffer.inst.toInt());
				AL.sourceUnqueueBuffers(s.inst, 1, tmpBytes);
				s.nextBuffer.unref();
				s.nextSound = null;
				s.nextBuffer = null;
			}
			if( nextSound != null ) {
				s.nextSound = nextSound;
				s.nextBuffer = getBuffer(nextSound, c.soundGroup);
				s.nextBuffer.playCount++;
				tmpBytes.setInt32(0, s.nextBuffer.inst.toInt());
				AL.sourceQueueBuffers(s.inst, 1, tmpBytes);
				if( AL.getError() != 0 )
					throw "Failed to queue buffer : format differs between " + c.sound + " and " + nextSound;
			}
		}
	}

	function queueNext( c : Channel ) {
		var snd = c.queue.shift();
		if( snd == null )
			return false;
		c.sound = snd;
		c.position -= c.duration;
		c.duration = snd.getData().duration;
		c.positionChanged = false;
		return true;
	}

	// ------------------------------------------------------------------------
	// internals
	// ------------------------------------------------------------------------

	function releaseSource( s : Source ) {
		s.channel = null;
		if( s.playing ) {
			s.playing = false;
			AL.sourceStop(s.inst);
		}
		setBuffer(s, null);
	}

	function setBuffer( s : Source, b : Buffer ) {
		if( s.buffer == b )
			return;
		if( b == null ) {
			AL.sourcei(s.inst, AL.BUFFER, AL.NONE);
			s.buffer.unref();
			s.buffer = null;
		} else {
			AL.sourcei(s.inst, AL.BUFFER, b.inst.toInt());
			b.playCount++;
			s.buffer = b;
		}
	}

	function getBuffer( snd : hxd.res.Sound, grp : SoundGroup ) : Buffer {
		var b = bufferMap.get(snd);
		if( b != null )
			return b;
		if( buffers.length >= 256 ) {
			// cleanup unused buffers
			var now = haxe.Timer.stamp();
			for( b in buffers.copy() )
				if( b.playCount == 0 && b.lastStop < now - 60 )
					releaseBuffer(b);
		}
		AL.genBuffers(1, tmpBytes);
		var b = new Buffer(ALBuffer.ofInt(tmpBytes.getInt32(0)));
		b.sound = snd;
		buffers.push(b);
		bufferMap.set(snd, b);
		var data = snd.getData();
		var mono = grp.mono;
		data.load(function() fillBuffer(b, data, mono));
		return b;
	}

	function releaseBuffer( b : Buffer ) {
		buffers.remove(b);
		bufferMap.remove(b.sound);
		@:privateAccess b.sound.data = null; // free cached decoded data
		tmpBytes.setInt32(0, b.inst.toInt());
		AL.deleteBuffers(1, tmpBytes);
	}

	function sortChannel(a : Channel, b : Channel) {
		if (a.isVirtual != b.isVirtual)
			return (a.isVirtual && !b.isVirtual) ? 1 : -1;

		if (a.channelGroup.priority != b.channelGroup.priority)
			return a.channelGroup.priority < b.channelGroup.priority ? 1 : -1;

		if (a.priority != b.priority)
			return a.priority < b.priority ? 1 : -1;

		if (a.audibleGain != b.audibleGain)
			return a.audibleGain < b.audibleGain ? 1 : -1;

		return a.id < b.id ? 1 : -1;
	}

	function releaseChannel(c : Channel) {
		if (channels == c) {
			channels = c.next;
		} else {
			var prev = channels;
			while (prev.next != c)
				prev = prev.next;
			prev.next = c.next;
		}
		c.next = null;
		c.driver = null;
		if( c.source != null ) {
			releaseSource(c.source);
			c.source = null;
		}
	}

	function fillBuffer(buf : Buffer, dat : hxd.snd.Data, forceMono = false) {
		var targetRate = dat.samplingRate;

		#if !hl
		// perform resampling to nativechannel frequency
		targetRate = AL.NATIVE_FREQ;
		#end

		var targetChannels = forceMono || dat.channels == 1 ? 1 : 2;
		var alFormat;
		var targetFormat : hxd.snd.Data.SampleFormat = switch( dat.sampleFormat ) {
		case UI8:
			alFormat = targetChannels == 1 ? AL.FORMAT_MONO8 : AL.FORMAT_STEREO8;
			UI8;
		case I16:
			alFormat = targetChannels == 1 ? AL.FORMAT_MONO16 : AL.FORMAT_STEREO16;
			I16;
		case F32:
			#if hl
			alFormat = targetChannels == 1 ? AL.FORMAT_MONO16 : AL.FORMAT_STEREO16;
			I16;
			#else
			alFormat = targetChannels == 1 ? AL.FORMAT_MONOF32 : AL.FORMAT_STEREOF32;
			F32;
			#end
		}
		if( targetChannels != dat.channels || targetFormat != dat.sampleFormat || targetRate != dat.samplingRate )
			dat = dat.resample(targetRate, targetFormat, targetChannels);
		var dataBytes = haxe.io.Bytes.alloc(dat.samples * dat.getBytesPerSample());
		dat.decode(dataBytes, 0, 0, dat.samples);
		AL.bufferData(buf.inst, alFormat, dataBytes, dataBytes.length, dat.samplingRate);
	}
}