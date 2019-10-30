package h3d.shader.pbr;

class Indirect extends PropsDefinition {

	static var SRC = {

		@param var irrLut : Sampler2D;
		@param var irrDiffuse : SamplerCube;
		@param var irrSpecular : SamplerCube;
		@param var irrSpecularLevels : Float;
		@param var irrPower : Float;

		@param var rot : Float;

		@const var showSky : Bool;
		@const var skyColor : Bool;
		@param var skyColorValue : Vec3;

		@const var drawIndirectDiffuse : Bool;
		@const var drawIndirectSpecular : Bool;
		@param var skyMap : SamplerCube;
		@param var skyThreshold : Float;
		@param var skyScale : Float;
		@const var gammaCorrect : Bool;
		@param var cameraInvViewProj : Mat4;
		@param var emissivePower : Float;
		var calculatedUV : Vec2;

		function fragment() {
			var s = sin(rot);
			var c = cos(rot);
	
			var isSky = normal.dot(normal) <= 0;
			if( isSky ) {
				if( showSky ) {
					var color : Vec3;
					if( skyColor )
						color = skyColorValue;
					else {
						normal = (vec3( uvToScreen(calculatedUV) * 5. /*?*/ , 1. ) * cameraInvViewProj.mat3x4()).normalize();
						var rotatedNormal = vec3(normal.x * c - normal.y * s, normal.x * s + normal.y * c, normal.z);
						color = skyMap.get(rotatedNormal).rgb;
						color.rgb *= mix(1.0, skyScale, (max( max(color.r, max(color.g, color.b)) - skyThreshold, 0) / max(0.001, (1.0 - skyThreshold))));
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
				
				var rotatedNormal = vec3(normal.x * c - normal.y * s, normal.x * s + normal.y * c, normal.z);

				if( drawIndirectDiffuse ) {
					diffuse = irrDiffuse.get(rotatedNormal).rgb * albedo;
				}
				if( drawIndirectSpecular ) {
					var reflectVec = reflect(-view, normal);
					var roatetdReflecVec = vec3(reflectVec.x * c - reflectVec.y * s, reflectVec.x * s + reflectVec.y * c, reflectVec.z);
					var envSpec = textureLod(irrSpecular, roatetdReflecVec, roughness * irrSpecularLevels).rgb;
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

