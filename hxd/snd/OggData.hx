package hxd.snd;

#if hl

private typedef OggFile = hl.Abstract<"fmt_ogg">;

class OggData extends Data {

	var bytes : haxe.io.Bytes;
	var reader : OggFile;
	var currentSample : Int;

	public function new( bytes : haxe.io.Bytes ) {
		this.bytes = bytes;
		reader = ogg_open(bytes, bytes.length);
		if( reader == null ) throw "Failed to decode OGG data";

		var b = 0, f = 0, s = 0, c = 0;
		ogg_info(reader, b, f, s, c);
		channels = c;
		samples = s;
		sampleFormat = I16;
		samplingRate = f;
	}

	override function resample(rate:Int, format:Data.SampleFormat, channels:Int):Data  {
		switch( format ) {
		case UI8, I16 if( channels == this.channels && rate == this.samplingRate ):
			var g = new OggData(bytes);
			g.sampleFormat = format;
			return g;
		default:
			return super.resample(rate, format, channels);
		}
	}

	override function decodeBuffer(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		if( currentSample != sampleStart ) {
			currentSample = sampleStart;
			if( !ogg_seek(reader, sampleStart) ) throw "Invalid sample start";
		}
		var bpp = getBytesPerSample();
		var output : hl.Bytes = out;
		output = output.offset(outPos);
		var format = switch( sampleFormat ) {
		case UI8: 1 | 256;
		case I16: 2;
		default:
			throw "assert";
		}
		var bytesNeeded = sampleCount * bpp;
		while( bytesNeeded > 0 ) {
			var read = ogg_read(reader, output, bytesNeeded, format);
			if( read < 0 ) throw "Failed to decode OGG data";
			if( read == 0 ) {
				// EOF
				output.fill(0,bytesNeeded, sampleFormat == UI8 ? 0x80 : 0);
				break;
			}
			bytesNeeded -= read;
			output = output.offset(read);
		}
		currentSample += sampleCount;
	}

	@:hlNative("fmt", "ogg_open") static function ogg_open( bytes : hl.Bytes, size : Int ) : OggFile {
		return null;
	}

	@:hlNative("fmt", "ogg_seek") static function ogg_seek( o : OggFile, sample : Int ) : Bool {
		return false;
	}

	@:hlNative("fmt", "ogg_info") static function ogg_info( o : OggFile, bitrate : hl.Ref<Int>, freq : hl.Ref<Int>, samples : hl.Ref<Int>, channels : hl.Ref<Int> ) : Void {
	}

	@:hlNative("fmt", "ogg_read") static function ogg_read( o : OggFile, output : hl.Bytes, size : Int, format : Int ) : Int {
		return 0;
	}

}

#elseif js

class OggData extends Data {
	
	var buffer : haxe.io.Bytes;
	var onEnd : Void -> Void;
	
	#if stb_ogg_sound
	var stbFallback:OggDataSTB;
	var bytesFallback:haxe.io.Bytes;
	#end
	
	public function new(bytes:haxe.io.Bytes) {
		
		if (bytes == null) return;
		
		// header check: OGG container, Vorbis audio, version 0 of spec
		if (bytes.getString(0, 4) != "OggS" || bytes.getString(29, 6) != "vorbis" || bytes.getInt32(35) != 0) {
			throw "Invalid OGG header";
		}
		
		sampleFormat = F32;
		channels = bytes.get(39);
		samplingRate = bytes.getInt32(40);
		
		#if stb_ogg_sound
		stbFallback = null;
		bytesFallback = bytes;
		#end
		
		var ctx = hxd.snd.webaudio.Context.get();
		if( ctx == null ) return;
		ctx.decodeAudioData(bytes.getData(), processBuffer, onError);
		
		// is this valid or causes issues onerror?
		var decodedRate = Std.int(ctx.sampleRate);
		samples = Math.ceil(samples * decodedRate / samplingRate);
		samplingRate = decodedRate;
	}
	
	override function isLoading() {
		#if stb_ogg_sound
		if (stbFallback != null) return stbFallback.isLoading();
		#end
		return buffer == null;
	}

	override public function load(onEnd:Void->Void) {
		#if stb_ogg_sound
		if (stbFallback != null) {
			stbFallback.load(onEnd);
			return;
		}
		#end
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
	
	function onError(_:js.html.DOMException) {
		// if OGG cannot be read by browser (e.g. Safari), use STB library instead
		#if stb_ogg_sound
		stbFallback = new OggDataSTB(bytesFallback);
		bytesFallback = null;
		samples = stbFallback.samples;
		samplingRate = stbFallback.samplingRate;
		sampleFormat = stbFallback.sampleFormat;
		channels = stbFallback.channels;
		#else
		throw "Ogg support requires -lib stb_ogg_sound";
		#end
	}
	
	#if stb_ogg_sound
	override function resample(rate:Int, format:Data.SampleFormat, channels:Int):Data {
		if (stbFallback != null) return stbFallback.resample(rate, format, channels);
		else return super.resample(rate, format, channels);
	}
	#end
	
	override function decodeBuffer(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		
		#if stb_ogg_sound
		if (stbFallback != null) {
			stbFallback.decodeBuffer(out, outPos, sampleStart, sampleCount);
			return;
		}
		#end
		
		if( buffer == null ) {
			// not yet available : fill with blanks
			out.fill(outPos, sampleCount * 4 * channels, 0);
		} else {
			out.blit(outPos, buffer, sampleStart * 4 * channels, sampleCount * 4 * channels);
		}
	}
}

#elseif stb_ogg_sound

// standalone STB-based support for OGG
typedef OggData = OggDataSTB;

#else

class OggData extends Data {

	public function new( bytes : haxe.io.Bytes ) {
	}

	override function decodeBuffer(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		throw "Ogg support requires -lib stb_ogg_sound";
	}

}

#end

#if stb_ogg_sound

private class BytesOutput extends haxe.io.Output {

	var bytes : haxe.io.Bytes;
	var position : Int;

	public function new() {
	}

	public function done() {
	}

	public function init( bytes : haxe.io.Bytes, position : Int ) {
		this.bytes = bytes;
		this.position = position;
	}

	override function writeFloat(f) {
		bytes.setFloat(position, f);
		position += 4;
	}

	override function writeInt16(i) {
		bytes.setUInt16(position, i);
		position += 2;
	}

}

class OggDataSTB extends Data {

	var reader : stb.format.vorbis.Reader;
	var output : BytesOutput;
	var decodedFirst : Int;
	var decodedLast : Int;
	var decoded : haxe.io.Bytes;
	static inline var CACHED_SAMPLES = 44100 * 3; // 3s of cached sound

	public function new( bytes : haxe.io.Bytes ) {
		if( bytes != null ) {
			reader = stb.format.vorbis.Reader.openFromBytes(bytes);
			samples = reader.totalSample;
			channels = reader.header.channel;
			samplingRate = reader.header.sampleRate;
			sampleFormat = F32;
		}
		output = new BytesOutput();
		decodedFirst = 0;
		decodedLast = 0;
	}

	override function resample(rate, format, channels):Data {
		if( sampleFormat == format && samplingRate == rate && this.channels == channels )
			return this;
		switch( format ) {
		case I16, F32 if( rate % this.samplingRate == 0 && channels >= this.channels ):
			var c = new OggDataSTB(null);
			c.reader = reader;
			c.samples = samples;
			c.samplingRate = samplingRate;
			c.sampleFormat = format;
			c.channels = channels;
			return c;
		default:
			return super.resample(rate, format, channels);
		}
	}

	override function decodeBuffer(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		var last = sampleStart + sampleCount;
		var bpp = getBytesPerSample();
		if( sampleStart < decodedFirst || last > decodedLast ) {
			var need = sampleCount - sampleStart;
			if( need > CACHED_SAMPLES || samples > CACHED_SAMPLES ) {
				// directly decode in out
				output.init(out, outPos);
				reader.currentSample = sampleStart;
				reader.read(output, sampleCount, channels, samplingRate, sampleFormat == F32);
				output.done();
				return;
			}
			if( decoded == null )
				decoded = haxe.io.Bytes.alloc((samples < CACHED_SAMPLES ? samples : CACHED_SAMPLES) * bpp);
			need = CACHED_SAMPLES;
			if( sampleStart + need > samples ) need = samples - sampleStart;
			output.init(decoded,0);
			reader.currentSample = sampleStart;
			reader.read(output, need, channels, samplingRate, sampleFormat == F32);
			output.done();
			decodedFirst = sampleStart;
			decodedLast = sampleStart + need;
			if( sampleStart == 0 && need == samples ) {
				reader = null;
				output = null;
			}
		}
		out.blit(outPos, decoded, (sampleStart - decodedFirst) * bpp, sampleCount * bpp);
	}

}

#end
