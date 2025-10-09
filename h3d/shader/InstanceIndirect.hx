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

		// x : indexCount, y : indexStart, z : minScreenRatio, w : materialIndex
		@param var subPartsInfos : StorageBuffer<Vec4>;

		@const var ENABLE_CULLING : Bool;
		@param var frustum : Buffer<Vec4, 6>;

		@const var ENABLE_LOD : Bool;

		@const var ENABLE_DISTANCE_CLIPPING : Bool;
		@param var maxDistance : Float = -1;

		var modelView : Mat4;
		var invocID : Int;
		function __init__() {
			{
				setLayout(64, 1, 1);
				invocID = computeVar.workGroup.x * 64 + computeVar.localInvocationIndex;
			}
			modelView = instanceData[invocID].modelView;
		}

		function init() {}

		function getRadius() : Float {
			return 0.0;
		}

		function getLodCount() : Int {
			return 1;
		}

		function getSubPartsStart() : Int {
			return 0;
		}

		function getSubPartsCount() : Int {
			return 1;
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

		function getSubPartInfos( subPartIndex : Int, lod : Int ) : Vec4 {
			var pos = getSubPartsStart() + subPartIndex * getLodCount() + lod;
			return subPartsInfos[pos];
		}

		function getMaterialCommandStart( materialIndex : Int ) : Int {
			return materialIndex * instanceCount;
		}

		function getLodScreenRatio(lod : Int) : Float {
			return getSubPartInfos(0, lod).z;
		}

		function getMinScreenRatio() : Float {
			return ENABLE_LOD ? getSubPartInfos(0, getLodCount() - 1).z : 0.0;
		}

		function computeScreenRatio( distToCam : Float, radius : Float ) : Float {
			var screenRatio = radius / distToCam;
			return screenRatio * screenRatio;
		}

		function selectLod( screenRatio : Float ) : Int {
			var lod : Int = 0;
			if ( ENABLE_LOD ) {
				var lodCount = getLodCount();
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

		function main() {
			if ( invocID < instanceCount ) {
				init();

				var pos = vec3(modelView[0].w, modelView[1].w, modelView[2].w);
				var vScale = abs(vec3(1) * modelView.mat3x4() - pos);
				var scaledRadius = max(max(vScale.x, vScale.y), vScale.z);
				var toCam = camera.position - pos.xyz;
				var distToCam = length(toCam);

				scaledRadius *= getRadius();
				var culled = dot(scaledRadius, scaledRadius) < 1e-6;

				culled = culled || frustumCulling(pos, scaledRadius);
				culled = culled || distanceClipping(distToCam, scaledRadius);
				var screenRatio = computeScreenRatio(distToCam, scaledRadius);
				culled = culled || screenRatioCulling(screenRatio);

				var subPartsCount = getSubPartsCount();
				if ( ENABLE_COUNT_BUFFER ) {
					if ( !culled ) {
						var lod = selectLod(screenRatio);
						for ( subPartIndex in 0...subPartsCount ) {
							var subPartInfo = getSubPartInfos(subPartIndex, lod);
							var materialIndex = int(subPartInfo.w);
							var id = atomicAdd( countBuffer, materialIndex, 1 );
							var materialCommandStart = getMaterialCommandStart(materialIndex);
							emitInstance( materialCommandStart + id, int(subPartInfo.x), 1, int(subPartInfo.y), 0, invocID );
						}
					}
				} else {
					var lod = selectLod(screenRatio);
					for ( subPartIndex in 0...subPartsCount ) {
						var subPartInfo = getSubPartInfos(subPartIndex, lod);
						var materialIndex = int(subPartInfo.w);
						var id = atomicAdd( countBuffer, materialIndex, 1 );
						var materialCommandStart = getMaterialCommandStart(materialIndex);
						if ( !culled )
							emitInstance( materialCommandStart + id, int(subPartInfo.x), 1, int(subPartInfo.y), 0, invocID );
						else
							emitInstance( materialCommandStart + id, 0, 0, 0, 0, 0 );
					}
				}
			}
		}
	}
}

class SubPartInstanceIndirect extends InstanceIndirectBase {
	static var SRC = {
		// n : subMesh index
		@param var instancesInfos: StorageBuffer<Int>;
		// x : radius, y : lodCount, z : subPartsStart, w : subPartsCount
		@param var subMeshesInfos : StorageBuffer<Vec4>;

		@const(32) var MATERIAL_COUNT : Int = 1;
		@param var materialCommandStart : Array<Vec4, MATERIAL_COUNT>;

		var radius : Float;
		var lodCount : Int;
		var subPartsStart : Int;
		var subPartsCount : Int;

		function getRadius() : Float {
			return radius;
		}

		function getLodCount() : Int {
			return lodCount;
		}

		function getSubPartsStart()  : Int{
			return subPartsStart;
		}

		function getSubPartsCount() : Int {
			return subPartsCount;
		}

		function getMaterialCommandStart( materialIndex : Int ) : Int {
			return int(materialCommandStart[materialIndex].x);
		}

		function init() {
			var instanceID = invocID;
			var subMeshIndex = instancesInfos[instanceID];
			var subMeshInfos = subMeshesInfos[subMeshIndex];
			radius = subMeshInfos.x;
			lodCount = int(subMeshInfos.y);
			subPartsStart = int(subMeshInfos.z);
			subPartsCount = int(subMeshInfos.w);
		}
	}
}

class InstanceIndirect extends InstanceIndirectBase {
	static var SRC = {
		@param var radius : Float;
		@param var lodCount : Int = 1;
		@param var subPartsCount : Int;

		var fetchedRadius : Float;
		var fetchedLodCount : Int;
		var fetchedSubPartsCount : Int;

		function init() {
			fetchedRadius = radius;
			fetchedLodCount = lodCount;
			fetchedSubPartsCount = subPartsCount;
		}

		function getRadius() : Float {
			return fetchedRadius;
		}

		function getLodCount() : Int {
			return fetchedLodCount;
		}

		function getSubPartsStart() : Int {
			return 0;
		}

		function getSubPartsCount() : Int {
			return fetchedSubPartsCount;
		}
	}
}