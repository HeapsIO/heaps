package hxd.snd;

#if hlopenal

import openal.AL;
import hxd.snd.Manager;
import hxd.snd.Driver;

@:access(hxd.snd.Manager)
private class ALChannel {

	static var nativeUpdate : haxe.MainLoop.MainEvent;
	static var nativeChannels : Array<ALChannel>;

	static function updateChannels() {
		var i = 0;
		// Should ensure ordering if it was removed during update?
		for ( chn in nativeChannels ) chn.onUpdate();
	}

	var manager : Manager;
	var update : haxe.MainLoop.MainEvent;
	var native : NativeChannel;
	var samples : Int;

	var driver : Driver;
	var buffers : Array<BufferHandle>;
	var bufPos : Int;
	var src : SourceHandle;

	var fbuf : haxe.io.Bytes;
	var ibuf : haxe.io.Bytes;

	public function new(samples, native) {
		if ( nativeUpdate == null ) {
			nativeUpdate = haxe.MainLoop.add(updateChannels);
			#if (haxe_ver >= 4) nativeUpdate.isBlocking = false; #end
			nativeChannels = [];
		}
		this.native = native;
		this.samples = samples;

		this.manager = Manager.get();
		this.driver = manager.driver;

		buffers = [driver.createBuffer(), driver.createBuffer()];
		src = driver.createSource();
		bufPos = 0;

		// AL.sourcef(src,AL.PITCH,1.0);
		// AL.sourcef(src,AL.GAIN,1.0);
		fbuf = haxe.io.Bytes.alloc( samples<<3 );
		ibuf = haxe.io.Bytes.alloc( samples<<2 );

		for ( b in buffers )
			onSample(b);
		forcePlay();
		nativeChannels.push(this);
	}

	public function stop() {
		if ( src != null ) {
			nativeChannels.remove(this);
			driver.stopSource(src);
			driver.destroySource(src);
			for (buf in buffers)
				driver.destroyBuffer(buf);
			src = null;
			buffers = null;
		}
	}

	@:noDebug function onSample( buf : BufferHandle ) {
		@:privateAccess native.onSample(haxe.io.Float32Array.fromBytes(fbuf));

		// Convert Float32 to Int16
		for ( i in 0...samples << 1 ) {
			var v = Std.int(fbuf.getFloat(i << 2) * 0x7FFF);
			ibuf.set( i<<1, v );
			ibuf.set( (i<<1) + 1, v>>>8 );
		}
		driver.setBufferData(buf, ibuf, ibuf.length, I16, 2, Manager.STREAM_BUFFER_SAMPLE_COUNT);
		driver.queueBuffer(src, buf, 0, false);
	}

	inline function forcePlay() {
		if (!src.playing) driver.playSource(src);
	}

	function onUpdate(){
		var cnt = driver.getProcessedBuffers(src);
		while (cnt > 0)
		{
			cnt--;
			var buf = buffers[bufPos];
			driver.unqueueBuffer(src, buf);
			onSample(buf);
			forcePlay();
			if (++bufPos == buffers.length) bufPos = 0;
		}
	}
}

#end
class NativeChannel {

	#if flash
	var snd : flash.media.Sound;
	var channel : flash.media.SoundChannel;
	#elseif js
	// Avoid excessive buffer allocation when playing many sounds.
	// bufferSamples is constant and never change at runtime, so it's safe to use general pool.
	static var bufferPool : Array<haxe.io.Float32Array> = new Array();

	var front : js.html.audio.AudioBuffer;
	var back : js.html.audio.AudioBuffer;
	var current : js.html.audio.AudioBufferSourceNode;
	var queued : js.html.audio.AudioBufferSourceNode;
	var time : Float; // Mandatory for proper buffer sync, otherwise produces gaps in playback due to innacurate timings.
	var tmpBuffer : haxe.io.Float32Array;
	var gain : js.html.audio.GainNode;
	#elseif hlopenal
	var channel : ALChannel;
	#end
	public var bufferSamples(default, null) : Int;

	public function new( bufferSamples : Int ) {
		this.bufferSamples = bufferSamples;
		#if flash
		snd = new flash.media.Sound();
		snd.addEventListener(flash.events.SampleDataEvent.SAMPLE_DATA, onFlashSample);
		channel = snd.play(0, 0x7FFFFFFF);
		#elseif js
		var ctx = hxd.snd.webaudio.Context.get();

		var rate = Std.int(ctx.sampleRate);
		front = hxd.snd.webaudio.Context.getBuffer(2, bufferSamples, rate);
		back = hxd.snd.webaudio.Context.getBuffer(2, bufferSamples, rate);

		if ( bufferPool.length > 0 ) tmpBuffer = bufferPool.pop();
		else tmpBuffer = new haxe.io.Float32Array(bufferSamples * 2);

		gain = hxd.snd.webaudio.Context.getGain();
		gain.connect(hxd.snd.webaudio.Context.destination);

		fill(front);
		fill(back);

		current = ctx.createBufferSource();
		current.buffer = front;
		current.addEventListener("ended", swap);
		current.connect(gain);
		queued = ctx.createBufferSource();
		queued.buffer = back;
		queued.addEventListener("ended", swap);
		queued.connect(gain);

		var currTime : Float = ctx.currentTime;
		current.start(currTime);
		time = currTime + front.duration;
		queued.start(time);

		#elseif hlopenal
		channel = new ALChannel(bufferSamples, this);
		#end
	}

	#if flash
	function onFlashSample( event : flash.events.SampleDataEvent ) {
		var buf = event.data;
		buf.length = bufferSamples * 2 * 4;
		buf.position = 0;
		onSample(haxe.io.Float32Array.fromBytes(haxe.io.Bytes.ofData(buf)));
		buf.position = bufferSamples * 2 * 4;
	}
	#end

	#if js

	function swap( event : js.html.Event ) {
		var tmp = front;
		front = back;
		back = tmp;
		fill(tmp);

		current.removeEventListener("ended", swap);
		// current.disconnect(); // Should not be required as it's a one-shot object by design.
		current = queued;
		var ctx = hxd.snd.webaudio.Context.get();
		queued = ctx.createBufferSource();
		queued.buffer = tmp;
		queued.addEventListener("ended", swap);
		queued.connect(gain);

		time += front.duration;
		queued.start(time);
	}

	inline function fill( buffer : js.html.audio.AudioBuffer ) {
		onSample(tmpBuffer);
		// split the channels and copy to output
		var r = 0;
		var left = buffer.getChannelData(0);
		var right = buffer.getChannelData(1);
		for ( i in 0...bufferSamples )
		{
			left[i] = tmpBuffer[r++];
			right[i] = tmpBuffer[r++];
		}
	}

	#end

	function onSample( out : haxe.io.Float32Array ) {
	}

	public function stop() {
		#if flash
		if( channel != null ) {
			channel.stop();
			channel = null;
		}
		#elseif js
		if ( front != null ) {
			current.removeEventListener("ended", swap);
			current.stop();
			current.disconnect();
			current = null;

			queued.removeEventListener("ended", swap);
			queued.disconnect();
			queued.stop();
			queued = null;

			gain.disconnect();
			hxd.snd.webaudio.Context.putGain(gain);
			gain = null;

			hxd.snd.webaudio.Context.putBuffer(front);
			hxd.snd.webaudio.Context.putBuffer(back);

			bufferPool.push(tmpBuffer);
			tmpBuffer = null;
		}
		#elseif hlopenal
		if( channel != null ) {
			channel.stop();
			channel = null;
		}
		#end
	}

}
