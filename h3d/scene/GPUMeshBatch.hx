package h3d.scene;

import h3d.scene.MeshBatch.BatchData;

class GPUMeshBatch extends MeshBatch {

	static var INDIRECT_DRAW_ARGUMENTS_FMT = hxd.BufferFormat.make([{ name : "", type : DVec4 }, { name : "", type : DFloat }]);
	static var INSTANCES_INFOS_FMT = hxd.BufferFormat.make([{ name : "", type : DFloat }]);
	inline static var INSTANCES_INFOS_ELEMENT_COUNT = 1;
	inline static var SUB_MESHES_INFOS_ELEMENT_COUNT = 4;
	inline static var SUB_PARTS_INFOS_ELEMENT_COUNT = 4;

	var cpuInstancesInfos : haxe.io.Bytes;
	var gpuInstancesInfos : h3d.Buffer;

	var subPartsEmitted : Int = 0;
	var materialsEmitted : Array<Float>;

	var subMeshesInfos : h3d.Buffer;
	var subPartsInfos : h3d.Buffer;

	public var computePass : h3d.mat.Pass;
	public var commandBuffer : h3d.Buffer;
	public var gpuCounter : h3d.GPUCounter;

	var gpuLodEnabled : Bool;
	var gpuCullingEnabled : Bool;

	/**
	* If set, clip all instanced behind this distance.
	*/
	public var maxDistance : Float = -1;

	public function new(primitive, ?material, ?parent) {
		super(primitive, material, parent);

		#if (js || (hldx && !dx12))
		throw "Not available on this platform";
		#end

		enableGpuUpdate();
	}

	/**
	 * Enable lod selection at each frame on the gpu using a compute shader.
	 * Has effects only if a lod is available in the primitive.
	 */
	public function enableGpuLod() {
		gpuLodEnabled = primitiveSubMeshes != null || getPrimitive().lodCount() > 1;
		return gpuLodEnabled;
	}

	/**
	 * Enable per instance frustum culling on the gpu using a compute shader.
	 */
	public function enableGpuCulling() {
		gpuCullingEnabled = true;
	}

	function getLodCount() return gpuLodEnabled ? getPrimitive().lodCount() : 1;
	override function updateHasPrimitiveOffset() meshBatchFlags.set(HasPrimitiveOffset);

	override function begin( emitCountTip = -1 ) {
		if ( !gpuLodEnabled && !gpuCullingEnabled )
			throw "No need to create a GPUMeshBatch without gpu lod nor gpu culling, create a regular MeshBatch instead";
		subPartsEmitted = 0;
		materialsEmitted = [for ( _ in 0...materials.length) 0.0];
		return super.begin(emitCountTip);
	}

	override function initSubMeshResources( emitCountTip ) {
		if ( cpuInstancesInfos == null ) {
			var instanceInfosByteSize = INSTANCES_INFOS_ELEMENT_COUNT << 2;
			cpuInstancesInfos = haxe.io.Bytes.alloc( emitCountTip * instanceInfosByteSize );
		}
	}

	override function emitSubMesh(subMeshIndex : Int) {
		var subMesh = getSubMesh(subMeshIndex);

		var instanceInfosByteSize = INSTANCES_INFOS_ELEMENT_COUNT << 2;
		var minInstanceInfosSize = ( instanceCount + 1 ) * instanceInfosByteSize;
		if ( cpuInstancesInfos.length < minInstanceInfosSize ) {
			var next = haxe.io.Bytes.alloc(Std.int(cpuInstancesInfos.length * 3 / 2));
			next.blit(0, cpuInstancesInfos, 0, cpuInstancesInfos.length);
			cpuInstancesInfos = next;
		}

		subPartsEmitted += subMesh.subParts.length;
		for ( subPart in subMesh.subParts )
			materialsEmitted[subPart.matIndex] += 1.0;

		cpuInstancesInfos.setInt32(instanceCount << 2, subMeshIndex);
	}

	override function flushSubMeshResources() {
		var alloc = hxd.impl.Allocator.get();
		var upload = needUpload;

		var instancesInfosElementCount = instanceCount * INSTANCES_INFOS_ELEMENT_COUNT ;
		if ( gpuInstancesInfos == null || gpuInstancesInfos.isDisposed() || instancesInfosElementCount > gpuInstancesInfos.vertices ) {
			if ( gpuInstancesInfos != null)
				alloc.disposeBuffer( gpuInstancesInfos );
			gpuInstancesInfos = alloc.allocBuffer( instancesInfosElementCount, INSTANCES_INFOS_FMT, UniformReadWrite );
			upload = true;
		}

		if ( upload )
			gpuInstancesInfos.uploadBytes( cpuInstancesInfos, 0, instancesInfosElementCount );

		if ( subMeshesInfos == null ) {
			var tmpSubMeshesInfos = alloc.allocFloats( SUB_MESHES_INFOS_ELEMENT_COUNT * primitiveSubMeshes.length );

			var pos = 0;
			var subPartsCount = 0;
			var subPartsStart = 0;
			for ( subMesh in primitiveSubMeshes ) {
				tmpSubMeshesInfos[pos++] = subMesh.bounds.dimension() * 0.5;
				tmpSubMeshesInfos[pos++] = subMesh.lodCount;
				tmpSubMeshesInfos[pos++] = subPartsStart;
				tmpSubMeshesInfos[pos++] = subMesh.subParts.length;
				subPartsCount += subMesh.subParts.length;
				subPartsStart += subMesh.subParts.length * subMesh.lodCount;
			}
			subMeshesInfos = alloc.ofFloats( tmpSubMeshesInfos, hxd.BufferFormat.VEC4_DATA, Uniform );
			alloc.disposeFloats(tmpSubMeshesInfos);

			pos = 0;
			var tmpSubPartsInfos = alloc.allocFloats( SUB_PARTS_INFOS_ELEMENT_COUNT * subPartsCount );
			for ( subMesh in primitiveSubMeshes ) {
				var lodCount = subMesh.lodCount;
				var lodConfig = subMesh.lodConfig;
				var lodConfigHasCulling = lodConfig.length > lodCount - 1;
				var minScreenRatioCulling = lodConfigHasCulling ? lodConfig[lodConfig.length - 1] : 0.0;
				for ( subPart in subMesh.subParts ) {
					tmpSubPartsInfos[pos++] = subPart.indexCount;
					tmpSubPartsInfos[pos++] = subPart.indexStart;
					tmpSubPartsInfos[pos++] = 0 < lodConfig.length ? lodConfig[0] : 0.0;
					tmpSubPartsInfos[pos++] = subPart.matIndex;
					for ( i in 1...lodCount ) {
						tmpSubPartsInfos[pos++] = subPart.lodIndexCount[i - 1];
						tmpSubPartsInfos[pos++] = subPart.lodIndexStart[i - 1];
						tmpSubPartsInfos[pos++] = i < lodConfig.length ? lodConfig[i] : 0.0;
						tmpSubPartsInfos[pos++] = subPart.matIndex;
					}
					tmpSubPartsInfos[pos - 2] = minScreenRatioCulling;
				}
			}

			subPartsInfos = alloc.ofFloats( tmpSubPartsInfos, hxd.BufferFormat.VEC4_DATA, Uniform );
			alloc.disposeFloats(tmpSubPartsInfos);
		}
	}

	override function flush() {
		var alloc = hxd.impl.Allocator.get();
		var materialCount = materials.length;

		if ( !hasSubMeshes() ) {
			var prim = getPrimitive();
			if ( gpuLodEnabled ) {
				var lodCount = getLodCount();
				var tmpSubPartsInfos = alloc.allocFloats( SUB_PARTS_INFOS_ELEMENT_COUNT * materialCount * lodCount );
				var hmd = Std.downcast(prim, h3d.prim.HMDModel);
				var lodConfig = hmd.getLodConfig();
				var lodConfigHasCulling = lodConfig.length > lodCount - 1;
				var minScreenRatioCulling = lodConfigHasCulling ? lodConfig[lodConfig.length - 1] : 0.0;
				var pos = 0;
				for ( matIndex in 0...materialCount ) {
					for ( lodIndex in 0...lodCount ) {
						tmpSubPartsInfos[pos++] = hmd.getMaterialIndexCount(matIndex, lodIndex);
						tmpSubPartsInfos[pos++] = hmd.getMaterialIndexStart(matIndex, lodIndex);
						tmpSubPartsInfos[pos++] = lodIndex < lodConfig.length ? lodConfig[lodIndex] : 0.0;
						tmpSubPartsInfos[pos++] = matIndex;
					}
					tmpSubPartsInfos[pos - 2] = minScreenRatioCulling;
				}

				subPartsInfos = alloc.ofFloats( tmpSubPartsInfos, hxd.BufferFormat.VEC4_DATA, Uniform );
				alloc.disposeFloats( tmpSubPartsInfos );
			} else {
				var tmpSubPartsInfos = alloc.allocFloats( SUB_PARTS_INFOS_ELEMENT_COUNT * materialCount );
				var pos : Int = 0;
				for ( i in 0...materials.length ) {
					tmpSubPartsInfos[pos++] = prim.getMaterialIndexCount(i);
					tmpSubPartsInfos[pos++] = prim.getMaterialIndexStart(i);
					tmpSubPartsInfos[pos++] = 0.0;
					tmpSubPartsInfos[pos++] = i;
				}
				subPartsInfos = alloc.ofFloats( tmpSubPartsInfos, hxd.BufferFormat.VEC4_DATA, Uniform );
				alloc.disposeFloats( tmpSubPartsInfos );
			}
		}

		super.flush();

		var computeShader : h3d.shader.InstanceIndirect.InstanceIndirectBase;
		if( computePass == null ) {
			computeShader = hasSubMeshes() ? new h3d.shader.InstanceIndirect.SubPartInstanceIndirect() : new h3d.shader.InstanceIndirect();
			computePass = new h3d.mat.Pass("batchUpdate");
			computePass.addShader(computeShader);
			addComputeShaders(computePass);
		} else {
			computeShader = computePass.getShader(h3d.shader.InstanceIndirect.InstanceIndirectBase);
		}

		computeShader.ENABLE_LOD = gpuLodEnabled;
		computeShader.ENABLE_CULLING = gpuCullingEnabled;
		computeShader.ENABLE_DISTANCE_CLIPPING = maxDistance >= 0;
		computeShader.maxDistance = maxDistance;

		computeShader.subPartsInfos = subPartsInfos;
		computeShader.instanceCount = instanceCount;

		var commandCountNeeded : Int;
		if ( hasSubMeshes() ) {
			commandCountNeeded = subPartsEmitted;
			var computeShader : h3d.shader.InstanceIndirect.SubPartInstanceIndirect = cast computeShader;
			computeShader.MATERIAL_COUNT = materialCount;
			var materialCommandStart = [new h3d.Vector4()];
			for ( i in 1...materialCount )
				materialCommandStart.push(new h3d.Vector4(materialsEmitted[i-1]));
			computeShader.materialCommandStart = materialCommandStart;
			computeShader.subMeshesInfos = subMeshesInfos;
			computeShader.instancesInfos = gpuInstancesInfos;
		} else {
			commandCountNeeded = materialCount * instanceCount;
			var computeShader : h3d.shader.InstanceIndirect = cast computeShader;
			var prim = getPrimitive();
			computeShader.radius = prim.getBounds().dimension() * 0.5;
			computeShader.lodCount = getLodCount();
			computeShader.subPartsCount = materialCount;
		}

		var alloc = hxd.impl.Allocator.get();
		var commandCountAllocated = hxd.Math.nextPOT( commandCountNeeded );
		if ( commandBuffer == null ) {
			commandBuffer = alloc.allocBuffer( commandCountAllocated, INDIRECT_DRAW_ARGUMENTS_FMT, UniformReadWrite );
			gpuCounter = new h3d.GPUCounter( materialCount );
		} else if ( commandBuffer.vertices < commandCountAllocated ) {
			alloc.disposeBuffer( commandBuffer );
			commandBuffer = alloc.allocBuffer( commandCountAllocated, INDIRECT_DRAW_ARGUMENTS_FMT, UniformReadWrite );
		}
	}

	function addComputeShaders( pass : h3d.mat.Pass ) {}

	override function emit(ctx:RenderContext) {
		if ( instanceCount == 0 || (cullingCollider != null && !cullingCollider.inFrustum(ctx.camera.frustum)) )
			return;
		super.emit(ctx);
		if ( commandBuffer != null ) {
			var computeShader = computePass.getShader(h3d.shader.InstanceIndirect.InstanceIndirectBase);
			if ( gpuCullingEnabled )
				computeShader.frustum = ctx.getCameraFrustumBuffer();
			computeShader.instanceData = dataPasses.buffers[0];
			computeShader.commandBuffer = commandBuffer;
			gpuCounter.reset();
			computeShader.countBuffer = gpuCounter.buffer;
			computeShader.ENABLE_COUNT_BUFFER = isCountBufferAllowed();
			ctx.computeList(@:privateAccess computePass.shaders);
			ctx.computeDispatch(hxd.Math.ceil(instanceCount/64.0));
		}
	}

	override function emitPass(ctx : RenderContext, p : BatchData) {
		ctx.emitPass(p.pass, this).index = p.matIndex << 16;
	}

	override function setPassCommand(p : BatchData, bufferIndex : Int) {
		super.setPassCommand(p, bufferIndex);
		if ( commandBuffer != null ) {
			@:privateAccess instanced.commands.data = commandBuffer.vbuf;
			@:privateAccess instanced.commands.countBuffer = gpuCounter.buffer.vbuf;
			@:privateAccess instanced.commands.offset = p.matIndex * instanceCount;
			@:privateAccess instanced.commands.countOffset = p.matIndex;
		}
	}

	inline function isCountBufferAllowed() {
		#if hlsdl
		return h3d.impl.GlDriver.hasMultiIndirectCount;
		#else
		return true;
		#end
	}

	override function cleanPasses() {
		if ( instanced.commands != null )
			@:privateAccess instanced.commands.data = null;

		super.cleanPasses();

		var alloc = hxd.impl.Allocator.get();
		if ( subPartsInfos != null ) {
			alloc.disposeBuffer(subPartsInfos);
			subPartsInfos = null;
		}

		if ( subMeshesInfos != null ) {
			alloc.disposeBuffer(subMeshesInfos);
			subMeshesInfos = null;
		}

		if ( gpuInstancesInfos != null ) {
			alloc.disposeBuffer(gpuInstancesInfos);
			gpuInstancesInfos = null;
		}
		cpuInstancesInfos = null;

		if ( commandBuffer != null )
			alloc.disposeBuffer(commandBuffer);
		if( gpuCounter != null )
			gpuCounter.dispose();
	}
}