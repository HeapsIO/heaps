package h3d.shader;

class DepthAwareUpsampling extends ScreenShader {
	static var SRC = {

		@param var inverseProj : Mat4;
		@param var source : Sampler2D;
		@param var sourceDepth : Sampler2D;
		@param var destDepth : Sampler2D;
		@param var depthThreshold : Float = 1.0;

		final offsets : Array<Vec2, 9> = [
			vec2(-1, -1), vec2(-1, 0), vec2(-1, 1),
			vec2( 0, -1), vec2( 0, 0), vec2( 0, 1),
			vec2( 1, -1), vec2( 1, 0), vec2( 1, 1)
		];

		function getPosition( uv : Vec2, depth : Float ) : Vec3 {
			var temp = vec4(uvToScreen(uv), depth, 1) * inverseProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}

		function fragment() {
			var destDimensions = destDepth.size();
			var pixels = fragCoord.xy;
			var curDepth = destDepth.fetch(ivec2(pixels.xy)).r;
			var pcur = getPosition(calculatedUV, curDepth);
			var minDepthDist = 2.0;

			var nearestUV = calculatedUV;
			var isEdge = false;

			var sourceDimensions = sourceDepth.size();
			var sourceInvDimensions = 1 / sourceDimensions;
			var upscaleFactor = destDimensions / sourceDimensions;
			var halfPixels = floor( pixels / upscaleFactor ) + vec2(0.5);

			for ( i in 0...offsets.length ) {
				var uv = (halfPixels + offsets[i]) * sourceInvDimensions;
				var depth = sourceDepth.get(uv).r;
				var depthDist = abs(curDepth - depth);
				if ( depthDist < minDepthDist ) {
					minDepthDist = depthDist;
					nearestUV = uv;
				}
				var p = getPosition(uv, depth);
				var distance = abs(pcur.z - p.z);
				isEdge = isEdge || distance > depthThreshold;
			}

			if ( isEdge )
				pixelColor = source.getLod(nearestUV, 0);
			else
				pixelColor = source.getLod(calculatedUV, 0);
		}
	}
}