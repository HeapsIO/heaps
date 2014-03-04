package h3d.shader;

class AlphaKill extends hxsl.Shader {

	static var SRC = {
		
		@param var alphaThreshold : Float;
		var pixelColor : Vec4;
		
		function fragment() {
			if( pixelColor.a < alphaThreshold ) discard;
		}
	}
	
	public function new(threshold = 0.1) {
		super();
		this.alphaThreshold = threshold;
	}
	
}