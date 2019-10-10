package hxd.snd.webaudio;
#if (js && !useal)
import js.html.audio.*;

class BufferHandle {
	public var inst : AudioBuffer;
	public var isEnd : Bool;
	public var samples : Int;
	public function new() { }
}

@:allow(hxd.snd.webaudio.Driver)
class SourceHandle {
	public var sampleOffset   : Int;
	public var playing        : Bool;

	public var driver : Driver;
	public var lowPass : BiquadFilterNode;
	public var gain : GainNode;
	public var destination : AudioNode;
	public var buffers : Array<BufferPlayback>;
	public var pitch : Float;
	public var firstPlay : Bool;

	public function new() {
		buffers = [];
		sampleOffset = 0;
		pitch = 1;
		firstPlay = true;
	}

	public function updateDestination() {
		if (lowPass != null) {
			destination = lowPass;
			lowPass.connect(gain);
		} else {
			destination = gain;
		}
		gain.connect(driver.destination);
		for (b in buffers) {
			if ( b.node != null ) {
				b.node.connect(destination);
			}
		}
	}

	public function applyPitch() {
		// BUG: Because pitch is k-rate parameter, it applies it once per 128 sample block, which throws timings off and creates audio skips.
		// Noticeable mainly with low pitch values, so it's not particularly usable to reduce pitch gradually.
		var t = 0.;
		for ( b in buffers ) {
			t = b.readjust(t, this);
		}
	}
}

class BufferPlayback {

	public var buffer : BufferHandle;
	public var node : AudioBufferSourceNode;
	public var offset : Float;
	public var dirty : Bool; // Playback was started - node no longer usable.
	public var consumed : Bool; // Node was played completely (ended event fired)
	public var starts : Float;
	public var ends : Float;

	public var currentSample(get, never):Int;
	
	static inline var FADE_SAMPLES = 10; // Click prevent at the start.

	public function new()
	{

	}

	function get_currentSample ( ):Int {
		if ( consumed ) return buffer.samples;
		if ( node == null || !dirty ) return 0;
		return Math.floor((node.context.currentTime - starts) / ((buffer.inst.duration - offset) / node.playbackRate.value) * buffer.samples);
	}

	public function set(buf : BufferHandle, grainOffset : Float) {
		buffer = buf;
		offset = Math.isNaN(grainOffset) ? 0 : grainOffset;
		dirty = false;
		consumed = false;
		starts = 0;
		ends = 0;
	}

	public function start( ctx : AudioContext, source : SourceHandle, time : Float) {
		dirty = true;
		consumed = false;
		if (node != null) {
			stop();
		}
		if ( source.firstPlay && buffer.samples > FADE_SAMPLES ) {
			source.firstPlay = false;
			var channels = [for (i in 0...buffer.inst.numberOfChannels) buffer.inst.getChannelData(i)];
			var j = 0, fade = 0.;
			while ( j < FADE_SAMPLES ) {
				var i = 0;
				while ( i < channels.length ) {
					channels[i][j] *= fade;
					i++;
				}
				j++;
				fade += 1 / FADE_SAMPLES;
				if (fade > 1) fade = 1;
			}
		}
		node = ctx.createBufferSource();
		node.buffer = buffer.inst;
		node.addEventListener("ended", onBufferConsumed);
		node.connect(source.destination);
		node.playbackRate.value = source.pitch;
		node.start(time, offset);
		starts = time;
		return ends = time + (buffer.inst.duration - offset) / source.pitch;
	}

	public function readjust( time : Float, source : SourceHandle ) {
		if (consumed || node == null) return ends;
		node.playbackRate.value = source.pitch;
		if (dirty) {
			var elapsed = node.context.currentTime - starts;
			return ends = starts + elapsed + (buffer.inst.duration - offset - elapsed) / source.pitch;
		}
		starts = time == 0 ? node.context.currentTime : time;
		if (source.playing)
			node.start(starts, offset);
		return ends = starts + (buffer.inst.duration - offset) / source.pitch;
	}

	public function stop( immediate : Bool = true ) {
		if ( node != null ) {
			node.removeEventListener("ended", onBufferConsumed);
			if (immediate) node.disconnect();
			else node.stop();
			node = null;
		}
	}

	function onBufferConsumed ( e : js.html.Event ) {
		node.removeEventListener("ended", onBufferConsumed);
		node.disconnect();
		node = null;
		consumed = true;
	}

	public function clear()
	{
		buffer = null;
		node = null;
	}

}

#end