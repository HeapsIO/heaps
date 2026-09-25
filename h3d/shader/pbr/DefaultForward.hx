package h3d.shader.pbr;

class DefaultForward extends hxsl.Shader {

	static var SRC = {
		@:extends h3d.shader.ShadowSampling;

		@global var camera : {
			var view : Mat4;
			var viewProj : Mat4;
			var position : Vec3;
			var inverseViewProj : Mat4;
		}

		@const(4) var CASCADE_COUNT:Int;
		@const(2) var MAX_DIR_SHADOW_COUNT:Int;
		@const(4) var MAX_POINT_SHADOW_COUNT:Int;
		@const(4) var MAX_SPOT_SHADOW_COUNT:Int;
		@const(2) var MAX_CAPSULE_SHADOW_COUNT:Int;
		@const(2) var MAX_RECT_SHADOW_COUNT:Int;

		@global @const var DIFFUSE_ONLY : Bool;

		@const var USE_BINDLESS = false;
		@const var DYNAMIC_SAMPLER_INDEX = false;
		@const var CLUSTERED = false;

		@:import h3d.shader.pbr.Light.LightEvaluation;
		@:import h3d.shader.pbr.BRDF;

		// Import pbr info
		var output : {color : Vec4, metalness : Float, roughness : Float, occlusion : Float, emissive : Float, velocity : Vec2, depth : Float };

		@param var lightInfos : Buffer<Vec4, 4096>;

		// Keep in sync with h3d.scene.pbr.LightBuffer.
		final DIR_LIGHT_STRIDE   : Int = 2;
		final POINT_LIGHT_STRIDE : Int = 2;
		final SPOT_LIGHT_STRIDE  : Int = 3;
		final CAPSULE_LIGHT_STRIDE : Int = 3;
		final RECT_LIGHT_STRIDE    : Int = 6;

		final DIR_SHADOW_STRIDE  : Int = 5;
		final SPOT_SHADOW_STRIDE : Int = 6;
		final CUBE_SHADOW_STRIDE : Int = 2;

		// Keep in sync with h3d.shader.pbr.ClusterCull.
		final CLUSTER_X : Int = 16;
		final CLUSTER_Y : Int = 9;
		final CLUSTER_Z : Int = 24;
		final CLUSTER_STRIDE : Int = 128;

		final LIGHT_DIR : Int = 0;
		final LIGHT_POINT : Int = 1;
		final LIGHT_SPOT : Int = 2;
		final LIGHT_CAPSULE : Int = 3;
		final LIGHT_RECT : Int = 4;

		@param var clusterData : StorageBuffer<Int>;
		@param var clusterZParams : Vec2;
		var clusterCounts : Int;
		var clusterStart : Int;

		// Buffer Info
		@param var dirLightCount     : Int;
		@param var dirLightOffset    : Int;
		@param var dirShadowCount    : Int;
		@param var dirShadowOffset   : Int;

		@param var pointLightCount   : Int;
		@param var pointLightOffset  : Int;
		@param var pointShadowCount  : Int;
		@param var pointShadowOffset : Int;

		@param var spotLightCount    : Int;
		@param var spotLightOffset   : Int;
		@param var spotShadowCount   : Int;
		@param var spotShadowOffset  : Int;

		@param var capsuleLightCount   : Int;
		@param var capsuleLightOffset  : Int;
		@param var capsuleShadowCount  : Int;
		@param var capsuleShadowOffset : Int;

		@param var rectLightCount    : Int;
		@param var rectLightOffset   : Int;
		@param var rectShadowCount   : Int;
		@param var rectShadowOffset  : Int;

		// ShadowMaps
		@param var cascadeShadowMaps : Sampler2DArray;
		@param var dirShadowMaps : Array<Sampler2D, MAX_DIR_SHADOW_COUNT>;
		@param var pointShadowMaps : Array<SamplerCube, MAX_POINT_SHADOW_COUNT>;
		@param var spotShadowMaps : Array<Sampler2D, MAX_SPOT_SHADOW_COUNT>;
		@param var capsuleShadowMaps : Array<SamplerCube, MAX_CAPSULE_SHADOW_COUNT>;
		@param var rectShadowMaps : Array<Sampler2D, MAX_RECT_SHADOW_COUNT>;

		var bindlessDirShadow : Sampler2D;
		var bindlessSpotShadow : Sampler2D;
		var bindlessRectShadow : Sampler2D;
		var bindlessPointShadow : SamplerCube;
		var bindlessCapsuleShadow : SamplerCube;

		// Direct Lighting
		@param var cameraPosition : Vec3;
		@param var emissivePower : Float;

		var albedoGamma : Vec3;

		var view : Vec3;
		var NdV : Float;
		var pbrSpecularColor : Vec3;
		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var emissive : Float;
		var F0 : Vec3;

		// Indirect Lighting
		@const var USE_INDIRECT = false;
		@param var irrLut : Sampler2D;
		@param var irrDiffuse : SamplerCube;
		@param var irrSpecular : SamplerCube;
		@param var irrSpecularLevels : Float;
		@param var irrPower : Float;
		@param var irrRotation : Vec2;

		var transformedNormal : Vec3;
		var transformedPosition : Vec3;
		var pixelColor : Vec4;
		var depth : Float;
		var pixelVelocity : Vec2;

		@:import h3d.shader.ColorSpaces;

		function rotateNormal( n : Vec3 ) : Vec3 {
			return vec3(n.x * irrRotation.x - n.y * irrRotation.y, n.x * irrRotation.y + n.y * irrRotation.x, n.z);
		}

		function indirectLighting() : Vec3 {
			var F = F0 + (max(vec3(1 - roughness), F0) - F0) * exp2( ( -5.55473 * NdV - 6.98316) * NdV );
			var rotatedNormal = rotateNormal(transformedNormal);
			var diffuse = irrDiffuse.get(rotatedNormal).rgb * albedoGamma;
			var reflectVec = reflect(-view, transformedNormal);
			var rotatedReflecVec = rotateNormal(reflectVec);
			var envSpec = textureLod(irrSpecular, rotatedReflecVec, roughness * irrSpecularLevels).rgb;
			var envBRDF = irrLut.get(vec2(roughness, NdV));
			var specular = envSpec * (F * envBRDF.x + envBRDF.y);
			var indirect = DIFFUSE_ONLY ? diffuse : (diffuse * (1 - metalness) * (1 - F) + specular);
			return indirect * irrPower * occlusion;
		}

		function directLighting( lightColor : Vec3, lightDirection : Vec3, specularDirection : Vec3 ) : Vec3 {
			var result = vec3(0);
			var NdL = clamp(transformedNormal.dot(lightDirection), 0.0, 1.0);
			if( lightColor.dot(lightColor) > 0.0001 && NdL > 0 ) {
				var half = (specularDirection + view).normalize();
				var NdH = clamp(transformedNormal.dot(half), 0.0, 1.0);
				var VdH = clamp(view.dot(half), 0.0, 1.0);
				var diffuse = albedoGamma / PI;

				// General Cook-Torrance formula for microfacet BRDF
				// 	f(l,v) = D(h).F(v,h).G(l,v,h) / 4(n.l)(n.v)
				var D = normalDistributionGGX(NdH, roughness);// Normal distribution fonction
				var F = fresnelSchlick(VdH, F0);// Fresnel term
				var G = geometrySchlickGGX(NdV, NdL, roughness);// Geometric attenuation
				var specular = (D * F * G).max(0.);
				var direct = DIFFUSE_ONLY ? diffuse : (diffuse * (1 - metalness) * (1 - F) + specular);
				result = direct * lightColor * NdL;
			}
			return result;
		}

		function __init__fragment() {
			pbrSpecularColor = vec3(0.04);
			albedoGamma = pixelColor.rgb * pixelColor.rgb; // gamma correct
		}

		function init() {
			view = (cameraPosition - transformedPosition).normalize();
			NdV = transformedNormal.dot(view).max(0.);
		}

		function evaluateDirShadow( index : Int ) : Float {
			var s = dirShadowOffset + index * DIR_SHADOW_STRIDE;
			var samplingMode = int(lightInfos[s].a);
			var shadow = 1.0;
			if( samplingMode >= 0 ) {
				var shadowParam = lightInfos[s].b;
				var shadowBias = lightInfos[s].r;
				var shadowViewProj = mat3x4(lightInfos[s+1], lightInfos[s+2], lightInfos[s+3]);
				var shadowPos = dirShadowPos(transformedPosition, shadowViewProj);
				if( USE_BINDLESS ) {
					resolveSampler(ivec2(int(lightInfos[s+4].r), int(lightInfos[s+4].g)), bindlessDirShadow);
					shadow = sampleShadow(bindlessDirShadow, shadowPos.xy, shadowPos.z, shadowBias, shadowParam, shadowParam, transformedPosition, samplingMode);
				} else
					shadow = sampleShadow(dirShadowMaps[index], shadowPos.xy, shadowPos.z, shadowBias, shadowParam, shadowParam, transformedPosition, samplingMode);
			}
			return shadow;
		}

		function evaluateDirLight( index : Int ) : Vec3 {
			var i = dirLightOffset + index * DIR_LIGHT_STRIDE;
			var lightColor = unpackIntColor(int(lightInfos[i].r)).rgb * lightInfos[i].g;
			var lightDir = lightInfos[i+1].xyz;

			return directLighting(lightColor, lightDir, lightDir);
		}

		function evaluatePointShadow( index : Int ) : Float {
			var s = pointShadowOffset + index * CUBE_SHADOW_STRIDE;
			var i = pointLightOffset + index * POINT_LIGHT_STRIDE;
			var samplingMode = int(lightInfos[s].a);
			var shadow = 1.0;
			if( samplingMode >= 0 ) {
				var shadowParam = lightInfos[s].b;
				var shadowBias = lightInfos[s].r;
				var range = lightInfos[s].g;
				var lightPos = lightInfos[i+1].rgb;
				var posToLight = transformedPosition.xyz - lightPos;
				var zMax = length(posToLight);
				var dir = posToLight / zMax;
				if( USE_BINDLESS ) {
					resolveSampler(ivec2(int(lightInfos[s+1].r), int(lightInfos[s+1].g)), bindlessPointShadow);
					shadow = sampleCubeShadow(bindlessPointShadow, dir, zMax, range, shadowBias, shadowParam, shadowParam, samplingMode);
				} else
					shadow = sampleCubeShadow(pointShadowMaps[index], dir, zMax, range, shadowBias, shadowParam, shadowParam, samplingMode);
			}
			return shadow;
		}

		function evaluatePointLight( index : Int ) : Vec3 {
			var i = pointLightOffset + index * POINT_LIGHT_STRIDE;
			var lightColor = unpackIntColor(int(lightInfos[i].r)).rgb * lightInfos[i].g;
			var size = lightInfos[i].b;
			var lightPos = lightInfos[i+1].rgb;
			var invRange4 = lightInfos[i+1].a;
			var delta = lightPos - transformedPosition;

			var lightDir = delta.normalize();
			return directLighting(pointLightIntensity(delta, size, invRange4) * lightColor, lightDir, lightDir);
		}

		function evaluateSpotShadow( index : Int ) : Float {
			var s = spotShadowOffset + index * SPOT_SHADOW_STRIDE;
			var samplingMode = int(lightInfos[s].a);
			var shadow = 1.0;
			if( samplingMode >= 0 ) {
				var shadowParam = lightInfos[s].b;
				var shadowBias = lightInfos[s].r;
				var shadowViewProj = mat4(lightInfos[s+1], lightInfos[s+2], lightInfos[s+3], lightInfos[s+4]);
				var shadowPos = spotShadowPos(transformedPosition, shadowViewProj);
				if( USE_BINDLESS ) {
					resolveSampler(ivec2(int(lightInfos[s+5].r), int(lightInfos[s+5].g)), bindlessSpotShadow);
					shadow = sampleShadow(bindlessSpotShadow, shadowPos.xy, shadowPos.z.saturate(), shadowBias, shadowParam, shadowParam, transformedPosition, samplingMode);
				} else
					shadow = sampleShadow(spotShadowMaps[index], shadowPos.xy, shadowPos.z.saturate(), shadowBias, shadowParam, shadowParam, transformedPosition, samplingMode);
			}
			return shadow;
		}

		function evaluateSpotLight( index : Int ) : Vec3 {
			var i = spotLightOffset + index * SPOT_LIGHT_STRIDE;
			var lightColor = unpackIntColor(int(lightInfos[i].r)).rgb * lightInfos[i].g;
			var angle = lightInfos[i].b;
			var fallOff = lightInfos[i].a;
			var lightPos = lightInfos[i+1].rgb;
			var invRange4 = lightInfos[i+1].a;
			var lightDir = lightInfos[i+2].rgb;
			var range = lightInfos[i+2].a;
			var delta = lightPos - transformedPosition;

			var fallOffInfo = spotLightIntensity(delta, lightDir, range, invRange4, fallOff, angle);
			var fallOff = fallOffInfo.x;
			var fallOffInfoAngle = fallOffInfo.y;

			var lightToPixel = delta.normalize();
			return directLighting(fallOff * lightColor * fallOffInfoAngle, lightToPixel, lightToPixel);
		}

		function evaluateCapsuleShadow( index : Int ) : Float {
			var s = capsuleShadowOffset + index * CUBE_SHADOW_STRIDE;
			var i = capsuleLightOffset + index * CAPSULE_LIGHT_STRIDE;
			var samplingMode = int(lightInfos[s].a);
			var shadow = 1.0;
			if( samplingMode >= 0 ) {
				var shadowParam = lightInfos[s].b;
				var shadowBias = lightInfos[s].r;
				var range = lightInfos[s].g;
				var lightPos = lightInfos[i+1].rgb;
				var posToLight = transformedPosition.xyz - lightPos;
				var zMax = length(posToLight);
				var dir = posToLight / zMax;
				if( USE_BINDLESS ) {
					resolveSampler(ivec2(int(lightInfos[s+1].r), int(lightInfos[s+1].g)), bindlessCapsuleShadow);
					shadow = sampleCubeShadow(bindlessCapsuleShadow, dir, zMax, range, shadowBias, shadowParam, shadowParam, samplingMode);
				} else
					shadow = sampleCubeShadow(capsuleShadowMaps[index], dir, zMax, range, shadowBias, shadowParam, shadowParam, samplingMode);
			}
			return shadow;
		}

		function evaluateCapsuleLight( index : Int ) : Vec3 {
			var i = capsuleLightOffset + index * CAPSULE_LIGHT_STRIDE;
			var lightColor = unpackIntColor(int(lightInfos[i].r)).rgb * lightInfos[i].g;
			var radius = lightInfos[i].b;
			var halfLength = lightInfos[i].a;
			var lightPos = lightInfos[i+1].rgb;
			var invRange4 = lightInfos[i+1].a;
			var left = lightInfos[i+2].rgb;

			var light = capsuleLightDiffuse(lightPos, left, halfLength, radius, invRange4, transformedPosition);
			var specularDir = capsuleLightSpecularDir(lightPos, left, halfLength, radius, transformedPosition, reflect(-view, transformedNormal));
			return directLighting(light.w * lightColor, light.xyz, specularDir);
		}

		function evaluateRectShadow( index : Int ) : Float {
			var s = rectShadowOffset + index * SPOT_SHADOW_STRIDE;
			var samplingMode = int(lightInfos[s].a);
			var shadow = 1.0;
			if( samplingMode >= 0 ) {
				var shadowParam = lightInfos[s].b;
				var shadowBias = lightInfos[s].r;
				var shadowViewProj = mat4(lightInfos[s+1], lightInfos[s+2], lightInfos[s+3], lightInfos[s+4]);
				var shadowPos = spotShadowPos(transformedPosition, shadowViewProj);
				if( USE_BINDLESS ) {
					resolveSampler(ivec2(int(lightInfos[s+5].r), int(lightInfos[s+5].g)), bindlessRectShadow);
					shadow = sampleShadow(bindlessRectShadow, shadowPos.xy, shadowPos.z.saturate(), shadowBias, shadowParam, shadowParam, transformedPosition, samplingMode);
				} else
					shadow = sampleShadow(rectShadowMaps[index], shadowPos.xy, shadowPos.z.saturate(), shadowBias, shadowParam, shadowParam, transformedPosition, samplingMode);
			}
			return shadow;
		}

		function evaluateRectLight( index : Int ) : Vec3 {
			var i = rectLightOffset + index * RECT_LIGHT_STRIDE;
			var lightColor = unpackIntColor(int(lightInfos[i].r)).rgb * lightInfos[i].g;
			var halfSize = vec2(lightInfos[i].b, lightInfos[i].a);
			var lightPos = lightInfos[i+1].rgb;
			var invRange4 = lightInfos[i+1].a;
			var lightDir = lightInfos[i+2].rgb;
			var range = lightInfos[i+2].a;
			var right = lightInfos[i+3].rgb;
			var up = lightInfos[i+4].rgb;
			var angles = vec4(lightInfos[i+3].a, lightInfos[i+4].a, lightInfos[i+5].r, lightInfos[i+5].g);

			var light = rectangleLightDiffuse(lightPos, lightDir, right, up, halfSize, angles, range, invRange4, transformedPosition);
			var specularDir = rectangleLightSpecularDir(lightPos, lightDir, right, up, halfSize, transformedPosition, reflect(-view, transformedNormal));
			return directLighting(light.w * lightColor, light.xyz, specularDir);
		}

		function evaluateCascadeLight() : Vec3 {
			var lightColor = unpackIntColor(int(lightInfos[0].r)).rgb * lightInfos[0].g;
			var lightDir = lightInfos[1].xyz;

			return directLighting(lightColor, lightDir, lightDir);
		}

		function inside(pos : Vec3) : Bool {
			if ( abs(pos.x) < 1.0 && abs(pos.y) < 1.0 && abs(pos.z) < 1.0 )
				return true;
			else
				return false;
		}

		function evaluateCascadeShadow() : Float {
			var samplingMode = int(lightInfos[0].a);
			var shadow = 1.0;
			if( samplingMode >= 0 ) {
				var shadowParam = lightInfos[0].b;
				var transitionFraction = lightInfos[1].a;
				var shadowViewProj = mat3x4(lightInfos[2], lightInfos[3], lightInfos[4]);

				var viewZ = (transformedPosition * camera.view.mat3x4()).z;

				var shadowPos0 = transformedPosition * shadowViewProj;

				var shouldContinue = true;
				@unroll for( c in 0...CASCADE_COUNT ) {
					var scale = lightInfos[5 + 2 * c];
					if( shouldContinue && viewZ <= scale.w ) {
						shouldContinue = false;

						var offset = lightInfos[6 + 2 * c];
						var shadowPos = ( c == 0 ) ? shadowPos0 : cascadeShadowPos(shadowPos0, scale.xyz, offset.xyz);
						shadow = sampleCascadeArray(cascadeShadowMaps, c, shadowPos, 0.0, shadowParam, shadowParam, transformedPosition, samplingMode);

						var blendFactor = cascadeBlendFactor(viewZ, scale.w, transitionFraction);
						if( blendFactor > 0.0 ) {
							if( c < CASCADE_COUNT - 1 ) {
								var nextScale = lightInfos[5 + 2 * (c + 1)];
								var nextOffset = lightInfos[6 + 2 * (c + 1)];
								var nextShadowPos = cascadeShadowPos(shadowPos0, nextScale.xyz, nextOffset.xyz);
								var nextShadow = sampleCascadeArray(cascadeShadowMaps, c + 1, nextShadowPos, 0.0, shadowParam, shadowParam, transformedPosition, samplingMode);
								shadow = nextShadow * blendFactor + shadow * (1 - blendFactor);
							} else {
								shadow = blendFactor + shadow * (1 - blendFactor);
							}
						}
					}
				}
			}
			return shadow;
		}

		function clusterIndex() : Int {
			var p = vec4(transformedPosition, 1.) * camera.viewProj;
			var ndc = p.xy / p.w;
			var tile = clamp(floor((ndc * 0.5 + 0.5) * vec2(float(CLUSTER_X), float(CLUSTER_Y))), vec2(0.), vec2(float(CLUSTER_X - 1), float(CLUSTER_Y - 1)));
			var viewZ = (transformedPosition * camera.view.mat3x4()).z;
			var slice = clamp(floor(log(max(viewZ, 1e-6)) * clusterZParams.x + clusterZParams.y), 0., float(CLUSTER_Z - 1));
			return ((int(slice) * CLUSTER_Y + int(tile.y)) * CLUSTER_X + int(tile.x)) * CLUSTER_STRIDE;
		}

		function evaluateLight( type : Int, index : Int ) : Vec3 {
			var c = vec3(0);
			if( type == LIGHT_DIR )
				c = evaluateDirLight(index);
			else if( type == LIGHT_POINT )
				c = evaluatePointLight(index);
			else if( type == LIGHT_SPOT )
				c = evaluateSpotLight(index);
			else if( type == LIGHT_CAPSULE )
				c = evaluateCapsuleLight(index);
			else
				c = evaluateRectLight(index);
			return c;
		}

		function evaluateShadowedLight( type : Int, index : Int ) : Vec3 {
			var c = evaluateLight(type, index);
			if( dot(c, c) > 1e-6 ) {
				if( type == LIGHT_DIR )
					c *= evaluateDirShadow(index);
				else if( type == LIGHT_POINT )
					c *= evaluatePointShadow(index);
				else if( type == LIGHT_SPOT )
					c *= evaluateSpotShadow(index);
				else if( type == LIGHT_CAPSULE )
					c *= evaluateCapsuleShadow(index);
				else
					c *= evaluateRectShadow(index);
			}
			return c;
		}

		function accumulateLights( acc : Vec3, type : Int, shadowCount : Int, lightCount : Int, maxShadowCount : Int ) : Vec3 {
			// Shadowed lights can only be culled with bindless. Per pixel index into a sampler array is not dynamically uniform
			if( !(CLUSTERED && USE_BINDLESS && type != LIGHT_DIR) ) {
				if( USE_BINDLESS || DYNAMIC_SAMPLER_INDEX ) {
					for( l in 0 ... shadowCount )
						acc += evaluateShadowedLight(type, l);
				} else {
					@unroll for( l in 0 ... maxShadowCount )
						if( l < shadowCount )
							acc += evaluateShadowedLight(type, l);
				}
			}
			if( CLUSTERED && type != LIGHT_DIR ) {
				var count = (clusterCounts >> ((type - LIGHT_POINT) * 8)) & 0xFF;
				for( k in 0 ... count ) {
					var l = clusterData[clusterStart + k];
					if( USE_BINDLESS && l < shadowCount )
						acc += evaluateShadowedLight(type, l);
					else
						acc += evaluateLight(type, l);
				}
				clusterStart += count;
			} else {
				for( l in shadowCount ... shadowCount + lightCount )
					acc += evaluateLight(type, l);
			}
			return acc;
		}

		function evaluateLighting() : Vec3 {

			var lightAccumulation = vec3(0);

			F0 = mix(pbrSpecularColor, albedoGamma, metalness);

			if( CLUSTERED ) {
				var cluster = clusterIndex();
				clusterCounts = clusterData[cluster];
				clusterStart = cluster + 1;
			}

			lightAccumulation = accumulateLights(lightAccumulation, LIGHT_DIR, dirShadowCount, dirLightCount, MAX_DIR_SHADOW_COUNT);
			lightAccumulation = accumulateLights(lightAccumulation, LIGHT_POINT, pointShadowCount, pointLightCount, MAX_POINT_SHADOW_COUNT);
			lightAccumulation = accumulateLights(lightAccumulation, LIGHT_SPOT, spotShadowCount, spotLightCount, MAX_SPOT_SHADOW_COUNT);
			lightAccumulation = accumulateLights(lightAccumulation, LIGHT_CAPSULE, capsuleShadowCount, capsuleLightCount, MAX_CAPSULE_SHADOW_COUNT);
			lightAccumulation = accumulateLights(lightAccumulation, LIGHT_RECT, rectShadowCount, rectLightCount, MAX_RECT_SHADOW_COUNT);

			// Cascade shadows
			if ( CASCADE_COUNT > 0 ) {
				var c = evaluateCascadeLight();
				if ( dot(c, c) > 1e-6 )
					c *= evaluateCascadeShadow();
				lightAccumulation += c;
			}

			// Indirect only support the main env from the scene at the moment
			if( USE_INDIRECT )
				lightAccumulation += indirectLighting();

			// Emissive Pass
			lightAccumulation += emissive * emissivePower * pixelColor.rgb;

			return lightAccumulation;
		}

		function fragment() {
			init();
			output.color = vec4(evaluateLighting(), pixelColor.a);
			output.depth = depth;
			output.velocity = pixelVelocity;
		}

	};
}
