package hxd.snd;

private class BytesOutput extends haxe.io.Output {

	var bytes : haxe.io.Bytes;
	var position : Int;
	#if flash
	var m : hxd.impl.Memory.MemoryReader;
	#end

	public function new() {
	}

	public function done() {
		#if flash
		m.end();
		#end
	}

	public function init( bytes : haxe.io.Bytes, position : Int ) {
		this.bytes = bytes;
		this.position = position;
		#if flash
		m = hxd.impl.Memory.select(bytes);
		#end
	}

	override function writeFloat(f) {
		#if flash
		m.wfloat(position, f);
		#else
		bytes.setFloat(position, f);
		#end
		position += 4;
	}

	override function writeInt16(i) {
		#if flash
		m.wb(position++, i >> 8);
		m.wb(position++, i);
		#else
		bytes.setUInt16(position, i);
		position += 2;
		#end
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