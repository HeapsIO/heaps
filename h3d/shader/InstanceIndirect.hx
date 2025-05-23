package h3d.shader;

class InstanceIndirectBase extends hxsl.Shader {
	static var SRC = {

		@global var camera : {
			var position : Vec3;
		}

		@const var ENABLE_COUNT_BUFFER : Bool;
		@param var countBuffer : RWBuffer<Int>;
		@param var commandBuffer : RWBuffer<Int>;
		@param var instanceData : StoragePartialBuffer<{ modelView : Mat4 }>;
		@param var instanceCount : Int;

		// 16 by default because 16 * 4 floats = 256 bytes and cbuffer are aligned to 256 bytes
		@const var MAX_MATERIAL_COUNT : Int = 16;
		// x : indexCount, y : startIndex, z : minScreenRatio, w : in first lod => minScreenRatioCulling
		@param var matInfos : Buffer<Vec4, MAX_MATERIAL_COUNT>;

		@const var ENABLE_CULLING : Bool;
		@param var frustum : Buffer<Vec4, 6>;

		@const var ENABLE_LOD : Bool;

		@const var ENABLE_DISTANCE_CLIPPING : Bool;
		@param var maxDistance : Float = -1;

		var matID : Int = 0;

		var modelView : Mat4;
		var invocID : Int;
		function __init__() {
			{
				setLayout(64, 1, 1);
				invocID = computeVar.workGroup.x * 64 + computeVar.localInvocationIndex;
			}
			modelView = instanceData[invocID].modelView;
		}

		function emitInstance(instanceID : Int, indexCount : Int, instanceCount : Int, startIndex : Int, startVertex : Int, baseInstance : Int ) {
			var instancePos = instanceID * 5;
			commandBuffer[instancePos + 0] = indexCount;
			commandBuffer[instancePos + 1] = instanceCount;
			commandBuffer[instancePos + 2] = startIndex;
			commandBuffer[instancePos + 3] = startVertex;
			commandBuffer[instancePos + 4] = baseInstance;
		}

		function frustumCulling( pos : Vec3, radius : Float ) : Bool {
			var culled = false;
			if ( ENABLE_CULLING ) {
				@unroll for ( i  in 0...6 ) {
					var plane = frustum[i];
					culled = culled || plane.x * pos.x + plane.y * pos.y + plane.z * pos.z - plane.w < -radius;
				}
			}
			return culled;
		}

		function distanceClipping( distToCam : Float, radius : Float ) : Bool {
			return ( ENABLE_DISTANCE_CLIPPING ) ? distToCam > maxDistance + radius : false;
		}

		function screenRatioCulling( screenRatio : Float ) : Bool {
			var minScreenRatioCulling = getMinScreenRatio();
			return screenRatio < minScreenRatioCulling;
		}

		function getLodCount() : Int {
			return 0;
		}

		function getLodScreenRatio( lod : Int ) : Float {
			return matInfos[lod + matID].z;
		}

		function getMinScreenRatio() : Float {
			return ENABLE_LOD ? matInfos[0].w : 0.0;
		}

		function computeScreenRatio( distToCam : Float, radius : Float ) : Float {
			var screenRatio = radius / distToCam;
			return screenRatio * screenRatio;
		}

		function selectLod( screenRatio : Float, lodCount : Int ) : Int {
			var lod : Int = 0;
			if ( ENABLE_LOD ) {
				for ( i in 0...lodCount ) {
					var minScreenRatio = getLodScreenRatio(i);
					if ( screenRatio > minScreenRatio )
						break;
					lod++;
				}
				lod = clamp(lod, 0, int(lodCount) - 1);
			}
			return lod;
		}
	}
}

class SubPartInstanceIndirect extends InstanceIndirectBase {

	static var SRC = {
		// n : material offset, n + 1 : subPart ID
		@param var instanceOffsets: StorageBuffer<Int>;
		@const var MAX_SUB_PART_BUFFER_ELEMENT_COUNT : Int = 16;
		@param var subPartCount : Int;
		// x : lodCount, y : radius,
		@param var subPartInfos : Buffer<Vec4, MAX_SUB_PART_BUFFER_ELEMENT_COUNT>;

		var lodCount = 0;
		function getLodCount() : Int {
			return lodCount;
		}

		function main() {
			if ( invocID < instanceCount ) {
				var pos = vec3(0) * modelView.mat3x4();
				var vScale = abs(vec3(1) * modelView.mat3x4() - pos);
				var scaledRadius = max(max(vScale.x, vScale.y), vScale.z);
				var toCam = camera.position - pos.xyz;
				var distToCam = length(toCam);

				var id = invocID * 2;
				matID = instanceOffsets[id];
				var subPartID = instanceOffsets[id + 1];
				var subPartInfo = subPartInfos[subPartID / 2];

				var packedID = (subPartID & 1) << 1;
				lodCount = int(subPartInfo[packedID]);
				var radius = subPartInfo[packedID + 1];

				scaledRadius *= radius;
				var culled = dot(scaledRadius, scaledRadius) < 1e-6;

				culled = culled || frustumCulling(pos, scaledRadius);
				culled = culled || distanceClipping(distToCam, scaledRadius);
				var computeScreenRatio = computeScreenRatio(distToCam, scaledRadius);
				culled = culled || screenRatioCulling(computeScreenRatio);

				if ( ENABLE_COUNT_BUFFER ) {
					if ( !culled ) {
						var id = atomicAdd( countBuffer, 0, 1);
						var lod = selectLod(computeScreenRatio, lodCount);
						var matInfo = ivec4(matInfos[lod + matID]);
						emitInstance( id, matInfo.x, 1, matInfo.y, 0, invocID );
					}
				} else {
					if ( !culled ) {
						var lod = selectLod(computeScreenRatio, lodCount);
						var matInfo = ivec4(matInfos[lod + matID]);
						emitInstance( invocID, matInfo.x, 1, matInfo.y, 0, invocID );
					} else {
						emitInstance( invocID, 0, 0, 0, 0, 0 );
					}
				}
			}
		}
	}
}

class InstanceIndirect extends InstanceIndirectBase {
	static var SRC = {
		@param var radius : Float;
		@param var materialCount : Int;
		@param var lodCount : Int = 1;

		function getLodCount() : Int {
			return lodCount;
		}

		function main() {
			if ( invocID < instanceCount ) {
				var pos = vec3(0) * modelView.mat3x4();
				var vScale = abs(vec3(1) * modelView.mat3x4() - pos);
				var scaledRadius = max(max(vScale.x, vScale.y), vScale.z);
				var toCam = camera.position - pos.xyz;
				var distToCam = length(toCam);

				scaledRadius *= radius;
				var culled = dot(scaledRadius, scaledRadius) < 1e-6;

				culled = culled || frustumCulling(pos, scaledRadius);
				culled = culled || distanceClipping(distToCam, scaledRadius);
				var computeScreenRatio = computeScreenRatio(distToCam, scaledRadius);
				culled = culled || screenRatioCulling(computeScreenRatio);

				if ( ENABLE_COUNT_BUFFER ) {
					if ( !culled ) {
						var id = atomicAdd( countBuffer, 0, 1);
						for ( i in 0...materialCount ) {
							matID = i * lodCount;
							var lod = selectLod(computeScreenRatio, lodCount);
							var matInfo = ivec4(matInfos[lod + matID]);
							var instanceID = id + i * instanceCount;
							emitInstance( instanceID, matInfo.x, 1, matInfo.y, 0, invocID );
						}
					}
				} else {
					if ( !culled ) {
						for ( i in 0...materialCount ) {
							matID = i * lodCount;
							var lod = selectLod(computeScreenRatio, lodCount);
							var matInfo = ivec4(matInfos[lod + matID]);
							var instanceID = invocID + i * instanceCount;
							emitInstance( instanceID, matInfo.x, 1, matInfo.y, 0, invocID );
						}
					} else {
						for ( i in 0...materialCount ) {
							var instanceID = invocID + i * instanceCount;
							emitInstance( instanceID, 0, 0, 0, 0, 0 );
						}
					}
				}
			}
		}
	}
}