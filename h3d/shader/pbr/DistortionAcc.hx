package h3d.shader.pbr;

/* Need a RG16F or RG32F Target*/

class Distortion extends hxsl.Shader {

	static var SRC = {

		@input var input : {
			var uv : Vec2;
		};

		@param var distortionDir : Sampler2D;
		@param var intensity : Float;

		var calculatedUV : Vec2;
		var pixelColor : Vec4;

		function vertex() {
			calculatedUV = input.uv;
		}

		function fragment() {
			var dir = normalize(((distortionDir.get(calculatedUV).xyz - 0.5) * 2.0)).xy * intensity;
			pixelColor = vec4(dir, 0, 1);
		}
	};
}
