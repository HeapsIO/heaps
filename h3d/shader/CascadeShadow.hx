package h3d.shader;

class CascadeShadow extends DirShadow {

	static var SRC = {

		var pixelColor : Vec4;

		@global var camera : {
			var view : Mat4;
		}

		@const var DEBUG : Bool;
		@const var BLEND : Bool;

		final MAX_CASCADE_COUNT : Int = 4;
		@param var cascadeShadowMaps : Array<Sampler2D, MAX_CASCADE_COUNT>;
		@param var cascadeScales : Array<Vec4, MAX_CASCADE_COUNT>;
		@param var cascadeOffsets : Array<Vec4, MAX_CASCADE_COUNT>;
		@param var cascadeDebugs : Array<Vec4, MAX_CASCADE_COUNT>;
		@param var cascadeCount : Int;
		@param var cascadeViewProj : Mat3x4;
		@param var cascadeTransitionFraction : Float;

		function fragment() {
			if( enable ) {
				var shadowValue = 1.0;
				var color = vec3(0);

				var viewZ = (transformedPosition * camera.view.mat3x4()).z;

				var shouldContinue = true;
				#if hldx
				for( i in 0...cascadeCount ) {
				#else
				@unroll for( i in 0...MAX_CASCADE_COUNT )
				if( i < cascadeCount) {
				#end
					if( shouldContinue && viewZ <= cascadeScales[i].w ) {
						shouldContinue = false;

						var shadowPos0 = transformedPosition * cascadeViewProj;
						var shadowPos = ( i == 0 ) ? shadowPos0 : cascadeShadowPos(shadowPos0, cascadeScales[i].xyz, cascadeOffsets[i].xyz);
						shadowValue = sampleCascade(cascadeShadowMaps[i], shadowPos, 0.0, pcfScale, shadowPower, transformedPosition, SAMPLING_MODE);
						color = cascadeDebugs[i].rgb;

						if( BLEND ) {
							var blendFactor = cascadeBlendFactor(viewZ, cascadeScales[i].w, cascadeTransitionFraction);

							if( blendFactor > 0.0 ) {
								if( i < MAX_CASCADE_COUNT - 1 && i < cascadeCount - 1 ) {
									var nextShadowPos = cascadeShadowPos(shadowPos0, cascadeScales[i + 1].xyz, cascadeOffsets[i + 1].xyz);
									var nextShadow = sampleCascade(cascadeShadowMaps[i + 1], nextShadowPos, 0.0, pcfScale, shadowPower, transformedPosition, SAMPLING_MODE);
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