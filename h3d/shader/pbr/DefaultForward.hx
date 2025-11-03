package h3d.shader.pbr;

class DefaultForward extends hxsl.Shader {

	static var SRC = {

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

		@global @const var DIFFUSE_ONLY : Bool;

		@:import h3d.shader.pbr.Light.LightEvaluation;
		@:import h3d.shader.pbr.BRDF;

		// Import pbr info
		var output : {color : Vec4, metalness : Float, roughness : Float, occlusion : Float, emissive : Float, velocity : Vec2, depth : Float };

		@param var lightInfos : Buffer<Vec4, 4096>;

		// Buffer Info
		@param var dirLightCount : Int;
		@param var dirShadowCount : Int;
		@param var pointLightCount : Int;
		@param var pointShadowCount : Int;
		@param var spotLightCount : Int;
		@param var spotShadowCount : Int;
		@param var pointLightStride : Int;
		@param var spotLightStride : Int;
		@param var cascadeLightStride : Int;

		// ShadowMaps
		@param var cascadeShadowMaps : Array<Sampler2D, CASCADE_COUNT>;
		@param var dirShadowMaps : Array<Sampler2D, MAX_DIR_SHADOW_COUNT>;
		@param var pointShadowMaps : Array<SamplerCube, MAX_POINT_SHADOW_COUNT>;
		@param var spotShadowMaps : Array<Sampler2D, MAX_SPOT_SHADOW_COUNT>;

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

		function directLighting( lightColor : Vec3, lightDirection : Vec3) : Vec3 {
			var result = vec3(0);
			var NdL = clamp(transformedNormal.dot(lightDirection), 0.0, 1.0);
			if( lightColor.dot(lightColor) > 0.0001 && NdL > 0 ) {
				var half = (lightDirection + view).normalize();
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
			var i = index * 5;

			var shadow = 1.0;
			if (lightInfos[i].a > 0) {
				var shadowBias = lightInfos[i+1].a;
				var shadowProj = mat3x4(lightInfos[i+2], lightInfos[i+3], lightInfos[i+4]);
				var shadowPos = transformedPosition * shadowProj;
				var shadowUv = screenToUv(shadowPos.xy);
				var depth = dirShadowMaps[index].get(shadowUv.xy).r;
				shadow = (shadowPos.z - shadowBias > depth) ? 0.0 : 1.0;
			}
			return shadow;
		}

		function evaluateDirLight( index : Int ) : Vec3 {
			var i = index * 5;
			var lightColor = lightInfos[i].rgb;
			var lightDir = lightInfos[i+1].xyz;

			return directLighting(lightColor, lightDir);
		}

		function evaluatePointShadow( index : Int ) : Float {
			var i = index * 3 + pointLightStride;

			var shadow = 1.0;
			if (lightInfos[i+2].g > 0) {
				var lightPos = lightInfos[i+1].rgb;
				var range = lightInfos[i+2].r;
				var shadowBias = lightInfos[i+2].b;
				var posToLight = transformedPosition.xyz - lightPos;
				var dir = normalize(posToLight.xyz);
				var depth = pointShadowMaps[index].getLod(dir, 0).r * range;
				var zMax = length(posToLight);
				shadow = (zMax - shadowBias > depth) ? 0.0 : 1.0;
			}
			return shadow;
		}

		function evaluatePointLight( index : Int ) : Vec3 {
			var i = index * 3 + pointLightStride;
			var lightColor = lightInfos[i].rgb;
			var size = lightInfos[i].a;
			var lightPos = lightInfos[i+1].rgb;
			var invRange4 = lightInfos[i+1].a;
			var delta = lightPos - transformedPosition;

			return directLighting(pointLightIntensity(delta, size, invRange4) * lightColor, delta.normalize());
		}

		function evaluateSpotShadow( index : Int ) : Float {
			var i = index * 8 + spotLightStride;

			var shadow = 1.0;
			if (lightInfos[i+3].b > 0) {
				var shadowBias = lightInfos[i+3].a;
				var shadowProj = mat4(lightInfos[i+4], lightInfos[i+5], lightInfos[i+6], lightInfos[i+7]);
				var shadowPos = vec4(transformedPosition, 1.0) * shadowProj;
				shadowPos.xyz /= shadowPos.w;
				var shadowUv = screenToUv(shadowPos.xy);
				var depth = spotShadowMaps[index].get(shadowUv.xy).r;
				shadow = (shadowPos.z - shadowBias > depth) ? 0.0 : 1.0;
			}
			return shadow;
		}

		function evaluateSpotLight( index : Int ) : Vec3 {
			var i = index * 8 + spotLightStride;
			var lightColor = lightInfos[i].rgb;
			var range = lightInfos[i].a;
			var lightPos = lightInfos[i+1].xyz;
			var invRange4 = lightInfos[i+1].a;
			var lightDir = lightInfos[i+2].xyz;
			var angle = lightInfos[i+3].r;
			var fallOff = lightInfos[i+3].g;
			var delta = lightPos - transformedPosition;

			var fallOffInfo = spotLightIntensity(delta, lightDir, range, invRange4, fallOff, angle);
			var fallOff = fallOffInfo.x;
			var fallOffInfoAngle = fallOffInfo.y;

			return directLighting(fallOff * lightColor * fallOffInfoAngle, delta.normalize());
		}

		function evaluateCascadeLight() : Vec3 {
			var i = cascadeLightStride;
			var lightColor = lightInfos[i].rgb;
			var lightDir = lightInfos[i+1].xyz;

			return directLighting(lightColor, lightDir);
		}

		function inside(pos : Vec3) : Bool {
			if ( abs(pos.x) < 1.0 && abs(pos.y) < 1.0 && abs(pos.z) < 1.0 )
				return true;
			else
				return false;
		}

		function evaluateCascadeShadow() : Float {
			var i = cascadeLightStride;
			var shadow = 1.0;
			var shadowProj = mat3x4(lightInfos[i + 2], lightInfos[i + 3], lightInfos[i + 4]);

			@unroll for ( c in 0...CASCADE_COUNT ) {
				var cascadeScale = lightInfos[i + 5 + 2 * c];
				var shadowPos0 = transformedPosition * shadowProj;
				var shadowPos = c == 0 ? shadowPos0 : shadowPos0 * cascadeScale.xyz + lightInfos[i + 6 + 2 * c].xyz;
				if ( inside(shadowPos) ) {
					var zMax = saturate(shadowPos.z);
					var shadowUv = shadowPos.xy;
					shadowUv.y = 1.0 - shadowUv.y;
					var depth = cascadeShadowMaps[c].get(shadowUv.xy).r;
					shadow -= zMax > depth ? 1.0 : 0.0;
				}
			}
			return saturate(shadow);
		}

		function evaluateLighting() : Vec3 {

			var lightAccumulation = vec3(0);

			F0 = mix(pbrSpecularColor, albedoGamma, metalness);

			// Dir Light With Shadow
			@unroll for( l in 0 ... MAX_DIR_SHADOW_COUNT ) {
				if ( l < dirShadowCount ) {
					var c = evaluateDirLight(l);
					if ( dot(c, c) > 1e-6 )
						c *= evaluateDirShadow(l);
					lightAccumulation += c;
				}
			}
			// Dir Light
			for( l in dirShadowCount ... dirLightCount )
				lightAccumulation += evaluateDirLight(l);

			// Point Light With Shadow
			@unroll for( l in 0 ... MAX_POINT_SHADOW_COUNT ) {
				if ( l < pointShadowCount ) {
					var c = evaluatePointLight(l);
					if ( dot(c, c) > 1e-6 )
						c *= evaluatePointShadow(l);
					lightAccumulation += c;
				}
			}
			// Point Light
			for( l in pointShadowCount ... pointLightCount + pointShadowCount )
				lightAccumulation += evaluatePointLight(l);

			// Spot Light With Shadow
			@unroll for( l in 0 ... MAX_SPOT_SHADOW_COUNT ) {
				var c = evaluateSpotLight(l);
				if ( dot(c, c) > 1e-6 )
					c *= evaluateSpotShadow(l);
				lightAccumulation += c;
			}
			// Spot Light
			for( l in spotShadowCount ... spotLightCount + spotShadowCount )
				lightAccumulation += evaluateSpotLight(l);

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