package h3d.scene;

enum MeshBatchFlag {
	EnableResizeDown;
	EnableGpuUpdate;
	EnableStorageBuffer;
	HasPrimitiveOffset;
	EnableCpuLod;
	ForceGpuUpdate;
	EnableSubMesh;
}

typedef CpuIndirectCallBuffer = { bytes : haxe.io.Bytes, count : Int };

/**
	h3d.scene.MeshBatch allows to draw multiple meshed in a single draw call.
	See samples/MeshBatch.hx for an example.
**/
class MeshBatch extends MultiMaterial {

	static var modelViewID = hxsl.Globals.allocID("global.modelView");
	static var modelViewInverseID = hxsl.Globals.allocID("global.modelViewInverse");
	static var previousModelViewID = hxsl.Globals.allocID("global.previousModelView");
	static var BATCH_START_FMT = hxd.BufferFormat.make([{ name : "Batch_Start", type : DFloat }]);
	inline static var MAX_BUFFER_ELEMENTS = 4096;
	inline static var MAX_STORAGE_BUFFER_ELEMENTS = 128 * 1024 * 1024 >> 2;
	inline static var DEFAULT_EMIT_COUNT_TIP = 128;

	var instanced : h3d.prim.Instanced;
	var dataPasses : BatchData;
	var needUpload = false;
	var instancedParams : hxsl.Cache.BatchInstanceParams;
	var meshBatchFlags(default, null) : haxe.EnumFlags<MeshBatchFlag>;

	/**
		Set if shader list or shader constants has changed, before calling begin()
	**/
	public var shadersChanged = true;

	/**
		The number of instances on this batch
	**/
	public var instanceCount(default,null) : Int = 0;

	/**
	 * 	If set, use this position in emitInstance() instead MeshBatch absolute position
	**/
	public var worldPosition : Matrix;

	/**
		Tells the mesh batch to draw only a subpart of the primitive.
	**/
	public var primitiveSubMeshes : Array<SubMesh>;
	public var curSubMesh : Int = -1;

	/**
		Use one indirect call buffer per material.
		Instances can not be culled for a specific pass yet.
	**/
	var cpuIndirectCallBuffers : Array<CpuIndirectCallBuffer>;
	var gpuIndirectCallBuffers : Array<h3d.impl.InstanceBuffer>;

	/**
		If set, exact bounds will be recalculated during emitInstance (default true)
	**/
	public var calcBounds = true;

	/**
	 	With EnableCpuLod, set the lod of the next emitInstance.
		Without EnableCpuLod and not using primitiveSubMeshes, set the lod of the whole batch.
	**/
	public var curLod : Int = -1;

	public function new( primitive, ?material, ?parent ) {
		instanced = new h3d.prim.Instanced();
		instanced.commands = new h3d.impl.InstanceBuffer();
		instanced.setMesh(primitive);
		super(instanced, material == null ? null : [material], parent);
		for( p in this.material.getPasses() )
			@:privateAccess p.batchMode = true;
	}

	/**
	 * Buffer of per instance params such as position is created as a storage buffer
	 * allowing for huge amount of instances.
	 */
	public function enableStorageBuffer() {
		meshBatchFlags.set(EnableStorageBuffer);
	}

	/**
	 * Buffer of per instance params such as position is created with its own format
	 * allowing compute shaders to update those parameters.
	 */
	public function enableGpuUpdate() {
		meshBatchFlags.set(EnableGpuUpdate);
		meshBatchFlags.set(EnableStorageBuffer);
	}

	/**
	 * Force PerInstance to be setup by a compute shader.
	 * Don't support without Storage Buffer to simplify implementation.
	 */
	public function forceGpuUpdate() {
		meshBatchFlags.set(EnableGpuUpdate);
		meshBatchFlags.set(EnableStorageBuffer);
		meshBatchFlags.set(ForceGpuUpdate);
	}

	/**
	 * Use sub mesh to emit instance.
	 * Don't support multiple materials without Storage Buffer to simplify implementation.
	**/
	public function enableSubMesh() {
		meshBatchFlags.set(EnableSubMesh);
		if ( materials.length > 1 )
			meshBatchFlags.set(EnableStorageBuffer);
	}

	public function enableCpuLod() {
		var prim = getPrimitive();
		var lodCount = prim.lodCount();
		if ( lodCount <= 1 )
			return;
		if ( partsFromPrimitive(prim) ) {
			meshBatchFlags.set(EnableCpuLod);
			meshBatchFlags.set(EnableStorageBuffer);
		}
	}

	function getPrimitive() return @:privateAccess instanced.primitive;
	function storageBufferEnabled() return meshBatchFlags.has(EnableStorageBuffer);
	function gpuUpdateEnabled() return meshBatchFlags.has(EnableGpuUpdate);
	function gpuUpdateForced() return meshBatchFlags.has(ForceGpuUpdate);
	function getMaxElements() return storageBufferEnabled() ? MAX_STORAGE_BUFFER_ELEMENTS : MAX_BUFFER_ELEMENTS;
	function hasPrimitiveOffset() return meshBatchFlags.has(HasPrimitiveOffset);
	function hasSubMeshes() return meshBatchFlags.has(EnableSubMesh);
	function cpuLodEnabled() return meshBatchFlags.has(EnableCpuLod);

	inline function shouldResizeDown( currentSize : Int, minSize : Int ) : Bool {
		return meshBatchFlags.has(EnableResizeDown) && currentSize > minSize << 1;
	}

	public function begin( emitCountTip = -1 ) : Int {
		instanceCount = 0;

		if ( emitCountTip < 0 )
			emitCountTip = DEFAULT_EMIT_COUNT_TIP;

		if ( primitiveSubMeshes != null )
			enableSubMesh();

		instanced.initBounds();
		if( shadersChanged ) {
			initShadersMapping();
			shadersChanged = false;
		}

		var p = dataPasses;
		var alloc = hxd.impl.Allocator.get();
		while( p != null ) {
			var size = emitCountTip * p.paramsCount * 4;
			if( p.data == null || p.data.length < size || shouldResizeDown(p.data.length, size) ) {
				if( p.data != null ) alloc.disposeFloats(p.data);
				p.data = alloc.allocFloats(size);
			}
			p = p.next;
		}

		if ( hasSubMeshes() )
			initSubMeshResources( emitCountTip );

		return emitCountTip;
	}

	function initSubMeshResources( emitCountTip ) {
		if ( cpuIndirectCallBuffers == null ) {
			var instanceSize = emitCountTip * h3d.impl.InstanceBuffer.ELEMENT_SIZE;
			cpuIndirectCallBuffers = [for ( _ in 0...materials.length ) { bytes : haxe.io.Bytes.alloc(instanceSize), count : 0 }];
		} else {
			for ( cpuIndirectCallBuffer in cpuIndirectCallBuffers )
				cpuIndirectCallBuffer.count = 0;
		}
	}

	function initShadersMapping() {
		var scene = getScene();
		if( scene == null ) return;
		cleanPasses();
		updateHasPrimitiveOffset();
		for( index in 0...materials.length ) {
			var mat = materials[index];
			if( mat == null ) continue;
			for( p in mat.getPasses() ) @:privateAccess {
				var ctx = scene.renderer.getPassByName(p.name);
				if( ctx == null ) continue;

				var output = ctx.output;
				var shaders = p.getShadersRec();
				var rt = output.compileShaders(scene.ctx.globals, shaders, Default);
				var shader = output.shaderCache.makeBatchShader(rt, shaders, instancedParams);

				var b = createBatchData();
				b.paramsCount = shader.paramsSize;
				b.maxInstance = Std.int( getMaxElements() / b.paramsCount);
				b.bufferFormat = hxd.BufferFormat.VEC4_DATA;
				if( b.maxInstance <= 0 )
					throw "Mesh batch shaders needs at least one perInstance parameter";
				b.params = shader.params;
				b.shader = shader;
				b.pass = p;
				b.matIndex = index;
				b.shaders = [null/*link shader*/];
				p.dynamicParameters = true;
				p.batchMode = true;

				if ( gpuUpdateEnabled() )
					calcBufferFormat(b);

				b.next = dataPasses;
				dataPasses = b;

				var sl = shaders;
				while( sl != null ) {
					b.shaders.push(sl.s);
					sl = sl.next;
				}
				shader.Batch_UseStorage = storageBufferEnabled();
				shader.Batch_Count = storageBufferEnabled() ? 0 : b.maxInstance * b.paramsCount;
				shader.Batch_HasOffset = hasPrimitiveOffset();
				shader.constBits = (shader.Batch_Count << 2) | (shader.Batch_UseStorage ? ( 1 << 1 ) : 0) | (shader.Batch_HasOffset ? 1 : 0);
				shader.updateConstants(null);

				@:privateAccess b.pass.addSelfShader(b.shader);
			}

		}
	}

	function updateHasPrimitiveOffset() meshBatchFlags.setTo(HasPrimitiveOffset, hasSubMeshes());

	function createBatchData() {
		return new BatchData();
	}

	function calcBufferFormat(b : BatchData) {
		var pl = [];
		var p = b.params;
		while( p != null ) {
			pl.push(p);
			p = p.next;
		}
		pl.sort(function(p1,p2) return p1.pos - p2.pos);
		var fmt : Array<hxd.BufferFormat.BufferInput> = [];
		var curPos = 0;
		var paddingIndex = 0;
		for( p in pl ) {
			var paddingSize = p.pos - curPos;
			if ( paddingSize > 0 ) {
				var paddingType : hxsl.Ast.Type = switch ( paddingSize ) {
				case 1:
					TFloat;
				case 2,3:
					TVec(paddingSize, VFloat);
				default:
					throw "Buffer has padding";
				}
				var t = hxd.BufferFormat.InputFormat.fromHXSL(paddingType);
				fmt.push(new hxd.BufferFormat.BufferInput("padding_"+paddingIndex,t));
				paddingIndex++;
				curPos = p.pos;
			}
			var name = p.name;
			var prev = fmt.length;
			switch( p.type ) {
			case TMat3:
				for( i in 0...3 )
					fmt.push(new hxd.BufferFormat.BufferInput(name+"__m"+i,DVec3));
			case TMat3x4:
				for( i in 0...3 )
					fmt.push(new hxd.BufferFormat.BufferInput(name+"__m"+i,DVec4));
			case TMat4:
				for( i in 0...4 )
					fmt.push(new hxd.BufferFormat.BufferInput(name+"__m"+i,DVec4));
			default:
				var t = hxd.BufferFormat.InputFormat.fromHXSL(p.type);
				fmt.push(new hxd.BufferFormat.BufferInput(p.name,t));
			}
			for( i in prev...fmt.length )
				curPos += fmt[i].getBytesSize() >> 2;
		}
		if ( curPos & 3 != 0 ) {
			var paddingSize = 4 - (curPos & 3);
			var paddingType : hxsl.Ast.Type = switch ( paddingSize ) {
			case 1:
				TFloat;
			case 2,3:
				TVec(paddingSize, VFloat);
			default:
				throw "Buffer has padding";
			}
			var t = hxd.BufferFormat.InputFormat.fromHXSL(paddingType);
			fmt.push(new hxd.BufferFormat.BufferInput("padding_"+paddingIndex,t));
		}
		b.bufferFormat = hxd.BufferFormat.make(fmt);
	}

	public function emitInstance() {
		// When using sub meshes we need to fill the indirect call buffers for multi draw
		if( hasSubMeshes() )
			emitSubMesh(curSubMesh);

		// Instance data can be filled from the GPU
		if( !gpuUpdateForced() ) {

			if ( !hasSubMeshes() && calcBounds)
				instanced.addInstanceBounds(worldPosition == null ? absPos : worldPosition);

			// Use the mesh batch abs pos if no world position has been set.
			if ( worldPosition == null )
				syncPos();

			syncData();
		}

		instanceCount++;
	}

	function getSubMesh( subMeshIndex : Int ) : SubMesh {
		return primitiveSubMeshes[subMeshIndex];
	}

	function emitSubMesh(subMeshIndex : Int) {
		if ( cpuIndirectCallBuffers == null )
			throw "Something went wrong during the initialization";
		if ( subMeshIndex < 0 || subMeshIndex >= primitiveSubMeshes.length )
			throw "Invalid subMeshIndex";

		var subMesh = getSubMesh(subMeshIndex);
		var subParts = subMesh.subParts;
		if(calcBounds) @:privateAccess {
			instanced.tmpBounds.load(subMesh.bounds);
			instanced.tmpBounds.transform(worldPosition == null ? absPos : worldPosition);
			instanced.bounds.add(instanced.tmpBounds);
		}

		var instanceSize = h3d.impl.InstanceBuffer.ELEMENT_SIZE;
		for ( subPart in subParts ) {
			var indexCount = subPart.indexCount;
			var indexStart = subPart.indexStart;
			if ( curLod >= 0 && cpuLodEnabled() ) {
				indexStart = subPart.lodIndexStart[curLod];
				indexCount = subPart.lodIndexCount[curLod];
			}

			if ( indexCount == 0 && storageBufferEnabled() )
				continue;

			var matIndex = subPart.matIndex;
			var indirectCallBuffer = cpuIndirectCallBuffers[matIndex];

			// Resize
			var count = indirectCallBuffer.count++;
			var pos = count * instanceSize;
			var minIndirectCallBufferSize = pos + instanceSize;
			if ( indirectCallBuffer.bytes.length < minIndirectCallBufferSize ) {
				var next = haxe.io.Bytes.alloc(Std.int((indirectCallBuffer.bytes.length * 3 / 2)));
				next.blit(0, indirectCallBuffer.bytes, 0, pos);
				indirectCallBuffer.bytes = next;
			}

			// Emit
			var bytes = indirectCallBuffer.bytes;
			bytes.setInt32(pos, indexCount);
			bytes.setInt32(pos + 4, 1);
			bytes.setInt32(pos + 8, indexStart);
			bytes.setInt32(pos + 12, 0);
			bytes.setInt32(pos + 16, instanceCount);

			cpuIndirectCallBuffers[matIndex] = indirectCallBuffer;
		}

		// To clean
		instanced.commands = null;
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		if( instanceCount == 0 ) return;
		flush();
	}

	function flushSubMeshResources() {
		if ( !storageBufferEnabled() )
			throw "Storage buffer must be set to use per material indirect call buffers";

		if ( gpuIndirectCallBuffers == null )
			gpuIndirectCallBuffers = [for ( i in 0...materials.length ) new h3d.impl.InstanceBuffer()];

		for ( matIndex in 0...materials.length ) {
			var cpuIndirectCallBuffer = cpuIndirectCallBuffers[matIndex];
			var gpuIndirectCallBuffer = gpuIndirectCallBuffers[matIndex];

			// Upload indirect call buffer
			var count = cpuIndirectCallBuffer.count;
			if ( needUpload || gpuIndirectCallBuffer.commandCount != count ) {
				var bytes = cpuIndirectCallBuffer.bytes;
				if ( count == 0 ) {
					count = 1;
					bytes.setInt32(0,  0);
					bytes.setInt32(4,  0);
					bytes.setInt32(8,  0);
					bytes.setInt32(12, 0);
					bytes.setInt32(16, 0);
				}

				var gpuIndirectCallMaxCount = gpuIndirectCallBuffer.maxCommandCount;
				if ( shouldResizeDown(gpuIndirectCallMaxCount, count) || count > gpuIndirectCallMaxCount )
					gpuIndirectCallBuffer.allocFromBytes(count, bytes);
				else
					gpuIndirectCallBuffer.uploadBytes(count, bytes);
			}
		}
	}

	public function flush() {
		var p = dataPasses;
		var alloc = hxd.impl.Allocator.get();

		var prim = getPrimitive();
		var instanceSize = h3d.impl.InstanceBuffer.ELEMENT_SIZE;

		if ( hasSubMeshes() && storageBufferEnabled() )
			flushSubMeshResources();

		// Allocate and upload GPU buffers for each data passes
		while( p != null ) {
			var index = 0;
			var start = 0;
			while( start < instanceCount ) {
				var upload = needUpload;
				var buf = p.buffers[index];
				if( instanceCount > p.maxInstance && storageBufferEnabled() )
					throw "Maximum instance count reached";

				var count = hxd.Math.imin(instanceCount - start, p.maxInstance);
				var maxVertexCount = gpuUpdateEnabled() ? p.maxInstance : getMaxElements();
				var vertexCount = Std.int( count * (( 4 * p.paramsCount ) / p.bufferFormat.stride) );
				var vertexCountAllocated = #if js Std.int( MAX_BUFFER_ELEMENTS * 4 / p.bufferFormat.stride ) #else hxd.Math.imin( hxd.Math.nextPOT( vertexCount ), maxVertexCount ) #end;

				// Lazy instance data buffer allocation
				if( buf == null || buf.isDisposed() || buf.vertices < vertexCountAllocated ) {
					var bufferFlags : hxd.impl.Allocator.BufferFlags = storageBufferEnabled() ? UniformReadWrite : UniformDynamic;
					if ( buf != null )
						alloc.disposeBuffer(buf);
					buf = alloc.allocBuffer( vertexCountAllocated, p.bufferFormat, bufferFlags );
					p.buffers[index] = buf;
					upload = true;
				}

				// Upload instance data buffer
				if( upload && !gpuUpdateForced())
					buf.uploadFloats(p.data, start * p.paramsCount * 4, vertexCount);

				if( hasSubMeshes() && !storageBufferEnabled() ) {
					if( p.indirectCallBuffers == null )
						p.indirectCallBuffers = [];
					var indirectCallBuffer = p.indirectCallBuffers[index];
					if ( indirectCallBuffer == null )
						indirectCallBuffer = new h3d.impl.InstanceBuffer();
					var upload = needUpload || indirectCallBuffer.commandCount != count;
					if ( upload ) {
						var bytes = cpuIndirectCallBuffers[p.matIndex].bytes;
						if ( start > 0 && count < instanceCount ) {
							bytes = bytes.sub(start*instanceSize,count*instanceSize);
							for( i in 0...count )
								bytes.setInt32(i*instanceSize+16, i);
						}

						var maxCommandCount = indirectCallBuffer.maxCommandCount;
						if ( shouldResizeDown(maxCommandCount, count) || count > maxCommandCount) {
							indirectCallBuffer.allocFromBytes(count, bytes);
						} else {
							indirectCallBuffer.uploadBytes(count, bytes);
						}
						p.indirectCallBuffers[index] = indirectCallBuffer;
					}
				}

				onFlushBuffer(p, index, count);

				start += count;
				index++;
			}

			onFlushPass(p);

			while( p.buffers.length > index )
				alloc.disposeBuffer( p.buffers.pop() );
			p = p.next;
		}
		if ( hasPrimitiveOffset() ) {
			var offsets = prim.resolveBuffer("Batch_Start");
			if ( offsets == null || offsets.vertices < instanceCount || offsets.isDisposed() ) {
				if ( offsets != null ) {
					offsets.dispose();
					prim.removeBuffer(offsets);
				}
				var tmp = haxe.io.Bytes.alloc(4 * instanceCount);
				for ( i in 0...instanceCount )
					tmp.setFloat(i<<2, i);
				offsets = new h3d.Buffer(instanceCount, BATCH_START_FMT);
				offsets.uploadBytes(tmp, 0, instanceCount);
				prim.addBuffer(offsets);
			}
		}
		needUpload = false;
	}

	function onFlushBuffer(p : BatchData, index : Int, count : Int) {}

	function onFlushPass(p : BatchData) {}

	function syncData() {
		var batch = dataPasses;
		var invWorldPosition = null;
		var worldPosition = worldPosition ?? absPos;
		while( batch != null ) {
			var startPos = batch.paramsCount * instanceCount << 2;
			// in case we are bigger than emitCountTip
			if( startPos + (batch.paramsCount << 2) > batch.data.length )
				batch.data.grow(batch.data.length << 1);

			var p = batch.params;
			var buf = batch.data;
			var shaders = batch.shaders;

			while( p != null ) {
				var bufLoader = new hxd.FloatBufferLoader(buf, startPos + p.pos);
				if( p.perObjectGlobal != null ) {
					if ( p.perObjectGlobal.gid == modelViewID ) {
						bufLoader.loadMatrix(worldPosition);
					} else if ( p.perObjectGlobal.gid == modelViewInverseID ) {
						if ( invWorldPosition == null )
							invWorldPosition = worldPosition == null ? getInvPos() : worldPosition.getInverse();
						bufLoader.loadMatrix(invWorldPosition);
					} else if ( p.perObjectGlobal.gid == previousModelViewID )
						bufLoader.loadMatrix(worldPosition);
					else
						throw "Unsupported global param " + p.perObjectGlobal.path;
					p = p.next;
					continue;
				}
				var curShader = shaders[p.instance];
				switch( p.type ) {
				case TVec(size, _):
					switch( size ) {
					case 2:
						var v : h3d.Vector = curShader.getParamValue(p.index);
						bufLoader.loadVec2(v);
					case 3:
						var v : h3d.Vector = curShader.getParamValue(p.index);
						bufLoader.loadVec3(v);
					case 4:
						var v : h3d.Vector4 = curShader.getParamValue(p.index);
						bufLoader.loadVec4(v);
					}
				case TFloat:
					bufLoader.loadFloat(curShader.getParamFloatValue(p.index));
				case TMat4:
					var m : h3d.Matrix = curShader.getParamValue(p.index);
					bufLoader.loadMatrix(m);
				default:
					throw "Unsupported batch type "+p.type;
				}
				p = p.next;
			}
			batch = batch.next;
		}
		needUpload = true;
	}

	override function emit(ctx:RenderContext) {
		if( instanceCount == 0 ) return;
		var p = dataPasses;
		while( p != null ) {
			var pass = p.pass;

			// check that the pass is still enable
			var material = materials[p.matIndex];
			if( material != null && material.getPass(pass.name) != null )
				emitPass(ctx, p);
			p = p.next;
		}
	}

	function emitPass(ctx : RenderContext, p : BatchData) {
		for( i in 0...p.buffers.length )
			ctx.emitPass(p.pass, this).index = i | (p.matIndex << 16);
	}

	override function draw(ctx:RenderContext) {
		var p = dataPasses;
		while( true ) {
			if( p.pass == ctx.drawPass.pass ) {
				var bufferIndex = ctx.drawPass.index & 0xFFFF;

				if ( storageBufferEnabled() )
					p.shader.Batch_StorageBuffer = p.buffers[bufferIndex];
				else
					p.shader.Batch_Buffer = p.buffers[bufferIndex];

				if( cpuIndirectCallBuffers == null )
					setPassCommand(p, bufferIndex);
				else
					instanced.commands = storageBufferEnabled() ? gpuIndirectCallBuffers[p.matIndex] : p.indirectCallBuffers[bufferIndex];

				break;
			}
			p = p.next;
		}
		ctx.uploadParams();
		var prev = ctx.drawPass.index;
		ctx.drawPass.index >>= 16;
		super.draw(ctx);
		ctx.drawPass.index = prev;
	}

	function setPassCommand(p : BatchData, bufferIndex : Int) {
		var count = hxd.Math.imin( instanceCount - p.maxInstance * bufferIndex, p.maxInstance );
		instanced.setCommand(p.matIndex, curLod >= 0 ? curLod : 0, count);
	}

	function partsFromPrimitive(prim : h3d.prim.MeshPrimitive) {
		var hmd = Std.downcast(prim, h3d.prim.HMDModel);
		if ( hmd == null )
			return false;
		if ( primitiveSubMeshes == null ) {
			var subMesh = new SubMesh();
			var lodCount = hmd.lodCount();
			subMesh.bounds = hmd.getBounds();
			subMesh.lodCount = lodCount;
			subMesh.lodConfig = hmd.getLodConfig();
			var subParts = [];
			for ( m in 0...materials.length ) {
				var primitiveSubPart = new SubPart();
				primitiveSubPart.indexStart = hmd.getMaterialIndexStart(m, 0);
				primitiveSubPart.indexCount = hmd.getMaterialIndexCount(m, 0);
				primitiveSubPart.lodIndexStart = [for (i in 0...lodCount) hmd.getMaterialIndexStart(m, i)];
				primitiveSubPart.lodIndexCount = [for (i in 0...lodCount) hmd.getMaterialIndexCount(m, i)];
				primitiveSubPart.matIndex = m;
				subParts.push(primitiveSubPart);
			}
			subMesh.subParts = subParts;
			primitiveSubMeshes = [subMesh];
			curSubMesh = 0;
		}
		return true;
	}

	override function addBoundsRec( b : h3d.col.Bounds, relativeTo: h3d.Matrix ) {
		var old = primitive;
		primitive = null;
		super.addBoundsRec(b, relativeTo);
		primitive = old;
		if( primitive == null || flags.has(FIgnoreBounds) )
			return;
		// already transformed in absolute
		var bounds = primitive.getBounds();
		if( relativeTo == null )
			b.add(bounds);
		else
			b.addTransform(bounds, relativeTo);
	}

	override function onRemove() {
		super.onRemove();
		cleanPasses();
	}

	public function disposeBuffers() {
		if( instanceCount == 0 ) return;
		var p = dataPasses;
		var alloc = hxd.impl.Allocator.get();
		while( p != null ) {
			for ( b in p.buffers )
				alloc.disposeBuffer(b);
			p.buffers.resize(0);
			p = p.next;
		}
	}

	function cleanPasses() {
		while( dataPasses != null ) {
			dataPasses.clean();
			dataPasses = dataPasses.next;
		}

		if( instanced.commands != null )
			instanced.commands.dispose();

		cpuIndirectCallBuffers = null;
		if ( gpuIndirectCallBuffers != null ) {
			for ( gpuIndirectCallBuffer in gpuIndirectCallBuffers )
				gpuIndirectCallBuffer.dispose();
			gpuIndirectCallBuffers = null;
		}

		shadersChanged = true;
	}
}

class BatchData {

	public var paramsCount : Int;
	public var maxInstance : Int;
	public var matIndex : Int;
	public var indirectCallBuffers : Array<h3d.impl.InstanceBuffer>;
	public var buffers : Array<h3d.Buffer> = [];
	public var bufferFormat : hxd.BufferFormat;
	public var data : hxd.FloatBuffer;
	public var params : hxsl.RuntimeShader.AllocParam;
	public var shader : hxsl.BatchShader;
	public var shaders : Array<hxsl.Shader>;
	public var pass : h3d.mat.Pass;
	public var next : BatchData;

	public function new() {
	}

	public function clean() {
		var alloc = hxd.impl.Allocator.get();

		pass.removeShader(shader);
		for( b in buffers )
			alloc.disposeBuffer(b);
		buffers.resize(0);

		if( indirectCallBuffers != null ) {
			for( b in indirectCallBuffers )
				b.dispose();
		}
		alloc.disposeFloats(data);
	}
}

class SubMesh {
	public var subParts : Array<SubPart>;
	public var bounds : h3d.col.Bounds;
	public var lodCount : Int;
	public var lodConfig : Array<Float>;
	public function new() {
	}
}

class SubPart {
	public var indexStart : Int;
	public var indexCount : Int;
	public var lodIndexStart : Array<Int>;
	public var lodIndexCount : Array<Int>;
	public var matIndex : Int = 0;
	public function new() {
	}
}