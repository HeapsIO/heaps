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
		@const(16) var MAX_POINT_SHADOW_COUNT:Int;
		@const(16) var MAX_SPOT_SHADOW_COUNT:Int;
		@const(2) var MAX_CAPSULE_SHADOW_COUNT:Int;
		@const(2) var MAX_RECT_SHADOW_COUNT:Int;

		@global @const var DIFFUSE_ONLY : Bool;

		@const var USE_BINDLESS = false;

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

		function evaluateLighting() : Vec3 {

			var lightAccumulation = vec3(0);

			F0 = mix(pbrSpecularColor, albedoGamma, metalness);

			// Dir Light With Shadow
			if( USE_BINDLESS ) {
				for( l in 0 ... dirShadowCount ) {
					var c = evaluateDirLight(l);
					if ( dot(c, c) > 1e-6 )
						c *= evaluateDirShadow(l);
					lightAccumulation += c;
				}
			} else {
				@unroll for( l in 0 ... MAX_DIR_SHADOW_COUNT ) {
					if ( l < dirShadowCount ) {
						var c = evaluateDirLight(l);
						if ( dot(c, c) > 1e-6 )
							c *= evaluateDirShadow(l);
						lightAccumulation += c;
					}
				}
			}
			// Dir Light
			for( l in dirShadowCount ... dirLightCount + dirShadowCount )
				lightAccumulation += evaluateDirLight(l);

			// Point Light With Shadow
			if( USE_BINDLESS ) {
				for( l in 0 ... pointShadowCount ) {
					var c = evaluatePointLight(l);
					if ( dot(c, c) > 1e-6 )
						c *= evaluatePointShadow(l);
					lightAccumulation += c;
				}
			} else {
				@unroll for( l in 0 ... MAX_POINT_SHADOW_COUNT ) {
					if ( l < pointShadowCount ) {
						var c = evaluatePointLight(l);
						if ( dot(c, c) > 1e-6 )
							c *= evaluatePointShadow(l);
						lightAccumulation += c;
					}
				}
			}
			// Point Light
			for( l in pointShadowCount ... pointLightCount + pointShadowCount )
				lightAccumulation += evaluatePointLight(l);

			// Spot Light With Shadow
			if( USE_BINDLESS ) {
				for( l in 0 ... spotShadowCount ) {
					var c = evaluateSpotLight(l);
					if ( dot(c, c) > 1e-6 )
						c *= evaluateSpotShadow(l);
					lightAccumulation += c;
				}
			} else {
				@unroll for( l in 0 ... MAX_SPOT_SHADOW_COUNT ) {
					if ( l < spotShadowCount ) {
						var c = evaluateSpotLight(l);
						if ( dot(c, c) > 1e-6 )
							c *= evaluateSpotShadow(l);
						lightAccumulation += c;
					}
				}
			}
			// Spot Light
			for( l in spotShadowCount ... spotLightCount + spotShadowCount )
				lightAccumulation += evaluateSpotLight(l);

			// Capsule Light With Shadow
			if( USE_BINDLESS ) {
				for( l in 0 ... capsuleShadowCount ) {
					var c = evaluateCapsuleLight(l);
					if ( dot(c, c) > 1e-6 )
						c *= evaluateCapsuleShadow(l);
					lightAccumulation += c;
				}
			} else {
				@unroll for( l in 0 ... MAX_CAPSULE_SHADOW_COUNT ) {
					if ( l < capsuleShadowCount ) {
						var c = evaluateCapsuleLight(l);
						if ( dot(c, c) > 1e-6 )
							c *= evaluateCapsuleShadow(l);
						lightAccumulation += c;
					}
				}
			}
			// Capsule Light
			for( l in capsuleShadowCount ... capsuleLightCount + capsuleShadowCount )
				lightAccumulation += evaluateCapsuleLight(l);

			// Rectangle Light With Shadow
			if( USE_BINDLESS ) {
				for( l in 0 ... rectShadowCount ) {
					var c = evaluateRectLight(l);
					if ( dot(c, c) > 1e-6 )
						c *= evaluateRectShadow(l);
					lightAccumulation += c;
				}
			} else {
				@unroll for( l in 0 ... MAX_RECT_SHADOW_COUNT ) {
					if ( l < rectShadowCount ) {
						var c = evaluateRectLight(l);
						if ( dot(c, c) > 1e-6 )
							c *= evaluateRectShadow(l);
						lightAccumulation += c;
					}
				}
			}
			// Rectangle Light
			for( l in rectShadowCount ... rectLightCount + rectShadowCount )
				lightAccumulation += evaluateRectLight(l);

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
