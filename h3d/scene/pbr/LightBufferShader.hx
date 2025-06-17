package h3d.scene.pbr;

class LightBufferShader extends hxsl.Shader {
	static var SRC = {
		@global var camera : {
			var view : Mat4;
			var proj : Mat4;
			var position : Vec3;
			var projFlip : Float;
			var projDiag : Vec3;
			var viewProj : Mat4;
			var previousViewProj : Mat4;
			var inverseViewProj : Mat4;
			var zNear : Float;
			var zFar : Float;
			@var var dir : Vec3;
			var jitterOffsets : Vec4;
		};
		@param var inverseProj : Mat4;

		@global var global : {
			var time : Float;
			var pixelSize : Vec2;
		};

		@global var depthMap : Channel;
		@param var depthBuffer : Sampler2D;

		@param var screenSize : Vec2;

		@param var allLights : RWBuffer<Vec4>;
		// TODO : do not copy but indirection
		@param var tileBuffer : RWBuffer<Vec4>;

		@param var MAX_DIR_LIGHT : Int;
		@param var MAX_SPOT_LIGHT : Int;
		@param var MAX_POINT_LIGHT : Int;

		@param var gridSize : Int;
		@param var tileStride : Int;

		@param var dirLightPerTile : Int;
		@param var pointLightPerTile : Int;
		@param var spotLightPerTile : Int;
		@param var dirLightStride : Int;
		@param var pointLightStride : Int;
		@param var spotLightStride : Int;
		
		var frustum : Array<Vec4, 4> = [
			vec4(0.0),
			vec4(0.0),
			vec4(0.0),
			vec4(0.0),
		];
		var minDepthVS : Float;
		var maxDepthVS : Float;

		// TODO : no culling for dir lights so no need to index them
		function cullDirLight() : Bool {
			return false;
		}

		function planeHasSphere(pos : Vec3, radius : Float, planeNormal : Vec3, planeDistance : Float) : Bool {
			return dot(planeNormal, pos) - planeDistance >= -radius;
		}

		function cullPointLight(pos : Vec3, range : Float) : Bool {
			var ppos = vec4(pos, 1.0) * camera.view;
			ppos /= ppos.w;
			var culled = ppos.z < minDepthVS - range || ppos.z > maxDepthVS + range;
			for ( i in 0...4 ) {
				var plane = frustum[i];
				if ( !planeHasSphere(ppos.xyz, range, plane.xyz, plane.w) )
					culled = true;
			}
			return culled;
		}

		function cullSpotLight(pos : Vec3, range : Float) : Bool {
			return false;
		}

		function computeTileFrustum() {
			var X = computeVar.globalInvocation.x;
			var Y = computeVar.globalInvocation.y;
			var tileSize = 1.0 / float(gridSize);

			var minDepth = 1.0;
			var maxDepth = 0.0;

			var pixelPerTile = ivec2(screenSize * tileSize);
			var startPixel = ivec2(vec2(X, Y) * tileSize * screenSize);
			for ( i in 0...pixelPerTile.x ) {
				for ( j in 0...pixelPerTile.y ) {
					var iuv = vec2(i + startPixel.x, j + startPixel.y);
					// fix .fetch for channel so it can replace depthMap.getLod
					var depth = depthBuffer.getLod(iuv / screenSize, 0.0).z;
					minDepth = 0.0;//min(minDepth, depth);
					maxDepth = 1.0;//max(maxDepth, depth);
				}
			}

			minDepthVS = clipToView(vec4(0.0, 0.0, minDepth, 1.0)).z;
			maxDepthVS = clipToView(vec4(0.0, 0.0, maxDepth, 1.0)).z;

			/*
			screenSpace
			[2]---------[3]
			 |           |
			 |           |
			 |           |
			 |           |
			 |           |
			[0]---------[1]
			*/
			var screenSpace : Array<Vec4, 4> = [vec4(0.0),vec4(0.0),vec4(0.0),vec4(0.0)];
			var depth = 1.0;
			screenSpace[0] = vec4(vec2(X, Y) * tileSize, depth, 1.0);
			screenSpace[1] = vec4(vec2(X+1, Y) * tileSize, depth, 1.0);
			screenSpace[2] = vec4(vec2(X, Y+1) * tileSize, depth, 1.0);
			screenSpace[3] = vec4(vec2(X+1, Y+1) * tileSize, depth, 1.0);

			var viewSpace : Array<Vec3, 4> = [vec3(0.0),vec3(0.0),vec3(0.0),vec3(0.0)];
			@unroll for ( i in 0...4 )
				viewSpace[i] = screenToView(screenSpace[i]);

			/*
			frustum planes
			 -----[3]-----
			 |           |
			 |           |
			[0]         [1]
			 |           |
			 |           |
			 -----[2]-----
			*/
			frustum[0] = computePlane(vec3(0.0), viewSpace[2], viewSpace[0]);
			frustum[1] = computePlane(vec3(0.0), viewSpace[1], viewSpace[3]);
			frustum[2] = computePlane(vec3(0.0), viewSpace[0], viewSpace[1]);
			frustum[3] = computePlane(vec3(0.0), viewSpace[3], viewSpace[2]);
		}

		function computePlane(p0 : Vec3, p1 : Vec3, p2 : Vec3) : Vec4 {
			var v1 = p1 - p0;
			var v2 = p2 - p0;
			var n = normalize(cross(v2, v1));
			// distance is same for all points so pick first arbitrarily
			var d = dot(n, p0);
			return vec4(n, d);
		}

		function screenToView(screen : Vec4) : Vec3 {
			var clip = vec4(uvToScreen(screen.xy), screen.z, screen.w);
			return clipToView(clip);
		}

		function clipToView(clip : Vec4) : Vec3 {
			var view = clip * inverseProj;
			view /= view.w;
			return view.xyz;
		}

		function main() {
			var X = computeVar.globalInvocation.x;
			var Y = computeVar.globalInvocation.y;
			var tileIdx = X + Y * gridSize;
			var tileStartVec4 = tileIdx * tileStride;

			var viewProj = camera.viewProj;

			computeTileFrustum();
			
			for ( i in 0...tileStride ) {
				tileBuffer[tileStartVec4 + i] = vec4(0.0);
			}

			var dirLightCount = 0;
			for ( i in 0...MAX_DIR_LIGHT ) {
				if ( dirLightCount >= dirLightPerTile )
					break;
				var lightStart = i * dirLightStride;
				var v1 = allLights[lightStart + 0];
				var lightColor = v1.xyz;
				var v2 = allLights[lightStart + 1];
				var lightDir = v2.xyz;
				if ( !cullDirLight() ) {
					var lightStartTile = tileStartVec4 + dirLightCount * dirLightStride;
					for ( j in 0...dirLightStride )
						tileBuffer[lightStartTile + j] = allLights[lightStart + j];
					dirLightCount++;
				}
			}

			var pointLightCount = 0;
			for ( i in 0...MAX_POINT_LIGHT ) {
				if ( pointLightCount >= pointLightPerTile )
					break;
				var lightStart = MAX_DIR_LIGHT * dirLightStride + i * pointLightStride;
				var pos = allLights[lightStart + 1].xyz;
				var range = allLights[lightStart + 2].x;
				if ( !cullPointLight(pos, range) ) {
					var lightStartTile = tileStartVec4 + dirLightPerTile * dirLightStride + pointLightCount * pointLightStride;
					for ( j in 0...pointLightStride )
						tileBuffer[lightStartTile + j] = allLights[lightStart + j];
					pointLightCount++;
				}
			}

			var spotLightCount = 0;
			for ( i in 0...MAX_SPOT_LIGHT ) {
				if ( spotLightCount >= spotLightPerTile )
					break;
				var lightStart = MAX_DIR_LIGHT * dirLightStride + MAX_POINT_LIGHT * pointLightStride + i * spotLightStride;
				var v1 = allLights[lightStart + 1];
				var pos = v1.xyz;
				var range = v1.w;
				if ( !cullSpotLight(pos, range) ) {
					var lightStartTile = tileStartVec4 + dirLightPerTile * dirLightStride + pointLightPerTile * pointLightStride + spotLightCount * spotLightStride;
					for ( j in 0...spotLightStride )
						tileBuffer[lightStartTile + j] = allLights[lightStart + j];
					spotLightCount++;
				}
			}

		}
	}
}
