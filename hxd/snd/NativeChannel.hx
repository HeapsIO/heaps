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
	static var ctx : js.html.audio.AudioContext;
	static var destination : js.html.audio.AudioNode;
	static var masterGain : js.html.audio.GainNode;
	static function getContext() : js.html.audio.AudioContext {
		if( ctx == null ) {
			try {
				ctx = new js.html.audio.AudioContext();
			} catch( e : Dynamic ) try {
				#if (haxe_ver >= 4)
				ctx = js.Syntax.code('new window.webkitAudioContext()');
				#else
				ctx = untyped __js__('new window.webkitAudioContext()');
				#end
			} catch( e : Dynamic ) {
				ctx = null;
			}
			if( ctx != null ) {
				if( ctx.state == SUSPENDED ) waitForPageInput();
				ctx.addEventListener("statechange", function(_) if( ctx.state == SUSPENDED ) waitForPageInput());
				masterGain = ctx.createGain();
				masterGain.connect(ctx.destination);

				destination = masterGain;
			}
		}
		return ctx;
	}
	// Avoid excessive buffer allocation when playing many sounds.
	// bufferSamples is constant and never change at runtime, so it's safe to use general pool.
	static var pool : Array<js.html.audio.AudioBuffer> = new Array();
	static var bufferPool : Array<haxe.io.Float32Array> = new Array();
	static var gainPool : Array<js.html.audio.GainNode> = new Array();
	
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
		var ctx = getContext();
		if( ctx == null ) return;
		
		if ( pool.length > 0 ) front = pool.pop();
		else front = ctx.createBuffer(2, bufferSamples, ctx.sampleRate);
		if ( pool.length > 0 ) back = pool.pop();
		else back = ctx.createBuffer(2, bufferSamples, ctx.sampleRate);
		
		if ( bufferPool.length > 0 ) tmpBuffer = bufferPool.pop();
		else tmpBuffer = new haxe.io.Float32Array(bufferSamples * 2);
		
		if ( gainPool.length != 0 ) gain = gainPool.pop();
		else gain = ctx.createGain();
		gain.connect(destination);

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

	static var waitDiv = null;
	static function waitForPageInput() {
		if( waitDiv != null ) waitDiv.remove();
		// insert invisible div on top of the page to capture events
		// see https://developers.google.com/web/updates/2017/09/autoplay-policy-changes#webaudio
		var div = js.Browser.document.createDivElement();
		div.setAttribute("style","width:100%;height:100%;background:transparent;z-index:9999;position:fixed;left:0;top:0");
		div.onclick = stopInput;
		div.onkeydown = stopInput;
		js.Browser.document.body.addEventListener("keydown",stopInput);
		js.Browser.document.body.addEventListener("touchend",stopInput);
		js.Browser.document.body.appendChild(div);
		waitDiv = div;
	}

	static function stopInput(_) {
		if( waitDiv == null ) return;
		waitDiv.remove();
		waitDiv = null;
		js.Browser.document.body.removeEventListener("keydown",stopInput);
		js.Browser.document.body.removeEventListener("touchend",stopInput);
		if( ctx != null ) ctx.resume();
	}
	
	function swap( event : js.html.Event ) {
		var tmp = front;
		front = back;
		back = tmp;
		fill(tmp);
		
		current.removeEventListener("ended", swap);
		// current.disconnect(); // Should not be required as it's a one-shot object by design.
		current = queued;
		var ctx = getContext();
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
			current.disconnect();
			current.removeEventListener("ended", swap);
			current.stop();
			current = null;
			
			queued.removeEventListener("ended", swap);
			queued.disconnect();
			queued.stop();
			queued = null;

			gainPool.push(gain);
			gain.disconnect();
			gain = null;

			pool.push(front);
			front = null;
			pool.push(back);
			back = null;
			
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
