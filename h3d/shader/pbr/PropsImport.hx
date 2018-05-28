package h3d.shader.pbr;

class PropsImport extends hxsl.Shader {

	static var SRC = {
		@param var albedoTex : Sampler2D;
		@param var normalTex : Sampler2D;
		@param var pbrTex : Sampler2D;
		@const var isScreen : Bool = true;

		@param var cameraInverseViewProj : Mat4;

		var albedo : Vec3;
		var depth : Float;
		var normal : Vec3;
		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var calculatedUV : Vec2;
		var transformedPosition : Vec3;
		var specularColor : Vec3;
		var screenUV : Vec2; // BaseMesh

		function fragment() {
			var uv = isScreen ? calculatedUV : screenUV;
			albedo = albedoTex.get(uv).rgb;
			var normalDepth = normalTex.get(uv);
			normal = normalDepth.xyz;
			depth = normalDepth.w;
			var pbr = pbrTex.get(uv);
			metalness = pbr.r;
			roughness = 1 - pbr.g;
			occlusion = pbr.b;

			specularColor = metalness < 0.3 ? vec3(metalness) : albedo;

			// this is the original object transformed position, not our current drawing object one
			var uv2 = (uv - 0.5) * vec2(2, -2);
			var temp = vec4(uv2, depth, 1) * cameraInverseViewProj;
			var originWS = temp.xyz / temp.w;
			transformedPosition = originWS;
		}

	};

}

