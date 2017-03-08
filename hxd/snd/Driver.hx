package hxd.snd;

#if hlopenal
typedef AL = openal.AL;
private typedef ALC          = openal.ALC;
private typedef ALSource     = openal.AL.Source;
private typedef ALBuffer     = openal.AL.Buffer;
private typedef ALDevice     = openal.ALC.Device;
private typedef ALContext    = openal.ALC.Context;
#else
typedef AL = hxd.snd.ALEmulator;
private typedef ALC       = hxd.snd.ALEmulator.ALCEmulator;
private typedef ALSource  = hxd.snd.ALEmulator.ALSource;
private typedef ALBuffer  = hxd.snd.ALEmulator.ALBuffer;
private typedef ALDevice  = hxd.snd.ALEmulator.ALDevice;
private typedef ALContext = hxd.snd.ALEmulator.ALContext;
#end

class Source {
	public var inst : ALSource;
	public var channel : Channel;
	public var buffers : Array<Buffer>;

	public var loop = false;
	public var volume = 1.;
	public var playing = false;
	public var hasQueue = false;

	public var streamData : hxd.snd.Data;
	public var streamSample : Int;
	public var streamPosition : Float;
	public var streamPositionNext : Float;

	public function new(inst) {
		this.inst = inst;
		buffers = [];
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
		if( sound == null ) {
			var tmp = haxe.io.Bytes.alloc(4);
			tmp.setInt32(0, inst.toInt());
			AL.deleteBuffers(1, tmp);
		} else {
			playCount--;
			if( playCount == 0 ) lastStop = haxe.Timer.stamp();
		}
	}
}

class Driver {

	/**
		When a channel is streaming, how much data should be bufferize.
	**/
	public static var STREAM_BUFSIZE = 1 << 19;

	/**
		Automatically set the channel to streaming mode if its duration exceed this value.
	**/
	public static var STREAM_DURATION = 5.;

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

	var cachedBytes   : haxe.io.Bytes;
	var resampleBytes : haxe.io.Bytes;

	var alDevice      : ALDevice;
	var alContext     : ALContext;
	var buffers       : Array<Buffer>;
	var sources       : Array<Source>;
	var bufferMap     : Map<hxd.res.Sound, Buffer>;

	var preUpdateCallbacks  : Array<Void->Void>;
	var postUpdateCallbacks : Array<Void->Void>;

	// ------------------------------------------------------------------------

	private function new() {
		masterVolume       = 1.0;
		masterSoundGroup   = new SoundGroup  ("master");
		masterChannelGroup = new ChannelGroup("master");
		listener = new Listener();

		buffers = [];
		bufferMap = new Map();

		preUpdateCallbacks  = [];
		postUpdateCallbacks = [];

		// al init
		alDevice  = ALC.openDevice(null);
		alContext = ALC.createContext(alDevice, null);
		ALC.makeContextCurrent(alContext);
		ALC.loadExtensions(alDevice);
		AL.loadExtensions();

		{	// alloc sources
			sources = [];
			var bytes = haxe.io.Bytes.alloc(4);
			for (i in 0...AL_NUM_SOURCES) {
				AL.genSources(1, bytes);
				if (AL.getError() != AL.NO_ERROR) break;
				var s = new Source(ALSource.ofInt(bytes.getInt32(0)));
				AL.sourcei(s.inst, AL.SOURCE_RELATIVE, AL.TRUE);
				sources.push(s);
			}
		}

		cachedBytes = haxe.io.Bytes.alloc(4 * 3 * 2);
	}

	public function addPreUpdateCallback(f : Void->Void) {
		preUpdateCallbacks.push(f);
	}

	public function addPostUpdateCallback(f : Void->Void) {
		postUpdateCallbacks.push(f);
	}

	function getTmp(size) {
		if( cachedBytes.length < size )
			cachedBytes = haxe.io.Bytes.alloc(size);
		return cachedBytes;
	}

	static function soundUpdate() {
		if( instance != null ) {
			for (f in instance.preUpdateCallbacks) f();
			instance.update();
			for (f in instance.postUpdateCallbacks) f();
		}
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

	public function cleanCache() {
		for( b in buffers.copy() )
			if( b.playCount == 0 )
				releaseBuffer(b);
	}

	public function dispose() {
		stopAll();

		inline function arrayBytes(a:Array<Int>) {
			#if hlopenal
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
		sources     = [];
		buffers     = [];
		
		ALC.makeContextCurrent(null);
		ALC.destroyContext(alContext);
		ALC.closeDevice(alDevice);
	}

	public function play(sound : hxd.res.Sound, ?channelGroup : ChannelGroup, ?soundGroup : SoundGroup) {
		if (soundGroup   == null) soundGroup   = masterSoundGroup;
		if (channelGroup == null) channelGroup = masterChannelGroup;
		var c = new Channel();
		c.driver = this;
		c.sound = sound;
		c.duration = c.sound.getData().duration;
		c.soundGroup   = soundGroup;
		c.channelGroup = channelGroup;
		c.next = channels;
		c.streaming = c.duration > STREAM_DURATION;
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
				if( c.streaming ) {
					if( c.positionChanged ) {
						// force full resync
						releaseSource(s);
						continue;
					}
					var count = AL.getSourcei(s.inst, AL.BUFFERS_PROCESSED);
					if( count > 0 ) {
						// swap buffers
						var b0 = s.buffers[0];
						var b1 = s.buffers[1];
						var tmp = getTmp(8);
						tmp.setInt32(0, b0.inst.toInt());
						AL.sourceUnqueueBuffers(s.inst, 1, tmp);
						s.streamPosition = s.streamPositionNext;
						updateStreaming(s, b0, c.soundGroup.mono);
						tmp.setInt32(0, b0.inst.toInt());
						AL.sourceQueueBuffers(s.inst, 1, tmp);
						s.buffers[0] = b1;
						s.buffers[1] = b0;
					}
					var position = AL.getSourcef(s.inst, AL.SEC_OFFSET);
					var prev = c.position;
					c.position = position + s.streamPosition;
					c.lastStamp = now;
					if( c.position > c.duration ) {
						if( c.queue.length > 0 ) {
							s.streamPosition -= c.duration;
							queueNext(c);
							c.onEnd();
						} else if( c.loop ) {
							c.position -= c.duration;
							s.streamPosition -= c.duration;
							c.onEnd();
						}
					}
					c.positionChanged = false;
				} else if( !c.positionChanged ) {
					var position = AL.getSourcef(s.inst, AL.SEC_OFFSET);
					var prev = c.position;
					c.position = position;
					c.lastStamp = now;
					c.positionChanged = false;
					if( c.queue.length > 0 ) {
						var count = AL.getSourcei(s.inst, AL.BUFFERS_PROCESSED);
						while( count > 0 ) {
							var tmp = getTmp(4);
							tmp.setInt32(0, s.buffers[0].inst.toInt());
							AL.sourceUnqueueBuffers(s.inst, 1, tmp);
							queueNext(c);
							count--;
							c.onEnd();
						}
					} else if( position < prev )
						c.onEnd();
				}
			default:
			}
		}

		// calc audible gain & virtualize inaudible channels
		var c = channels;
		while (c != null) {
			c.calcAudibleGain(now);
			c.isVirtual = c.pause || c.mute || c.channelGroup.mute || c.audibleGain < 1e-5;
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
		AL.listener3f(AL.POSITION, -listener.position.x, listener.position.y, listener.position.z);

		listener.direction.normalize();
		var tmpBytes = getTmp(24);
		tmpBytes.setFloat(0,  -listener.direction.x);
		tmpBytes.setFloat(4,  listener.direction.y);
		tmpBytes.setFloat(8,  listener.direction.z);

		listener.up.normalize();
		tmpBytes.setFloat(12, -listener.up.x);
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
			syncBuffers(s, c);
			c.positionChanged = true;
			c = c.next;
		}

		// update source parameters
		for ( s in sources ) {
			var c = s.channel;
			if( c == null) continue;
			syncSource(s);
		}
		
		var c = channels;
		while (c != null) {
			var next = c.next;
			// update virtual channels
			if (!c.pause && c.isVirtual) {
				c.position += now - c.lastStamp;
				c.lastStamp = now;
				if( c.position >= c.duration && !queueNext(c) && !c.loop ) {
					releaseChannel(c);
					c.onEnd();
				}
			}

			// clean removed effects
			if (c.channelGroup.removedEffects.length > 0) c.channelGroup.removedEffects = [];
			if (c.removedEffects != null && c.removedEffects.length > 0) c.removedEffects = [];
			c = next;
		}
	}

	function syncSource( s : Source ) {
		var c = s.channel;
		if( c == null ) return;
		if( c.positionChanged ) {
			if( !c.streaming ) {
				AL.sourcef(s.inst, AL.SEC_OFFSET, c.position);
				c.position = AL.getSourcef(s.inst, AL.SEC_OFFSET); // prevent rounding
			}
			c.positionChanged = false;
		}
		var loopFlag = c.loop && c.queue.length == 0 && !c.streaming;
		if( s.loop != loopFlag ) {
			s.loop = loopFlag;
			AL.sourcei(s.inst, AL.LOOPING, loopFlag ? AL.TRUE : AL.FALSE);
		}
		var v = c.currentVolume;
		if( s.volume != v ) {
			s.volume = v;
			AL.sourcef(s.inst, AL.GAIN, v);
		}

		for (e in c.channelGroup.removedEffects) e.unapply(s);
		for (e in c.removedEffects) e.unapply(s);

		for (e in c.channelGroup.effects) e.apply(s);
		for (e in c.effects) e.apply(s);

		if( !s.playing ) {
			s.playing = true;
			AL.sourcePlay(s.inst);
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
		if (s.channel != null) {
			for (e in s.channel.channelGroup.removedEffects) e.unapply(s);
			for (e in s.channel.removedEffects) e.unapply(s);
			for (e in s.channel.channelGroup.effects) e.unapply(s);
			for (e in s.channel.effects) e.unapply(s);

			s.channel.source = null;
			s.channel = null;
		}
		if( s.playing ) {
			s.playing = false;
			AL.sourceStop(s.inst);
		}
		syncBuffers(s, null);
	}

	function syncBuffers( s : Source, c : Channel ) {
		if( c == null ) {
			if( s.buffers.length == 0 )
				return;
			if( !s.hasQueue )
				AL.sourcei(s.inst, AL.BUFFER, AL.NONE);
			else {
				var tmpBytes = getTmp(4 * s.buffers.length);
				for( i in 0...s.buffers.length )
					tmpBytes.setInt32(i << 2, s.buffers[i].inst.toInt());
				AL.sourceUnqueueBuffers(s.inst, s.buffers.length, tmpBytes);
			}
			for( b in s.buffers )
				b.unref();
			s.buffers = [];
			s.streamData = null;
			s.hasQueue = false;

		} else if( c.streaming ) {

			if( !s.hasQueue ) {
				if( s.buffers.length != 0 ) throw "assert";
				s.hasQueue = true;
				var tmpBytes = getTmp(8);
				AL.genBuffers(2, tmpBytes);
				s.buffers = [new Buffer(ALBuffer.ofInt(tmpBytes.getInt32(0))), new Buffer(ALBuffer.ofInt(tmpBytes.getInt32(4)))];
				s.streamData = c.sound.getData();
				s.streamSample = Std.int(c.position * s.streamData.samplingRate);
				// fill first two buffers
				updateStreaming(s, s.buffers[0], c.soundGroup.mono);
				s.streamPosition = s.streamPositionNext;
				updateStreaming(s, s.buffers[1], c.soundGroup.mono);
				tmpBytes.setInt32(0, s.buffers[0].inst.toInt());
				tmpBytes.setInt32(4, s.buffers[1].inst.toInt());
				AL.sourceQueueBuffers(s.inst, 2, tmpBytes);
				/*var error = AL.getError();
				if( error != 0 )
					throw "Failed to queue streaming buffers 0x"+StringTools.hex(error);*/
			}

		} else if( s.hasQueue || c.queue.length > 0 ) {

			if( !s.hasQueue && s.buffers.length > 0 )
				throw "Can't queue on a channel that is currently playing an unstreamed data";

			var buffers = [getBuffer(c.sound, c.soundGroup)];
			for( snd in c.queue )
				buffers.push(getBuffer(snd, c.soundGroup));

			// only append new ones
			for( i in 0...s.buffers.length )
				if( buffers.shift() != s.buffers[i] )
					throw "assert";

			var tmpBytes = getTmp(buffers.length * 4);
			for( i in 0...buffers.length ) {
				var b = buffers[i];
				b.playCount++;
				tmpBytes.setInt32(i << 2, b.inst.toInt());
			}
			AL.sourceQueueBuffers(s.inst, buffers.length, tmpBytes);
			for( b in buffers )
				s.buffers.push(b);
			if( AL.getError() != 0 )
				throw "Failed to queue buffers : format differs";

		} else {
			var buffer = getBuffer(c.sound, c.soundGroup);
			AL.sourcei(s.inst, AL.BUFFER, buffer.inst.toInt());
			if( s.buffers[0] != null )
				s.buffers[0].unref();
			s.buffers[0] = buffer;
			buffer.playCount++;
		}
	}

	var targetRate : Int;
	var targetFormat : Data.SampleFormat;
	var targetChannels : Int;
	var alFormat : Int;

	function checkTargetFormat( dat : hxd.snd.Data, forceMono = false ) {
		targetRate = dat.samplingRate;
		#if !hl
		// perform resampling to nativechannel frequency
		targetRate = AL.NATIVE_FREQ;
		#end
		targetChannels = forceMono || dat.channels == 1 ? 1 : 2;
		targetFormat = switch( dat.sampleFormat ) {
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
		return targetChannels == dat.channels && targetFormat == dat.sampleFormat && targetRate == dat.samplingRate;
	}

	function updateStreaming( s : Source, buf : Buffer, forceMono : Bool ) {
		// decode
		var tmpBytes = getTmp(STREAM_BUFSIZE >> 1);
		var bpp = s.streamData.getBytesPerSample();
		var reqSamples = Std.int((STREAM_BUFSIZE >> 1) / bpp);
		var samples = reqSamples;
		var outPos = 0;
		var qPos = 0;

		while( samples > 0 ) {
			var avail = s.streamData.samples - s.streamSample;
			if( avail <= 0 ) {
				var next = s.channel.queue[qPos++];
				if( next != null ) {
					s.streamSample -= s.streamData.samples;
					s.streamData = next.getData();
				} else if( !s.channel.loop || s.streamData.samples == 0 )
					break;
				else
					s.streamSample -= s.streamData.samples;
			} else {
				var count = samples < avail ? samples : avail;
				if( outPos == 0 )
					s.streamPositionNext = s.streamSample / s.streamData.samplingRate;
				s.streamData.decode(tmpBytes, outPos, s.streamSample, count);
				s.streamSample += count;
				outPos += count * bpp;
				samples -= count;
			}
		}

		if( !checkTargetFormat(s.streamData, forceMono) ) {
			reqSamples -= samples;
			var bytes = resampleBytes;
			var reqBytes = targetChannels * reqSamples * Data.formatBytes(targetFormat);
			if( bytes == null || bytes.length < reqBytes ) {
				bytes = haxe.io.Bytes.alloc(reqBytes);
				resampleBytes = bytes;
			}
			s.streamData.resampleBuffer(resampleBytes, 0, tmpBytes, 0, targetRate, targetFormat, targetChannels, reqSamples);
			AL.bufferData(buf.inst, alFormat, resampleBytes, reqBytes, targetRate);
		} else {
			AL.bufferData(buf.inst, alFormat, tmpBytes, outPos, s.streamData.samplingRate);
		}
//		if( AL.getError() != 0 )
//			throw "Failed to upload buffer data";
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
		var tmpBytes = getTmp(4);
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
		var tmpBytes = getTmp(4);
		tmpBytes.setInt32(0, b.inst.toInt());
		AL.deleteBuffers(1, tmpBytes);
	}

	function sortChannel(a : Channel, b : Channel) {
		if (a.isVirtual != b.isVirtual)
			return a.isVirtual ? 1 : -1;

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
		
		for (e in c.effects) c.removeEffect(e);
		if  (c.source != null) releaseSource(c.source);

		c.next = null;
		c.driver = null;
		c.removedEffects = null;
	}

	function fillBuffer(buf : Buffer, dat : hxd.snd.Data, forceMono = false) {
		if( !checkTargetFormat(dat, forceMono) )
			dat = dat.resample(targetRate, targetFormat, targetChannels);
		var dataBytes = haxe.io.Bytes.alloc(dat.samples * dat.getBytesPerSample());
		dat.decode(dataBytes, 0, 0, dat.samples);
		AL.bufferData(buf.inst, alFormat, dataBytes, dataBytes.length, dat.samplingRate);
//		if( AL.getError() != 0 )
//			throw "Failed to upload buffer data";
	}
}