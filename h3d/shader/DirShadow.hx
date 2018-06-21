package h3d.shader;

class DirShadow extends hxsl.Shader {

	static var SRC = {

		@param var shadowMap : Channel;
		@param var shadowProj : Mat3x4;
		@param var shadowPower : Float;
		@param var shadowBias : Float;

		var transformedPosition : Vec3;
		var shadow : Float;

		function fragment() {
			var shadowPos = transformedPosition * shadowProj * vec3(0.5, -0.5, 1) + vec3(0.5, 0.5, 0);
			var depth = shadowMap.get(shadowPos.xy);
			var zMax = shadowPos.z.saturate();
			var delta = (depth + shadowBias).min(zMax) - zMax;
			shadow = exp( shadowPower * delta ).saturate();
		}

	}

}