package h3d.scene;

/** Batcher API **/

@:allow(h3d.scene.Batcher)
class ObjectInstance {
	public var meshes : Array<MeshInstance>;
	function new(meshes : Array<MeshInstance>) {
		this.meshes = meshes;
	}
}

@:allow(h3d.scene.Batcher)
class BatchGroup {
	var batcher : Batcher;
	var groupID : Int;

	public inline function new(b:Batcher, groupID : Int) {
		batcher = b;
		this.groupID = groupID;
	}

	public inline function emitInstance( obj : ObjectInstance, worldPosition : h3d.Matrix ) {
		batcher.emitInstance( obj, worldPosition, groupID );
	}

	public inline function remove() {
		batcher.removeGroup(this);
		batcher = null;
	}
}

@:allow(h3d.scene.Batch)
class Batcher extends h3d.scene.Object {
	static final BATCH_START_FMT = hxd.BufferFormat.make([{ name : "Batch_Start", type : DFloat }]);

	public var shadowMaxDistance = -1.0;
	public var isRelative : Bool = false;
	var followShader : FollowShader;

	var highestGroupID = 1;
	var freeGroupIDs : Array<Int> = [];
	var groups : Array<BatchGroup> = [];

	var batches : Array<Batch> = [];
	var instancesOffset : h3d.Buffer;

	function getBatchID( hmd : h3d.prim.HMDModel ) {
		var format = @:privateAccess hmd.data.vertexFormat;
		for ( i => b in batches )
			if ( b.primitive.vertexFormat == format )
				return i;
		var batchID = batches.length;
		batches.push(new Batch(this, format));
		return batchID;
	}

	public function addInstance( obj : h3d.scene.Object ) : ObjectInstance {
		var meshes = [];
		var invPos = obj.getInvPos();
		var renderer = getScene().renderer;
		for ( m in obj.getMeshes() ) {
			var hmd = Std.downcast(m.primitive, h3d.prim.HMDModel);
			if ( hmd == null )
				continue;

			var batchID = getBatchID(hmd);
			var batch = batches[batchID];

			var subMeshID = batch.addModel(m);
			var materials = [];
			for ( m in m.getMeshMaterials() )
				materials.push(batch.addMaterial(m, renderer));

			var meshInstance = new MeshInstance(m.getAbsPos() * invPos, batchID, subMeshID, materials);
			meshes.push(meshInstance);
		}
		return new ObjectInstance(meshes);
	}

	public function createGroup() : BatchGroup {
		var groupID = freeGroupIDs.length > 0 ? freeGroupIDs.pop() : highestGroupID++;
		var group = new BatchGroup(this, groupID);
		groups.push(group);
		return group;
	}

	public function removeGroup(group : BatchGroup) {
		var groupID = group.groupID;
		groups.remove(group);
		freeGroupIDs.push(groupID);
		for (b in batches)
			b.disposeGroup(groupID);
	}

	var tmpMat = new h3d.Matrix();
	public function emitInstance( instance : ObjectInstance, worldPosition : h3d.Matrix, groupID : Int = 0 ) {
		for ( mesh in instance.meshes ) {
			var batch = batches[mesh.batchID];
			tmpMat.multiply3x4(mesh.relPos, worldPosition);
			batch.emitMesh( mesh, tmpMat, groupID );
		}
	}

	override function emit( ctx : h3d.scene.RenderContext ) {
		var maxInstanceCount = 0;
		for ( b in batches ) {
			if ( b.totalInstanceCount == 0 )
				continue;
			maxInstanceCount = hxd.Math.imax(b.totalInstanceCount, maxInstanceCount);
			b.uploadPrimitive(ctx);
			b.uploadBatchInfos();
		}

		if ( maxInstanceCount == 0 )
			return;

		if ( isRelative ) {
			if ( followShader == null ) {
				followShader = new FollowShader();
				followShader.followMatrix = new h3d.Matrix();
				followShader.prevFollowMatrix = new h3d.Matrix();
			}
			var absPos = getAbsPos();
			followShader.followMatrix.load(absPos);
			followShader.prevFollowMatrix.load(prevAbsPos ?? absPos);
		}

		for ( b in batches )
			b.dispatchCulling(ctx);

		ctx.memoryBarrier();

		for ( batchID => b in batches )
			b.emit(ctx, batchID);

		ctx.memoryBarrier();
	}

	override function draw(ctx : h3d.scene.RenderContext ) {
		batches[ctx.drawPass.index & 0xFFFF].draw(ctx);
	}

	override function onRemove() {
		for ( b in batches)
			b.dispose();
		groups.resize(0);
		batches.resize(0);
		freeGroupIDs.resize(0);
		highestGroupID = 1;
	}

	function checkInstancesOffset( instanceCount : Int ) {
		if ( instancesOffset == null || instancesOffset.vertices < instanceCount || instancesOffset.isDisposed() ) {
			if ( instancesOffset != null ) {
				instancesOffset.dispose();
				for ( b in batches )
					b.primitive.removeBuffer(instancesOffset);
			}
			var tmp = haxe.io.Bytes.alloc(4 * instanceCount);
			for ( i in 0...instanceCount )
				tmp.setFloat(i<<2, i);
			instancesOffset = new h3d.Buffer(instanceCount, BATCH_START_FMT);
			instancesOffset.uploadBytes(tmp, 0, instanceCount);
			for ( b in batches )
				b.primitive.addBuffer(instancesOffset);
		}
	}
}

/** Batcher Implementation **/

@:allow(h3d.scene.Batcher)
private class MeshInstance {
	public var relPos : h3d.Matrix;
	public var batchID : Int;
	public var subMeshID : Int;
	public var materials : Array<MaterialInstance>;
	function new(relPos: h3d.Matrix, batchID : Int, subMeshID : Int, materials : Array<MaterialInstance>) {
		this.relPos = relPos;
		this.batchID = batchID;
		this.subMeshID = subMeshID;
		this.materials = materials;
	}
}

@:allow(h3d.scene.Batch)
private class MaterialInstance {
	public var draws : Array<DrawInstance>;

	function new( draws: Array<DrawInstance> ) {
		this.draws = draws;
	}
}

@:allow(h3d.scene.Batch)
private class DrawInstance {
	public var shaderData : hxd.FloatBuffer;
	public var passID : Int;

	function new(shaderData : hxd.FloatBuffer, passID : Int) {
		this.shaderData = shaderData;
		this.passID = passID;
	}
}

private class FollowShader extends hxsl.Shader {
	static var SRC = {
		@param var followMatrix : Mat4;
		@param var prevFollowMatrix : Mat4;

		var transformedPosition : Vec3;
		var previousTransformedPosition : Vec3;

		function vertex() {
			transformedPosition = transformedPosition * followMatrix.mat3x4();
			previousTransformedPosition = previousTransformedPosition * prevFollowMatrix.mat3x4();
		}
	};
}

private class BatchCulling extends hxsl.Shader {
	static var SRC = {
		@global var camera : {
			var position : Vec3;
			var proj : Mat4;
		}

		@param var cullingData : StorageBuffer<Vec4>; // xyz : position, w : boundingSphere
		@param var batchInfos : RWBuffer<Int>; // 2 elements => 0 : subMeshID, 1 : flags
		@param var subMeshInfos : StorageBuffer<Int>; // x : lodStart, y : lodCount
		@param var lodInfos : StorageBuffer<Float>; // x : screenRatio
		@param var frustum : Buffer<Vec4, 6>;
		@param var shadowMaxDistance : Float;
		@param var instanceCount : Int;
		@const var IS_RELATIVE : Bool = false;
		@param var worldMatrix : Mat4;

		final batchInfosStride = 2;
		final subMeshInfosStride = 2;

		function computeScreenRatio( distToCam : Float, radius : Float ) : Float {
			var screenMultiple = max(0.5 * camera.proj[0][0], 0.5 * camera.proj[1][1]);
			var screenRadius = screenMultiple * radius / max(1.0, distToCam);
			return 2.0 * screenRadius;
		}

		function main() {
			setLayout(64, 1, 1);
			var instanceID = computeVar.workGroup.x * 64 + computeVar.localInvocationIndex;
			if ( instanceID >= instanceCount )
				return;

			var instancePos = instanceID * batchInfosStride;
			var subMeshID : Int = batchInfos[instancePos + 0];
			var subMeshPos = subMeshID * subMeshInfosStride;
			var data = cullingData[instanceID];

			var position = data.xyz;
			var boundingSphere = data.w;
			if ( IS_RELATIVE )
				position = position * worldMatrix.mat3x4();
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
			batchInfos[instancePos + 1] = flags;
		}
	}
}

@:allow(h3d.scene.GroupData, h3d.scene.BatchPass)
private class Batch {
	static final CULLING_DATA_FMT = hxd.BufferFormat.make([{ name : "position", type : DVec3 }, { name : "boundingSphere", type : DFloat }]);
	static final BATCH_INFOS_FMT = hxd.BufferFormat.make([{ name : "subMeshID", type : DFloat }, { name : "flags", type : DFloat }]); // flags = culledMask(8 bits) + lodSelected(24 bits)
	static final GROUP_INFOS = hxd.BufferFormat.make([{ name : "batchInstanceStart", type : DFloat }]);

	public var batcher : h3d.scene.Batcher;
	public var primitive : h3d.prim.BatchPrimitive;

	public var totalInstanceCount : Int;
	public var instancesDirty : Bool;

	public var cullingData : h3d.Buffer;
	public var batchInfos : h3d.Buffer;
	public var groupsInfos : h3d.Buffer;

	public var needLogicNormal : Bool = false;
	var passes : Array<BatchPass> = [];
	var groups : Array<GroupData> = [];

	var cullingShader = new BatchCulling();

	public function new( b : Batcher, format : hxd.BufferFormat ) {
		batcher = b;
		primitive = new h3d.prim.BatchPrimitive(format);
	}

	public function addModel( mesh : h3d.scene.Mesh ) : Int {
		return primitive.addModel(cast mesh.primitive);
	}

	function findPassID( globals : hxsl.Globals, shaders : hxsl.ShaderList, bits : Int, name : String ) : Int {
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

	public function addMaterial( m : h3d.mat.Material, renderer : h3d.scene.Renderer ) : MaterialInstance {
		var globals = @:privateAccess renderer.ctx.globals;
		var draws : Array<DrawInstance> = [];
		for ( p in m.getPasses() ) @:privateAccess {
			var shaders = p.getShadersRec();
			var passID = findPassID(globals, shaders, p.bits, p.name);
			if ( passID < 0 ) {
				passID = passes.length;
				passes.push( new BatchPass(renderer, this, p, shaders, primitive) );
			}
			var bp = passes[passID];
			var shaderData = bp.getShaderData(shaders);
			var draw = new DrawInstance(shaderData , passID);
			draws.push(draw);
		}
		return new MaterialInstance(draws);
	}

	public function emitMesh( mesh : MeshInstance, worldPosition : h3d.Matrix, groupID : Int ) {
		var group = groups[groupID];
		if ( group == null ) {
			group = new GroupData(this);
			groups[groupID] = group;
		}

		var subMeshID = mesh.subMeshID;

		instancesDirty = true;
		totalInstanceCount++;

		group.emitMesh(primitive, subMeshID, mesh.materials, worldPosition, groupID);
	}

	public function uploadPrimitive(ctx : h3d.scene.RenderContext) {
		if ( primitive.buffer == null || primitive.buffer.isDisposed() ) {
			primitive.alloc(ctx.engine);
			if ( needLogicNormal )
				primitive.addLogicNormal();
		}
	}

	public function uploadBatchInfos() {
		if ( !instancesDirty )
			return;
		instancesDirty = false;

		if ( cullingData == null || cullingData.vertices < totalInstanceCount ) {
			cullingData?.dispose();
			cullingData = new h3d.Buffer(totalInstanceCount, CULLING_DATA_FMT, [UniformBuffer]);
		}

		if ( batchInfos == null || batchInfos.vertices < totalInstanceCount ) {
			batchInfos?.dispose();
			batchInfos = new h3d.Buffer(totalInstanceCount, BATCH_INFOS_FMT, [UniformBuffer, ReadWriteBuffer]);
		}

		var groupsNeeded = groups.length;
		if ( groupsInfos == null || groupsInfos.vertices < groupsNeeded ) {
			groupsInfos?.dispose();
			groupsInfos = new h3d.Buffer(groupsNeeded, GROUP_INFOS, [UniformBuffer]);
		}

		var groupsInfosBytes = haxe.io.Bytes.alloc(groupsNeeded * 4);

		var instanceCursor = 0;
		for ( groupID => g in groups ) {
			if ( g == null )
				continue;
			cullingData.uploadBytes( g.instancesData, 0, g.instanceCount, instanceCursor );
			batchInfos.uploadBytes( g.instancesInfos, 0, g.instanceCount, instanceCursor );
			groupsInfosBytes.setInt32( groupID * 4, instanceCursor );
			instanceCursor += g.instanceCount;
		}
		groupsInfos.uploadBytes( groupsInfosBytes, 0, groupsNeeded );
	}

	public function disposeGroup(groupID : Int) {
		groups[groupID]?.dispose();
	}

	public function dispatchCulling(ctx : h3d.scene.RenderContext) {
		if ( totalInstanceCount == 0 )
			return;
		cullingShader.cullingData = cullingData;
		cullingShader.batchInfos = batchInfos;
		cullingShader.subMeshInfos = primitive.gpuSubMeshInfos;
		cullingShader.lodInfos = primitive.gpuLodInfos;
		cullingShader.frustum = ctx.getCameraFrustumBuffer();
		cullingShader.instanceCount = totalInstanceCount;
		cullingShader.shadowMaxDistance = batcher.shadowMaxDistance;
		cullingShader.IS_RELATIVE = batcher.isRelative;
		cullingShader.worldMatrix = batcher.getAbsPos();
		ctx.computeDispatch(cullingShader, hxd.Math.ceil(totalInstanceCount/64.0), false);
	}

	public function emit( ctx : h3d.scene.RenderContext, batchID : Int ) {
		if ( totalInstanceCount == 0 )
			return;

		for ( i => p in passes ) {
			if ( p.totalInstanceCount == 0 )
				continue;
			p.uploadInstances();
			p.dispatchCommandBuilder(ctx, this);
			var hasFollowShader = p.pass.getShader(FollowShader) != null;
			if ( !batcher.isRelative && hasFollowShader )
				p.pass.removeShader(batcher.followShader);
			if ( batcher.isRelative && !hasFollowShader )
				p.pass.addShader(batcher.followShader);
			ctx.emitPass(p.pass, batcher).index = i << 16 | batchID;
			batcher.checkInstancesOffset(p.totalInstanceCount);
		}
	}

	public function draw( ctx : h3d.scene.RenderContext ) {
		passes[ctx.drawPass.index >> 16].draw(ctx);
	}

	public function dispose() {
		for (p in passes)
			p.dispose();
		passes.resize(0);
		for ( g in groups )
			g?.dispose();
		groups.resize(0);
		primitive.dispose();
		if ( totalInstanceCount != 0 )
			throw "Instance leak in batcher";
		totalInstanceCount = 0;
		cullingData?.dispose();
		cullingData = null;
		batchInfos?.dispose();
		batchInfos = null;
		instancesDirty = false;
		groupsInfos?.dispose();
		groupsInfos = null;
		needLogicNormal = false;

	}
}

private class GroupData {
	var passToEmitData : Map<BatchPass, EmitData> = [];
	var batch : Batch;

	public var instanceCount(default, null) = 0;
	public var instancesData(default, null) : haxe.io.Bytes;
	public var instancesInfos(default, null) : haxe.io.Bytes;

	public function new( b : Batch ) {
		batch = b;
	}

	public function emitMesh( primitive : h3d.prim.BatchPrimitive, subMeshID : Int, materials : Array<MaterialInstance>, worldPosition : h3d.Matrix, groupID : Int ) {
		var groupInstanceID = instanceCount++;

		var dataByteStride = Batch.CULLING_DATA_FMT.strideBytes;
		var dataNeeded = instanceCount * dataByteStride;
		if ( instancesData == null )
			instancesData = haxe.io.Bytes.alloc(dataNeeded);
		if ( instancesData.length < dataNeeded) {
			var old = instancesData;
			instancesData = haxe.io.Bytes.alloc(hxd.Math.imax(dataNeeded, (old.length >> 1) * 3));
			instancesData.blit(0, old, 0, old.length);
		}

		var subMesh = primitive.subMeshes[subMeshID];
		var position = worldPosition.getPosition();
		var scale = worldPosition.getScale();
		var boundingSphere = subMesh.bounds.getBoundingRadius();
		boundingSphere *= hxd.Math.max(hxd.Math.max(hxd.Math.abs(scale.x), hxd.Math.abs(scale.y)), hxd.Math.abs(scale.z));

		var dataStart = groupInstanceID * dataByteStride;
		instancesData.setFloat( dataStart + 0, position.x );
		instancesData.setFloat( dataStart + 4, position.y );
		instancesData.setFloat( dataStart + 8, position.z );
		instancesData.setFloat( dataStart + 12, boundingSphere );

		var infoByteStride = Batch.BATCH_INFOS_FMT.strideBytes;
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

		var globals = @:privateAccess batch.batcher.getScene().ctx.globals;

		var subPartStart = subMesh.subPartStart;
		for ( subPartIdx => m in materials ) {
			for ( draw in m.draws ) {
				var bp = batch.passes[draw.passID];
				var emitData = passToEmitData.get(bp);
				if ( emitData == null ) {
					emitData = new EmitData(bp);
					passToEmitData.set(bp, emitData);
				}
				emitData.emitInstance(groupInstanceID, groupID, subPartStart + subPartIdx * subMesh.lodCount, draw.shaderData, worldPosition);
			}
		}
	}

	public function dispose() {
		for ( e in passToEmitData ) @:privateAccess {
			e.dispose();
			if ( instanceCount < e.instanceCount )
				throw "assert";
			instanceCount -= e.instanceCount;
		}
		passToEmitData.clear();
		instancesData = null;
		instancesInfos = null;
		batch.instancesDirty = true;
		if ( batch.totalInstanceCount < instanceCount )
			throw "assert";
		batch.totalInstanceCount -= instanceCount;
		instanceCount = 0;
	}
}

private class BatchCommandBuilder extends hxsl.Shader {
	static var SRC = {
		@param var groupsInfos : StorageBuffer<Int>; // x : batchInstanceStart;
		@param var batchInfos : StorageBuffer<Int>; // 2 elements => 0 : subMeshID, 1 : flags => culledMask(8 bits) + lodSelected(24 bits)
		@param var instancesInfos : StorageBuffer<Int>; // 2 elements => 0 : groupInstanceID, 1 : flags => subPartID(16 bits) + groupID(16 bits)
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
			var groupInstanceID : Int = instancesInfos[passInstancePos + 0];
			var flags : Int = instancesInfos[passInstancePos + 1];
			var groupID : Int = flags >> 16;

			var batchInstanceStart = groupsInfos[groupID];
			var batchInstanceID = batchInstanceStart + groupInstanceID;
			var batchInstancePos = batchInstanceID * batchInfosStride;
			var batchFlags : Int = batchInfos[batchInstancePos + 1];
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
private class BatchPass {
	static var shaderTexParamsCache : Map<Int, Array<String>> = [];

	static final INDIRECT_DRAW_ARGUMENTS_FMT = hxd.BufferFormat.make([{ name : "", type : DVec4 }, { name : "", type : DFloat }]);
	static final PASS_INSTANCES_INFOS_FMT = hxd.BufferFormat.make([{ name : "batchInstanceID", type : DFloat }, { name : "flags", type : DFloat }]); // flags = subPartID(16 bits) + groupID(16 bits)

	static final modelViewID = hxsl.Globals.allocID("global.modelView");
	static final modelViewInverseID = hxsl.Globals.allocID("global.modelViewInverse");
	static final previousModelViewID = hxsl.Globals.allocID("global.previousModelView");

	public var primitive : h3d.prim.BatchPrimitive;
	public var pass : h3d.mat.Pass;
	public var batchShader : hxsl.BatchShader;
	public var shaders : Array<hxsl.Shader>;
	var cullingMask = 0;

	public var totalInstanceCount(default, null) = 0;
	var toEmit : Array<EmitData> = [];
	var instancesDirty = false;
	var instancesData : h3d.Buffer;
	var instancesInfos : h3d.Buffer;

	var command : h3d.impl.InstanceBuffer;
	var commandBuffer : h3d.Buffer;
	var countBuffer : h3d.GPUCounter;
	var builderShader = new BatchCommandBuilder();

	var textureHandlesMap : Map<h3d.mat.TextureHandle, Bool>;
	var textureHandles : Array<h3d.mat.TextureHandle>;

	public function new(renderer : h3d.scene.Renderer, batch : Batch, p : h3d.mat.Pass, sl : hxsl.ShaderList, prim : h3d.prim.BatchPrimitive) @:privateAccess {
		primitive = prim;
		var output = renderer.getPassByName(p.name);
		if( output == null )
			throw "Unknown pass " + p.name;

		var shaderLinker = output.output;
		var rt = shaderLinker.compileShaders(renderer.ctx.globals, sl, Default);
		batch.needLogicNormal = batch.needLogicNormal || rt.getInputFormat().hasInput("logicNormal");

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

	public function getShaderData( sl : hxsl.ShaderList ) : hxd.FloatBuffer {
		var p = batchShader.params;
		var shaders = [null/*link shader*/];
		while( sl != null ) {
			shaders.push(sl.s);
			sl = sl.next;
		}
		var shaderData = new hxd.FloatBuffer(batchShader.paramsSize * 4);
		while ( p != null ) {
			var bufLoader = new hxd.FloatBufferLoader(shaderData, p.pos);
			if( p.perObjectGlobal != null ) {
				if ( p.perObjectGlobal.gid != modelViewID && p.perObjectGlobal.gid != modelViewInverseID && p.perObjectGlobal.gid != previousModelViewID )
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
				if ( textureHandles == null ) {
					textureHandles = [];
					textureHandlesMap = [];
				}
				var h : h3d.mat.TextureHandle = curShader.getParamValue(p.index);
				if ( !textureHandlesMap.exists(h) ) {
					textureHandlesMap.set(h, true);
					textureHandles.push(h);
				}
				bufLoader.loadInt(h.handle.low);
				bufLoader.loadInt(h.handle.high);
			case TSampler(_):
				if ( textureHandles == null ) {
					textureHandles = [];
					textureHandlesMap = [];
				}
				var t : h3d.mat.Texture = curShader.getParamValue(p.index);
				var h = t.getHandle();
				if ( !textureHandlesMap.exists(h) ) {
					textureHandlesMap.set(h, true);
					textureHandles.push(h);
				}
				bufLoader.loadInt(h.handle.low);
				bufLoader.loadInt(h.handle.high);
			default:
				throw "Unsupported per instance type "+p.type;
			}
			p = p.next;
		}
		return shaderData;
	}

	public function uploadInstances() {
		if ( !instancesDirty )
			return;
		instancesDirty = false;

		var instanceDataSize = totalInstanceCount * batchShader.paramsSize;
		if ( instancesData == null || instancesData.vertices < instanceDataSize ) {
			instancesData?.dispose();
			instancesData = new h3d.Buffer( instanceDataSize, hxd.BufferFormat.VEC4_DATA, [UniformBuffer, ReadWriteBuffer] );
			batchShader.Batch_StorageBuffer = instancesData;
		}

		if ( instancesInfos == null || instancesInfos.vertices < totalInstanceCount ) {
			instancesInfos?.dispose();
			instancesInfos = new h3d.Buffer(totalInstanceCount, PASS_INSTANCES_INFOS_FMT, [UniformBuffer]);
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

	public function dispatchCommandBuilder(ctx : h3d.scene.RenderContext, batch : Batch) {
		builderShader.groupsInfos = batch.groupsInfos;
		builderShader.instancesInfos = instancesInfos;
		builderShader.batchInfos = batch.batchInfos;
		builderShader.subPartInfos = primitive.gpuSubPartInfos;
		builderShader.instanceCount = totalInstanceCount;
		builderShader.commandBuffer = commandBuffer;
		builderShader.countBuffer = countBuffer.buffer;
		builderShader.cullingMask = cullingMask;
		countBuffer.reset();
		ctx.computeDispatch(builderShader, hxd.Math.ceil(totalInstanceCount/64.0), false);
	}

	public function draw( ctx : h3d.scene.RenderContext ) {
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

@:allow(h3d.scene.BatchPass)
private class EmitData {
	var instanceCount : Int;
	var instancesInfos : haxe.io.Bytes;
	var instancesData : hxd.FloatBuffer;
	var batchPass : BatchPass;

	public function new(bp : BatchPass) {
		if ( !h3d.Engine.getCurrent().driver.hasFeature(Bindless) )
			throw "h3d.scene.Batcher requires Bindless support.";
		batchPass = bp;
		bp.toEmit.push(this);
	};

	public function emitInstance( groupInstanceID : Int, groupID : Int, subPartID : Int, shaderData : hxd.FloatBuffer,  worldPosition : h3d.Matrix ) {
		batchPass.instancesDirty = true;
		batchPass.totalInstanceCount++;
		var instanceID = instanceCount++;

		if ( subPartID > 0xFFFF || groupID > 0xFFFF )
			throw 'ID overflow. Too many ${subPartID > 0xFFFF ? "models" : "groups"}';

		var instanceInfosStride = BatchPass.PASS_INSTANCES_INFOS_FMT.strideBytes;
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
		var invWorldPosition : h3d.Matrix = null;
		while ( p != null ) {
			var bufLoader = new hxd.FloatBufferLoader(shaderData, p.pos);
			if( p.perObjectGlobal == null ) {
				p = p.next;
				continue;
			}
			if ( p.perObjectGlobal.gid == BatchPass.modelViewID )
				bufLoader.loadMatrix(worldPosition);
			else if ( p.perObjectGlobal.gid == BatchPass.modelViewInverseID ) {
				if ( invWorldPosition == null )
					invWorldPosition = worldPosition.getInverse();
				bufLoader.loadMatrix(invWorldPosition);
			} else if ( p.perObjectGlobal.gid == BatchPass.previousModelViewID )
				bufLoader.loadMatrix(worldPosition);
			else
				throw "Unsupported global param " + p.perObjectGlobal.path;
			p = p.next;
			continue;
		}


		#if hl
		var instanceByteStride = instanceDataStride * 4;
		var startPos = instanceID * instanceByteStride;
		var dst = hl.Bytes.getArray(instancesData.getNative());
		var src = hl.Bytes.getArray(shaderData.getNative());
		dst.blit(startPos, src, 0, instanceByteStride);
		#else
		var startPos = instanceID * instanceDataStride;
		for ( i in 0...instanceDataStride )
			instancesData[startPos + i] = shaderData[i];
		#end
	}

	public function dispose() {
		batchPass.instancesDirty = true;
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
