package hxd.snd;

@:access(hxd.snd.SoundChannel)
class SoundData {

	#if flash
	var snd : flash.media.Sound;
	var onStreamData : Void -> haxe.ds.Vector<Float>;
	#end

	public function new() {
		#if flash
		snd = new flash.media.Sound();
		#end
	}

	public function loadMP3( data : haxe.io.Bytes ) {
		#if flash
		snd.loadCompressedDataFromByteArray(data.getData(), data.length);
		#else
		throw "Not implemented";
		#end
	}

	public function extract( bytesOutput : haxe.io.Bytes, position : Int, startSample : Int, sampleCount : Int ) {
		#if flash
		var b = bytesOutput.getData();
		b.position = position;
		snd.extract(b, sampleCount, startSample + 2257);
		#else
		throw "Not implemented";
		#end
	}

	public function playNative( startTime : Float = 0., loop = false ) : SoundChannel {
		var c = new SoundChannel(this, loop);
		#if flash
		c.channel = snd.play(startTime * 1000, loop ? 0x7FFFFFFF : 1);
		c.init();
		#else
		throw "Not implemented";
		#end
		return c;
	}

	#if flash
	function onFlashSample( e : flash.events.SampleDataEvent ) {
		var buf = onStreamData();
		var bytes = e.data;
		bytes.position = 0;
		for( i in 0...buf.length )
			bytes.writeFloat(buf[i]);
	}
	#end

	public function playStream( onData : Void -> haxe.ds.Vector<Float> ) : SoundChannel {
		#if flash
		if( onStreamData == null )
			snd.addEventListener(flash.events.SampleDataEvent.SAMPLE_DATA, onFlashSample);
		onStreamData = onData;
		var c = new SoundChannel(this, true);
		c.channel = snd.play(0, 0x7FFFFFFF);
		return c;
		#else
		throw "Not implemented";
		return null;
		#end
	}

}