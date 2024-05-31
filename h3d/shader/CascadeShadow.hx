package h3d.shader;

class CascadeShadow extends DirShadow {

	static var SRC = {

		var pixelColor : Vec4;

		@global var camera : {
			var view : Mat4;
		}

		@const(5) var CASCADE_COUNT : Int;
		@const var DEBUG : Bool;
		@const var BLEND : Bool;
		@param var cascadeShadowMaps : Array<Sampler2D, CASCADE_COUNT>;
		@param var cascadeViewProj : Mat3x4;
		@param var cascadeTransitionFraction : Float;
		@param var cascadeScales : Array<Vec4, CASCADE_COUNT>;
		@param var cascadeOffsets : Array<Vec4, CASCADE_COUNT>;
		@param var cascadeDebugs : Array<Vec4, CASCADE_COUNT>;

		var texelSize : Vec2;

		function shadowPCF( shadowUv : Vec2, zMax : Float, c : Int ) : Float {
			var shadow = 1.0;
			var rot = rand(transformedPosition.x + transformedPosition.y + transformedPosition.z) * 3.14 * 2;
			var cosR = cos(rot);
			var sinR = sin(rot);
			var sampleStrength = 1.0 / PCF_SAMPLES;
			var offScale = texelSize * pcfScale;
			for(i in 0...PCF_SAMPLES) {
				var offset = poissonDisk[i].xy * offScale;
				offset = vec2(cosR * offset.x - sinR * offset.y, cosR * offset.y + sinR * offset.x);
				var depth = cascadeShadowMaps[c].getLod(shadowUv + offset, 0).r;
				shadow -= (zMax > depth) ? sampleStrength : 0.0;
			}
			return shadow;
		}

		function shadowESM( shadowUv : Vec2, zMax : Float, c : Int ) : Float {
			var depth = cascadeShadowMaps[c].get(shadowUv).r;
			var delta = depth.min(zMax) - zMax;
			return exp(shadowPower * delta).saturate();
		}

		function shadowBase( shadowUv : Vec2, zMax : Float, c : Int ) : Float {
			var depth = cascadeShadowMaps[c].get(shadowUv).r;
			return zMax > depth ? 0 : 1;
		}

		function sampleShadow( shadowPos : Vec3, c : Int) : Float {
			var zMax = shadowPos.z.saturate();
			var shadowUv = shadowPos.xy;
			shadowUv.y = 1.0 - shadowUv.y;

			if( USE_PCF )
				return shadowPCF(shadowUv, zMax, c);
			else if( USE_ESM )
				return shadowESM(shadowUv, zMax, c);
			else
				return shadowBase(shadowUv, zMax, c);
		}

		function fragment() {
			if ( enable ) {
				var shadowValue = 1.0;
				var color = vec3(0);
				texelSize = 1.0 / shadowRes;

				var vPos = vec4(transformedPosition, 1.0) * camera.view;
				vPos /= vPos.w;

				var cascadeFound = false;
				@unroll for ( i in 0...CASCADE_COUNT ) {
					if ( !cascadeFound && vPos.z <= cascadeScales[i].w ) {
						cascadeFound = true;

						var shadowPos0 = transformedPosition * cascadeViewProj;
						var shadowPos = ( i == 0 ) ? shadowPos0 : shadowPos0 * cascadeScales[i].xyz + cascadeOffsets[i].xyz;
						shadowValue = sampleShadow(shadowPos, i);
						color = cascadeDebugs[i].rgb;

						if ( BLEND ) {
							var blendEnd = cascadeScales[i].w;
							var blendSize = blendEnd * cascadeTransitionFraction;
							var blendStart = blendEnd - blendSize;
							var blendFactor = ( vPos.z - blendStart ) / blendSize;

							if (  blendFactor > 0.0 ) {
								if ( i != CASCADE_COUNT - 1 ) {
									var nextShadowPos = shadowPos0 * cascadeScales[i + 1].xyz + cascadeOffsets[i + 1].xyz;
									var nextShadow = sampleShadow(nextShadowPos, i + 1);
									shadowValue = nextShadow * blendFactor + shadowValue * (1 - blendFactor);

									var nextColor = cascadeDebugs[i + 1].rgb;
									color = nextColor * blendFactor + color * (1 - blendFactor);

								} else {
									shadowValue = blendFactor + shadowValue * (1 - blendFactor);
									color = color * (1 - blendFactor);
								}
							}
						}
					}
				}

				if ( DEBUG )
					pixelColor = vec4(color, 1.0);
				else {
					shadow = shadowValue;
					dirShadow = shadow;
				}
			}
		}
	}
}