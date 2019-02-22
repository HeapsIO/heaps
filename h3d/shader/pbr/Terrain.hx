package h3d.shader.pbr;

class Terrain extends hxsl.Shader {

	static var SRC = {

		@:import h3d.shader.BaseMesh;
		@const var SHOW_GRID : Bool;
		@const var SURFACE_COUNT : Int;
		@const var CHECKER : Bool;
		@const var COMPLEXITY : Bool;
		@const var PARALLAX : Bool;

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
		@param var blendSharpness : Float;

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

		var tangentViewPos : Vec3;
		var tangentFragPos : Vec3;

		function vertex() {
			calculatedUV = input.position.xy / primSize;
			var terrainUV = (calculatedUV * (heightMapSize - 1)) / heightMapSize;
			terrainUV += 0.5 / heightMapSize;
			transformedPosition += (vec3(0,0, textureLod(heightMap, terrainUV, 0).r) * global.modelView.mat3());
			TBN = mat3(normalize(cross(transformedNormal, vec3(0,1,0))), normalize(cross(transformedNormal,vec3(-1,0,0))), transformedNormal);
			tangentViewPos = camera.position * TBN;
			tangentFragPos = transformedPosition * TBN;
		}

		function getWeight( i : Vec3,  uv : Vec2 ) : Vec3 {
			var weight = vec3(0);
			weight.x = weightTextures.getLod(vec3(uv, i.x), 0).r;
			if( i.y != i.x ) weight.y = weightTextures.getLod(vec3(uv, i.y), 0).r;
			if( i.z != i.x ) weight.z = weightTextures.getLod(vec3(uv, i.z), 0).r;
			return weight;
		}

		function getDepth( i : Vec3,  uv : Vec2 ) : Vec3 {
			var depth = vec3(0);
			if( w.x > 0 ) depth.x = pbrTextures.getLod(getsurfaceUV(i.x, uv), 0).a;
			if( w.y > 0 ) depth.y = pbrTextures.getLod(getsurfaceUV(i.y, uv), 0).a;
			if( w.z > 0 ) depth.z = pbrTextures.getLod(getsurfaceUV(i.z, uv), 0).a;
			return 1 - depth;
		}

		var w : Vec3;
		var i : Vec3;
		function getPOMUV( i : Vec3, uv : Vec2 ) : Vec2 {
			if( !PARALLAX )
				return uv;
			else {
				var viewDir = normalize(tangentViewPos - tangentFragPos);
				var numLayers = mix(float(maxStep), float(minStep), viewDir.dot(transformedNormal));
				var layerDepth = 1 / numLayers;
				var curLayerDepth = 0.;
				var delta = (viewDir.xy / viewDir.z) * parallaxAmount / numLayers;
				var curUV = uv;
				var depth = getDepth(i, curUV);
				var curDepth = depth.dot(w);
				var prevDepth = 0.;
				while( curLayerDepth < curDepth ) {
					curUV += delta;
					prevDepth = curDepth;
					i = surfaceIndexMap.getLod(curUV, 0).rgb * 255;
					w = getWeight(i, curUV);
					depth = getDepth(i, curUV);
					curDepth = depth.dot(w);
					curLayerDepth += layerDepth;
				}
				var prevUV = curUV - delta;
				var after = curDepth - curLayerDepth;
				var before = prevDepth - curLayerDepth + layerDepth;
				var pomUV = mix(curUV, prevUV,  after / (after - before));
				return pomUV;
			}
		}

		function getsurfaceUV( i : Float, uv : Vec2 ) : Vec3 {
			var id = int(i);
			var angle = surfaceParams[id].w;
			var offset = vec2(surfaceParams[id].y, surfaceParams[id].z);
			var tilling = surfaceParams[id].x;
			var worldUV = (uv + tileIndex) * tilling + offset;
			var res = vec2( worldUV.x * cos(angle) - worldUV.y * sin(angle) , worldUV.y * cos(angle) + worldUV.x * sin(angle));
			var surfaceUV = vec3(res % 1, i);
			return surfaceUV;
		}

		function fragment() {

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
			else {
				i = surfaceIndexMap.get(calculatedUV).rgb * 255;
				w = getWeight(i, calculatedUV);
				var pomUV = getPOMUV(i, calculatedUV);
				if( PARALLAX ) {
					i = surfaceIndexMap.get(pomUV).rgb * 255;
					w = getWeight(i, pomUV);
				}
				var h = vec3(0);
				var surfaceUV1 = getsurfaceUV(i.x, pomUV);
				var surfaceUV2 = getsurfaceUV(i.y, pomUV);
				var surfaceUV3 = getsurfaceUV(i.z, pomUV);
				var pbr1 = vec4(0), pbr2 = vec4(0), pbr3 = vec4(0);
				if( w.x > 0 ) pbr1 = pbrTextures.get(surfaceUV1).rgba;
				if( w.y > 0 ) pbr2 = pbrTextures.get(surfaceUV2).rgba;
				if( w.z > 0 ) pbr3 = pbrTextures.get(surfaceUV3).rgba;

				// Height Blend
				var h = vec3( 	secondSurfaceParams[i.x].x + pbr1.a * (secondSurfaceParams[i.x].y - secondSurfaceParams[i.x].x),
								secondSurfaceParams[i.y].x + pbr2.a * (secondSurfaceParams[i.y].y - secondSurfaceParams[i.y].x),
								secondSurfaceParams[i.z].x + pbr3.a * (secondSurfaceParams[i.z].y - secondSurfaceParams[i.z].x));
				w = mix(w, vec3(w.x * h.x, w.y * h.y, w.z * h.z), heightBlendStrength);

				// Sharpness
				var m = max(w.x, max(w.y, w.z));
				var mw = ceil(w - m + 0.01);
				w = mix(w, mw, blendSharpness);

				// Blend
				var albedo = vec3(0);
				var normal = vec4(0);
				var pbr = vec4(0);
				if( w.x > 0 ) {
					albedo += albedoTextures.get(surfaceUV1).rgb * w.x;
					normal += normalTextures.get(surfaceUV1).rgba * w.x;
					pbr += pbr1 * w.x;
				}
				if( w.y > 0 ) {
					albedo += albedoTextures.get(surfaceUV2).rgb * w.y;
					normal += normalTextures.get(surfaceUV2).rgba * w.y;
					pbr += pbr2 * w.y;
				}
				if( w.z > 0 ) {
					albedo += albedoTextures.get(surfaceUV3).rgb * w.z;
					normal += normalTextures.get(surfaceUV3).rgba * w.z;
					pbr += pbr3 * w.z;
				}
				var wSum = w.x + w.y + w.z;
				albedo /= wSum;
				pbr /= wSum;
				normal /= wSum;

				// Output
				normal = vec4(unpackNormal(normal), 0.0);
				pixelColor = vec4(albedo, 1.0);
				transformedNormal = normalize(normal.xyz) * TBN;
				roughnessValue = 1 - pbr.g * pbr.g;
				metalnessValue = pbr.r;
				occlusionValue = pbr.b;
				emissiveValue = 0;
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

