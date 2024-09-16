package h3d.shader;

class DepthAwareUpsampling extends ScreenShader {
	static var SRC = {

		@param var inverseProj : Mat4;
		@param var source : Sampler2D;
		@param var sourceDepth : Sampler2D;
		@param var destDepth : Sampler2D;
		@param var depthThreshold : Float = 1.0;

		final offsets : Array<Vec2, 4> = [
			vec2(-1,  0), vec2(0, -1), 
			vec2( 1,  0), vec2(0,  1)
		];

		function getPosition( uv : Vec2, depthTexture : Sampler2D ) : Vec3 {
			var depth = unpack(depthTexture.get(uv));
			var temp = vec4(uvToScreen(uv), depth, 1) * inverseProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}

		function fragment() {
			var invDimensions = 1 / sourceDepth.size();
			var pcur = getPosition(calculatedUV, destDepth);
			var p = getPosition(calculatedUV, sourceDepth);
			var minDistance = abs(pcur.z - p.z);

			var nearestUV = calculatedUV;
			var isEdge = minDistance > depthThreshold;

			for ( i in 0...offsets.length ) {
				var uv = calculatedUV + offsets[i] * invDimensions;
				p = getPosition(uv, sourceDepth);
				var distance = abs(pcur.z - p.z); 
				if ( distance < minDistance) {
					minDistance = distance;
					nearestUV = uv;
				}
				isEdge = isEdge || distance > depthThreshold;
			}

			if ( isEdge )
				pixelColor = source.getLod(nearestUV, 0);
			else
				pixelColor = source.getLod(calculatedUV, 0);
		}
	}
}