package h3d.shader;

class ShadowSampling extends hxsl.Shader {

	static var SRC = {
		// Keep in sync with ShadowSamplingKind in h3d.shadow.Shadows
		final SAMPLING_NONE = 0;
		final SAMPLING_ESM  = 1;
		final SAMPLING_PCF  = 2;

		final poissonDisk : Array<Vec2, 16> = [
			vec2(-0.94201624,-0.39906216 ), vec2( 0.94558609,-0.76890725 ), vec2(-0.09418410,-0.92938870 ), vec2( 0.34495938, 0.29387760 ),
			vec2(-0.91588581, 0.45771432 ), vec2(-0.81544232,-0.87912464 ), vec2(-0.38277543, 0.27676845 ), vec2( 0.97484398, 0.75648379 ),
			vec2( 0.44323325,-0.97511554 ), vec2( 0.53742981,-0.47373420 ), vec2(-0.26496911,-0.41893023 ), vec2( 0.79197514, 0.19090188 ),
			vec2(-0.24188840, 0.99706507 ), vec2(-0.81409955, 0.91437590 ), vec2( 0.19984126, 0.78641367 ), vec2( 0.14383161,-0.14100790 ),
		];

		final offsetDirections : Array<Vec3, 20> = [
			vec3( 1,  1,  1), vec3( 1, -1,  1), vec3(-1, -1,  1), vec3(-1,  1,  1),
			vec3( 1,  1, -1), vec3( 1, -1, -1), vec3(-1, -1, -1), vec3(-1,  1, -1),
			vec3( 1,  1,  0), vec3( 1, -1,  0), vec3(-1, -1,  0), vec3(-1,  1,  0),
			vec3( 1,  0,  1), vec3(-1,  0,  1), vec3( 1,  0, -1), vec3(-1,  0, -1),
			vec3( 0,  1,  1), vec3( 0, -1,  1), vec3( 0, -1, -1), vec3( 0,  1, -1)
		];

		function poissonRotation( pos : Vec3 ) : Vec2 {
			var dp = dot(vec4(pos.x + pos.y + pos.z), vec4(12.9898, 78.233, 45.164, 94.673));
			var rot = fract(sin(dp) * 43758.5453) * 3.14 * 2;
			return vec2(cos(rot), sin(rot));
		}

		function poissonOffset( i : Int, cs : Vec2, scale : Float ) : Vec2 {
			var o = poissonDisk[i].xy * scale;
			return vec2(cs.x * o.x - cs.y * o.y, cs.x * o.y + cs.y * o.x);
		}

		function compareDepth( depth : Float, zMax : Float, bias : Float ) : Float {
			return (zMax - bias > depth) ? 0.0 : 1.0;
		}

		function insideShadow(uv : Vec2) : Bool {
			return uv.x > 0.0 && uv.x < 1.0 && uv.y > 0.0 && uv.y < 1.0;
		}

		function esmFilter( depth : Float, zMax : Float, bias : Float, power : Float ) : Float {
			return exp(power * ((depth + bias).min(zMax) - zMax)).saturate();
		}

		function dirShadowPos( pos : Vec3, m : Mat3x4 ) : Vec3 {
			var p = pos * m;
			return vec3(screenToUv(p.xy), p.z.saturate());
		}

		function spotShadowPos( pos : Vec3, m : Mat4 ) : Vec3 {
			var p = vec4(pos, 1.0) * m;
			p.xyz /= p.w;
			return vec3(screenToUv(p.xy), p.z);
		}

		function shadowPcf( shadowMap : Sampler2D, uv : Vec2, zMax : Float, bias : Float, pcfScale : Float, pos : Vec3 ) : Float {
			var cs = poissonRotation(pos);
			var shadow = 1.0;
			@unroll for( i in 0...16 ) {
				var o = poissonOffset(i, cs, pcfScale);
				var compare = insideShadow(uv) ? compareDepth(shadowMap.getLod(uv + o, 0).r, zMax, bias) : 1.0;
				shadow -= compare > 0.0 ? 0.0 : 1.0 / 12.0;
			}
			return shadow;
		}

		function cubeShadowPcf( shadowMap : SamplerCube, dir : Vec3, zMax : Float, range : Float, bias : Float, pcfScale : Float ) : Float {
			var shadow = 1.0;
			if( range >= zMax ) {
				var sampleStrength = 1.0 / 20;
				@unroll for( i in 0...20 ) {
					var offset = offsetDirections[i] * pcfScale;
					var depth = shadowMap.getLod(dir + offset, 0).r * range;
					if( zMax - bias > depth )
						shadow -= sampleStrength;
				}
			}
			return saturate(shadow);
		}

		function sampleShadow( shadowMap : Sampler2D, uv : Vec2, zMax : Float, bias : Float, pcfScale : Float, esmPower : Float, worldPos : Vec3, samplingMode : Int ) : Float {
			var shadow = 1.0;
			if( insideShadow(uv) ) {
				if( samplingMode == SAMPLING_PCF )
					shadow = shadowPcf(shadowMap, uv, zMax, bias, pcfScale, worldPos);
				else if( samplingMode == SAMPLING_ESM )
					shadow = esmFilter(shadowMap.getLod(uv, 0).r, zMax, bias, esmPower);
				else if( samplingMode == SAMPLING_NONE)
					shadow = compareDepth(shadowMap.getLod(uv, 0).r, zMax, bias);
			}
			return shadow;
		}

		function sampleCubeShadow( shadowMap : SamplerCube, dir : Vec3, zMax : Float, range : Float, bias : Float, pcfScale : Float, esmPower : Float, samplingMode : Int ) : Float {
			var shadow = 1.0;
			if( samplingMode == SAMPLING_PCF )
				shadow = cubeShadowPcf(shadowMap, dir, zMax, range, bias, pcfScale);
			else if( samplingMode == SAMPLING_ESM )
				shadow = esmFilter(shadowMap.getLod(dir, 0).r, zMax, bias, esmPower);
			else if( samplingMode == SAMPLING_NONE )
				shadow = compareDepth(shadowMap.getLod(dir, 0).r, zMax, bias);
			return shadow;
		}

	};
}