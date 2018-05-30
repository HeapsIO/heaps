package h3d.shader.pbr;

class Shadow extends hxsl.Shader {

	static var SRC = {

		@global var shadow : {
			map : Channel,
			proj : Mat3x4,
			color : Vec3, // unused ?
			power : Float,
			bias : Float,
		};
		@param var shadowMap : Sampler2D;
		var transformedPosition : Vec3;
		var occlusion : Float;

		function fragment() {
			var shadowPos = transformedPosition * shadow.proj * vec3(0.5, -0.5, 1) + vec3(0.5, 0.5, 0);
			var depth = shadow.map.get(shadowPos.xy);
			var zMax = shadowPos.z.saturate();
			var delta = (depth + shadow.bias).min(zMax) - zMax;
			var shade = exp( shadow.power * delta ).saturate();
			occlusion *= shade;
		}

	}

}