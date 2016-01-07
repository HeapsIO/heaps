package hxd.res;

class Sound extends Resource {

	var data : hxd.snd.Data;
	var channel : hxd.snd.Channel;
	public var lastPlay(default, null) = 0.;

	public function getData() : hxd.snd.Data {
		if( data != null )
			return data;
		var bytes = entry.getBytes();

		#if flash
		if( bytes.length == 0 )
			return new hxd.snd.LoadingData(this);
		#end

		switch( bytes.get(0) ) {
		case 'R'.code: // RIFF (wav)
			data = new hxd.snd.WavData(bytes);
		case 255, 'I'.code: // MP3 (or ID3)
			data = new hxd.snd.Mp3Data(bytes);
		case 'O'.code: // Ogg (vorbis)
			#if stb_ogg_sound
			data = new hxd.snd.OggData(bytes);
			#else
			throw "OGG format requires -lib stb_ogg_sound (for " + entry.path+")";
			#end
		default:
		}
		if( data == null )
			throw "Unsupported sound format " + entry.path;
		return data;
	}

	public function dispose() {
		stop();
		data = null;
	}

	public function stop() {
		if( channel != null ) {
			channel.stop();
			channel = null;
		}
	}

	public function play( ?loop = false, volume = 1. ) {
		lastPlay = haxe.Timer.stamp();
		return channel = getWorker().play(this, loop, volume);
	}

	static var defaultWorker : hxd.snd.Worker = null;

	public static function getWorker() {
		if( defaultWorker == null ) {
			// don't use a native worker since we haven't setup it in our main()
			var old = hxd.Worker.ENABLE;
			hxd.Worker.ENABLE = false;
			defaultWorker = new hxd.snd.Worker();
			defaultWorker.start();
			hxd.Worker.ENABLE = old;
		}
		return defaultWorker;
	}

	public static function startWorker() {
		if( defaultWorker != null )
			return true;
		defaultWorker = new hxd.snd.Worker();
		return defaultWorker.start();
	}

}