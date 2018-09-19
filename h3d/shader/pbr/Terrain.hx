package h3d.shader.pbr;

class Terrain extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.BaseMesh;

		@param var previewTex : Sampler2D;
		@param var heightMap : Sampler2D;
		@param var heightMapSize : Float;
		@param var surfaceIndexMap : Sampler2D;
		@param var primSize : Float;
		@param var cellSize : Float;

		@param var albedoTextures : Sampler2DArray;
		@param var normalTextures : Sampler2DArray;
		@param var pbrTextures : Sampler2DArray;
		@param var weightTextures : Sampler2DArray;
		@param var parallaxAmount : Float;
		@param var weightCount : Int;
		@param var surfaceParams : Array<Vec4, 8>;
		@param var secondSurfaceParams : Array<Vec4, 8>;
		@param var tileIndex : Vec2;

		@const var showGrid : Bool;
		@const var useHeightBlend : Bool;

		var calculatedUV : Vec2;
		var terrainUV : Vec2;
		var TBN : Mat3;
		var worldNormal : Vec3;

		function computeNormal(uv: Vec2) : Vec3 {
			var offset = vec2(1.0/heightMapSize, 0) * heightMapSize / (primSize / cellSize);
			var base = heightMap.get(uv).r;
			var ddx = heightMap.get(uv + offset.xy).r;
			var ddy = heightMap.get(uv + offset.yx).r;
			var normal = normalize(vec3(base - ddx, base - ddy, 0.1));
			normal = (normal * global.modelView.mat3()).normalize();
			worldNormal = normal;
			return normal;
		}

		function vertex() {
			calculatedUV = input.position.xy / primSize;
			terrainUV = (calculatedUV * (heightMapSize - 2)) / heightMapSize;
			terrainUV += 0.5 / heightMapSize;
			transformedPosition += (vec3(0,0, heightMap.get(terrainUV).r) * global.modelView.mat3());
			transformedNormal = computeNormal(terrainUV);
			var tangent = normalize(cross(transformedNormal, vec3(0,1,0)));
			var bitangent = normalize(cross(transformedNormal,vec3(1,0,0)));
			TBN = mat3(tangent, bitangent, transformedNormal);
		}

		function getPOMUV( uv : Vec2, surfaceIndex : Int, minLayers : Int, maxLayers : Int, amount: Float) : Vec2 {
			var viewWS = (camera.position - transformedPosition).normalize();
			var viewNS : Vec3;
			{
				var n = transformedNormal.normalize();
				var transformedTangent = normalize(cross(transformedNormal, vec3(0,1,0)));
				var tanX = transformedTangent.xyz.normalize();
				var tanY = n.cross(tanX);
				viewNS = vec3(viewWS.dot(tanX), viewWS.dot(tanY), viewWS.dot(n)).normalize();
			}

			var numLayers = mix(float(maxLayers), float(minLayers), abs(viewNS.z));
			var layerDepth = 1 / numLayers;
			var curLayerDepth = 0.;
			var delta = (viewNS.xy / viewNS.z) * amount / numLayers;
			var curUV = uv;
			var curDepth = 1 - pbrTextures.get(vec3(curUV, surfaceIndex)).a;
			while( curLayerDepth < curDepth ) {
				curUV += delta;
				curDepth =  1 - pbrTextures.get(vec3(curUV, surfaceIndex)).a;
				curLayerDepth += layerDepth;
			}
			var prevUV = curUV - delta;
			var after = curDepth - curLayerDepth;
			var before =  (1 - pbrTextures.get(vec3(prevUV, surfaceIndex)).a) - curLayerDepth + layerDepth;
			return mix(curUV, prevUV, after / (after - before));
		}

		function getsurfaceUV(i : Int, uv : Vec2) : Vec3 {
			var angle = surfaceParams[i].w;
			var offset = vec2(surfaceParams[i].y, surfaceParams[i].z);
			var tilling = surfaceParams[i].x;
			var worldUV = vec2((uv + tileIndex) * tilling) + offset;
			var res = vec2( worldUV.x * cos(angle) - worldUV.y * sin(angle) , worldUV.y * cos(angle) + worldUV.x * sin(angle));
			var surfaceUV = vec3(res, i);
			return surfaceUV;
		}

		var emissiveValue : Float;
		var metalnessValue : Float;
		var roughnessValue : Float;
		var occlusionValue : Float;
		function fragment() {

			if(useHeightBlend){
				var curTexIndex = 0;
				var curWeight = 0.0;
				var curUV = vec2(0);
				for(i in 0...weightCount){
					var uv = getPOMUV(calculatedUV, i, 64, 128, parallaxAmount);
					var h = pbrTextures.get(getsurfaceUV(i, uv)).a;
					var a = weightTextures.get(vec3(uv, i)).r;
					if(h * a > curWeight){
						curTexIndex = i;
						curWeight = h * a;
						curUV = getsurfaceUV(i, uv).xy;
					}
				}
				var albedo = albedoTextures.get(vec3(curUV, curTexIndex)).rgb;
				var normal = unpackNormal(normalTextures.get(vec3(curUV, curTexIndex)).rgba);
				var pbr = pbrTextures.get(vec3(curUV, curTexIndex)).rgba;

				/*var albedo = albedoTextures.get(getsurfaceUV(curTexIndex)).rgb;
				var normal = unpackNormal(normalTextures.get(getsurfaceUV(curTexIndex)).rgba);
				var pbr = pbrTextures.get(getsurfaceUV(curTexIndex)).rgba;*/

				var index : Int = int(surfaceIndexMap.get(calculatedUV).r * 255);
				pixelColor = vec4(albedo, 1.0);
				transformedNormal = normalize(normal) * TBN;
				roughnessValue = 1 - pbr.g * pbr.g;
				metalnessValue = pbr.r;
				occlusionValue = pbr.b;
				emissiveValue = 0;

				if(curWeight <= 0) {
					pixelColor = vec4(0,0,0, 1.0);
					transformedNormal = vec3(0,0,1) * TBN;
					roughnessValue = 1;
					metalnessValue = 0;
					occlusionValue = 1;
					emissiveValue = 0;
				}
			}
			else{
				var albedo = vec3(0);
				var normal = vec4(0);
				var pbr = vec4(0);
				for(i in 0...weightCount){
					var a = weightTextures.get(vec3(calculatedUV, i)).r;
					albedo += albedoTextures.get(getsurfaceUV(i, calculatedUV)).rgb * a;
					pbr += pbrTextures.get(getsurfaceUV(i, calculatedUV)).rgba * a;
					normal += normalTextures.get(getsurfaceUV(i, calculatedUV)).rgba * a;
				}
				normal = vec4(unpackNormal(normal), 0.0);
				pixelColor = vec4(albedo, 0.0);
				transformedNormal = normalize(normal.xyz) * TBN;
				roughnessValue = 1 - pbr.g * pbr.g;
				metalnessValue = pbr.r;
				occlusionValue = pbr.b;
				emissiveValue = 0;
			}

			// Tri-planar Mapping
			/*var coords = vec3(input.position.xy / primSize, heightMap.get(terrainUV).r / primSize);
			var blending = abs( worldNormal );
			blending = normalize(max(blending, 0.00001)); // Force weights to sum to 1.0
			var b = (blending.x + blending.y + blending.z);
			blending /= vec3(b, b, b);
			var xaxis = texture( albedoTextures, vec3(coords.yz, index));
			var yaxis = texture( albedoTextures, vec3(coords.xz, index));
			var zaxis = texture( albedoTextures, vec3(coords.xy, index));
			// blend the results of the 3 planar projections.
			var tex = xaxis * blending.x + yaxis * blending.y + zaxis * blending.z;
			pixelColor = tex;*/

			if(showGrid){
				var gridColor = vec4(1,0,0,1);
				var tileEdgeColor = vec4(1,1,0,1);
				var grid = ((input.position.xy.mod(cellSize) / cellSize ) - 0.5) * 2.0;
				grid = ceil(max(vec2(0), abs(grid) - 0.9));
				var tileEdge = max( (1 - ceil(input.position.xy / primSize - 0.1 / (primSize / cellSize) )), floor(input.position.xy / primSize + 0.1 / (primSize / cellSize)));
				emissiveValue = max(max(grid.x, grid.y), max(tileEdge.x, tileEdge.y));
				pixelColor = mix( pixelColor, gridColor, clamp(0,1,max(grid.x, grid.y)));
				pixelColor = mix( pixelColor, tileEdgeColor, clamp(0,1,max(tileEdge.x, tileEdge.y)));
				metalnessValue =  mix(metalnessValue, 0, emissiveValue);
				roughnessValue = mix(roughnessValue, 1, emissiveValue);
				occlusionValue = mix(occlusionValue, 1, emissiveValue);
				transformedNormal = mix(transformedNormal, vec3(0,0,1), emissiveValue);
			}
		}
	};
}

