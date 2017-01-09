package hxd.snd;
import format.wav.Data;

class WavData extends hxd.snd.Data {

	var rawData : haxe.io.Bytes;

	public function new(bytes) {
		if( bytes != null )
			init(new format.wav.Reader(new haxe.io.BytesInput(bytes)).read());
	}

	function init(d:format.wav.Data.WAVE) {
		var h = d.header;
		samplingRate = h.samplingRate;
		channels = h.channels;
		sampleFormat = switch( h.bitsPerSample ) {
		case 8: UI8;
		case 16: I16;
		default:
			throw "Unsupported WAV " + h.bitsPerSample + " bits";
		}
		rawData = d.data;
		samples = Std.int(rawData.length / getBytesPerSample());
	}

	override function decodeBuffer(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int) {
		var bpp = getBytesPerSample();
		out.blit(outPos, rawData, sampleStart * bpp, sampleCount * bpp);
	}

}