package h3d.scene;

import h3d.scene.MeshBatch.BatchData;
import h3d.scene.MeshBatch.MeshBatchPart;

class GPUMeshBatch extends MeshBatch {

	static var INDIRECT_DRAW_ARGUMENTS_FMT = hxd.BufferFormat.make([{ name : "", type : DVec4 }, { name : "", type : DFloat }]);
	static var INSTANCE_OFFSETS_FMT = hxd.BufferFormat.make([{ name : "", type : DFloat }]);

	var matInfos : h3d.Buffer;
	var emittedSubParts : Array<MeshBatch.MeshBatchPart>;
	var currentSubParts : Int;
	var currentMaterialOffset : Int;
	var instanceOffsetsCpu : haxe.io.Bytes;
	var instanceOffsetsGpu : h3d.Buffer;
	var subPartsInfos : h3d.Buffer;
	var countBytes : haxe.io.Bytes;
	var materialCount : Int;

	public var computePass : h3d.mat.Pass;
	public var commandBuffer : h3d.Buffer;
	public var countBuffer : h3d.Buffer;

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
		gpuLodEnabled = primitiveSubParts != null || getPrimitive().lodCount() > 1;
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

	override function begin( emitCountTip = -1) {
		if ( !gpuLodEnabled && !gpuCullingEnabled )
			throw "No need to create a GPUMeshBatch without gpu lod nor gpu culling, create a regular MeshBatch instead";

		emitCountTip = super.begin(emitCountTip);

		if ( primitiveSubParts != null && ( gpuCullingEnabled || gpuLodEnabled ) && instanceOffsetsCpu == null ) {
			var size = emitCountTip * 2 * 4;
			instanceOffsetsCpu = haxe.io.Bytes.alloc(size);
		}

		return emitCountTip;
	}

	override function emitPrimitiveSubParts() {
		if ( primitiveSubParts.length > 1 )
			throw "Multi material with gpu instancing is not supported";
		var primitiveSubPart = primitiveSubParts[0];
		if (emittedSubParts == null) {
			currentSubParts = 0;
			currentMaterialOffset = 0;
			emittedSubParts = [ primitiveSubPart.clone() ];
		} else {
			var currentIndexStart = emittedSubParts[currentSubParts].indexStart;
			if ( currentIndexStart != primitiveSubPart.indexStart  ) {
				currentSubParts = -1;
				currentIndexStart = primitiveSubPart.indexStart;
				currentMaterialOffset = 0;
				for ( i => part in emittedSubParts ) {
					if ( part.indexStart == currentIndexStart ) {
						currentSubParts = i;
						break;
					}
					currentMaterialOffset += part.lodIndexCount.length + 1;
				}
				if ( currentSubParts < 0 ) {
					currentSubParts = emittedSubParts.length;
					emittedSubParts.push( primitiveSubPart.clone() );
				}
			}
		}
		var maxInstanceID = ( instanceCount + 1 ) * 2;
		if ( instanceOffsetsCpu.length < maxInstanceID * 4 ) {
			var next = haxe.io.Bytes.alloc(Std.int(instanceOffsetsCpu.length*3/2));
			next.blit(0, instanceOffsetsCpu, 0, instanceOffsetsCpu.length);
			instanceOffsetsCpu = next;
		}
		instanceOffsetsCpu.setInt32((instanceCount * 2 + 0) * 4, currentMaterialOffset);
		instanceOffsetsCpu.setInt32((instanceCount * 2 + 1) * 4, currentSubParts);
	}

	override function flush() {
		var alloc = hxd.impl.Allocator.get();
		var lodCount = getLodCount();
		materialCount = materials.length;
		var prim = getPrimitive();
		var hmd = Std.downcast(prim, h3d.prim.HMDModel);

		if ( emittedSubParts != null ) {
			var upload = needUpload;
			var vertex = instanceCount * 2;
			if ( instanceOffsetsGpu == null || instanceOffsetsGpu.isDisposed() || vertex > instanceOffsetsGpu.vertices ) {
				if ( instanceOffsetsGpu != null)
					alloc.disposeBuffer( instanceOffsetsGpu );
				instanceOffsetsGpu = alloc.allocBuffer( vertex, INSTANCE_OFFSETS_FMT, UniformReadWrite );
				upload = true;
			}
			if ( upload )
				instanceOffsetsGpu.uploadBytes( instanceOffsetsCpu, 0, vertex );

			if ( matInfos == null ) {
				materialCount = 0;
				var tmpSubPartInfos = alloc.allocFloats( 2 * emittedSubParts.length );
				var pos = 0;
				for ( subPart in emittedSubParts ) {
					var lodCount = subPart.lodIndexCount.length + 1;
					tmpSubPartInfos[pos++] = lodCount;
					tmpSubPartInfos[pos++] = subPart.bounds.dimension() * 0.5;
					materialCount += lodCount;
				}
				subPartsInfos = alloc.ofFloats( tmpSubPartInfos, hxd.BufferFormat.VEC4_DATA, Uniform );
				alloc.disposeFloats(tmpSubPartInfos);

				var tmpMatInfos = alloc.allocFloats( 4 * ( materialCount + emittedSubParts.length ) );
				pos = 0;
				for ( subPart in emittedSubParts ) {
					var maxLod = subPart.lodIndexCount.length;
					var lodConfig = subPart.lodConfig;
					tmpMatInfos[pos++] = subPart.indexCount;
					tmpMatInfos[pos++] = subPart.indexStart;
					tmpMatInfos[pos++] = ( 0 < lodConfig.length ) ? lodConfig[0] : 0.0;
					tmpMatInfos[pos++] = ( maxLod < lodConfig.length && maxLod > 0 ) ? lodConfig[lodConfig.length - 1] : 0.0;
					for ( i in 0...maxLod ) {
						tmpMatInfos[pos++] = subPart.lodIndexCount[i];
						tmpMatInfos[pos++] = subPart.lodIndexStart[i];
						tmpMatInfos[pos++] = ( i + 1 < lodConfig.length ) ? lodConfig[i + 1] : 0.0;
						pos++;
					}
				}

				matInfos = alloc.ofFloats( tmpMatInfos, hxd.BufferFormat.VEC4_DATA, Uniform );
				alloc.disposeFloats(tmpMatInfos);
			}
		} else if ( matInfos == null ) {
			if ( gpuLodEnabled ) {
				var tmpMatInfos = alloc.allocFloats( 4 * materialCount * lodCount );
				matInfos = alloc.allocBuffer( materialCount * lodCount, hxd.BufferFormat.VEC4_DATA, Uniform );
				var lodConfig = hmd.getLodConfig();
				var startIndex : Int = 0;
				var lodConfigHasCulling = lodConfig.length > lodCount - 1;
				var minScreenRatioCulling = lodConfigHasCulling ? lodConfig[lodConfig.length-1] : 0.0;
				for ( i => lod in @:privateAccess hmd.lods ) {
					for ( j in 0...materialCount ) {
						var indexCount = lod.indexCounts[j];
						var matIndex = i + j * lodCount;
						tmpMatInfos[matIndex * 4 + 0] = indexCount;
						tmpMatInfos[matIndex * 4 + 1] = startIndex;
						tmpMatInfos[matIndex * 4 + 2] = ( i < lodConfig.length ) ? lodConfig[i] : 0.0;
						tmpMatInfos[matIndex * 4 + 3] = minScreenRatioCulling;
						startIndex += indexCount;
					}
				}
				matInfos.uploadFloats( tmpMatInfos, 0, materialCount * lodCount );
				alloc.disposeFloats( tmpMatInfos );
			} else {
				var tmpMatInfos = alloc.allocFloats( 4 * materialCount );
				matInfos = alloc.allocBuffer( materialCount, hxd.BufferFormat.VEC4_DATA, Uniform );
				var pos : Int = 0;
				for ( i in 0...materials.length ) {
					tmpMatInfos[pos++] = prim.getMaterialIndexCount(i);
					tmpMatInfos[pos++] = prim.getMaterialIndexStart(i);
					pos += 2;
				}
				matInfos.uploadFloats( tmpMatInfos, 0, materialCount );
				alloc.disposeFloats( tmpMatInfos );
			}
		}

		super.flush();

		var computeShader : h3d.shader.InstanceIndirect.InstanceIndirectBase;
		if( computePass == null ) {
			computeShader = emittedSubParts != null ? new h3d.shader.InstanceIndirect.SubPartInstanceIndirect() : new h3d.shader.InstanceIndirect();
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
		computeShader.MAX_MATERIAL_COUNT = 16;
		while ( materialCount * lodCount > computeShader.MAX_MATERIAL_COUNT )
			computeShader.MAX_MATERIAL_COUNT = computeShader.MAX_MATERIAL_COUNT + 16;
		computeShader.matInfos = matInfos;

		if ( emittedSubParts != null ) {
			var computeShader : h3d.shader.InstanceIndirect.SubPartInstanceIndirect = cast computeShader;
			computeShader.subPartCount = emittedSubParts.length;
			computeShader.subPartInfos = subPartsInfos;
			computeShader.instanceOffsets = instanceOffsetsGpu;
			computeShader.MAX_SUB_PART_BUFFER_ELEMENT_COUNT = 16;
			var maxSubPartsElement = hxd.Math.ceil( emittedSubParts.length / 2 );
			while ( maxSubPartsElement > computeShader.MAX_SUB_PART_BUFFER_ELEMENT_COUNT )
				computeShader.MAX_SUB_PART_BUFFER_ELEMENT_COUNT = computeShader.MAX_SUB_PART_BUFFER_ELEMENT_COUNT + 16;
		} else {
			var computeShader : h3d.shader.InstanceIndirect = cast computeShader;
			computeShader.instanceCount = instanceCount;
			computeShader.radius = prim.getBounds().dimension() * 0.5;
			computeShader.lodCount = lodCount;
			computeShader.materialCount = materialCount;
		}

		var alloc = hxd.impl.Allocator.get();
		var commandCountAllocated = hxd.Math.nextPOT( instanceCount * materialCount );
		if ( commandBuffer == null ) {
			commandBuffer = alloc.allocBuffer( commandCountAllocated, INDIRECT_DRAW_ARGUMENTS_FMT, UniformReadWrite );
			countBuffer = alloc.allocBuffer( 1, hxd.BufferFormat.VEC4_DATA, UniformReadWrite );
			if ( countBytes == null ) {
				countBytes = haxe.io.Bytes.alloc(4*4);
				countBytes.setInt32(0, 0);
			}
		} else if ( commandBuffer.vertices < commandCountAllocated ) {
			alloc.disposeBuffer( commandBuffer );
			commandBuffer = alloc.allocBuffer( commandCountAllocated, INDIRECT_DRAW_ARGUMENTS_FMT, UniformReadWrite );
		}

		materialCount = 0;
	}

	function addComputeShaders( pass : h3d.mat.Pass ) {}

	override function emit(ctx:RenderContext) {
		super.emit(ctx);
		if ( commandBuffer != null && instanceCount > 0) {
			var computeShader = computePass.getShader(h3d.shader.InstanceIndirect.InstanceIndirectBase);
			if ( gpuCullingEnabled )
				computeShader.frustum = ctx.getCameraFrustumBuffer();
			computeShader.instanceData = dataPasses.buffers[0];
			computeShader.commandBuffer = commandBuffer;
			countBuffer.uploadBytes(countBytes, 0, 1);
			computeShader.countBuffer = countBuffer;
			computeShader.ENABLE_COUNT_BUFFER = isCountBufferAllowed();
			ctx.computeList(@:privateAccess computePass.shaders);
			ctx.computeDispatch(instanceCount);
		}
	}

	override function emitPass(ctx : RenderContext, p : BatchData) {
		ctx.emitPass(p.pass, this).index = p.matIndex << 16;
	}

	override function setPassCommand(p : BatchData, bufferIndex : Int) {
		super.setPassCommand(p, bufferIndex);
		if ( commandBuffer != null ) {
			@:privateAccess instanced.commands.data = commandBuffer.vbuf;
			@:privateAccess instanced.commands.countBuffer = countBuffer.vbuf;
			@:privateAccess instanced.commands.offset = p.matIndex * instanceCount;
			@:privateAccess instanced.commands.countOffset = 0;
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
		if ( matInfos != null ) {
			alloc.disposeBuffer(matInfos);
			matInfos = null;
		}

		if ( subPartsInfos != null )
			alloc.disposeBuffer(subPartsInfos);

		if ( instanceOffsetsGpu != null )
			alloc.disposeBuffer(instanceOffsetsGpu);
		instanceOffsetsCpu = null;

		if ( commandBuffer != null )
			alloc.disposeBuffer(commandBuffer);
		if ( countBuffer != null )
			alloc.disposeBuffer(countBuffer);

		emittedSubParts = null;
		countBytes = null;
	}
}