package h3d.shader.pbr;

class GammaCorrect extends hxsl.Shader {
	static var SRC = {
		var pixelColor : Vec4;

		@const var useEmissiveHDR : Bool;
		var emissive : Float;

		function fragment() {
			pixelColor.rgb *= pixelColor.rgb;
			// use emissive value to increase light intensity
			if( useEmissiveHDR ) pixelColor.rgb *= 1 + emissive;
		}
	}
}