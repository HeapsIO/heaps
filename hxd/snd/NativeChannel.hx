package hxd.snd;

#if hxsdl
private class ChannelMapper extends sdl.SoundChannel {
	var native : NativeChannel;
	public function new(samples, native) {
		super(samples);
		this.native = native;
	}
	#if cpp
	override function onSample( buf : cpp.Pointer<cpp.Float32>, len : Int ) {
		var data : haxe.io.BytesData = [];
		cpp.NativeArray.setUnmanagedData(data, buf.reinterpret(), len<<2);
		@:privateAccess native.onSample(haxe.io.Float32Array.fromBytes(haxe.io.Bytes.ofData(data)));
	}
	#end
}
#elseif lime_openal
import lime.media.openal.AL;
import lime.media.openal.ALBuffer;
import lime.media.openal.ALSource;

private class ALChannel {
	var native : NativeChannel;
	var samples : Int;

	var buffers : Array<ALBuffer>;
	var src : ALSource;

	var fbuf : haxe.io.Bytes;
	var ibuf : haxe.io.Bytes;
	var iview : lime.utils.ArrayBufferView;

	public function new(samples, native){
		this.native = native;
		this.samples = samples;
		buffers = AL.genBuffers(2);
		src = AL.genSource();
		AL.sourcef(src,AL.PITCH,1.0);
		AL.sourcef(src,AL.GAIN,1.0);
		fbuf = haxe.io.Bytes.alloc( samples<<3 );
		ibuf = haxe.io.Bytes.alloc( samples<<2 );
		iview = new lime.utils.Int16Array(ibuf);

		for ( b in buffers )
			onSample(b);
		forcePlay();
		lime.app.Application.current.onUpdate.add( onUpdate );
	}

	public function stop() {
		if ( src != null ){
			lime.app.Application.current.onUpdate.remove( onUpdate );
			
			AL.sourceStop(src);
			AL.deleteSource(src);
			AL.deleteBuffers(buffers);
			src = null;
			buffers = null;
		}
	}

	@:noDebug function onSample( buf : ALBuffer ) {
		@:privateAccess native.onSample(haxe.io.Float32Array.fromBytes(fbuf));

		// Convert Float32 to Int16
		#if cpp
		var fb = fbuf.getData();
		var ib = ibuf.getData();
		for( i in 0...samples<<1 )
			untyped __global__.__hxcpp_memory_set_i16( ib, i<<1, __global__.__int__(__global__.__hxcpp_memory_get_float( fb, i<<2 ) * 0x7FFF) );
		#else
		for ( i in 0...samples << 1 ) {
			var v = Std.int(fbuf.getFloat(i << 2) * 0x7FFF);
			ibuf.set( i<<1, v );
			ibuf.set( (i<<1) + 1, v>>>8 );
		}
		#end

		AL.bufferData(buf, AL.FORMAT_STEREO16, iview, ibuf.length, 44100);
		AL.sourceQueueBuffers(src, 1, [buf]);
	}

	inline function forcePlay() {
		if( AL.getSourcei(src,AL.SOURCE_STATE) != AL.PLAYING )
			AL.sourcePlay(src);
	}

	function onUpdate( i : Int ){
		var r = AL.getSourcei(src,AL.BUFFERS_PROCESSED);
		if( r > 0 ){
			for( b in AL.sourceUnqueueBuffers(src,r) )
				onSample(b);
			forcePlay();
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
	#elseif lime_openal
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
		sproc = ctx.createScriptProcessor(bufferSamples, 2, 2);
		tmpBuffer = new haxe.io.Float32Array(bufferSamples * 2);
		sproc.connect(ctx.destination);
		sproc.onaudioprocess = onJsSample;
		#elseif hxsdl
		channel = new ChannelMapper(bufferSamples, this);
		#elseif lime_openal
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
		#elseif lime_openal
		if( channel != null ) {
			channel.stop();
			channel = null;
		}
		#end
	}

}
