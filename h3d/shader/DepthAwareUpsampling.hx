package h3d.shader;

class DepthAwareUpsampling extends ScreenShader {
	static var SRC = {

		@global var camera : {
			var inverseViewProj : Mat4;
		}

		@param var source : Sampler2D;
		@param var sourceDepth : Sampler2D;
		@param var destDepth : Sampler2D;
		@param var depthThreshold : Float = 1.0;

		function getPosition( uv : Vec2, depthTexture : Sampler2D ) : Vec3 {
			var depth = unpack(depthTexture.get(uv));
			var temp = vec4(uvToScreen(uv), depth, 1) * camera.inverseViewProj;
			var originWS = temp.xyz / temp.w;
			return originWS;
		}

		function fragment() {
			var invDimensions = 1 / sourceDepth.size();
			var pcur = getPosition(calculatedUV, destDepth);
			var minDistance = 100000.0;

			var nearestUV = calculatedUV;
			var isEdge = false;

			for ( y in -2...2 ) {
				for ( x in -2...2 ) {
					var uv = calculatedUV + vec2(x, y) * invDimensions;
					var p = getPosition(uv, sourceDepth);
					var distance = abs(pcur.z - p.z); 
					if ( distance < minDistance) {
						minDistance = distance;
						nearestUV = uv;
					}
					isEdge = isEdge || distance > depthThreshold;
				}
			}

			if ( isEdge )
				pixelColor = source.getLod(nearestUV, 0);
			else
				pixelColor = source.getLod(calculatedUV, 0);
		}
	}
}