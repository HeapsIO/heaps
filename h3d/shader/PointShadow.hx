package h3d.shader;

class PointShadow extends hxsl.Shader {

	static var SRC = {

		@const var enable : Bool;

		@param var shadowMap : SamplerCube;
		@param var lightPos : Vec3;
		@param var shadowPower : Float;
		@param var shadowBias : Float;
		@param var zFar : Float;

		var transformedPosition : Vec3;
		var shadow : Float;

		function fragment() {
			if( enable ) {
				var posToLight = transformedPosition.xyz - lightPos;
				var dir = normalize(vec3(posToLight.x, posToLight.y, posToLight.z));
				var depth = shadowMap.get(dir).r * zFar;
				var zMax = length(posToLight);
				var delta = (depth + shadowBias).min(zMax) - zMax;
				shadow = exp( shadowPower * delta ).saturate();
			}
		}
	}
}