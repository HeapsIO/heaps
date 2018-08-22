package h3d.shader;

class SpotShadow extends hxsl.Shader {

	static var SRC = {

		@const var enable : Bool;

		@param var shadowMap : Channel;
		@param var shadowProj : Mat4;
		@param var shadowPower : Float;
		@param var shadowBias : Float;

		var transformedPosition : Vec3;
		var shadow : Float;

		function fragment() {
			if( enable ) {
				var shadowPos = vec4(transformedPosition, 1.0) * shadowProj;
				var shadowScreenPos = shadowPos.xyz / shadowPos.w;
				var depth = shadowMap.get(screenToUv(shadowScreenPos.xy));
				var zMax = shadowScreenPos.z.saturate();
				var delta = (depth + shadowBias).min(zMax) - zMax;
				shadow = exp( shadowPower * delta ).saturate();
			}
		}
	}
}