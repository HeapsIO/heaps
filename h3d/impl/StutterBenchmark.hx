package h3d.impl;

class Stutter {
	public var impact : Float;
	public var frameCount : Int;
	public var startTime : Float;

	public function new(v:Float) {
		impact = v;
		frameCount = 1;
		startTime = haxe.Timer.stamp();
	}
}

enum StutterSeverity {
	Minor;
	Major;
	Severe;
	All;
}

class StutterBenchmark {

	static var MAX_FRAME_COUNT : Int = 60;
	static var STUTTER_FLAT_THRESHOLD : Float = 10.0;
	static var STUTTER_MULT_THRESHOLD : Float = 1.5;

	static var STUTTER_MAJOR_DURATION : Float = 20.0;
	static var STUTTER_SEVERE_DURATION : Float = 50.0;

	var stutters : Array<Stutter> = [];
	var frames : FrameData;

	var median : Float = 0;
	var frameWithoutStutter : Int = 0;

	public function new() {
		frames = new FrameData(MAX_FRAME_COUNT);
	}

    public function update( dt : Float ) {
		var dtInMs = dt * 1000;
		if(isStutter(dtInMs)){
			if(frameWithoutStutter > 1){
				stutters.push(new Stutter(dtInMs - median));
			} else if(stutters.length > 0) {
				var cur = stutters[stutters.length - 1];
				cur.frameCount++;
				cur.impact += dtInMs - median;
			}
			frameWithoutStutter = 0;
			frames.push(dtInMs);
		} else {
			frameWithoutStutter++;
			frames.push(dtInMs);
		}

		var t = haxe.Timer.stamp();
		var length = stutters.length;
		for( i in 0...length) {
			var j = length - 1 - i;
			if(t - stutters[j].startTime > 60) {
				stutters.remove(stutters[j]);
			}
		}
	}

	function isStutter(dtInMs : Float) : Bool {
		if( frames.length == 0 )
			return false;
		median = frames.getMedian();
		return dtInMs > median + STUTTER_FLAT_THRESHOLD || dtInMs > median * STUTTER_MULT_THRESHOLD;
	}

	public function getStutterCount(severity: StutterSeverity) : Int {
		if(severity == All)
			return stutters.length;
		var count = 0;
		for(s in stutters) {
			switch(severity) {
				case Minor:
					if(s.impact < STUTTER_MAJOR_DURATION)
						count++;
				case Major:
					if(s.impact >= STUTTER_MAJOR_DURATION && s.impact < STUTTER_SEVERE_DURATION)
						count++;
				case Severe:
					if(s.impact >= STUTTER_SEVERE_DURATION)
						count++;
				case All:
			}
		}
		return count;
	}

	public function getWorstStutterDuration() : Float {
		var worst = 0.0;
		for(s in stutters) {
			if(s.impact > worst)
				worst = s.impact;
		}
		return worst;
	}
}