package h3d.shader;

class DirShadow extends hxsl.Shader {

	static var SRC = {

		@const var enable : Bool;

		@param var shadowMap : Channel;
		@param var shadowProj : Mat3x4;
		@param var shadowPower : Float;
		@param var shadowBias : Float;

		var transformedPosition : Vec3;
		var shadow : Float;

		function fragment() {
			if( enable ) {
				var shadowPos = transformedPosition * shadowProj;
				var depth = shadowMap.get(screenToUv(shadowPos.xy));
				var zMax = shadowPos.z.saturate();
				var delta = (depth + shadowBias).min(zMax) - zMax;
				shadow = exp( shadowPower * delta ).saturate();
			}
		}

	}

}