package h3d.shader;

class HZB extends h3d.shader.ScreenShader {
	static var SRC = {
		@const var compareMax : Bool;
		@param var source : Sampler2D;
		@param var sourceWidth : Int;
		@param var sourceHeight : Int;

		function compareDepth( depth1 : Float, depth2 : Float ) : Float {
			return compareMax ? max(depth1, depth2) : min(depth1, depth2);
		}

		function fragment() {
			var prevTexelPos = floor(fragCoord.xy) * 2.0;
			var depth = source.fetch(ivec2(prevTexelPos)).x;
			depth = compareDepth(depth, source.fetch(ivec2(prevTexelPos + vec2(1, 0))).x);
			depth = compareDepth(depth, source.fetch(ivec2(prevTexelPos + vec2(0, 1))).x);
			depth = compareDepth(depth, source.fetch(ivec2(prevTexelPos + vec2(1, 1))).x);
			var prevWidthOdd = (sourceWidth & 1) != 0;
			var prevHeightOdd = (sourceHeight & 1) != 0;
			if ( prevWidthOdd ) {
				depth = compareDepth(depth, source.fetch(ivec2(prevTexelPos + vec2(2, 0))).x);
				depth = compareDepth(depth, source.fetch(ivec2(prevTexelPos + vec2(2, 1))).x);
			}
			if ( prevHeightOdd ) {
				depth = compareDepth(depth, source.fetch(ivec2(prevTexelPos + vec2(0, 2))).x);
				depth = compareDepth(depth, source.fetch(ivec2(prevTexelPos + vec2(1, 2))).x);
			}
			if ( prevWidthOdd && prevHeightOdd )
				depth = compareDepth(depth, source.fetch(ivec2(prevTexelPos + vec2(2, 2))).x);

			output.color = vec4(depth.xxx, 1.0);
		}
	}
}