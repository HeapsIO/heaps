package h3d.shader;

class HZB extends h3d.shader.ScreenShader {
	static var SRC = {
		@const var compareMax : Bool;
		@param var source : Sampler2D;
		@param var sourceWidth : Int;
		@param var sourceHeight : Int;
		var depth : Float;
		var prevTexelPos : IVec2;

		function compareDepth( offset : IVec2 ) {
			var depth2 = source.fetch(prevTexelPos + offset).x;
			depth = compareMax ? max(depth, depth2) : min(depth, depth2);
		}

		function fragment() {
			prevTexelPos = ivec2(floor(fragCoord.xy) * 2.0);
			depth = source.fetch(prevTexelPos).x;
			compareDepth(ivec2(1, 0));
			compareDepth(ivec2(0, 1));
			compareDepth(ivec2(1, 1));
			var prevWidthOdd = (sourceWidth & 1) != 0;
			var prevHeightOdd = (sourceHeight & 1) != 0;
			if ( prevWidthOdd ) {
				compareDepth(ivec2(2, 0));
				compareDepth(ivec2(2, 1));
			}
			if ( prevHeightOdd ) {
				compareDepth(ivec2(0, 2));
				compareDepth(ivec2(1, 2));
			}
			if ( prevWidthOdd && prevHeightOdd )
				compareDepth(ivec2(2, 2));

			output.color = vec4(depth.xxx, 1.0);
		}
	}
}