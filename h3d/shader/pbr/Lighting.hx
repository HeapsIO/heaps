package h3d.shader.pbr;

class Indirect extends PropsDefinition {

	static var SRC = {

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
					if( skyColor )
						color = skyColorValue;
					else {
						var normal = (vec3( uvToScreen(calculatedUV), 1. ) * cameraInvViewProj.mat3x4()).normalize();
						color = skyMap.get(rotateNormal(normal)).rgb;
						color = min(color, skyHdrMax);
					}
					if( gammaCorrect )
						color *= color;
					pixelColor.rgb += color * irrPower;
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
				// 		f(l,v) = D(h).F(v,h).G(l,v,h) / 4(n.l)(n.v)

				// formulas below from 2013 Siggraph "Real Shading in UE4"
				var alpha = roughness * roughness;

				// D = normal distribution fonction
				// GGX (Trowbridge-Reitz) "Disney"
				var alpha2 = alpha * alpha;
				var denom = NdH * NdH * (alpha2 - 1.) + 1;
				var D = alpha2 / (PI * denom * denom);

				// F = fresnel term
				// Schlick approx
				// pow 5 optimized with Spherical Gaussian
				// var F = F0 + (1 - F0) * pow(1 - v.dot(h), 5.);
				var F = F0 + (1. - F0) * exp2( ( -5.55473 * VdH - 6.98316) * VdH );

				// G = geometric attenuation
				// Schlick (modified for UE4 with k=alpha/2)
				// k = (rough + 1)² / 8
				var k = (roughness + 1);
				k *= k;
				k *= 0.125;

				//var G = (1 / (NdV * (1 - k) + k)) * (1 / (NdL * (1 - k) + k)) * NdL * NdV;
				//var Att = 1 / (4 * NdL * NdV);
				var G_Att = (1 / (NdV * (1 - k) + k)) * (1 / (NdL * (1 - k) + k)) * 0.25;
				var specular = (D * F * G_Att).max(0.);

				var direct = (diffuse * (1 - metalness) * (1 - F) + specular) * pbrLightColor * NdL;
				pixelColor.rgb += direct * shadow * mix(1, occlusion, pbrOcclusionFactor);
			} else if( doDiscard )
				discard;
		}
	};

}

