package hxd.snd;

#if hl

private typedef OpusFile = hl.Abstract<"fmt_opus">;

class OpusData extends Data {

	var bytes : haxe.io.Bytes;
	var reader : OpusFile;
	var currentSample : Int;

	public function new( bytes : haxe.io.Bytes ) {
		this.bytes = bytes;
		reader = opus_open(bytes, bytes.length);
		if( reader == null ) throw "Failed to decode Opus data";

		var b = 0, f = 0, s = 0, c = 0;
		opus_info(reader, b, f, s, c);
		channels = c;
		samples = s;
		sampleFormat = I16;
		samplingRate = f; // Always 48000 for Opus
	}

	override function resample(rate:Int, format:Data.SampleFormat, channels:Int):Data {
		switch( format ) {
		case I16 if( channels == this.channels && rate == this.samplingRate ):
			var g = new OpusData(bytes);
			return g;
		case F32 if( channels == this.channels && rate == this.samplingRate ):
			var g = new OpusData(bytes);
			g.sampleFormat = F32;
			return g;
		default:
			return super.resample(rate, format, channels);
		}
	}

	override function decodeBuffer(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		if( currentSample != sampleStart ) {
			currentSample = sampleStart;
			if( !opus_seek(reader, sampleStart) ) throw "Invalid sample start";
		}
		var bpp = getBytesPerSample();
		var output : hl.Bytes = out;
		output = output.offset(outPos);
		var format = switch( sampleFormat ) {
		case I16: 2;
		case F32: 3;
		default:
			throw "assert";
		}
		var bytesNeeded = sampleCount * bpp;
		while( bytesNeeded > 0 ) {
			var read = opus_read(reader, output, bytesNeeded, format);
			if( read < 0 ) throw "Failed to decode Opus data";
			if( read == 0 ) {
				// EOF
				output.fill(0, bytesNeeded, 0);
				break;
			}
			bytesNeeded -= read;
			output = output.offset(read);
		}
		currentSample += sampleCount;
	}

	@:hlNative("fmt", "opus_open") static function opus_open( bytes : hl.Bytes, size : Int ) : OpusFile {
		return null;
	}

	@:hlNative("fmt", "opus_seek") static function opus_seek( o : OpusFile, sample : Int ) : Bool {
		return false;
	}

	@:hlNative("fmt", "opus_info") static function opus_info( o : OpusFile, bitrate : hl.Ref<Int>, freq : hl.Ref<Int>, samples : hl.Ref<Int>, channels : hl.Ref<Int> ) : Void {
	}

	@:hlNative("fmt", "opus_read") static function opus_read( o : OpusFile, output : hl.Bytes, size : Int, format : Int ) : Int {
		return 0;
	}

}

#else

class OpusData extends Data {

	public function new( bytes : haxe.io.Bytes ) {
	}

	override function decodeBuffer(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		throw "Opus support requires HashLink";
	}

}

#end
