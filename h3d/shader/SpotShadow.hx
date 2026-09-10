package h3d.shader;

class SpotShadow extends hxsl.Shader {

	static var SRC = {
		@:import h3d.shader.ShadowSampling;

		@const var enable : Bool;
		@const(2) var SAMPLING_MODE : Int;

		// ESM
		@param var shadowPower : Float;
		// PCF
		@param var pcfScale : Float;

		@param var shadowMap : Sampler2D;
		@param var shadowViewProj : Mat4;
		@param var shadowBias : Float;

		var transformedPosition : Vec3;
		var shadow : Float;

		function fragment() {
			if( enable ) {
				var shadowPos = spotShadowPos(transformedPosition, shadowViewProj);
				shadow = sampleShadow(shadowMap, shadowPos.xy, shadowPos.z.saturate(), shadowBias, pcfScale, shadowPower, transformedPosition, SAMPLING_MODE);
			}
		}
	}
}

