package hxd.snd;

import openal.AL;
import openal.ALC;

class System {
	public static var instance : System;

	public var masterVolume	: Float;
	public var masterSoundGroup   (default, null) : SoundGroup;
	public var masterChannelGroup (default, null) : ChannelGroup;

	var soundGroups   : Array<SoundGroup>;
	var channelGroups : Array<ChannelGroup>;
	var effects       : Array<Effect>;

	public var listenerPos : h3d.Vector;
	public var listenerVel : h3d.Vector;
	public var listenerDir : h3d.Vector;
	public var listenerUp  : h3d.Vector;

	var usedChannels : Channel;
	var freeChannels : Channel;

	// ------------------------------------------------------------------------
	// AL SHIT
	// ------------------------------------------------------------------------

	var AL_NUM_SOURCES = 16;
	var AL_NUM_BUFFERS = 256;

	var alListenerOriBytes : haxe.io.Bytes;

	var alDevice      : Device;
	var alContext     : Context;

	var alBuffers     : Array<Buffer>;
	var alBufRefs     : Array<Int>;
	var alFreeBufs    : Array<Int>;
	var soundToBuf    : Map<hxd.res.Sound, Int>;
	var bufToSound    : Map<Int, hxd.res.Sound>;

	var alSources     : Array<Source>;
	var chanToSource  : Map<Channel, Int>;
	var sourceToChan  : Array<Channel>;
	var alFreeSources : Array<Int>;

	// ------------------------------------------------------------------------

	private function new() {
		masterVolume       = 1.0;
		masterSoundGroup   = new SoundGroup  ("master");
		masterChannelGroup = new ChannelGroup("master");

		soundGroups   = [masterSoundGroup];
		channelGroups = [masterChannelGroup];
		effects       = [];

		listenerPos = new h3d.Vector();
		listenerVel = new h3d.Vector();
		listenerDir = new h3d.Vector(0,  0, -1);
		listenerUp  = new h3d.Vector(0,  1,  0);

		{
			// al init
			alDevice  = ALC.openDevice(null);
			alContext = ALC.createContext(alDevice, null);
			ALC.makeContextCurrent(alContext);

			var bytes = haxe.io.Bytes.alloc(4 * AL_NUM_SOURCES);
			AL.genSources(AL_NUM_SOURCES, bytes);
			alSources = [];
			for (i in 0...AL_NUM_SOURCES) alSources.push(cast bytes.getInt32(i * 4));

			var bytes = haxe.io.Bytes.alloc(4 * AL_NUM_BUFFERS);
			AL.genBuffers(AL_NUM_BUFFERS, bytes);
			alBuffers = [];
			for (i in 0...AL_NUM_BUFFERS) alBuffers.push(cast bytes.getInt32(i * 4));
		}

		alBufRefs  = [];
		alFreeBufs = [];

		for (i in 0...alBuffers.length) {
			alBufRefs.push(0);
			alFreeBufs.push(i);
		}

		sourceToChan  = [];
		alFreeSources = [];
		for (i in 0...alSources.length) {
			alFreeSources.push(i);
			sourceToChan.push(null);
		}

		soundToBuf = new Map();
		bufToSound = new Map();
		chanToSource = new Map();
		alListenerOriBytes = haxe.io.Bytes.alloc(4 * 3 * 2);
	}

	public static function init() {
		instance = new System();
	}

	public function shutdown() {
		for (s in alSources) {
			var buf : Int = AL.NONE;
			AL.getSourcei(s, AL.BUFFER, new hl.Ref(buf));
			if (buf != AL.NONE) AL.sourcei(s, AL.BUFFER, AL.NONE);
		}

		AL.deleteSources(AL_NUM_SOURCES, hl.Bytes.getArray(alSources));
		AL.deleteBuffers(AL_NUM_BUFFERS, hl.Bytes.getArray(alBuffers));

		ALC.makeContextCurrent(null);
		ALC.destroyContext(alContext);
		ALC.closeDevice(alDevice);
	}

	public function createSoundGroup(name : String) {
		var sg = new SoundGroup(name);
		soundGroups.push(sg);
		return sg;
	}

	public function createChannelGroup(name : String) {
		var cg = new ChannelGroup(name);
		channelGroups.push(cg);
		return cg;
	}

	public function releaseSoundGroup(sg : SoundGroup) {
		soundGroups.remove(sg);
	}

	public function releaseChannelGroup(cg : ChannelGroup) {
		channelGroups.remove(cg);
	}

	public function createEffect<T:Effect>(etype : Class<T>, ?args : Array<Dynamic>) : T {
		if (args == null) args = [];
		var e = Type.createInstance(etype, args);
		return e;
	}

	public function releaseEffect(e : Effect) {
		effects.remove(e);
	}

	public function playSound(sound : hxd.res.Sound, ?soundGroup : SoundGroup, ?channelGroup : ChannelGroup) {
		if (soundGroup   == null) soundGroup   = masterSoundGroup;
		if (channelGroup == null) channelGroup = masterChannelGroup;
		var c = acquireChannel(sound, soundGroup, channelGroup);

		var index = soundToBuf.get(sound);
		if (index == null) {
			index = alFreeBufs.pop();
			if (index == null) throw "too many buffers";
			soundToBuf.set(sound, index);
			fillBuffer(alBuffers[index], c.soundData, soundGroup.mono);
		} else alFreeBufs.remove(index);

		var oldSound = bufToSound.get(index);
		if (oldSound != null && oldSound != sound) {
			soundToBuf.remove(oldSound);
			alBufRefs[index] = 0;
		}

		bufToSound.set(index, sound);
		alBufRefs[index] = alBufRefs[index] + 1;

		return c;
	}

	public function update() {
		// update playing channels from sources & release stopped channels
		for (i in 0...alSources.length) {
			var c = sourceToChan[i];
			if (c == null) continue;
			var state  = 0;
			var source = alSources[i];
			AL.getSourcei(source, AL.SOURCE_STATE, new hl.Ref(state));
			switch (state) {
				case AL.STOPPED :
					releaseChannel(c);
				case AL.PLAYING :
					if (!c.positionChanged) {
						var position : hl.F32 = 0.0;
						AL.getSourcef(source, AL.SEC_OFFSET, new hl.Ref(position));
						c.position = position;
						c.positionChanged = false;
					}
				default :
			}
		}

		// calc audible gain & virtualize inaudible channels
		var c = usedChannels;
		while (c != null) {
			c.isVirtual = false;
			c.calcAudibleGain();
			if (c.pause || c.mute || c.channelGroup.mute || c.audibleGain == 0) c.isVirtual = true;
			c = c.next;
		}

		// sort channels by priority
		usedChannels = haxe.ds.ListSort.sortSingleLinked(usedChannels, sortChannel);

		{	// virtualize sounds that puts the put the audible count over the maximum number of sources
			var sgroupRefs = new Map<SoundGroup, Int>();

			var audibleCount = 0;
			var c = usedChannels;
			while (c != null && !c.isVirtual) {
				if (++audibleCount > alSources.length) c.isVirtual = true;
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
		for (i in 0...alSources.length) {
			if (sourceToChan[i] == null || !sourceToChan[i].isVirtual) continue;
			releaseSource(i);
		}

		// bind sources to non virtual channels
		var c = usedChannels;
		while (c != null) {
			var srcIndex = chanToSource.get(c);
			if (srcIndex != null || c.isVirtual) {
				c = c.next;
				continue;
			}

			srcIndex = alFreeSources.pop();
			if (srcIndex == null) throw "woups " + c.id;
			chanToSource.set(c, srcIndex);
			sourceToChan[srcIndex] = c;

			// bind buf & play source
			var source = alSources[srcIndex];
			var buffer = alBuffers[soundToBuf.get(c.soundRes)];
			AL.sourcei(source, AL.BUFFER, buffer);
			AL.sourcePlay(source);
			AL.sourcef(source, AL.SEC_OFFSET, c.position);
			c.positionChanged = false;
			c = c.next;
		}

		{	// update listener parameters
			AL.listenerf(AL.GAIN, masterVolume);
			AL.listener3f(AL.POSITION, listenerPos.x, listenerPos.y, listenerPos.z);

			alListenerOriBytes.setFloat(0,  listenerDir.x);
			alListenerOriBytes.setFloat(4,  listenerDir.y);
			alListenerOriBytes.setFloat(8,  listenerDir.z);

			alListenerOriBytes.setFloat(12, listenerUp.x);
			alListenerOriBytes.setFloat(16, listenerUp.y);
			alListenerOriBytes.setFloat(20, listenerUp.z);

			AL.listenerfv(AL.ORIENTATION, alListenerOriBytes);
		}

		// update source paramaters
		for (i in 0...alSources.length) {
			var c = sourceToChan[i];
			var source = alSources[i];
			if (c == null) continue;

			if (c.positionChanged) {
				AL.sourcef(source, AL.SEC_OFFSET, c.position);
				c.positionChanged = false;
			}

			AL.sourcei(source, AL.LOOPING, c.loop ? AL.TRUE : AL.FALSE);
			AL.sourcef(source, AL.GAIN, c.volume * c.channelGroup.volume * c.soundGroup.volume);

			for (e in c.effects) @:privateAccess e.apply(c, source);
		}

		// update virtual channels
		var c = usedChannels;
		while (c != null) {
			if (!c.pause && c.isVirtual) {
				c.position += haxe.Timer.stamp() - c.lastStamp;
				if (!c.loop && c.position >= c.duration)
					releaseChannel(c);
			}
			c = c.next;
		}
	}

	// ------------------------------------------------------------------------
	// internals
	// ------------------------------------------------------------------------

	function releaseSource(i : Int) {
		chanToSource.remove(sourceToChan[i]);
		sourceToChan[i] = null;
		alFreeSources.push(i);

		var source = alSources[i];
		AL.sourceStop(source);
		AL.sourcei(source, AL.BUFFER, AL.NONE);
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

	function acquireChannel(sound : hxd.res.Sound, soundGroup : SoundGroup, channelGroup : ChannelGroup) {
		var c : Channel = null;

		if (freeChannels == null) {
			c = new Channel();
		} else {
			c = freeChannels;
			freeChannels = c.nextFree;
			c.nextFree   = null;
		}

		c.init(sound);

		c.soundGroup   = soundGroup;
		c.channelGroup = channelGroup;

		c.next = usedChannels;
		usedChannels = c;

		return c;
	}

	function releaseChannel(c : Channel) {
		if (usedChannels == c) {
			usedChannels = c.next;
		} else {
			var prev = usedChannels;
			while (prev.next != c)
				prev = prev.next;
			prev.next = c.next;
		}

		var bi = soundToBuf.get(c.soundRes);
		alBufRefs[bi] = alBufRefs[bi] - 1;
		if (alBufRefs[bi] == 0) alFreeBufs.unshift(bi);

		c.next       = null;
		c.nextFree   = freeChannels;
		freeChannels = c;

		var isrc = chanToSource.get(c);
		if (isrc != null) releaseSource(isrc);
	}

	function fillBuffer(buf : Buffer, dat : hxd.snd.Data, ?mono = false) {
		var nsamples  = dat.samples;
		var nchannels = mono ? 1 : 2;

		var floatBytes = haxe.io.Bytes.alloc(nsamples * 2 * 4);
		var shortBytes = haxe.io.Bytes.alloc(nsamples * nchannels * 2);

		dat.decode(floatBytes, 0, 0, nsamples);
		if (nchannels == 2) for (i in 0...nsamples) {
			shortBytes.setUInt16(i * 4 + 0, Std.int(floatBytes.getFloat(i * 8 + 0) * 32767));
			shortBytes.setUInt16(i * 4 + 2, Std.int(floatBytes.getFloat(i * 8 + 4) * 32767));
		} else for (i in 0...nsamples) {
			var valL = Std.int(floatBytes.getFloat(i * 8 + 0) * 32767);
			var valR = Std.int(floatBytes.getFloat(i * 8 + 4) * 32767);
			shortBytes.setUInt16(i * 2, (valL + valR) >> 1);
		}

		var format = switch(nchannels) {
			case 1 : AL.FORMAT_MONO16;
			case 2 : AL.FORMAT_STEREO16;
			default : throw "unsupported sound format";
		}
		AL.bufferData(buf, format, shortBytes, shortBytes.length, 44100);
	}
}