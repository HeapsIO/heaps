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
		@param var weightCount : Int;
		@param var heightBlendStrength : Float;
		@param var heightBlendSharpness : Float;

		@param var parallaxAmount : Float;
		@param var minStep : Int;
		@param var maxStep : Int;

		@param var surfaceParams : Array<Vec4, 8>;
		@param var secondSurfaceParams : Array<Vec4, 8>;
		@param var tileIndex : Vec2;

		@const var showGrid : Bool;

		var calculatedUV : Vec2;
		var terrainUV : Vec2;
		var TBN : Mat3;
		var worldNormal : Vec3;
		var emissiveValue : Float;
		var metalnessValue : Float;
		var roughnessValue : Float;
		var occlusionValue : Float;

		function vertex() {
			terrainUV = input.position.xy / primSize * (heightMapSize - 1) / heightMapSize + 0.5 / heightMapSize;
			calculatedUV = input.position.xy / primSize;
			transformedPosition += (vec3(0,0, heightMap.get(terrainUV).r) * global.modelView.mat3());
			TBN = mat3(normalize(cross(transformedNormal, vec3(0,1,0))), normalize(cross(transformedNormal,vec3(-1,0,0))), transformedNormal);
		}

		function getPOMUV( uv : Vec2, surfaceIndex : Int) : Vec2 {
			var viewWS = (camera.position - transformedPosition).normalize();
			var viewNS : Vec3;
			{
				var n = transformedNormal.normalize();
				var transformedTangent = normalize(cross(transformedNormal, vec3(0,1,0)));
				var tanX = transformedTangent.xyz.normalize();
				var tanY = n.cross(tanX);
				viewNS = vec3(viewWS.dot(tanX), viewWS.dot(tanY), viewWS.dot(n)).normalize();
			}

			var numLayers = mix(float(maxStep), float(minStep), abs(viewNS.z));
			var layerDepth = 1 / numLayers;
			var curLayerDepth = 0.;
			var delta = (viewNS.xy / viewNS.z) * parallaxAmount / numLayers * 1.0/surfaceParams[surfaceIndex].x;
			var curUV = uv;
			var curDepth = 1 - pbrTextures.get(getsurfaceUV(surfaceIndex, curUV)).a;
			while( curLayerDepth < curDepth ) {
				curUV += delta;
				curDepth =  1 - pbrTextures.get(getsurfaceUV(surfaceIndex, curUV)).a;
				curLayerDepth += layerDepth;
			}
			var prevUV = curUV - delta;
			var after = curDepth - curLayerDepth;
			var before = (1 - pbrTextures.get(vec3(prevUV, surfaceIndex)).a) - curLayerDepth + layerDepth;
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

		function fragment() {
			// Extract participating surfaces from the pixel
			var texIndex = surfaceIndexMap.get(calculatedUV).rgb;
			var i1 : Int = int(texIndex.r * 255);
			var i2 : Int = int(texIndex.g * 255);
			var i3 : Int = int(texIndex.b * 255);
			var uv1 = getPOMUV(calculatedUV, i1);
			var uv2 = getPOMUV(calculatedUV, i2);
			var uv3 = getPOMUV(calculatedUV, i3);
			var surfaceUV1 = getsurfaceUV(i1, uv1);
			var surfaceUV2 = getsurfaceUV(i2, uv2);
			var surfaceUV3 = getsurfaceUV(i3, uv3);
			var pbr1 = pbrTextures.get(surfaceUV1).rgba;
			var pbr2 = pbrTextures.get(surfaceUV2).rgba;
			var pbr3 = pbrTextures.get(surfaceUV3).rgba;
			var albedo1 = albedoTextures.get(surfaceUV1).rgb;
			var albedo2 = albedoTextures.get(surfaceUV2).rgb;
			var albedo3 = albedoTextures.get(surfaceUV3).rgb;
			var normal1 = normalTextures.get(surfaceUV1).rgba;
			var normal2 = normalTextures.get(surfaceUV2).rgba;
			var normal3 = normalTextures.get(surfaceUV3).rgba;
			var h1 = pbr1.a;
			var h2 = pbr2.a;
			var h3 = pbr3.a;
			var aw1 = weightTextures.get(vec3(uv1, i1)).r;
			var aw2 = weightTextures.get(vec3(uv2, i2)).r;
			var aw3 = weightTextures.get(vec3(uv3, i3)).r;

			// Sum of each surface
			var albedo = vec3(0);
			var normal = vec4(0,0,0,0);
			var pbr = vec4(0);
			var weightSum = 0 + heightBlendSharpness * 0;

			// Keep the surface with the heightest weight for sharpness
			var maxAlbedo = vec3(0);
			var maxPbr = vec4(0);
			var maxNormal = vec4(0);
			var curMaxWeight = -1.0;

			// Alpha / Height Blend
			var b1 = mix(aw1, aw1 * h1, heightBlendStrength);
			var b2 = mix(aw2, aw2 * h2, heightBlendStrength);
			var b3 = mix(aw3, aw3 * h3, heightBlendStrength);
			albedo += albedo1 * b1;
			albedo += albedo2 * b2;
			albedo += albedo3 * b3;
			pbr += pbr1 * b1;
			pbr += pbr2 * b2;
			pbr += pbr3 * b3;
			normal += normal1 * b1;
			normal += normal2 * b2;
			normal += normal3 * b3;

			// Normalisation
			weightSum = b1 + b2 + b3;
			albedo /= vec3(weightSum);
			pbr /= vec4(weightSum);
			normal /= vec4(weightSum);

			// Find the max
			var maxW = clamp(ceil(b1 - curMaxWeight), 0 ,1);
			curMaxWeight = mix(curMaxWeight, b1, maxW);
			maxAlbedo = mix(maxAlbedo, albedo1, maxW);
			maxPbr = mix(maxPbr, pbr1, maxW);
			maxNormal = mix(maxNormal, normal1, maxW);
			maxW = clamp(ceil(b2 - curMaxWeight), 0 ,1);
			curMaxWeight = mix(curMaxWeight, b2, maxW);
			maxAlbedo = mix(maxAlbedo, albedo2, maxW);
			maxPbr = mix(maxPbr, pbr2, maxW);
			maxNormal = mix(maxNormal, normal2, maxW);
			maxW = clamp(ceil(b3 - curMaxWeight), 0 ,1);
			curMaxWeight = mix(curMaxWeight, b3, maxW);
			maxAlbedo = mix(maxAlbedo, albedo3, maxW);
			maxPbr = mix(maxPbr, pbr3, maxW);
			maxNormal = mix(maxNormal, normal3, maxW);

			// Sharpness
			albedo = mix(albedo, maxAlbedo, heightBlendSharpness);
			pbr = mix(normal, maxPbr, heightBlendSharpness);
			normal = mix(normal, maxNormal, heightBlendSharpness);

			// Output
			normal = vec4(unpackNormal(normal), 0.0);
			pixelColor = vec4(albedo, 0.0);
			//transformedNormal = normalize(normal.xyz) * TBN;
			roughnessValue = 1 - pbr.g * pbr.g;
			metalnessValue = pbr.r;
			occlusionValue = pbr.b;
			emissiveValue = 0;

			if(showGrid){
				var gridColor = vec4(1,0,0,1);
				var tileEdgeColor = vec4(1,1,0,1);
				var grid : Vec2 = ((input.position.xy.mod(cellSize) / cellSize ) - 0.5) * 2.0;
				grid = ceil(max(vec2(0), abs(grid) - 0.9));
				var tileEdge = max( (1 - ceil(input.position.xy / primSize - 0.1 / (primSize / cellSize) )), floor(input.position.xy / primSize + 0.1 / (primSize / cellSize)));
				emissiveValue = max(max(grid.x, grid.y), max(tileEdge.x, tileEdge.y));
				pixelColor = mix( pixelColor, gridColor, clamp(0,1,max(grid.x, grid.y)));
				pixelColor = mix( pixelColor, tileEdgeColor, clamp(0,1,max(tileEdge.x, tileEdge.y)));
				metalnessValue =  mix(metalnessValue, 0, emissiveValue);
				roughnessValue = mix(roughnessValue, 1, emissiveValue);
				occlusionValue = mix(occlusionValue, 1, emissiveValue);
				transformedNormal = mix(transformedNormal, vec3(0,1,0), emissiveValue);
			}
		}
	};
}

