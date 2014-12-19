package h3d.shader;

class Shadow extends hxsl.Shader {

	static var SRC = {
		@global var shadow : {
			map : Sampler2D,
			proj : Mat3x4,
			color : Vec3,
			power : Float,
			bias : Float,
		};
		var pixelColor : Vec4;
		var transformedPosition : Vec3;
		var pixelTransformedPosition : Vec3;
		@private var shadowPos : Vec3;
		@const var perPixel : Bool;

		function vertex() {
			if( !perPixel ) shadowPos = transformedPosition * shadow.proj * vec3(0.5, -0.5, 1) + vec3(0.5, 0.5, 0);
		}

		function fragment() {

			var shadowPos = if( perPixel ) pixelTransformedPosition * shadow.proj * vec3(0.5, -0.5, 1) + vec3(0.5, 0.5, 0) else shadowPos;

			var depth = unpack(shadow.map.get(shadowPos.xy));

			#if false
			// TODO : integrate surface-based bias
			cosTheta = N.L
			float bias = 0.005*tan(acos(cosTheta));
			bias = clamp(bias, 0, 0.01)
			#end

			var zMax = shadowPos.z.saturate();
			var delta = (depth + shadow.bias).min(zMax) - zMax;
			var shade = exp( shadow.power * delta  ).saturate();
			pixelColor.rgb *= (1 - shade) * shadow.color.rgb + shade;
		}
	};

	public function new() {
		super();
	}

}