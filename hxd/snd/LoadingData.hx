package hxd.snd;

class LoadingData extends Data {

	var snd : hxd.res.Sound;
	var waitCount = 0;

	public function new(snd) {
		this.snd = snd;
	}

	override function decode(out:haxe.io.Bytes, outPos:Int, sampleStart:Int, sampleCount:Int):Void {
		var d = snd.getData();
		if( hxd.impl.Api.isOfType(d, LoadingData) )
			throw "Sound data is not yet available, use load() first";
		d.decode(out, outPos, sampleStart, sampleCount);
	}

	override public function load(onEnd:Void->Void) {
		if( waitCount > 10 )
			throw "Failed to load data";
		var d = snd.getData();
		if( hxd.impl.Api.isOfType(d, LoadingData) ) {
			waitCount++;
			haxe.Timer.delay(load.bind(onEnd), 100);
			return;
		}
		d.load(onEnd);
	}

}