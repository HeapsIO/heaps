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

#elseif stb_ogg_sound

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

class OggData extends Data {

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
			var c = new OggData(null);
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

#else

class OggData extends Data {

	public function new( bytes : haxe.io.Bytes ) {
	}

	override function decodeBuffer(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		throw "Ogg support requires -lib stb_ogg_sound";
	}

}

#end