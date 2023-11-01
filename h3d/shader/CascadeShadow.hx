package h3d.shader;

class CascadeShadow extends DirShadow {

	static var SRC = {

		var pixelColor : Vec4;

		@const(5) var CASCADE_COUNT:Int;
		@const var DEBUG : Bool;
		@param var cascadeShadowMaps : Array<Sampler2D, CASCADE_COUNT>;
		@param var cascadeProjs : Array<Mat3x4, CASCADE_COUNT>;
		@param var cascadeDebugs : Array<Vec4, CASCADE_COUNT>;
		@param var cascadeBias : Array<Float, CASCADE_COUNT>;

		function inside(pos : Vec3) : Bool {
			if ( abs(pos.x) < 1.0 && abs(pos.y) < 1.0 && abs(pos.z) < 1.0 ) {
				return true;
			} else {
				return false;
			}
		}

		function fragment() {
			if( enable ) {
				shadow = 1.0;
				var texelSize = 1.0/shadowRes;
				@unroll for ( c in 0...CASCADE_COUNT ) {
					var shadowPos = transformedPosition * cascadeProjs[c];
					
					if ( inside(shadowPos) ) {
						shadow = 1.0;
						var zMax = shadowPos.z.saturate();
						var shadowUv = screenToUv(shadowPos.xy);
						var bias = cascadeBias[c];
						if( USE_PCF ) {
							var rot = rand(transformedPosition.x + transformedPosition.y + transformedPosition.z) * 3.14 * 2;
							var cosR = cos(rot);
							var sinR = sin(rot);
							var sampleStrength = 1.0 / PCF_SAMPLES;
							var offScale = texelSize * pcfScale;
							for(i in 0...PCF_SAMPLES) {
								var offset = poissonDisk[i].xy * offScale;
								offset = vec2(cosR * offset.x - sinR * offset.y, cosR * offset.y + sinR * offset.x);
								var depth = cascadeShadowMaps[c].getLod(shadowUv + offset, 0).r;
								shadow  -= (zMax - bias > depth) ? sampleStrength : 0.0;
							}
						}
						else if( USE_ESM ) {
							var depth = cascadeShadowMaps[c].get(shadowUv).r;
							var delta = (depth + bias).min(zMax) - zMax;
							shadow = exp(shadowPower * delta).saturate();		
						}
						else {
							var depth = cascadeShadowMaps[c].get(shadowUv).r;
							shadow -= zMax - bias > depth ? 1 : 0;
						}
					}
				}
			}

			if ( DEBUG ) {
				pixelColor = vec4(0.0, 0.0, 0.0, 1.0);
				@unroll for ( c in 0...CASCADE_COUNT ) {
					var shadowPos = transformedPosition * cascadeProjs[c];
					if ( inside(shadowPos) ) {
						pixelColor.rgb = cascadeDebugs[c].rgb;
					}
				}
			}
			shadow = saturate(shadow);
			dirShadow = shadow;
		}
	}
}