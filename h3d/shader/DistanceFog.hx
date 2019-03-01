package h3d.shader;

class DistanceFog extends ScreenShader {

	static var SRC = {

		@param var startDistance : Float;
		@param var endDistance : Float;
		@param var startOpacity : Float;
		@param var endOpacity: Float;
		@param var startColorDistance : Float;
		@param var endColorDistance : Float;
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
			if( startDistance > distance ) discard;
			var opacityFactor = (distance - startDistance) / (endDistance - startDistance);
			var colorFactor = (distance - startColorDistance) / (endColorDistance - startColorDistance);
			var fogColor = mix(startColor, endColor, colorFactor);
			var fogOpacity = mix(startOpacity, endOpacity, opacityFactor);
			if( fogOpacity <= 0 ) discard;
			pixelColor = vec4(fogColor, fogOpacity);
		}
	};

	public function new() {
		super();
	}

}