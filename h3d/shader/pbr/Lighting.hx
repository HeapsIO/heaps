package h3d.shader.pbr;

class Indirect extends PropsDefinition {

	static var SRC = {

		@:import h3d.shader.pbr.BDRF;

		// Flags
		@const var drawIndirectDiffuse : Bool;
		@const var drawIndirectSpecular : Bool;
		@const var showSky : Bool;
		@const var skyColor : Bool;

		// Indirect Params
		@param var irrLut : Sampler2D;
		@param var irrDiffuse : SamplerCube;
		@param var irrSpecular : SamplerCube;
		@param var irrSpecularLevels : Float;
		@param var irrPower : Float;
		@param var irrRotation : Vec2;

		// Sky Params
		@param var skyMap : SamplerCube;
		@param var skyHdrMax : Float;
		@const var gammaCorrect : Bool;
		@param var cameraInvViewProj : Mat4;
		@param var skyColorValue : Vec3;

		// Emissive Blend
		@param var emissivePower : Float;

		var calculatedUV : Vec2;

		function rotateNormal( n : Vec3 ) : Vec3 {
			return vec3(n.x * irrRotation.x - n.y * irrRotation.y, n.x * irrRotation.y + n.y * irrRotation.x, n.z);
		}

		function getEnvSpecular( normal : Vec3, roughness : Float ) : Vec3 {
			return irrSpecular.textureLod( rotateNormal(normal), roughness * irrSpecularLevels).rgb;
		}

		function getEnvDiffuse( normal : Vec3 ) : Vec3 {
			return irrDiffuse.get( rotateNormal(normal) ).rgb;
		}

		function fragment() {
			var isSky = normal.dot(normal) <= 0;
			if( isSky ) {
				if( showSky ) {
					var color : Vec3;
					if( skyColor ) {
						color = skyColorValue;
						if( gammaCorrect )
							color *= color;
					} else {
						var normal = (vec3( uvToScreen(calculatedUV), 1. ) * cameraInvViewProj.mat3x4()).normalize();
						color = skyMap.get(rotateNormal(normal)).rgb;
						color = min(color, skyHdrMax);
						if( gammaCorrect )
							color *= color;
						color *= irrPower;
					}
					pixelColor.rgb += color;
				} else
					discard;
			} else {

				var diffuse = vec3(0.);
				var specular = vec3(0.);

				var F0 = pbrSpecularColor;
				var F = F0 + (max(vec3(1 - roughness), F0) - F0) * exp2( ( -5.55473 * NdV - 6.98316) * NdV );

				if( drawIndirectDiffuse ) {
					diffuse = getEnvDiffuse(normal) * albedo;
				}
				if( drawIndirectSpecular ) {
					var reflectVec = reflect(-view, normal);
					var envSpec = getEnvSpecular(reflectVec, roughness);
					var envBRDF = irrLut.get(vec2(roughness, NdV));
					specular = envSpec * (F * envBRDF.x + envBRDF.y);
				}

				var indirect = (diffuse * (1 - metalness) * (1 - F) + specular) * irrPower;
				pixelColor.rgb += indirect * occlusion + albedo * emissive * emissivePower;
			}
		}
	};
}

class Direct extends PropsDefinition {

	static var SRC = {

		@:import h3d.shader.pbr.BDRF;

		var pbrLightDirection : Vec3;
		var pbrLightColor : Vec3;
		var pbrOcclusionFactor : Float;
		@const var doDiscard : Bool = true;

		function fragment() {

			var NdL = normal.dot(pbrLightDirection).max(0.);
			if( pbrLightColor.dot(pbrLightColor) > 0.0001 && NdL > 0 ) {

				var half = (pbrLightDirection + view).normalize();
				var NdH = normal.dot(half).max(0.);
				var VdH = view.dot(half).max(0.);

				// ------------- DIRECT LIGHT -------------------------

				var F0 = pbrSpecularColor;
				var diffuse = albedo / PI;

				// General Cook-Torrance formula for microfacet BRDF
				// 	f(l,v) = D(h).F(v,h).G(l,v,h) / 4(n.l)(n.v)
				var D = normalDistributionGGX(NdH, roughness);// Normal distribution fonction
				var F = fresnelSchlick(VdH, F0);// Fresnel term
				var G = geometrySchlickGGX(NdV, NdL, roughness);// Geometric attenuation
				var specular = (D * F * G).max(0.);

				var direct = (diffuse * (1 - metalness) * (1 - F) + specular) * pbrLightColor * NdL;
				pixelColor.rgb += direct * shadow * mix(1, occlusion, pbrOcclusionFactor);
			} else if( doDiscard )
				discard;
		}
	};

}

