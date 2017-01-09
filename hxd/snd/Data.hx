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

	public function decode( out : haxe.io.Bytes, outPos : Int, sampleStart : Int, sampleCount : Int ) : Void {
		var bpp = getBytesPerSample();
		if( sampleStart < 0 || sampleCount < 0 || outPos < 0 || outPos + sampleCount * bpp > out.length )
			throw haxe.io.Error.OutsideBounds;
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

	@:noDebug
	public function resample( rate : Int, format : SampleFormat, channels : Int ) : Data {
		if( sampleFormat == format && samplingRate == rate && this.channels == channels )
			return this;

		var newSamples = Math.ceil(samples * (rate / samplingRate));
		var bpp = getBytesPerSample();
		var data = haxe.io.Bytes.alloc(bpp * samples);
		var resample = samples != newSamples;
		decodeBuffer(data, 0, 0, samples);

		var out = new haxe.io.BytesBuffer();
		var srcChannels = this.channels;
		var commonChannels = channels < srcChannels ? channels : srcChannels;
		var extraChannels = (channels > srcChannels ? channels : srcChannels) - commonChannels;
		var sval = 0., ival = 0;
		for( i in 0...newSamples ) {
			var targetSample = (i / (newSamples - 1)) * (samples - 1);
			var isample = Std.int(targetSample);
			var offset = targetSample - isample;
			var srcPos = isample * bpp;
			if( isample == samples - 1 ) resample = false;
			for( k in 0...commonChannels ) {
				var sval1, sval2 = 0.;

				inline function sext16(v:Int) {
					return (v & 0x8000) == 0 ? v : v | 0xFFFF0000;
				}

				switch( sampleFormat ) {
				case UI8:
					sval1 = data.get(srcPos) / 0xFF;
					if( resample ) sval2 = data.get(srcPos + bpp) / 0xFF;
					srcPos++;
				case I16:
					sval1 = sext16(data.getUInt16(srcPos)) / 0x8000;
					if( resample ) sval2 = sext16(data.getUInt16(srcPos + bpp)) / 0x8000;
					srcPos += 2;
				case F32:
					sval1 = data.getFloat(srcPos);
					if( resample ) sval2 = data.getFloat(srcPos + bpp);
					srcPos += 4;
				}

				sval = resample ? hxd.Math.lerp(sval1, sval2, offset) : sval1;
				switch( format ) {
				case UI8:
					ival = Std.int((sval + 1) * 128);
					if( ival > 255 ) ival = 255;
					out.addByte(ival);
				case I16:
					ival = Std.int(sval * 0x8000);
					if( ival > 0x7FFF ) ival = 0x7FFF;
					out.addByte(ival & 0xFF);
					out.addByte((ival>>>8) & 0xFF);
				case F32:
					out.addFloat(sval);
				}
			}
			for( i in 0...extraChannels )
				switch( format ) {
				case UI8:
					out.addByte(ival);
				case I16:
					out.addByte(ival & 0xFF);
					out.addByte((ival>>>8) & 0xFF);
				case F32:
					out.addFloat(sval);
				}
		}

		var data = new WavData(null);
		data.channels = channels;
		data.samples = newSamples;
		data.sampleFormat = format;
		data.samplingRate = rate;
		@:privateAccess data.rawData = out.getBytes();
		return data;
	}

	function decodeBuffer( out : haxe.io.Bytes, outPos : Int, sampleStart : Int, sampleCount : Int ) : Void {
		throw "Not implemented";
	}

	public function getBytesPerSample() {
		return channels * switch( sampleFormat ) {
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