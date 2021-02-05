package h3d.shader.pbr;

class DefaultForward extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.pbr.Light.LightEvaluation;
		@:import h3d.shader.pbr.BDRF;

		// Import pbr info
		var output : {color : Vec4, metalness : Float, roughness : Float, occlusion : Float, emissive : Float };

		@const(256) var BUFFER_SIZE : Int = 1;
		@param var lightInfos : Buffer<Vec4, BUFFER_SIZE>;

		// Buffer Info
		@param var dirLightCount : Int;
		@param var pointLightCount : Int;
		@param var spotLightCount : Int;
		@param var dirLightStride : Int;
		@param var pointLightStride : Int;

		// ShadowMaps
		//@param var dirShadowMaps : Array<Sampler2D, 2>;
		//@param var pointShadowMaps : Array<SamplerCube, 3>;
		//@param var spotShadowMaps : Array<Sampler2D, 3>;

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
			var indirect = (diffuse * (1 - metalness) * (1 - F) + specular) * irrPower;
			return indirect * occlusion;
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

				result = (diffuse * (1 - metalness) * (1 - F) + specular) * lightColor * NdL;
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

		function evaluateDirLight( index : Int ) : Vec3 {
			var i = index * 5;
			var lightColor = lightInfos[i].rgb;
			var lightDir = lightInfos[i+1].xyz;
			var hasShadowMap = lightInfos[i].a > 0;

			// Shadow
			var shadow = 1.0;
			/*if( hasShadowMap ) {
				var shadowBias = lightInfos[i+1].a;
				var shadowProj = mat3x4(lightInfos[i+2], lightInfos[i+3], lightInfos[i+4]);
				var shadowPos = transformedPosition * shadowProj;
				var shadowUv = screenToUv(shadowPos.xy);
				var depth = dirShadowMaps[index].get(shadowUv.xy).r;
				shadow = (shadowPos.z - shadowBias > depth) ? 0.0 : 1.0;
			}*/

			return directLighting(lightColor, lightDir) * shadow;
		}

		function evaluatePointLight( index : Int ) : Vec3 {
			var i = index * 3 + dirLightStride;
			var lightColor = lightInfos[i].rgb;
			var size = lightInfos[i].a;
			var lightPos = lightInfos[i+1].rgb;
			var invRange4 = lightInfos[i+1].a;
			var range = lightInfos[i+2].r;
			var hasShadowMap = lightInfos[i+2].g > 0;
			var delta = lightPos - transformedPosition;

			// Shadow
			var shadow = 1.0;
			/*if( hasShadowMap ) {
				var shadowBias = lightInfos[i+2].b;
				var posToLight = transformedPosition.xyz - lightPos;
				var dir = normalize(posToLight.xyz);
				var depth = pointShadowMaps[index].getLod(dir, 0).r * range;
				var zMax = length(posToLight);
				shadow = (zMax - shadowBias > depth) ? 0.0 : 1.0;
			}*/

			return directLighting(pointLightIntensity(delta, size, invRange4) * lightColor, delta.normalize()) * shadow;
		}

		function evaluateSpotLight( index : Int ) : Vec3 {
			var i = index * 8 + dirLightStride + pointLightStride;
			var lightColor = lightInfos[i].rgb;
			var range = lightInfos[i].a;
			var lightPos = lightInfos[i+1].xyz;
			var invRange4 = lightInfos[i+1].a;
			var lightDir = lightInfos[i+2].xyz;
			var angle = lightInfos[i+3].r;
			var fallOff = lightInfos[i+3].g;
			var hasShadowMap = lightInfos[i+3].b > 0;
			var delta = lightPos - transformedPosition;

			// Shadow
			var shadow = 1.0;
			/*if( hasShadowMap ) {
				var shadowBias = lightInfos[i+3].a;
				var shadowProj = mat4(lightInfos[i+4], lightInfos[i+5], lightInfos[i+6], lightInfos[i+7]);
				var shadowPos = vec4(transformedPosition, 1.0) * shadowProj;
				shadowPos.xyz /= shadowPos.w;
				var shadowUv = screenToUv(shadowPos.xy);
				var depth = spotShadowMaps[index].get(shadowUv.xy).r;
				shadow = (shadowPos.z - shadowBias > depth) ? 0.0 : 1.0;
			}*/

			var fallOffInfo = spotLightIntensity(delta, lightDir, range, invRange4, fallOff, angle);
			var fallOff = fallOffInfo.x;
			var fallOffInfoAngle = fallOffInfo.y;

			return directLighting(fallOff * lightColor * fallOffInfoAngle, delta.normalize()) * shadow;
		}

		function evaluateLighting() : Vec3 {

			var lightAccumulation = vec3(0);

			F0 = mix(pbrSpecularColor, albedoGamma, metalness);

			// Dir Light
			@unroll for( l in 0 ... dirLightCount )
				lightAccumulation += evaluateDirLight(l);

			// Point Light
			@unroll for( l in 0 ... pointLightCount )
				lightAccumulation += evaluatePointLight(l);

			// Spot Light
			@unroll for( l in 0 ... spotLightCount )
				lightAccumulation += evaluateSpotLight(l);

			// Indirect only support the main env from the scene at the moment
			if( USE_INDIRECT )
				lightAccumulation += indirectLighting();

			// Emissive Pass
			lightAccumulation += emissive * emissivePower;

			return lightAccumulation;
		}

		function fragment() {
			init();
			output.color = vec4(evaluateLighting(), pixelColor.a);
		}

	};
}