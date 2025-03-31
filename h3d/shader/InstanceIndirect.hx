package h3d.shader;

class InstanceIndirect extends hxsl.Shader {
	static var SRC = {

		@global var camera : {
			var position : Vec3;
		}

		// n : material offset, n + 1 : subPart ID
		@const var ENABLE_COUNT_BUFFER : Bool;
		@param var countBuffer : RWBuffer<Int>;
		@param var instanceOffsets: StorageBuffer<Int>;
		@param var commandBuffer : RWBuffer<Int>;
		@param var instanceData : StoragePartialBuffer<{ modelView : Mat4 }>;
		@param var radius : Float;

		@const var USING_SUB_PART : Bool = false;
		@const var MAX_SUB_PART_BUFFER_ELEMENT_COUNT : Int = 16;
		@param var subPartCount : Int;
		@param var startInstanceOffset : Int;
		// x : lodCount, y : radius,
		@param var subPartInfos : Buffer<Vec4, MAX_SUB_PART_BUFFER_ELEMENT_COUNT>;

		// 16 by default because 16 * 4 floats = 256 bytes and cbuffer are aligned to 256 bytes
		@const var MAX_MATERIAL_COUNT : Int = 16;
		@param var materialCount : Int;
		@param var matIndex : Int;
		// x : indexCount, y : startIndex, z : minScreenRatio, w : in first lod => minScreenRatioCulling
		@param var matInfos : Buffer<Vec4, MAX_MATERIAL_COUNT>;

		@const var ENABLE_CULLING : Bool;
		@param var frustum : Buffer<Vec4, 6>;

		@const var ENABLE_LOD : Bool;
		@param var lodCount : Int = 1;

		@const var ENABLE_DISTANCE_CLIPPING : Bool;
		@param var maxDistance : Float = -1;

		var modelView : Mat4;
		function __init__() {
			modelView = instanceData[computeVar.globalInvocation.x].modelView;
		}

		function main() {
			var invocID = computeVar.globalInvocation.x;
			var lod : Int = 0;
			var pos = vec3(0) * modelView.mat3x4();
			var vScale = abs(vec3(1) * modelView.mat3x4() - pos);
			var scaledRadius = max(max(vScale.x, vScale.y), vScale.z);
			var toCam = camera.position - pos.xyz;
			var distToCam = length(toCam);

			var radius = radius;
			var matOffset = matIndex * lodCount;
			var lodCount = lodCount;

			if ( USING_SUB_PART ) {
				var id = (invocID + startInstanceOffset) * 2;
				matOffset = instanceOffsets[id];
				var subPartID = instanceOffsets[id + 1];
				var subPartInfo = subPartInfos[subPartID / 2];

				var packedID = (subPartID & 1) << 1;
				lodCount = int(subPartInfo[packedID]);
				radius = subPartInfo[packedID + 1];
			}

			scaledRadius *= radius;
			var culled = dot(scaledRadius, scaledRadius) < 1e-6;

			if ( ENABLE_CULLING ) {
				@unroll for ( i  in 0...6 ) {
					var plane = frustum[i];
					culled = culled || plane.x * pos.x + plane.y * pos.y + plane.z * pos.z - plane.w < -scaledRadius;
				}
			}

			if ( ENABLE_DISTANCE_CLIPPING ) {
				culled = culled || distToCam > maxDistance + scaledRadius;
			}

			if ( ENABLE_LOD ) {
				var screenRatio = scaledRadius / distToCam;
				screenRatio = screenRatio * screenRatio;
				var minScreenRatioCulling = matInfos[matOffset].w;
				var culledByScreenRatio = screenRatio < minScreenRatioCulling;
				culled = culled || culledByScreenRatio;
				var lodStart = culledByScreenRatio ? lodCount : 0;
				for ( i in lodStart...lodCount ) {
					var minScreenRatio = matInfos[i + matOffset].z;
					if ( screenRatio > minScreenRatio )
						break;
					lod++;
				}
				lod = clamp(lod, 0, int(lodCount) - 1);
			}

			var matInfo = ivec4(0.0);
			if ( !culled ) {
				matInfo = ivec4(matInfos[lod + matOffset]);
				culled = culled || matInfo.x <= 0;
			}
			if ( ENABLE_COUNT_BUFFER ) {
				if ( !culled ) {
					var id = atomicAdd( countBuffer, 0, 1);
					commandBuffer[ id * 5 ] = matInfo.x;
					commandBuffer[ id * 5 + 1] = 1;
					commandBuffer[ id * 5 + 2] = matInfo.y;
					commandBuffer[ id * 5 + 3] = 0;
					commandBuffer[ id * 5 + 4] = invocID;
				}
			} else {
				if ( !culled ) {
					commandBuffer[ invocID * 5 ] = matInfo.x;
					commandBuffer[ invocID * 5 + 1] = 1;
					commandBuffer[ invocID * 5 + 2] = matInfo.y;
					commandBuffer[ invocID * 5 + 3] = 0;
					commandBuffer[ invocID * 5 + 4] = invocID;
				} else {
					commandBuffer[ invocID * 5 ] = 0;
					commandBuffer[ invocID * 5 + 1] = 0;
					commandBuffer[ invocID * 5 + 2] = 0;
					commandBuffer[ invocID * 5 + 3] = 0;
					commandBuffer[ invocID * 5 + 4] = 0;
				}
			}
		}
	}
}