package h3d.shader;

class KillAlpha extends hxsl.Shader {

	static var SRC = {

		@param var threshold : Float;
		var pixelColor : Vec4;

		function fragment() {
			if( pixelColor.a < threshold ) discard;
		}
	}

	public function new(threshold = 0.) {
		super();
		this.threshold = threshold;
	}

}