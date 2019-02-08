package h3d.shader;

class DistanceFog extends ScreenShader {

	static var SRC = {

		@param var startDistance : Float;
		@param var endDistance : Float;
		@param var density : Float;
		@param var startColor : Vec3;
		@param var endColor : Vec3;

		@ignore @param var depthTexture : Channel;
		@ignore @param var cameraPos : Vec3;
		@ignore @param var cameraInverseViewProj : Mat4;

		function getPosition( uv: Vec2 ) : Vec3 {
			var depth = depthTexture.get(uv);
			var uv2 = uvToScreen(calculatedUV);
			var isSky = 1 - ceil(depth);
			depth = mix(depth, 1, isSky);
			var temp = vec4(uv2, depth, 1) * cameraInverseViewProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}

		function fragment() {
			var calculatedUV = input.uv;
			var origin = getPosition(calculatedUV);
			var distance = (origin - cameraPos).length();

			var fog = clamp((distance - startDistance) / (endDistance - startDistance), 0, 1);
			var fogColor = mix(startColor, endColor, fog);
			var fogDensity = mix(0, density, fog);

			pixelColor = vec4(fogColor,fogDensity);
		}
	};

	public function new() {
		super();
	}

}