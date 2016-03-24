package hxd;

class Timer {

	public static var wantedFPS = 60.;
	public static var maxDeltaTime = 0.5;
	public static var oldTime = haxe.Timer.stamp();
	public static var tmod_factor = 0.95;
	public static var calc_tmod : Float = 1;
	public static var tmod : Float = 1;
	public static var deltaT : Float = 1;

	public static var smoothing : Bool = true;

	static var frameCount = 0;

	public inline static function update() {
		frameCount++;
		var newTime = haxe.Timer.stamp();
		deltaT = newTime - oldTime;
		oldTime = newTime;
		if( deltaT < maxDeltaTime )
		{
			if(smoothing)
			{
				calc_tmod = calc_tmod * tmod_factor + (1 - tmod_factor) * deltaT * wantedFPS;
			}
			else
			{
				calc_tmod = deltaT;
			}
		}
		else
		{
			calc_tmod = maxDeltaTime;
		}
		tmod = calc_tmod;
	}

	public inline static function fps() : Float {
		return wantedFPS/calc_tmod;
	}

	public static function skip() {
		oldTime = haxe.Timer.stamp();
	}

}
