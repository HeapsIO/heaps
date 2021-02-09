package hxd.snd.webaudio;
#if (js && !useal)

import hxd.snd.webaudio.AudioTypes;
import hxd.snd.Driver.DriverFeature;
import js.html.audio.*;

class Driver implements hxd.snd.Driver {

	public var ctx : AudioContext;
	public var masterGain(get, never) : GainNode;
	public var destination(get, set) : AudioNode;

	var playbackPool : Array<BufferPlayback>;

	public function new()
	{
		playbackPool = [];

		ctx = Context.get();
	}

	/**
		Returns free AudioBuffer instance corresponding to sample count, amount of channels and sample-rate.
	**/
	public inline function getBuffer(channels : Int, sampleCount : Int, rate : Int) : AudioBuffer {
		return Context.getBuffer(channels, sampleCount, rate);
	}

	/**
		Puts AudioBuufer back to it's pool.
	**/
	public inline function putBuffer( buf : AudioBuffer ) {
		Context.putBuffer(buf);
	}

	/**
		Returns free Gain node
	**/
	public inline function getGain():GainNode
	{
		return Context.getGain();
	}

	public inline function putGain(gain:GainNode) {
		Context.putGain(gain);
	}

	public function hasFeature (d : DriverFeature) : Bool {
		switch (d) {
			case MasterVolume: return true;
		}
	}

	public function setMasterVolume (value : Float) : Void {
		masterGain.gain.value = value;
	}

	public function setListenerParams (position : h3d.Vector, direction : h3d.Vector, up : h3d.Vector, ?velocity : h3d.Vector) : Void {
		ctx.listener.setPosition(-position.x, position.y, position.z);
		ctx.listener.setOrientation(-direction.x, direction.y, direction.z, -up.x, up.y, up.z);
		// TODO: Velocity
	}

	public function createSource () : SourceHandle {
		var s = new SourceHandle();
		s.driver = this;
		s.gain = getGain();
		s.updateDestination();
		return s;
	}

	public function playSource (source : SourceHandle) : Void {
		if ( !source.playing ) {
			source.playing = true;
			if ( source.buffers.length != 0 ) {
				var time = ctx.currentTime;
				for ( b in source.buffers ) {
					if ( b.consumed ) continue;
					time = b.start(ctx, source, time);
				}
			}
		}
	}

	public function stopSource (source : SourceHandle) : Void {
		source.playing = false;
		source.sampleOffset = 0;
	}

	public function setSourceVolume (source : SourceHandle, value : Float) : Void {
		source.gain.gain.value = value;
	}

	public function destroySource (source : SourceHandle) : Void {
		stopSource(source);
		source.gain.disconnect();
		source.driver = null;
		putGain(source.gain);
		source.gain = null;
		for ( b in source.buffers ) {
			b.stop();
			b.clear();
			playbackPool.push(b);
		}
		source.buffers = [];
	}

	public function createBuffer () : BufferHandle {
		var b = new BufferHandle();
		b.samples = 0;
		return b;
	}

	public function setBufferData (buffer : BufferHandle, data : haxe.io.Bytes, size : Int, format : Data.SampleFormat, channelCount : Int, samplingRate : Int) : Void {
		var sampleCount = Std.int(size / hxd.snd.Data.formatBytes(format) / channelCount);
		buffer.samples = sampleCount;
		if (sampleCount == 0) return;

		if ( buffer.inst == null ) {
			buffer.inst = getBuffer(channelCount, sampleCount, samplingRate);
		} else if ( buffer.inst.sampleRate != samplingRate || buffer.inst.numberOfChannels != channelCount || buffer.inst.length != sampleCount ) {
			putBuffer(buffer.inst);
			buffer.inst = getBuffer(channelCount, sampleCount, samplingRate);
		}
		switch (format)
		{
			case UI8:
				var ui8 = new hxd.impl.TypedArray.Uint8Array(data.getData());
				if (channelCount == 1) {
					var chn = buffer.inst.getChannelData(0);
					for ( i in 0...sampleCount ) {
						chn[i] = ui8[i] / 0xff;
					}
				} else {
					var left = buffer.inst.getChannelData(0);
					var right = buffer.inst.getChannelData(1);
					// TODO: 3+ channels
					var r = 0;
					for ( i in 0...sampleCount ) {
						left[i] = ui8[r] / 0xff;
						right[i] = ui8[r+1] / 0xff;
						r += channelCount;
					}
				}
			case I16:
				var i16 = new hxd.impl.TypedArray.Int16Array(data.getData());
				if (channelCount == 1) {
					var chn = buffer.inst.getChannelData(0);
					for ( i in 0...sampleCount ) {
						chn[i] = i16[i] / 0x8000;
					}
				} else {
					var left = buffer.inst.getChannelData(0);
					var right = buffer.inst.getChannelData(1);
					// TODO: 3+ channels
					var r = 0;
					for ( i in 0...sampleCount ) {
						left[i] = i16[r] / 0x8000;
						right[i] = i16[r+1] / 0x8000;
						r += channelCount;
					}
				}
			case F32:
				var f32 = new hxd.impl.TypedArray.Float32Array(data.getData());
				if (channelCount == 1) {
					var chn = buffer.inst.getChannelData(0);
					for ( i in 0...sampleCount ) {
						chn[i] = f32[i];
					}
				} else {
					var left = buffer.inst.getChannelData(0);
					var right = buffer.inst.getChannelData(1);
					// TODO: 3+ channels
					var r = 0;
					for ( i in 0...sampleCount ) {
						left[i] = f32[r];
						right[i] = f32[r+1];
						r += channelCount;
					}
				}
		}
	}
	public function destroyBuffer (buffer : BufferHandle) : Void {
		if ( buffer.inst != null ) putBuffer(buffer.inst);
		buffer.inst = null;
	}

	public function queueBuffer (source : SourceHandle, buffer : BufferHandle, sampleStart : Int, endOfStream : Bool) : Void {
		var buf = playbackPool.length != 0 ? playbackPool.pop() : new BufferPlayback();
		if (buffer.inst == null) return;
		buf.set(buffer, (sampleStart / buffer.inst.length) * buffer.inst.duration);
		buffer.isEnd = endOfStream;
		source.buffers.push(buf);
		if ( source.playing ) {
			if ( source.buffers.length != 1 ) {
				var t = source.buffers[source.buffers.length - 2].ends;
				buf.start(ctx, source, (js.Syntax.code("isFinite({0})", t):Bool) ? hxd.Math.max(t, ctx.currentTime) : ctx.currentTime);
			} else {
				buf.start(ctx, source, ctx.currentTime);
			}
		}
	}
	public function unqueueBuffer (source : SourceHandle, buffer : BufferHandle) : Void {
		var i = 0;
		while ( i < source.buffers.length ) {
			var b = source.buffers[i];
			if ( b.buffer == buffer ) {
				source.buffers.splice(i, 1);
				b.stop(!buffer.isEnd);
				b.clear();
				playbackPool.push(b);
				break;
			}
		}
		if (buffer.isEnd || !source.playing) source.sampleOffset = 0;
		else source.sampleOffset += buffer.samples;
	}
	public function getProcessedBuffers (source : SourceHandle) : Int {
		var cnt = 0;
		for (b in source.buffers) if ( b.consumed ) cnt++;
		return cnt;
	}
	public function getPlayedSampleCount (source : SourceHandle) : Int {
		var consumed:Int = 0;
		var buf : BufferPlayback = null;
		for (b in source.buffers) {
			if (b.consumed) {
				consumed += b.buffer.samples;
			} else if ( b.dirty ) {
				buf = b;
				break;
			}
		}
		if ( buf != null ) {
			return source.sampleOffset + consumed + buf.currentSample;
		}

		return source.sampleOffset + consumed;
	}

	public function update () : Void { }
	public function dispose () : Void {
		// TODO
	}

	public function getEffectDriver(type : String) : hxd.snd.Driver.EffectDriver<Dynamic> {
		return switch(type) {
			case "pitch"          : new PitchDriver();
			case "spatialization" : new SpatializationDriver();
			case "lowpass"        : new LowPassDriver();
			// case "reverb"         : new ReverbDriver(this);
			default               : new hxd.snd.Driver.EffectDriver<Dynamic>();
		}
	}

	inline function get_masterGain() return Context.masterGain;
	inline function set_destination(node : AudioNode) return Context.destination = node;
	inline function get_destination() return Context.destination;

}

#end