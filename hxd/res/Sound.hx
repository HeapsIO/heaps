package hxd.res;

class Sound extends Resource {

	var data : hxd.snd.Data;
	public var lastPlay(default, null) = 0.;

	public function getData() : hxd.snd.Data {
		if( data != null )
			return data;
		var bytes = entry.getBytes();
		switch( bytes.get(0) ) {
		case 'R'.code: // RIFF (wav)
			data = new hxd.snd.WavData(bytes);
		case 255, 'I'.code: // MP3 (or ID3)
			data = new hxd.snd.Mp3Data(bytes);
		default:
		}
		if( data == null )
			throw "Unsupported sound format " + entry.path;
		return data;
	}

	public function dispose() {
		data = null;
	}

	public function play( loop = false ) {
		if( defaultWorker == null ) {
			// don't use a native worker since we haven't setup it in our main()
			var old = hxd.Worker.ENABLE;
			hxd.Worker.ENABLE = false;
			defaultWorker = new hxd.snd.Worker();
			defaultWorker.start();
			hxd.Worker.ENABLE = old;
		}
		lastPlay = haxe.Timer.stamp();
		return defaultWorker.play(this, loop);
	}

	static var defaultWorker : hxd.snd.Worker = null;

	public static function startWorker() {
		if( defaultWorker != null )
			return true;
		defaultWorker = new hxd.snd.Worker();
		return defaultWorker.start();
	}

}