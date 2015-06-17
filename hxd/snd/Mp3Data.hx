package hxd.snd;

class Mp3Data extends Data {

	#if flash
	var snd : flash.media.Sound;
	#elseif js
	var buffer : haxe.io.Bytes;
	var onEnd : Void -> Void;
	#end

	public function new( bytes : haxe.io.Bytes ) {
		var mp = new format.mp3.Reader(new haxe.io.BytesInput(bytes)).read();
		samples = mp.sampleCount;
		// Sadly mp3 is not meant to perfectly loop, let's try to extract the real number of samples that were actually encoded with LAME
		// http://gabriel.mp3-tech.org/mp3infotag.html
		var frame = mp.frames[0].data;
		var lame = -1;
		for( i in 0...frame.length - 24 )
			if( frame.get(i) == "L".code && frame.get(i + 1) == "A".code && frame.get(i + 2) == "M".code && frame.get(i + 3) == "E".code ) {
				lame = i;
				break;
			}
		if( lame >= 0 ) {
			var startEnd = (frame.get(lame + 21) << 16) | (frame.get(lame + 22) << 8) | frame.get(lame + 23);
			var start = startEnd >> 12;
			var end = startEnd & ((1 << 12) - 1);
			samples -= start + end + 1152; // first frame is empty
		}
		#if flash
		snd = new flash.media.Sound();
		bytes.getData().position = 0;
		snd.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);
		#elseif js
		var ctx = @:privateAccess NativeChannel.getContext();
		ctx.decodeAudioData(bytes.getData(), processBuffer);
		#end
	}


	#if js
	override public function load(onEnd:Void->Void) {
		if( buffer != null ) onEnd() else this.onEnd = onEnd;
	}

	function processBuffer( buf : js.html.audio.AudioBuffer ) {
		var left = buf.getChannelData(0);
		var right = buf.numberOfChannels < 2 ? left : buf.getChannelData(1);
		var join = new js.html.Float32Array(left.length * 2);
		var w = 0;
		for( i in 0...buf.length ) {
			join[w++] = left[i];
			join[w++] = right[i];
		}
		samples = buf.length; // actual decoded samples
 		buffer = haxe.io.Bytes.ofData(join.buffer);
		if( onEnd != null ) {
			onEnd();
			onEnd = null;
		}
	}
	#end

	override public function decode(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		#if flash
		var b = out.getData();
		b.position = outPos;
		snd.extract(b, sampleCount, sampleStart + 2257 /* MAGIC_DELAY, silence added at mp3 start */ );
		#elseif js
		if( buffer == null ) {
			// not yet available : fill with blanks
			out.fill(outPos, sampleCount * 8, 0);
		} else {
			out.blit(outPos, buffer, sampleStart * 8, sampleCount * 8);
		}
		#else
		throw "MP3 decoding is not available for this platform";
		#end
	}

}