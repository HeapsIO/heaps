package h3d.shader;

class HZB extends h3d.shader.ScreenShader {
	static var SRC = {
		@global var camera : {
			@const var reverseDepth : Bool;
		}

		@param var source : Sampler2D;
		@param var invWidth : Float;
		@param var invHeight : Float;

		function compareDepth( depth1 : Float, depth2 : Float ) : Float {
			return camera.reverseDepth ? max(depth1, depth2) : min(depth1, depth2);
		}

		function fragment() {
			var offsetSize = vec2(invWidth, invHeight);
			var depth = source.getLod(calculatedUV, 0.0).x;
			depth = compareDepth(depth, source.getLod(calculatedUV + vec2(1, 0) * offsetSize, 0.0).x);
			depth = compareDepth(depth, source.getLod(calculatedUV + vec2(0, 1) * offsetSize, 0.0).x);
			depth = compareDepth(depth, source.getLod(calculatedUV + vec2(1, 1) * offsetSize, 0.0).x);

			output.color = vec4(depth.xxx, 1.0);
		}
	}
}