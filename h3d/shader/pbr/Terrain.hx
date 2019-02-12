package h3d.shader.pbr;

class Terrain extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.BaseMesh;
		@const var SHOW_GRID : Bool;
		@const var SURFACE_COUNT : Int;
		@const var CHECKER : Bool;
		@const var COMPLEXITY : Bool;

		@param var heightMapSize : Float;
		@param var primSize : Float;
		@param var cellSize : Float;

		@param var albedoTextures : Sampler2DArray;
		@param var normalTextures : Sampler2DArray;
		@param var pbrTextures : Sampler2DArray;
		@param var weightTextures : Sampler2DArray;
		@param var surfaceIndexMap : Sampler2D;
		@param var heightMap : Sampler2D;
		@param var surfaceParams : Array<Vec4, SURFACE_COUNT>;
		@param var secondSurfaceParams : Array<Vec4, SURFACE_COUNT>;

		@param var heightBlendStrength : Float;
		@param var heightBlendSharpness : Float;
		@param var parallaxAmount : Float;
		@param var minStep : Int;
		@param var maxStep : Int;
		@param var tileIndex : Vec2;

		var calculatedUV : Vec2;
		var terrainUV : Vec2;
		var TBN : Mat3;

		var emissiveValue : Float;
		var metalnessValue : Float;
		var roughnessValue : Float;
		var occlusionValue : Float;

		function vertex() {
			calculatedUV = input.position.xy / primSize;
			var terrainUV = (calculatedUV * (heightMapSize - 1)) / heightMapSize;
			terrainUV += 0.5 / heightMapSize;
			transformedPosition += (vec3(0,0, textureLod(heightMap, terrainUV, 0).r) * global.modelView.mat3());
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
			var delta = (viewNS.xy / viewNS.z) * parallaxAmount / numLayers;
			var curUV = uv;
			var curDepth = 1 - pbrTextures.get(getsurfaceUV(surfaceIndex, curUV)).a;
			while( curLayerDepth < curDepth ) {
				curUV += delta;
				curDepth =  1 - pbrTextures.getLod( getsurfaceUV(surfaceIndex, curUV), 0).a;
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

			if( !CHECKER && !COMPLEXITY ) {
				// Extract participating surfaces from the pixel
				var texIndex = surfaceIndexMap.get(calculatedUV).rgb;

				var i1 : Int = int(texIndex.r * 255);
				var uv1 = getPOMUV(calculatedUV, i1);
				var surfaceUV1 = getsurfaceUV(i1, uv1);
				var pbr1 = pbrTextures.get(surfaceUV1).rgba;
				var albedo1 = albedoTextures.get(surfaceUV1).rgb;
				var normal1 = normalTextures.get(surfaceUV1).rgba;
				var h1 = pbr1.a;
				var aw1 = weightTextures.get(vec3(calculatedUV, i1)).r;

				var i2 : Int = int(texIndex.g * 255);
				var aw2 = weightTextures.get(vec3(calculatedUV, i2)).r;

				var i3 : Int = int(texIndex.b * 255);
				var aw3 = weightTextures.get(vec3(calculatedUV, i3)).r;

				// Sum of each surface
				var albedo = vec3(0);
				var normal = vec4(0,0,0,0);
				var pbr = vec4(0);
				var weightSum = 0.0;

				// Keep the surface with the heightest weight for sharpness
				var maxAlbedo = vec3(0);
				var maxPbr = vec4(0);
				var maxNormal = vec4(0);
				var curMaxWeight = -1.0;

				// Alpha / Height Blend
				var b1 = 0.0, b2 = 0.0, b3 = 0.0;
				b1 = mix(aw1, aw1 * h1, heightBlendStrength);
				albedo += albedo1 * b1;
				pbr += pbr1 * b1;
				normal += normal1 * b1;

				// Find the max
				var maxW = clamp(ceil(b1 - curMaxWeight), 0, 1);
				curMaxWeight = mix(curMaxWeight, b1, maxW);
				maxAlbedo = mix(maxAlbedo, albedo1, maxW);
				maxPbr = mix(maxPbr, pbr1, maxW);
				maxNormal = mix(maxNormal, normal1, maxW);

				if(aw2 > 0){
					var uv2 = getPOMUV(calculatedUV, i2);
					var surfaceUV2 = getsurfaceUV(i2, uv2);
					var pbr2 = pbrTextures.get(surfaceUV2).rgba;
					var albedo2 = albedoTextures.get(surfaceUV2).rgb;
					var normal2 = normalTextures.get(surfaceUV2).rgba;
					var h2 = pbr2.a;
					b2 = mix(aw2, aw2 * h2, heightBlendStrength);
					albedo += albedo2 * b2;
					pbr += pbr2 * b2;
					normal += normal2 * b2;
					maxW = clamp(ceil(b2 - curMaxWeight), 0, 1);
					curMaxWeight = mix(curMaxWeight, b2, maxW);
					maxAlbedo = mix(maxAlbedo, albedo2, maxW);
					maxPbr = mix(maxPbr, pbr2, maxW);
					maxNormal = mix(maxNormal, normal2, maxW);
				}

				if(aw3 > 0){
					var uv3 = getPOMUV(calculatedUV, i3);
					var surfaceUV3 = getsurfaceUV(i3, uv3);
					var pbr3 = pbrTextures.get(surfaceUV3).rgba;
					var albedo3 = albedoTextures.get(surfaceUV3).rgb;
					var normal3 = normalTextures.get(surfaceUV3).rgba;
					var h3 = pbr3.a;
					b3 = mix(aw3, aw3 * h3, heightBlendStrength);
					albedo += albedo3 * b3;
					pbr += pbr3 * b3;
					normal += normal3 * b3;
					maxW = clamp(ceil(b3 - curMaxWeight), 0,1);
					curMaxWeight = mix(curMaxWeight, b3, maxW);
					maxAlbedo = mix(maxAlbedo, albedo3, maxW);
					maxPbr = mix(maxPbr, pbr3, maxW);
					maxNormal = mix(maxNormal, normal3, maxW);
				}

				// Normalisation
				weightSum = b1 + b2 + b3;
				albedo /= vec3(weightSum);
				pbr /= vec4(weightSum);
				normal /= vec4(weightSum);

				// Sharpness
				albedo = mix(albedo, maxAlbedo, heightBlendSharpness);
				pbr = mix(pbr, maxPbr, heightBlendSharpness);
				normal = mix(normal, maxNormal, heightBlendSharpness);

				// Output
				normal = vec4(unpackNormal(normal), 0.0);
				pixelColor = vec4(albedo, 1.0);
				transformedNormal = normalize(normal.xyz) * TBN;
				roughnessValue = 1 - pbr.g * pbr.g;
				metalnessValue = pbr.r;
				occlusionValue = pbr.b;
				emissiveValue = 0;
			}

			// DEBUG
			if( CHECKER ) {
				var tile = abs(abs(floor(input.position.x)) % 2 - abs(floor(input.position.y)) % 2);
				pixelColor = vec4(mix(vec3(0.4), vec3(0.1), tile), 1.0);
				transformedNormal = vec3(0,0,1) * TBN;
				roughnessValue = mix(0.9, 0.6, tile);
				metalnessValue = mix(0.4, 0, tile);
				occlusionValue = 1;
				emissiveValue = 0;
			}
			else if( COMPLEXITY ) {
				var blendCount = 0 + weightTextures.get(vec3(0)).r * 0;
				for(i in 0 ... SURFACE_COUNT)
					blendCount += ceil(weightTextures.get(vec3(calculatedUV, i)).r);
				pixelColor = vec4(mix(vec3(0,1,0), vec3(1,0,0), blendCount / 3.0) , 1);
				transformedNormal = vec3(0,0,1) * TBN;
				emissiveValue = 1;
				roughnessValue = 1;
				metalnessValue = 0;
				occlusionValue = 1;
			}
			if( SHOW_GRID ) {
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

