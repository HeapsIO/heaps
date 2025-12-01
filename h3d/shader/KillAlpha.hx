package h3d.shader;

class KillAlpha extends hxsl.Shader {

	static var SRC = {

		@param var threshold : Float;
		var pixelColor : Vec4;

		function fragment() {
			// Put the result of the check in a var. This way the DCE can correctly say that only the alpha channel of pixelColor is needed.
			var doDiscard = pixelColor.a < threshold;
			if( doDiscard ) discard;
		}
	}

	public function new(threshold = 0.) {
		super();
		this.threshold = threshold;
	}

}