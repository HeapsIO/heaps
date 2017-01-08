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

		var header = mp.frames[0].header;
		sampleFormat = F32;
		samplingRate = format.mp3.Constants.MPEG.srEnum2Num(header.samplingRate);
		channels = header.channelMode == Mono ? 1 : 2;

		#if flash

		// flash only allows to decode mp3 in stereo 44.1Khz
		channels = 2;
		if( samplingRate != 44100 ) {
			samples = Math.ceil(samples * 44100.0 / samplingRate);
			samplingRate = 44100;
		}

		snd = new flash.media.Sound();
		bytes.getData().position = 0;
		snd.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);
		#elseif js
		ctx.decodeAudioData(bytes.getData(), processBuffer);
		#end
	}


	#if js
	override public function load(onEnd:Void->Void) {
		if( buffer != null ) onEnd() else this.onEnd = onEnd;
	}

	function processBuffer( buf : js.html.audio.AudioBuffer ) {
		var left = buf.getChannelData(0);
		samples = buf.length; // actual decoded samples

		if( channels == 1 ) {
			buffer = haxe.io.Bytes.ofData(left);
			return;
		}

		var right = buf.numberOfChannels < 2 ? left : buf.getChannelData(1);
		var join = new js.html.Float32Array(left.length * 2);
		var w = 0;
		for( i in 0...buf.length ) {
			join[w++] = left[i];
			join[w++] = right[i];
		}

 		buffer = haxe.io.Bytes.ofData(join.buffer);
		if( onEnd != null ) {
			onEnd();
			onEnd = null;
		}
	}
	#end

	override function decodeBuffer(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		#if flash
		var b = out.getData();
		b.position = outPos;
		while( sampleCount > 0 ) {
			var r = Std.int(snd.extract(b, sampleCount, sampleStart + 2257 /* MAGIC_DELAY, silence added at mp3 start */ ));
			if( r == 0 ) {
				while( sampleCount > 0 ) {
					b.writeFloat(0);
					b.writeFloat(0);
					sampleCount--;
				}
				return;
			}
			sampleCount -= r;
			sampleStart += r;
		}
		#elseif js
		if( buffer == null ) {
			// not yet available : fill with blanks
			out.fill(outPos, sampleCount * 4 * channels, 0);
		} else {
			out.blit(outPos, buffer, sampleStart * 4 * channels, sampleCount * 4 * channels);
		}
		#else
		throw "MP3 decoding is not available for this platform";
		#end
	}

}
