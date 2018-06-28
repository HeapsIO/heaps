package hxd.snd;

enum SampleFormat {
	UI8;
	I16;
	F32;
}

class Data {

	public var samples(default, null) : Int;
	public var samplingRate(default, null) : Int;
	public var sampleFormat(default, null) : SampleFormat;
	public var channels(default, null) : Int;

	public var duration(get, never) : Float;

	public function isLoading() {
		return false;
	}

	public function decode( out : haxe.io.Bytes, outPos : Int, sampleStart : Int, sampleCount : Int ) : Void {
		var bpp = getBytesPerSample();
		if( sampleStart < 0 || sampleCount < 0 || outPos < 0 || outPos + sampleCount * bpp > out.length ) {

			var s = ("sampleStart = " + sampleStart);
			s += (" sampleCount = " + sampleCount);
			s += (" outPos = " + outPos);
			s += (" bpp = " + bpp);
			s += (" out.length = " + out.length);
			throw s;
		}
		if( sampleStart + sampleCount >= samples ) {
			var count = 0;
			if( sampleStart < samples ) {
				count = samples - sampleStart;
				decodeBuffer(out, outPos, sampleStart, count);
			}
			out.fill(outPos + count*bpp, (sampleCount - count) * bpp, 0);
			return;
		}
		decodeBuffer(out, outPos, sampleStart, sampleCount);
	}

	public function resample( rate : Int, format : SampleFormat, channels : Int ) : Data {
		if( sampleFormat == format && samplingRate == rate && this.channels == channels )
			return this;

		var newSamples = Math.ceil(samples * (rate / samplingRate));
		var bpp = getBytesPerSample();
		var data = haxe.io.Bytes.alloc(bpp * samples);
		decodeBuffer(data, 0, 0, samples);

		var out = haxe.io.Bytes.alloc(channels * newSamples * formatBytes(format));
		resampleBuffer(out, 0, data, 0, rate, format, channels, samples);

		var data = new WavData(null);
		data.channels = channels;
		data.samples = newSamples;
		data.sampleFormat = format;
		data.samplingRate = rate;
		@:privateAccess data.rawData = out;
		return data;
	}

	@:noDebug
	public function resampleBuffer( out : haxe.io.Bytes, outPos : Int, input : haxe.io.Bytes, inPos : Int, rate : Int, format : SampleFormat, channels : Int, samples : Int ) {
		var bpp = getBytesPerSample();
		var newSamples = Math.ceil(samples * (rate / samplingRate));
		var resample = samples != newSamples;
		// optimized version for simple stereo to mono convertion (used for spatialization)
		if( !resample && this.sampleFormat == I16 && format == I16 && channels == 1 && this.channels == 2 ) {
			var r = inPos, w = outPos;
			inline function sext16(v:Int) {
				return (v & 0x8000) == 0 ? v : v | 0xFFFF0000;
			}
			for( i in 0...samples ) {
				var sl = input.getUInt16(r); r += 2;
				var sr = input.getUInt16(r); r += 2;
				var s;
				if( (sl ^ sr) >= 0x8000 ) {
					// not same signess
					sl = sext16(sl);
					sr = sext16(sr);
					s = ((sl + sr) >> 1) & 0xFFFF;
				} else
					s = (sl + sr) >> 1;
				out.setUInt16(w, s);
				w += 2;
			}
			return;
		}
		var srcChannels = this.channels;
		var commonChannels = channels < srcChannels ? channels : srcChannels;
		var extraChannels  = channels - commonChannels;
		var sval = 0., ival = 0;
		for( i in 0...newSamples ) {
			var targetSample = (i / (newSamples - 1)) * (samples - 1);
			var isample = Std.int(targetSample);
			var offset = targetSample - isample;
			var srcPos = inPos + isample * bpp;
			if( isample == samples - 1 ) resample = false;
			for( k in 0...commonChannels ) {
				var sval1, sval2 = 0.;

				inline function sext16(v:Int) {
					return (v & 0x8000) == 0 ? v : v | 0xFFFF0000;
				}

				switch( sampleFormat ) {
				case UI8:
					sval1 = input.get(srcPos) / 0xFF;
					if( resample ) sval2 = input.get(srcPos + bpp) / 0xFF;
					srcPos++;
				case I16:
					sval1 = sext16(input.getUInt16(srcPos)) / 0x8000;
					if( resample ) sval2 = sext16(input.getUInt16(srcPos + bpp)) / 0x8000;
					srcPos += 2;
				case F32:
					sval1 = input.getFloat(srcPos);
					if( resample ) sval2 = input.getFloat(srcPos + bpp);
					srcPos += 4;
				}

				sval = resample ? hxd.Math.lerp(sval1, sval2, offset) : sval1;
				switch( format ) {
				case UI8:
					ival = Std.int((sval + 1) * 128);
					if( ival > 255 ) ival = 255;
					out.set(outPos++, ival);
				case I16:
					ival = Std.int(sval * 0x8000);
					if( ival > 0x7FFF ) ival = 0x7FFF;
					ival = ival & 0xFFFF;
					out.setUInt16(outPos, ival);
					outPos += 2;
				case F32:
					out.setFloat(outPos, sval);
					outPos += 4;
				}
			}
			for( i in 0...extraChannels )
				switch( format ) {
				case UI8:
					out.set(outPos++,ival);
				case I16:
					out.setUInt16(outPos, ival);
					outPos += 2;
				case F32:
					out.setFloat(outPos, sval);
					outPos += 4;
				}
		}
	}


	function decodeBuffer( out : haxe.io.Bytes, outPos : Int, sampleStart : Int, sampleCount : Int ) : Void {
		throw "Not implemented";
	}

	public function getBytesPerSample() {
		return channels * formatBytes(sampleFormat);
	}

	public static inline function formatBytes(format:SampleFormat) {
		return switch( format ) {
		case UI8: 1;
		case I16: 2;
		case F32: 4;
		}
	}

	/**
		Some platforms might require some data to be loaded before we can start decoding.
		Use load() and wait for onEnd to make sure that the sound data and the correct number of samples is available.
		onEnd() might be called back immediately if the data is already available.
	**/
	public function load( onEnd : Void -> Void ) {
		onEnd();
	}

	function get_duration() {
		return samples / samplingRate;
	}

}