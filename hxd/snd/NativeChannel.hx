package hxd.snd;

#if hxsdl
private class ChannelMapper extends sdl.SoundChannel {
	var native : NativeChannel;
	public function new(samples, native) {
		super(samples);
		this.native = native;
	}
	override function onSample( buf : cpp.Pointer<cpp.Float32>, len : Int ) {
		var data : haxe.io.BytesData = [];
		cpp.NativeArray.setUnmanagedData(data, buf.reinterpret(), len<<2);
		@:privateAccess native.onSample(haxe.io.Float32Array.fromBytes(haxe.io.Bytes.ofData(data)));
	}
}
#end

class NativeChannel {

	#if flash
	var snd : flash.media.Sound;
	var channel : flash.media.SoundChannel;
	#elseif js
	static var ctx : js.html.audio.AudioContext;
	static function getContext() {
		if( ctx == null ) {
			try {
				ctx = new js.html.audio.AudioContext();
			} catch( e : Dynamic ) {
				throw "Web Audio API not available for this browser";
			}
		}
		return ctx;
	}
	var sproc : js.html.audio.ScriptProcessorNode;
	var tmpBuffer : haxe.io.Float32Array;
	#elseif hxsdl
	var channel : ChannelMapper;
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
		sproc = ctx.createScriptProcessor(bufferSamples, 2, 2);
		tmpBuffer = new haxe.io.Float32Array(bufferSamples * 2);
		sproc.connect(ctx.destination);
		sproc.onaudioprocess = onJsSample;
		#elseif hxsdl
		channel = new ChannelMapper(bufferSamples, this);
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
	function onJsSample( event : js.html.audio.AudioProcessingEvent ) {
		onSample(tmpBuffer);
		// split the channels and copy to output
		var r = 0;
		var left = event.outputBuffer.getChannelData(0);
		var right = event.outputBuffer.getChannelData(1);
		for( i in 0...bufferSamples ) {
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
		if( sproc != null ) {
			sproc.disconnect();
			sproc = null;
		}
		#elseif hxsdl
		if( channel != null ) {
			channel.stop();
			channel = null;
		}
		#end
	}

}