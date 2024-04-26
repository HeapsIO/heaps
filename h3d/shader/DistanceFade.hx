package h3d.shader;

class DistanceFade extends hxsl.Shader {

	static var SRC = {
		@param @const var nearFadeEnabled : Bool;
		@param var nearMinFade : Float;
		@param var nearMaxFade : Float;

		@param @const var farFadeEnabled : Bool;
		@param var farMinFade : Float;
		@param var farMaxFade : Float;

		@:import h3d.shader.BaseMesh;

		function fragment() {
			var distFromCam = length(transformedPosition - camera.position);

			var alphaNear = 1.0;
			var alphaFar =  1.0;

			if (farFadeEnabled)
				alphaFar = 1.0 - saturate((distFromCam - farMinFade) / (farMaxFade - farMinFade));

			if (nearFadeEnabled)
				alphaNear = saturate((distFromCam - nearMinFade) / (nearMaxFade - nearMinFade));

			pixelColor.a *= min(alphaFar, alphaNear);
		}
	};
}