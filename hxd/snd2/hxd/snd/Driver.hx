package hxd.snd;

import openal.AL;
import openal.ALC;

class Source {
	public var inst : openal.AL.Source;
	public var channel : Channel;
	public var buffer : Buffer;

	public function new(inst) {
		this.inst = inst;
	}
}

class Buffer {
	public var inst : openal.AL.Buffer;
	public var sound : hxd.res.Sound;
	public var playCount : Int;
	public var lastStop : Float;

	public function new(inst) {
		this.inst = inst;
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

	var alDevice      : Device;
	var alContext     : Context;

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
		sources = [for (i in 0...AL_NUM_SOURCES) new Source(cast bytes.getInt32(i * 4))];

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

		AL.deleteSources(sources.length, hl.Bytes.getArray([for( s in sources ) s.inst]));
		AL.deleteBuffers(buffers.length, hl.Bytes.getArray([for( b in buffers ) b.inst]));
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
		c.init(this, sound);
		c.soundGroup   = soundGroup;
		c.channelGroup = channelGroup;
		c.next = channels;
		channels = c;
		return c;
	}

	public function update() {
		// update playing channels from sources & release stopped channels
		for( s in sources ) {
			var c = s.channel;
			if( c == null ) continue;
			var state  = 0;
			AL.getSourcei(s.inst, AL.SOURCE_STATE, new hl.Ref(state));
			switch (state) {
			case AL.STOPPED:
				releaseChannel(c);
				c.onEnd();
			case AL.PLAYING:
				if (!c.positionChanged) {
					var position : hl.F32 = 0.0;
					AL.getSourcef(s.inst, AL.SEC_OFFSET, new hl.Ref(position));
					c.position = position;
					c.positionChanged = false;
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

			// bind buf & play source
			setBuffer(s, getBuffer(c));
			AL.sourcePlay(s.inst);
			AL.sourcef(s.inst, AL.SEC_OFFSET, c.position);
			c.positionChanged = false;
			c = c.next;
		}

		// update source paramaters
		for ( s in sources ) {
			var c = s.channel;
			if( c == null) continue;

			if (c.positionChanged) {
				AL.sourcef(s.inst, AL.SEC_OFFSET, c.position);
				c.positionChanged = false;
			}

			AL.sourcei(s.inst, AL.LOOPING, c.loop ? AL.TRUE : AL.FALSE);
			AL.sourcef(s.inst, AL.GAIN, c.volume * c.channelGroup.volume * c.soundGroup.volume);

			for(e in c.effects)
				e.apply(c, s);
		}

		// update virtual channels
		var c = channels;
		var now = haxe.Timer.stamp();
		while (c != null) {
			var next = c.next;
			if (!c.pause && c.isVirtual) {
				c.position += now - c.lastStamp;
				if (!c.loop && c.position >= c.duration)
					releaseChannel(c);
			}
			c = next;
		}
	}

	// ------------------------------------------------------------------------
	// internals
	// ------------------------------------------------------------------------

	function releaseSource( s : Source ) {
		s.channel = null;
		AL.sourceStop(s.inst);
		setBuffer(s, null);
	}

	function setBuffer( s : Source, b : Buffer ) {
		if( s.buffer == b )
			return;
		if( b == null ) {
			AL.sourcei(s.inst, AL.BUFFER, AL.NONE);
			s.buffer.playCount--;
			if( s.buffer.playCount == 0 ) s.buffer.lastStop = haxe.Timer.stamp();
			s.buffer = null;
		} else {
			AL.sourcei(s.inst, AL.BUFFER, b.inst);
			b.playCount++;
			s.buffer = b;
		}
	}

	function getBuffer( c : Channel ) : Buffer {
		var b = bufferMap.get(c.sound);
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
		var b = new Buffer(cast tmpBytes.getInt32(0));
		b.sound = c.sound;
		buffers.push(b);
		bufferMap.set(c.sound, b);
		fillBuffer(b, c.sound.getData(), c.soundGroup.mono);
		return b;
	}

	function releaseBuffer( b : Buffer ) {
		buffers.remove(b);
		bufferMap.remove(b.sound);
		@:privateAccess b.sound.data = null; // free cached decoded data
		tmpBytes.setInt32(0, cast b.inst);
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

		return a.initStamp < b.initStamp ? 1 : -1;
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
		if( c.source != null ) {
			releaseSource(c.source);
			c.source = null;
		}
	}

	function fillBuffer(buf : Buffer, dat : hxd.snd.Data, forceMono = false) {
		var targetRate = dat.samplingRate;
		var targetChannels = forceMono || dat.channels == 1 ? 1 : 2;
		var alFormat;
		var targetFormat : hxd.snd.Data.SampleFormat = switch( dat.sampleFormat ) {
		case I8:
			alFormat = targetChannels == 1 ? AL.FORMAT_MONO8 : AL.FORMAT_STEREO8;
			I8;
		case I16, F32:
			alFormat = targetChannels == 1 ? AL.FORMAT_MONO16 : AL.FORMAT_STEREO16;
			I16;
		}
		if( targetChannels != dat.channels || targetFormat != dat.sampleFormat || targetRate != dat.samplingRate )
			dat = dat.resample(targetRate, targetFormat, targetChannels);
		var dataBytes = haxe.io.Bytes.alloc(dat.samples * dat.getBytesPerSample());
		dat.decode(dataBytes, 0, 0, dat.samples);
		AL.bufferData(buf.inst, alFormat, dataBytes, dataBytes.length, dat.samplingRate);
	}
}