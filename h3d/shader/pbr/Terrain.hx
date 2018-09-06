package h3d.shader.pbr;

class Terrain extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.BaseMesh;

		@param var previewTex : Sampler2D;
		@param var heightMap : Sampler2D;
		@param var heightMapSize : Float;
		@param var primSize : Float;
		@param var cellSize : Float;

		@const var usePreview : Bool;
		@const var showGrid : Bool;

		var calculatedUV : Vec2;

		function getNormal(uv: Vec2) : Vec3 {
			var offset = vec2(1.0/heightMapSize, 0);
			var base = heightMap.get(uv).r;
			var ddx = heightMap.get(uv + offset.xy).r;
			var ddy = heightMap.get(uv + offset.yx).r;
			var normal = normalize(vec3(base - ddx, base - ddy, 0.5));
			normal = (normal * global.modelView.mat3()).normalize();
			return normal;
		}

		function vertex() {
			calculatedUV = input.position.xy / primSize;
			calculatedUV = (calculatedUV * (heightMapSize - 2)) / heightMapSize;
			calculatedUV += 0.5 / heightMapSize;
			transformedPosition += (vec3(0,0, heightMap.get(calculatedUV).r) * global.modelView.mat3());
			transformedNormal = getNormal(calculatedUV);
		}

		var emissiveValue : Float;
		var metalnessValue : Float;
		var roughnessValue : Float;
		function fragment() {
			if(usePreview) emissiveValue = previewTex.get(calculatedUV).r * 0.5;
			else emissiveValue = 0;

			metalnessValue = 0.0;
			roughnessValue = 0.5;

			//emissiveValue = heightMap.get(calculatedUV).r;
			//pixelColor = vec4(calculatedUV.xy, 0,0);

			if(showGrid){
				var edge = ((input.position.xy.mod(cellSize) / cellSize ) - 0.5) * 2.0;
				edge = ceil(max(vec2(0), abs(edge) - 0.9));
				emissiveValue = max(edge.x, edge.y);
			}
		}

	};
}

