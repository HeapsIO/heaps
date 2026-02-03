package h3d.scene;

class BatchCommandBuilder extends hxsl.Shader {
	static var SRC = {
		@param var groupsInfos : StorageBuffer<Int>; // x : batchInstanceStart;
		@param var batchInstancesInfos : StorageBuffer<Int>; // 2 elements => 0 : subMeshID, 1 : flags => culledMask(8 bits) + lodSelected(24 bits)
		@param var passInstancesInfos : StorageBuffer<Int>; // 2 elements => 0 : groupInstanceID, 1 : flags => subPartID(16 bits) + groupID(16 bits)
		@param var subPartInfos : StorageBuffer<Int>; // 2 elements => 0 : indexCount, 1 : indexStart
		@param var countBuffer : RWBuffer<Int>;
		@param var commandBuffer : RWBuffer<Int>;
		@param var instanceCount : Int;
		@param var cullingMask : Int;

		final passInfosStride : Int = 2;
		final batchInfosStride : Int = 2;
		final subPartInfosStride : Int = 2;

		function emitInstance(instanceID : Int, indexCount : Int, instanceCount : Int, startIndex : Int, startVertex : Int, baseInstance : Int ) {
			var instancePos = instanceID * 5;
			commandBuffer[instancePos + 0] = indexCount;
			commandBuffer[instancePos + 1] = instanceCount;
			commandBuffer[instancePos + 2] = startIndex;
			commandBuffer[instancePos + 3] = startVertex;
			commandBuffer[instancePos + 4] = baseInstance;
		}

		function main() {
			setLayout(64, 1, 1);
			var passInstanceID = computeVar.workGroup.x * 64 + computeVar.localInvocationIndex;
			if ( passInstanceID >= instanceCount )
				return;

			var passInstancePos = passInstanceID * passInfosStride;
			var groupInstanceID : Int = passInstancesInfos[passInstancePos + 0];
			var flags : Int = passInstancesInfos[passInstancePos + 1];
			var groupID : Int = flags >> 16;

			var batchInstanceStart = groupsInfos[groupID];
			var batchInstanceID = batchInstanceStart + groupInstanceID;
			var batchInstancePos = batchInstanceID * batchInfosStride;
			var batchFlags : Int = batchInstancesInfos[batchInstancePos + 1];
			var batchCullingMask : Int = batchFlags & 0xFF;

			if ( (batchCullingMask & cullingMask) != 0 )
				return;

			var lodSelected : Int = batchFlags >> 8;
			var subPartID : Int = flags & 0xFFFF;

			var subPartPos = (subPartID + lodSelected) * subPartInfosStride;
			var indexCount : Int = subPartInfos[subPartPos + 0];
			var indexStart : Int = subPartInfos[subPartPos + 1];

			var id = atomicAdd( countBuffer, 0, 1 );
			emitInstance( id, indexCount, 1, indexStart, 0, passInstanceID );
		}
	}
}

@:allow(h3d.scene.EmitData)
class BatchPass {
	static var shaderTexParamsCache : Map<Int, Array<String>> = [];
	static var INDIRECT_DRAW_ARGUMENTS_FMT = hxd.BufferFormat.make([{ name : "", type : DVec4 }, { name : "", type : DFloat }]);
	static var INSTANCES_INFOS_FMT = hxd.BufferFormat.make([{ name : "batchInstanceID", type : DFloat }, { name : "flags", type : DFloat }]); // flags = subPartID(16 bits) + groupID(16 bits)

	public var pass : h3d.mat.Pass;
	public var batchShader : hxsl.BatchShader;
	public var shaders : Array<hxsl.Shader>;

	public var totalInstanceCount(default, null) = 0;
	var toEmit : Array<EmitData> = [];
	var instancesData : h3d.Buffer;
	var instancesInfos : h3d.Buffer;
	var command : h3d.impl.InstanceBuffer;
	var commandBuffer : h3d.Buffer;
	var countBuffer : h3d.GPUCounter;
	var textureHandlesMap : Map<h3d.mat.TextureHandle, Bool>;
	var textureHandles : Array<h3d.mat.TextureHandle>;
	var triCount = 0;
	var instanceDirty = false;
	var cullingMask = 0;

	public function new(batcher : h3d.scene.Batcher, p : h3d.mat.Pass, sl : hxsl.ShaderList) @:privateAccess {
		var scene = batcher.getScene();
		var output = scene.renderer.getPassByName(p.name);
		if( output == null )
			throw "Unknown pass " + p.name;

		var shaderLinker = output.output;
		var rt = shaderLinker.compileShaders(scene.ctx.globals, sl, Default);
		batcher.needLogicNormal = batcher.needLogicNormal || rt.getInputFormat().hasInput("logicNormal");

		var shaderVisited : Map<String, Bool> = [];
		var forcedPerInstance = [];
		for ( s in sl ) {
			var si = s.instance;
			var name = si.shader.name;
			if ( shaderVisited.exists(name) )
				continue;
			shaderVisited.set(name, true);
			var params = shaderTexParamsCache.get(si.id);
			if (params == null) {
				params = [];
				for ( v in si.shader.vars ) {
					if ( v.kind != Param || !v.type.match(TSampler(_)|TInt|TFloat|TVec(_)) )
						continue;
					params.push(v.name);
				}
				shaderTexParamsCache.set(si.id, params);
			}
			if ( params.length == 0 )
				continue;
			forcedPerInstance.push({ shader: name, params : params });
		}
		// perInstance needs to be in reverse order ?
		forcedPerInstance.reverse();
		batchShader = shaderLinker.shaderCache.makeBatchShader(rt, sl, new hxsl.Cache.BatchInstanceParams(forcedPerInstance));
		batchShader.Batch_UseStorage = true;
		batchShader.Batch_HasOffset = true;
		batchShader.constBits = 1 << 1 | 1 << 0;
		batchShader.updateConstants(null);
		pass = p.clone();
		shaders = [];
		while( sl != null ) {
			shaders.push(sl.s);
			sl = sl.next;
		}

		pass.addSelfShader(batchShader);
		pass.batchMode = true;
		pass.dynamicParameters = false;
		cullingMask = pass.name == "shadow" ? 1 << 1 : 1 << 0;
	}

	public function uploadInstanceBuffer() {
		if ( !instanceDirty )
			return;
		instanceDirty = false;

		var instanceDataSize = totalInstanceCount * batchShader.paramsSize;
		if ( instancesData == null || instancesData.vertices < instanceDataSize ) {
			instancesData?.dispose();
			instancesData = new h3d.Buffer( instanceDataSize, hxd.BufferFormat.VEC4_DATA, [UniformBuffer, ReadWriteBuffer] );
			batchShader.Batch_StorageBuffer = instancesData;
		}

		if ( instancesInfos == null || instancesInfos.vertices < totalInstanceCount ) {
			instancesInfos?.dispose();
			instancesInfos = new h3d.Buffer(totalInstanceCount, INSTANCES_INFOS_FMT, [UniformBuffer]);
		}

		var instanceCursor = 0;
		for ( ed in toEmit ) {
			instancesData.uploadFloats( ed.instancesData, 0, ed.instanceCount * batchShader.paramsSize, instanceCursor * batchShader.paramsSize );
			instancesInfos.uploadBytes( ed.instancesInfos, 0, ed.instanceCount, instanceCursor );
			instanceCursor += ed.instanceCount;
		}

		if ( commandBuffer == null || commandBuffer.vertices < totalInstanceCount )  {
			commandBuffer?.dispose();
			commandBuffer = new h3d.Buffer(totalInstanceCount, INDIRECT_DRAW_ARGUMENTS_FMT, [UniformBuffer, ReadWriteBuffer]);
			if ( command == null )
				command = new h3d.impl.InstanceBuffer();
			@:privateAccess command.data = commandBuffer.vbuf;
		}

		if ( countBuffer == null ) {
			countBuffer = new GPUCounter();
			@:privateAccess command.countBuffer = countBuffer.buffer.vbuf;
		}
	}

	var builderShader = new BatchCommandBuilder();
	public function dispatchCommandBuilder(ctx : h3d.scene.RenderContext, batcher : Batcher) {
		builderShader.groupsInfos = @:privateAccess batcher.groupsInfos;
		builderShader.passInstancesInfos = instancesInfos;
		builderShader.batchInstancesInfos = @:privateAccess batcher.instancesInfos;
		builderShader.subPartInfos = @:privateAccess batcher.primitive.gpuSubPartInfos;
		builderShader.instanceCount = totalInstanceCount;
		builderShader.commandBuffer = commandBuffer;
		builderShader.countBuffer = countBuffer.buffer;
		builderShader.cullingMask = cullingMask;
		countBuffer.reset();
		ctx.computeDispatch(builderShader, hxd.Math.ceil(totalInstanceCount/64.0), false);
	}

	public function draw( primitive : h3d.prim.BatchPrimitive, ctx : h3d.scene.RenderContext ) {
		if ( textureHandles != null )
			ctx.selectTextureHandles( textureHandles );
		var engine = ctx.engine;
		@:privateAccess engine.driver.selectMultiBuffers(primitive.formats, primitive.buffers);
		@:privateAccess command.commandCount = totalInstanceCount;
		engine.renderInstanced(primitive.indexes, command);
	}

	public function dispose() {
		instancesData?.dispose();
		instancesInfos?.dispose();
		commandBuffer?.dispose();
		countBuffer?.dispose();
	}
}

class BatchCulling extends hxsl.Shader {
	static var SRC = {
		@global var camera : {
			var position : Vec3;
			var proj : Mat4;
		}

		@param var instancesData : StorageBuffer<Vec4>; // xyz : position, w : boundingSphere
		@param var instancesInfos : RWBuffer<Int>; // 2 elements => 0 : subMeshID, 1 : flags
		@param var subMeshInfos : StorageBuffer<Int>; // x : lodStart, y : lodCount
		@param var lodInfos : StorageBuffer<Float>; // x : screenRatio
		@param var frustum : Buffer<Vec4, 6>;
		@param var shadowMaxDistance : Float;
		@param var instanceCount : Int;

		final instanceInfosStride = 2;
		final subMeshInfosStride = 2;

		function computeScreenRatio( distToCam : Float, radius : Float ) : Float {
			var screenMultiple = max(0.5 * camera.proj[0][0], 0.5 * camera.proj[1][1]);
			var screenRadius = screenMultiple * radius / max(1.0, distToCam);
			return 2.0 * screenRadius;
		}

		function main() {
			setLayout(64, 1, 1);
			var invocID = computeVar.workGroup.x * 64 + computeVar.localInvocationIndex;
			if ( invocID >= instanceCount )
				return;

			var instancePos = invocID * instanceInfosStride;
			var subMeshID : Int = instancesInfos[instancePos + 0];
			var subMeshPos = subMeshID * subMeshInfosStride;
			var data = instancesData[invocID];

			var position = data.xyz;
			var boundingSphere = data.w;
			var lodStart : Int = subMeshInfos[subMeshPos + 0];
			var lodCount : Int = subMeshInfos[subMeshPos + 1];

			var mainCulled = false;
			@unroll for ( i  in 0...6 ) {
				var plane = frustum[i];
				mainCulled = mainCulled || ((dot(plane.xyz, position) - plane.w) < -boundingSphere);
			}

			var toCam = camera.position - position.xyz;
			var distToCam = length(toCam);
			var screenRatio = computeScreenRatio(distToCam, boundingSphere);

			var lodSelected : Int = 0;
			for ( i in 0...lodCount ) {
				var minScreenRatio = lodInfos[lodStart + i];
				if ( screenRatio > minScreenRatio )
					break;
				lodSelected++;
			}

			var shadowCulled = shadowMaxDistance > 0 && shadowMaxDistance < distToCam;

			var cullingMask : Int = 0;
			cullingMask |= mainCulled ? 1 << 0 : 0;
			cullingMask |= shadowCulled ? 1 << 1 : 0;
			cullingMask |= lodCount == lodSelected ? 3 : 0;

			var flags : Int = 0;
			flags |= lodSelected << 8;
			flags |= cullingMask & 0xFF;
			instancesInfos[instancePos + 1] = flags;
		}
	}
}

@:allow(h3d.scene.Batcher)
class BatchGroup {
	var passToEmitData : Map<BatchPass, Int> = [];
	var emitData : Array<EmitData> = [];
	var batcher : Batcher;
	var groupID : Int;

	var instanceCount = 0;
	var instancesData : haxe.io.Bytes;
	var instancesInfos : haxe.io.Bytes;

	public function new(b:Batcher, groupID : Int) {
		batcher = b;
		this.groupID = groupID;
	}

	function emitGroupInstance( mesh : h3d.scene.Mesh, subMeshID : Int, worldPosition : h3d.Matrix ) {
		batcher.instancesDirty = true;
		batcher.totalInstanceCount++;
		var groupInstanceID = instanceCount++;

		var dataByteStride = Batcher.BATCH_INSTANCES_DATA_FMT.strideBytes;
		var dataNeeded = instanceCount * dataByteStride;
		if ( instancesData == null )
			instancesData = haxe.io.Bytes.alloc(dataNeeded);
		if ( instancesData.length < dataNeeded) {
			var old = instancesData;
			instancesData = haxe.io.Bytes.alloc(hxd.Math.imax(dataNeeded, (old.length >> 1) * 3));
			instancesData.blit(0, old, 0, old.length);
		}

		var position = worldPosition.getPosition();
		var scale = worldPosition.getScale();
		var boundingSphere = mesh.primitive.getBounds().getBoundingRadius();
		boundingSphere *= hxd.Math.max(hxd.Math.max(hxd.Math.abs(scale.x), hxd.Math.abs(scale.y)), hxd.Math.abs(scale.z));

		var dataStart = groupInstanceID * dataByteStride;
		instancesData.setFloat( dataStart + 0, position.x );
		instancesData.setFloat( dataStart + 4, position.y );
		instancesData.setFloat( dataStart + 8, position.z );
		instancesData.setFloat( dataStart + 12, boundingSphere );

		var infoByteStride = Batcher.BATCH_INSTANCES_INFOS_FMT.strideBytes;
		var infoNeeded = instanceCount * infoByteStride;
		if ( instancesInfos == null )
			instancesInfos = haxe.io.Bytes.alloc(infoNeeded);
		if ( instancesInfos.length < infoNeeded) {
			var old = instancesInfos;
			instancesInfos = haxe.io.Bytes.alloc(hxd.Math.imax(infoNeeded, (old.length >> 1) * 3));
			instancesInfos.blit(0, old, 0, old.length);
		}

		var infoStart = groupInstanceID * infoByteStride;
		instancesInfos.setInt32( infoStart + 0, subMeshID );
		instancesInfos.setInt32( infoStart + 4, 0 );

		return groupInstanceID;
	}

	public function emitInstance( mesh : h3d.scene.Mesh, worldPosition : h3d.Matrix ) {
		var hmd = Std.downcast(mesh.primitive, h3d.prim.HMDModel);
		if ( hmd == null )
			throw "Only HMDModel meshes can be batched";

		var subMeshID = batcher.primitive.getSubMeshID(hmd);
		if ( subMeshID < 0 )
			throw "Model not added to batcher";

		var groupInstanceID = emitGroupInstance(mesh, subMeshID, worldPosition);
		var subMesh = batcher.primitive.subMeshes[subMeshID];
		var subPartStart = subMesh.subPartStart;
		for ( subPartIdx => m in mesh.getMeshMaterials() ) {
			for ( pass in m.getPasses() ) {
				var sl = @:privateAccess pass.getShadersRec();
				var bpIdx : Int = batcher.findPass(sl, @:privateAccess pass.bits, pass.name);
				if ( bpIdx < 0 )
					throw "Pass not found in batcher";

				var bp = batcher.passes[bpIdx];
				var dataIdx = passToEmitData.get(bp);
				if ( dataIdx == null ) {
					dataIdx = emitData.length;
					emitData.push(new EmitData(this, bp));
					passToEmitData.set(bp, dataIdx);
				}
				emitData[dataIdx].emitInstance(groupInstanceID, groupID, subPartStart + subPartIdx * subMesh.lodCount, sl, worldPosition);
			}
		}
	}

	public function remove() {
		batcher.groups.remove(this);
		batcher.freeGroupIDs.push(groupID);
		batcher.instancesDirty = true;
		if ( batcher.totalInstanceCount < instanceCount )
			throw "assert";
		batcher.totalInstanceCount -= instanceCount;
		batcher = null;
		dispose();
	}

	@:allow(h3d.scene.Batcher)
	function dispose() {
		for ( ed in emitData )
			ed.dispose();
		emitData.resize(0);
		passToEmitData.clear();
		instancesData = null;
		instancesInfos = null;
		instanceCount = 0;
	}
}

@:allow(h3d.scene.BatchGroup, h3d.scene.BatchPass)
class Batcher extends h3d.scene.Object {
	static var BATCH_INSTANCES_DATA_FMT = hxd.BufferFormat.make([{ name : "position", type : DVec3 }, { name : "boundingSphere", type : DFloat }]);
	static var BATCH_INSTANCES_INFOS_FMT = hxd.BufferFormat.make([{ name : "subMeshID", type : DFloat }, { name : "flags", type : DFloat }]); // flags = culledMask(8 bits) + lodSelected(24 bits)
	static final GROUP_INFOS = hxd.BufferFormat.make([{ name : "batchInstanceStart", type : DFloat }]);
	static final BATCH_START_FMT = hxd.BufferFormat.make([{ name : "Batch_Start", type : DFloat }]);

	var highestGroupID = 0;
	var freeGroupIDs : Array<Int> = [];
	var groups : Array<BatchGroup> = [];
	var passes : Array<BatchPass> = [];
	var primitive : h3d.prim.BatchPrimitive;
	var needLogicNormal : Bool = false;
	public var shadowMaxDistance = -1.0;

	var totalInstanceCount : Int;
	var instancesData : h3d.Buffer;
	var instancesInfos : h3d.Buffer;
	var instancesDirty : Bool;
	var groupsInfos : h3d.Buffer;

	public function new( format : hxd.BufferFormat, ?parent:h3d.scene.Object ) {
		super(parent);
		primitive = new h3d.prim.BatchPrimitive(format);
		if ( format == null )
			throw "assert";
	}

	function findPass( shaders : hxsl.ShaderList, bits : Int, name : String ) : Int {
		var globals = @:privateAccess getScene().ctx.globals;
		for ( i => bp in passes ) @:privateAccess {
			if ( bp.pass.bits == bits && name == bp.pass.name ) {
				var sl = shaders;
				var sIdx = 0;
				while ( sl != null ) {
					var s1 = sl.s;
					var s2 = bp.shaders[sIdx];
					s1.updateConstants(globals);
					s2.updateConstants(globals);
					if ( s1.instance.id != s2.instance.id )
						break;
					sIdx++;
					sl = sl.next;
				}
				if ( sIdx == bp.shaders.length )
					return i;
			}
		}
		return -1;
	}

	public function addMesh( mesh : h3d.scene.Mesh ) {
		var hmd = Std.downcast(mesh.primitive, h3d.prim.HMDModel);
		if ( hmd == null )
			return;
		primitive.addModel(hmd);

		for ( m in mesh.getMeshMaterials() ) {
			for ( p in m.getPasses() ) @:privateAccess {
				var shaders = p.getShadersRec();
				var bpIdx : Int = findPass(shaders, p.bits, p.name);
				if ( bpIdx < 0 )
					passes.push( new BatchPass(this, p, shaders) );
			}
		}
	}

	public function createGroup() : BatchGroup {
		var groupID = freeGroupIDs.length > 0 ? freeGroupIDs.pop() : highestGroupID++;
		var group = new BatchGroup(this, groupID);
		groups.push(group);
		instancesDirty = true;
		return group;
	}

	function uploadBatchInstance() {
		if ( !instancesDirty )
			return;
		instancesDirty = false;

		if ( instancesData == null || instancesData.vertices < totalInstanceCount ) {
			instancesData?.dispose();
			instancesData = new h3d.Buffer(totalInstanceCount, BATCH_INSTANCES_DATA_FMT, [UniformBuffer]);
		}

		if ( instancesInfos == null || instancesInfos.vertices < totalInstanceCount ) {
			instancesInfos?.dispose();
			instancesInfos = new h3d.Buffer(totalInstanceCount, BATCH_INSTANCES_INFOS_FMT, [UniformBuffer, ReadWriteBuffer]);
		}

		var groupsNeeded = highestGroupID;
		if ( groupsInfos == null || groupsInfos.vertices < groupsNeeded ) {
			groupsInfos?.dispose();
			groupsInfos = new h3d.Buffer(groupsNeeded, GROUP_INFOS, [UniformBuffer]);
		}

		var groupsInfosBytes = haxe.io.Bytes.alloc(groupsNeeded * 4);

		var instanceCursor = 0;
		for ( g in groups ) {
			instancesData.uploadBytes( g.instancesData, 0, g.instanceCount, instanceCursor );
			instancesInfos.uploadBytes( g.instancesInfos, 0, g.instanceCount, instanceCursor );
			groupsInfosBytes.setInt32( g.groupID * 4, instanceCursor );
			instanceCursor += g.instanceCount;
		}
		groupsInfos.uploadBytes( groupsInfosBytes, 0, groupsNeeded );
	}

	var cullingShader = new BatchCulling();
	public function dispatchCulling(ctx : h3d.scene.RenderContext) {
		cullingShader.instancesData = instancesData;
		cullingShader.instancesInfos = instancesInfos;
		cullingShader.subMeshInfos = primitive.gpuSubMeshInfos;
		cullingShader.lodInfos = primitive.gpuLodInfos;
		cullingShader.frustum = ctx.getCameraFrustumBuffer();
		cullingShader.instanceCount = totalInstanceCount;
		cullingShader.shadowMaxDistance = shadowMaxDistance;
		ctx.computeDispatch(cullingShader, hxd.Math.ceil(totalInstanceCount/64.0), false);
	}

	override function emit( ctx : h3d.scene.RenderContext ) {
		if ( totalInstanceCount == 0 )
			return;

		if ( primitive.buffer == null || primitive.buffer.isDisposed() ) {
			primitive.alloc(ctx.engine);
			if ( needLogicNormal )
				primitive.addLogicNormal();
		}

		uploadBatchInstance();
		dispatchCulling(ctx);

		for ( i => p in passes ) {
			if ( p.totalInstanceCount == 0 )
				continue;
			p.uploadInstanceBuffer();
		}

		ctx.memoryBarrier();

		var maxInstanceCount = 0;
		for ( i => p in passes ) {
			if ( p.totalInstanceCount == 0 )
				continue;
			p.dispatchCommandBuilder(ctx, this);
			maxInstanceCount = hxd.Math.imax(p.totalInstanceCount, maxInstanceCount);
			ctx.emitPass(p.pass, this).index = i;
		}

		if ( maxInstanceCount == 0 )
			return;

		ctx.memoryBarrier();

		var offsets = primitive.resolveBuffer("Batch_Start");
		if ( offsets == null || offsets.vertices < maxInstanceCount || offsets.isDisposed() ) {
			if ( offsets != null ) {
				offsets.dispose();
				primitive.removeBuffer(offsets);
			}
			var tmp = haxe.io.Bytes.alloc(4 * maxInstanceCount);
			for ( i in 0...maxInstanceCount )
				tmp.setFloat(i<<2, i);
			offsets = new h3d.Buffer(maxInstanceCount, BATCH_START_FMT);
			offsets.uploadBytes(tmp, 0, maxInstanceCount);
			primitive.addBuffer(offsets);
		}
	}

	override function draw(ctx : h3d.scene.RenderContext ) {
		passes[ctx.drawPass.index].draw(primitive, ctx);
	}

	override function onRemove() {
		primitive.dispose();
		for ( g in groups )
			g.dispose();
		for ( p in passes )
			p.dispose();
		groups.resize(0);
		passes.resize(0);
		freeGroupIDs.resize(0);
		instancesData?.dispose();
		instancesData = null;
		instancesInfos?.dispose();
		instancesInfos = null;
		groupsInfos?.dispose();
		groupsInfos = null;
		totalInstanceCount = 0;
		instancesDirty = false;
		highestGroupID = 0;
	}
}

@:allow(h3d.scene.BatchPass)
class EmitData {
	static final modelViewID = hxsl.Globals.allocID("global.modelView");
	static final modelViewInverseID = hxsl.Globals.allocID("global.modelViewInverse");
	static final previousModelViewID = hxsl.Globals.allocID("global.previousModelView");

	var group : BatchGroup;
	var instanceCount : Int;
	var instancesInfos : haxe.io.Bytes;
	var instancesData : hxd.FloatBuffer;
	var batchPass : BatchPass;
	var modelViewPos : Int;

	public var pass(get, never) : h3d.mat.Pass;
	public function get_pass() {
		return batchPass.pass;
	}

	public function new(g : BatchGroup, bp : BatchPass) {
		if ( !h3d.Engine.getCurrent().driver.hasFeature(Bindless) )
			throw "h3d.scene.Batcher requires Bindless support.";
		group = g;
		batchPass = bp;
		bp.toEmit.push(this);
	};

	public function emitInstance( groupInstanceID : Int, groupID : Int, subPartID : Int, sl : hxsl.ShaderList,  worldPosition : h3d.Matrix ) {
		batchPass.instanceDirty = true;
		batchPass.totalInstanceCount++;
		var instanceID = instanceCount++;

		if ( subPartID > 0xFFFF || groupID > 0xFFFF )
			throw 'ID overflow. Too many ${subPartID > 0xFFFF ? "models" : "groups"}';

		var instanceInfosStride = BatchPass.INSTANCES_INFOS_FMT.strideBytes;
		var minInstanceInfosSize = instanceCount * instanceInfosStride;
		if ( instancesInfos == null )
			instancesInfos = haxe.io.Bytes.alloc(minInstanceInfosSize);
		if ( instancesInfos.length < minInstanceInfosSize) {
			var old = instancesInfos;
			instancesInfos = haxe.io.Bytes.alloc( hxd.Math.imax((old.length >> 1) * 3, minInstanceInfosSize) );
			instancesInfos.blit(0, old, 0, old.length);
		}
		instancesInfos.setInt32(instanceID * instanceInfosStride + 0, groupInstanceID);
		instancesInfos.setInt32(instanceID * instanceInfosStride + 4, groupID << 16 | subPartID );

		var instanceDataStride = batchPass.batchShader.paramsSize * 4;
		var minInstanceDataSize = instanceCount * instanceDataStride;
		if ( instancesData == null )
			instancesData = new hxd.FloatBuffer(minInstanceDataSize);
		if ( instancesData.length < minInstanceDataSize)
			instancesData.grow((minInstanceDataSize >> 1) * 3);

		var p = batchPass.batchShader.params;
		var data = instancesData;
		var shaders = [null/*link shader*/];
		while( sl != null ) {
			shaders.push(sl.s);
			sl = sl.next;
		}
		var invWorldPosition : h3d.Matrix = null;

		var startPos = instanceID * instanceDataStride;
		while ( p != null ) {
			var bufLoader = new hxd.FloatBufferLoader(data, startPos + p.pos);
			if( p.perObjectGlobal != null ) {
				if ( p.perObjectGlobal.gid == modelViewID ) {
					modelViewPos = p.pos;
					bufLoader.loadMatrix(worldPosition);
				} else if ( p.perObjectGlobal.gid == modelViewInverseID ) {
					if ( invWorldPosition == null )
						invWorldPosition = worldPosition.getInverse();
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
			case TInt:
				bufLoader.loadInt(Std.int(curShader.getParamFloatValue(p.index)));
			case TMat4:
				var m : h3d.Matrix = curShader.getParamValue(p.index);
				bufLoader.loadMatrix(m);
			case TTextureHandle:
				if ( batchPass.textureHandles == null ) {
					batchPass.textureHandles = [];
					batchPass.textureHandlesMap = [];
				}
				var h : h3d.mat.TextureHandle = curShader.getParamValue(p.index);
				if ( !batchPass.textureHandlesMap.exists(h) ) {
					batchPass.textureHandlesMap.set(h, true);
					batchPass.textureHandles.push(h);
				}
				bufLoader.loadInt(h.handle.low);
				bufLoader.loadInt(h.handle.high);
			case TSampler(_):
				if ( batchPass.textureHandles == null ) {
					batchPass.textureHandles = [];
					batchPass.textureHandlesMap = [];
				}
				var t : h3d.mat.Texture = curShader.getParamValue(p.index);
				var h = t.getHandle();
				if ( !batchPass.textureHandlesMap.exists(h) ) {
					batchPass.textureHandlesMap.set(h, true);
					batchPass.textureHandles.push(h);
				}
				bufLoader.loadInt(h.handle.low);
				bufLoader.loadInt(h.handle.high);
			default:
				throw "Unsupported per instance type "+p.type;
			}
			p = p.next;
		}
	}

	public function dispose() {
		batchPass.instanceDirty = true;
		if ( batchPass.totalInstanceCount < instanceCount )
			throw "assert";
		batchPass.totalInstanceCount -= instanceCount;
		batchPass.toEmit.remove(this);
		batchPass = null;
		instancesData = null;
		instancesInfos = null;
		instanceCount = 0;
	}
}