package h3d.pass;

class TimeoutShader extends h3d.shader.ScreenShader {
	static var SRC = {
		function fragment() {
			var v = calculatedUV.x + calculatedUV.y;

			while (v > -1.0) {
				v += 0.0001;
				if (v > 999999.0) {
					v = 0.0;
				}
			}

			pixelColor = vec4(v,v,v,0.0);
		}
	}
}

class Timeout extends ScreenFx<TimeoutShader> {
	public function new() {
		super(new TimeoutShader());
	}

	public static function run() {
		var engine = h3d.Engine.getCurrent();
		var inst : Timeout = @:privateAccess engine.resCache.get(Timeout);
		if( inst == null ) {
			inst = new Timeout();
			@:privateAccess engine.resCache.set(Timeout, inst);
		}
		return inst.render();
	}
}