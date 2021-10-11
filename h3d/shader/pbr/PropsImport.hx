package h3d.shader.pbr;

class PropsImport extends hxsl.Shader {

	static var SRC = {
		@param var albedoTex : Sampler2D;
		@param var normalTex : Sampler2D;
		@param var pbrTex : Sampler2D;
		@param var depthTex : Sampler2D;
		@param var otherTex : Sampler2D;
		@const var isScreen : Bool = true;

		@param var cameraInverseViewProj : Mat4;
		@param var occlusionPower : Float;

		var albedo : Vec3;
		var depth : Float;
		var normal : Vec3;
		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var emissive : Float;
		var custom1 : Float;
		var custom2 : Float;
		var calculatedUV : Vec2;
		var transformedPosition : Vec3;
		var pbrSpecularColor : Vec3;
		var screenUV : Vec2; // BaseMesh

		function fragment() {
			var uv = isScreen ? calculatedUV : screenUV;
			albedo = albedoTex.get(uv).rgb;
			albedo *= albedo; // gamma correct

			normal = normalTex.get(uv).xyz;
			var pbr = pbrTex.get(uv);
			metalness = pbr.r;
			roughness = pbr.g;
			occlusion = mix(1, pbr.b, occlusionPower);

			var other = otherTex.get(uv);
			emissive = other.r;
			custom1 = other.g;
			custom2 = other.b;
			depth = depthTex.get(uv).r;

			pbrSpecularColor = mix(vec3(0.04),albedo,metalness);

			// this is the original object transformed position, not our current drawing object one
			var temp = vec4(uvToScreen(uv), depth, 1) * cameraInverseViewProj;
			var originWS = temp.xyz / temp.w;
			transformedPosition = originWS;
		}

	};

}

