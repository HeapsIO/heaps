package hxd.res;

class Sound extends Resource {
	
	public var volume(default, set) = 1.0;
	public var loop : Bool;
	
	#if flash
	var snd : flash.media.Sound;
	var channel : flash.media.SoundChannel;
	#end
	
	public function getPosition() : Float {
		#if flash
		return channel.position;
		#else
		return 0.;
		#end
	}
	
	public function play() {
		playAt(0);
	}
	
	public function playAt( startPosition : Float ) {
		#if flash
		if( snd != null ) {
			channel = snd.play(startPosition);
			volume = volume;
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
		channel = snd.play();
		volume = volume;
		#else
		#end
	}
	
	public function stop() {
		#if flash
		if( channel != null ) {
			channel.stop();
			channel = null;
		}
		#end
	}
	
	function set_volume( v : Float ) {
		volume = v;
		#if flash
		if( channel != null )
			channel.soundTransform = new flash.media.SoundTransform(v);
		#end
		return v;
	}

}