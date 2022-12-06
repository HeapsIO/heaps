package h3d.shader;

class CascadeShadow extends DirShadow {

	static var SRC = {

		@const(5) var CASCADE_COUNT:Int;
		@param var cascadeShadowMaps : Array<Sampler2D, CASCADE_COUNT>;
		@param var cascadeProjs : Array<Mat3x4, CASCADE_COUNT>;
		@param var cascadeLimits : Array<Float, CASCADE_COUNT>;
		@param var camViewProj : Mat4;

		function fragment() {
			if( enable ) {
				if( USE_PCF ) {
					shadow = 1.0;
					var texelSize = 1.0/shadowRes;
					@unroll for ( c in 0...CASCADE_COUNT ) {
						var shadowPos = transformedPosition * cascadeProjs[c];
						var zMax = shadowPos.z.saturate();
						var shadowUv = screenToUv(shadowPos.xy);

						var rot = rand(transformedPosition.x + transformedPosition.y + transformedPosition.z) * 3.14 * 2;
						var cosR = cos(rot);
						var sinR = sin(rot);
						var sampleStrength = 1.0 / PCF_SAMPLES;
						var offScale = texelSize * pcfScale;
						for(i in 0...PCF_SAMPLES) {
							var offset = poissonDisk[i].xy * offScale;
							offset = vec2(cosR * offset.x - sinR * offset.y, cosR * offset.y + sinR * offset.x);
							var depth = cascadeShadowMaps[c].getLod(shadowUv + offset, 0).r;
							shadow  -= (zMax - shadowBias > depth) ? sampleStrength : 0.0;
						}
					}
				}
				else if( USE_ESM ) {
					var shadowPos = transformedPosition * cascadeProjs[0];
					var zMax = shadowPos.z.saturate();
					var depth = cascadeShadowMaps[0].get(screenToUv(shadowPos.xy)).r;
					var delta = (depth + shadowBias).min(zMax) - zMax;
					shadow = exp(shadowPower * delta).saturate();
				}
				else {
					shadow = 1.0;
					@unroll for ( c in 0...CASCADE_COUNT ) {
						var shadowPos = transformedPosition * cascadeProjs[c];
						var shadowUv = screenToUv(shadowPos.xy);
						var zMax = shadowPos.z.saturate();
						var depth = cascadeShadowMaps[c].get(shadowUv).r;
						shadow -= zMax - shadowBias > depth ? 1 : 0;
					}
				}
			}
			shadow = saturate(shadow);
			dirShadow = shadow;
		}
	}
}