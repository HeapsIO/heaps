package h3d.shader.pbr;

class BDRF extends hxsl.Shader {

	static var SRC = {

		function getAnisotropicRoughness( roughness : Float, anisotropy : Float ) : Vec2 {
			// [Burley12] Offers more pleasant and intuitive results, but is slightly more expensive
			//var da = sqrt(1 - 0.9 * anisotropy);
			//var at = anisotropy / da;
			//var ab = anisotropy * da;

			// [Kulla17] Allows creation of sharp highlights
			var at = max(roughness * (1.0 + anisotropy), 0.001);
			var ab = max(roughness * (1.0 - anisotropy), 0.001);

			return vec2(at, ab);
		}

		// [Heitz14] Anisotropic visibility function
		function smithGGXCorrelatedAnisotropic( at : Float, ab : Float, TdV : Float, BdV : Float, TdL : Float, BdL : Float, NdV: Float, NdL : Float ) : Float {
			var lambdaV = NdL * length(vec3(at * TdV, ab * BdV, NdV));
			var lambdaL = NdV * length(vec3(at * TdL, ab * BdL, NdL));
			var v = 0.5 / (lambdaV + lambdaL);
			return saturate(v);
		}

		// GGX Anisotropic
		function normalDistributionGGXAnisotropic( at : Float, ab : Float, NdH : Float, TdH : Float, BdH : Float, roughness : Float, anisotropy : Float ) : Float {
			var a2 = at * ab;
			var v = vec3(ab * TdH, at * BdH, a2 * NdH);
			var v2 = dot(v, v);
			var w2 = a2 / v2;
			return a2 * w2 * w2 * (1.0 / PI);
		}

		// Formulas below from 2013 Siggraph "Real Shading in UE4"

		// GGX (Trowbridge-Reitz) "Disney"
		function normalDistributionGGX( NdH : Float, roughness: Float ) : Float {
			var alpha = roughness * roughness;
			var alpha2 = alpha * alpha;
			var denom = NdH * NdH * (alpha2 - 1.) + 1;
			return alpha2 / (PI * denom * denom);
		}

		// G = geometric attenuation
		// Schlick (modified for UE4 with k=alpha/2)
		// k = (rough + 1)² / 8
		function geometrySchlickGGX( NdV : Float, NdL : Float, roughness : Float ) : Float {
			var k = (roughness + 1);
			k *= k;
			k *= 0.125;
			//var G = (1 / (NdV * (1 - k) + k)) * (1 / (NdL * (1 - k) + k)) * NdL * NdV;
			//var Att = 1 / (4 * NdL * NdV);
			return (1 / (NdV * (1 - k) + k)) * (1 / (NdL * (1 - k) + k)) * 0.25;
		}

		// Schlick approx
		// pow 5 optimized with Spherical Gaussian
		// var F = F0 + (1 - F0) * pow(1 - v.dot(h), 5.);
		function fresnelSchlick( VdH : Float, F0 : Vec3 ) : Vec3 {
			return F0 + (1. - F0) * exp2( ( -5.55473 * VdH - 6.98316) * VdH );
		}
	}

}
