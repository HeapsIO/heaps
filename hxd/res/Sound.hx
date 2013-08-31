package hxd.res;

class Sound extends Resource {
	
	#if flash
	var snd : flash.media.Sound;
	#end
	
	public function play() {
		#if flash
		if( snd != null ) {
			snd.play();
			return;
		}
		snd = new flash.media.Sound();
		var bytes = entry.getBytes();
		switch( bytes.get(0) ) {
		case 'R'.code: // RIFF (wav)
			// TODO : use snd.loadPCMFromByteArray
			throw "WAV not supported ATM";
		case 255: // MP3
			snd.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);
		default:
			throw "Unsupported sound format " + entry.path;
		}
		hxd.impl.Tmp.saveBytes(bytes);
		snd.play();
		#else
		#end
	}

}