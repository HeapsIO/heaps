package h3d.shader;

class CascadeShadow extends DirShadow {

	static var SRC = {

		var pixelColor : Vec4;

		@global var camera : {
			var view : Mat4;
		}

		@const var DEBUG : Bool;
		@const var BLEND : Bool;

		final MAX_CASCADE_COUNT = 4;
		@param var cascadeShadowMaps : Array<Sampler2D, 4>;
		@param var cascadeScales : Array<Vec4, 4>;
		@param var cascadeOffsets : Array<Vec4, 4>;
		@param var cascadeDebugs : Array<Vec4, 4>;
		@param var cascadeCount : Int;
		@param var cascadeViewProj : Mat3x4;
		@param var cascadeTransitionFraction : Float;

		function sampleCascade( shadowPos : Vec3, c : Int) : Float {
			var zMax = shadowPos.z.saturate();
			var shadowUv = shadowPos.xy;
			shadowUv.y = 1.0 - shadowUv.y;

			sampleShadow( cascadeShadowMaps[c], shadowUv, zMax, 0.0, pcfScale, shadowPower, transformedPosition, SAMPLING_MODE );
		}

		function fragment() {
			if( enable ) {
				var shadowValue = 1.0;
				var color = vec3(0);

				var vPos = vec4(transformedPosition, 1.0) * camera.view;
				vPos /= vPos.w;

				var shouldContinue = true;
				#if hldx
				for( i in 0...cascadeCount ) {
				#else
				@unroll for( i in 0...MAX_CASCADE_COUNT )
				if( i < cascadeCount) {
				#end
					if( shouldContinue && vPos.z <= cascadeScales[i].w ) {
						shouldContinue = false;

						var shadowPos0 = transformedPosition * cascadeViewProj;
						var shadowPos = ( i == 0 ) ? shadowPos0 : shadowPos0 * cascadeScales[i].xyz + cascadeOffsets[i].xyz;
						shadowValue = sampleCascade(shadowPos, i);
						color = cascadeDebugs[i].rgb;

						if( BLEND ) {
							var blendEnd = cascadeScales[i].w;
							var blendSize = blendEnd * cascadeTransitionFraction;
							var blendStart = blendEnd - blendSize;
							var blendFactor = ( vPos.z - blendStart ) / blendSize;

							if( blendFactor > 0.0 ) {
								if( i < MAX_CASCADE_COUNT - 1 && i < cascadeCount - 1 ) {
									var nextShadowPos = shadowPos0 * cascadeScales[i + 1].xyz + cascadeOffsets[i + 1].xyz;
									var nextShadow = sampleCascade(nextShadowPos, i + 1);
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

				if( DEBUG )
					pixelColor = vec4(color, 1.0);
				else {
					shadow = shadowValue;
					dirShadow = shadow;
				}
			}
		}
	}
}