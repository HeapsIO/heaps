package hxd.snd;

#if hl

private typedef Mp3File = hl.Abstract<"fmt_mp3">;

#end

class Mp3Data extends Data {

	#if flash
	var snd : flash.media.Sound;
	#elseif js
	var buffer : haxe.io.Bytes;
	var onEnd : Void -> Void;
	#elseif hl
	var bytes : haxe.io.Bytes;
	var frameOffsets:Array<Int>;
	// Sample count in one frame. After some searching, I couldn't find any mp3 files that contained frames with different Layers (hence - different samples/frame).
	// Simplifies seeking quite a bit if we assume that we won't find any mp3 files with different sampling per frame.
	var samplesPerFrame:Int;
	var reader : Mp3File;
	var frame : haxe.io.Bytes;
	var currentFrame : Int;
	var currentSample : Int;
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

		var ctx = hxd.snd.webaudio.Context.get();
		if( ctx == null ) return;
		ctx.decodeAudioData(bytes.getData(), processBuffer);

		var decodedRate = Std.int(ctx.sampleRate);
		samples = Math.ceil(samples * decodedRate / samplingRate);
		samplingRate = decodedRate;

		#elseif hl

		this.bytes = bytes;
		// Re-reading MP3 to find offsets to each frame in file for seeking.
		frameOffsets = new Array();
		samplesPerFrame = format.mp3.Tools.getSampleCountHdr(header);
		var byteInput = new haxe.io.BytesInput(bytes);
		var reader = new format.mp3.Reader(byteInput);
		var ft;
		var totalSamples : Int = 0;
		while ( (ft = reader.seekFrame()) == FT_MP3 ) {
			var headerPos = byteInput.position - 2; // 0xfff sync
			var header = reader.readFrameHeader();
			if ( header != null && !format.mp3.Tools.isInvalidFrameHeader(header) ) {
				// TODO: Layer I support. Layer I frames contain only 384 frames.
				var len = format.mp3.Tools.getSampleDataSizeHdr(header);
				if ( byteInput.length - byteInput.position >= len ) {
					frameOffsets.push(headerPos);
					totalSamples += format.mp3.Tools.getSampleCountHdr(header);
					byteInput.position += len;
				}
			}
		}

		this.frame = haxe.io.Bytes.alloc(1152*channels*4); // 2 channels, F32.
		this.currentSample = -1;
		this.currentFrame = -1;
		this.reader = mp3_open(bytes, bytes.length);

		#end
	}


	#if js

	override function isLoading() {
		return buffer == null;
	}

	override public function load(onEnd:Void->Void) {
		if( buffer != null ) onEnd() else this.onEnd = onEnd;
	}

	function processBuffer( buf : js.html.audio.AudioBuffer ) {
		var left = buf.getChannelData(0);
		samples = buf.length; // actual decoded samples

		if( channels == 1 ) {
			buffer = haxe.io.Bytes.ofData(left.buffer);
			return;
		}

		var right = buf.numberOfChannels < 2 ? left : buf.getChannelData(1);
		var join = new hxd.impl.TypedArray.Float32Array(left.length * 2);
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
		#elseif hl
		if ( currentSample != sampleStart ) {
			var targetFrame = Math.floor(sampleStart / samplesPerFrame);
			if ( targetFrame != currentFrame ) {
				seekFrame(Math.floor(sampleStart / samplesPerFrame));
			}
			this.currentSample = sampleStart;
		}
		var frameStart = currentFrame * samplesPerFrame;
		var writeSamples:Int, offset:Int;
		// Fill out remaining of the frame.
		if ( currentSample != frameStart ) {
			writeSamples = samplesPerFrame - (currentSample - frameStart);
			offset = (currentSample - frameStart) * 4 * channels;
			out.blit(outPos, frame, offset, frame.length - offset);
			outPos += frame.length - offset;

			sampleCount -= writeSamples;
			currentSample += writeSamples;
			seekFrame(currentFrame + 1);
		}
		writeSamples = samplesPerFrame;
		offset = samplesPerFrame * 4 * channels;
		// Fill out frames that fit inside buffer
		while ( sampleCount > writeSamples ) {
			out.blit(outPos, frame, 0, frame.length);
			outPos += offset;

			sampleCount -= writeSamples;
			currentSample += writeSamples;
			seekFrame(currentFrame + 1);
		}
		// Fill beginning of the frame to the remainder of the buffer.
		if ( sampleCount > 0 ) {
			writeSamples = sampleCount;
			out.blit(outPos, frame, 0, sampleCount * 4 * channels);
			currentSample += sampleCount;
		}
		#else
		throw "MP3 decoding is not available for this platform";
		#end
	}

	#if hl

	inline function seekFrame( to : Int ) {
		currentFrame = to;
		mp3_decode_frame(reader, bytes, bytes.length, frameOffsets[to], frame, frame.length, 0);
	}

	@:hlNative("fmt", "mp3_open") static function mp3_open( bytes : hl.Bytes, size : Int ) : Mp3File {
		return null;
	}

	@:hlNative("fmt", "mp3_decode_frame") static function mp3_decode_frame( o : Mp3File, bytes : hl.Bytes, size : Int, position : Int, output : hl.Bytes, outputSize : Int, offset : Int ) : Int {
		return 0;
	}

	#end

}
