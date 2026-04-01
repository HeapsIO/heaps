package h3d.scene;

/** Batcher API **/

enum BatcherFlags {
	ManualEmitGPU;
}

@:allow(h3d.scene.Batcher)
class ObjectInstance {
	public var meshes : Array<MeshInstance>;
	function new(meshes : Array<MeshInstance>) {
		this.meshes = meshes;
	}
}

@:allow(h3d.scene.Batcher)
class BatchLibrary {
	static final BATCH_START_FMT = hxd.BufferFormat.make([{ name : "Batch_Start", type : DFloat }]);
	var primitives : Array<h3d.prim.BatchPrimitive> = [];
	var instancesOffset : h3d.Buffer;

	public function new() {
	}

	function getPrimitive( format : hxd.BufferFormat ) {
		for ( p in primitives )
			if ( p.vertexFormat == format )
				return p;
		var p = new h3d.prim.BatchPrimitive(format);
		primitives.push(p);
		return p;
	}

	public function addModel( m : h3d.prim.HMDModel ) {
		var prim = getPrimitive(@:privateAccess m.data.vertexFormat);
		prim.addModel(m);
	}

	public function dispose() {
		for ( p in primitives )
			p.dispose();
		instancesOffset?.dispose();
	}

	public function checkOffsetBuffer( instanceCount : Int ) {
		if ( instancesOffset == null || instancesOffset.vertices < instanceCount || instancesOffset.isDisposed() ) {
			if ( instancesOffset != null ) {
				instancesOffset.dispose();
				for ( p in primitives )
					p.removeBuffer(instancesOffset);
			}
			var tmp = haxe.io.Bytes.alloc(4 * instanceCount);
			for ( i in 0...instanceCount )
				tmp.setFloat(i<<2, i);
			instancesOffset = new h3d.Buffer(instanceCount, BATCH_START_FMT);
			instancesOffset.uploadBytes(tmp, 0, instanceCount);
			for ( p in primitives )
				p.addBuffer(instancesOffset);
		}
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

	public inline function emitInstance( obj : ObjectInstance, worldPosition : h3d.Matrix, syncID : Int = 0 ) {
		batcher.emitInstance( obj, worldPosition, syncID, groupID );
	}

	public inline function remove() {
		batcher.removeGroup(this);
		batcher = null;
	}
}

@:allow(h3d.scene.Batch)
class Batcher extends h3d.scene.Object {
	public var shadowMaxDistance = -1.0;
	public var shadowCameraFrustumCulling = false; // Aggressive culling inside Shadow passes, using player camera frustum
	public var shadowCullingOffset = 100.0;
	public var isRelative : Bool = false;
	public var batchFlags = new haxe.EnumFlags<BatcherFlags>();
	public var syncShader : SyncShaderInterface;
	var followShader : FollowShader;

	var highestGroupID = 1;
	var freeGroupIDs : Array<Int> = [];
	var groups : Array<BatchGroup> = [];

	var batches : Array<Batch> = [];
	var primToBatch : Map<h3d.prim.BatchPrimitive, Int> = [];
	var library : BatchLibrary;
	var shouldDisposeLibrary : Bool = false;

	public function addShader( s : hxsl.Shader ) {
		for ( b in batches )
			for ( p in @:privateAccess b.passes )
				p.pass.addShader(s);
	}

	public function new( parent : h3d.scene.Object, library : BatchLibrary = null, batchFlags = null ) {
		if ( !h3d.Engine.getCurrent().driver.hasFeature(Bindless) )
			throw "h3d.scene.Batcher requires Bindless support.";
		super(parent);
		if ( batchFlags != null )
			this.batchFlags = batchFlags;
		shouldDisposeLibrary = library == null;
		this.library = shouldDisposeLibrary ? new BatchLibrary() : library;
		ignoreCollide = true;
	}

	function getBatchID( hmd : h3d.prim.HMDModel ) {
		var format = @:privateAccess hmd.data.vertexFormat;
		var prim = library.getPrimitive(format);
		var batchID = primToBatch.get(prim);
		if ( batchID != null )
			return batchID;
		var batchID = batches.length;
		batches.push(new Batch(this, prim));
		primToBatch.set(prim, batchID);
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
	public function emitInstance( instance : ObjectInstance, worldPosition : h3d.Matrix, syncID : Int = 0, groupID : Int = 0 ) {
		for ( mesh in instance.meshes ) {
			var batch = batches[mesh.batchID];
			tmpMat.multiply3x4(mesh.relPos, worldPosition);
			batch.emitMesh( mesh, tmpMat, syncID, groupID );
		}
	}

	public function syncGPU(ctx : h3d.scene.RenderContext) {
		if ( !batchFlags.has(ManualEmitGPU) )
			throw "Can't call syncGPU without flag ManualEmitGPU";
		for ( b in batches )
			b.syncGPU(ctx);
		ctx.memoryBarrier();
	}

	public function emitGPU(ctx : h3d.scene.RenderContext) {
		if ( !batchFlags.has(ManualEmitGPU) )
			throw "Can't call emitGPU without flag ManualEmitGPU";
		for ( b in batches )
			b.emitGPU(ctx);
		ctx.memoryBarrier();
	}

	override function emit( ctx : h3d.scene.RenderContext ) {
		var maxInstanceCount = 0;
		for ( b in batches ) {
			b.uploadPrimitive(ctx);
			if ( b.totalInstanceCount == 0 )
				continue;
			maxInstanceCount = hxd.Math.imax(b.totalInstanceCount, maxInstanceCount);
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

		var doDispatch = !batchFlags.has(ManualEmitGPU);
		for ( batchID => b in batches )
			b.emit(ctx, batchID, doDispatch);

		if ( doDispatch )
			ctx.memoryBarrier();
	}

	override function draw(ctx : h3d.scene.RenderContext ) {
		batches[ctx.drawPass.index & 0xFFFF].draw(ctx);
	}

	override function onRemove() {
		for ( b in batches)
			b.dispose();
		if ( shouldDisposeLibrary )
			library.dispose();
		groups.resize(0);
		batches.resize(0);
		freeGroupIDs.resize(0);
		highestGroupID = 1;
	}
}

class BaseSync extends hxsl.Shader {
	static var SRC = {
		@param var instancesData : RWBuffer<Vec4>;
		@param var instanceStride : Int;
		@param var modelViewOffset : Int;
		@param var instanceCount : Int;
		@param var syncIDs : StorageBuffer<Int>;

		function getModelView( id : Int ) : Mat4 {
			var modelViewPos = id * instanceStride + modelViewOffset;
			return mat4(
				instancesData[modelViewPos + 0],
				instancesData[modelViewPos + 1],
				instancesData[modelViewPos + 2],
				instancesData[modelViewPos + 3],
			);
		}

		function fillModelView( id : Int, modelView : Mat4 ) {
			var modelViewPos = id * instanceStride + modelViewOffset;
			instancesData[modelViewPos + 0] = modelView[0];
			instancesData[modelViewPos + 1] = modelView[1];
			instancesData[modelViewPos + 2] = modelView[2];
			instancesData[modelViewPos + 3] = modelView[3];
		}
	}
}

interface SyncShaderInterface {
	var instancesData(get,set) : h3d.Buffer;
	var instanceStride(get,set) : Int;
	var modelViewOffset(get,set) : Int;
	var instanceCount(get,set) : Int;
	var syncIDs(get,set) : h3d.Buffer;
	public function hasSyncIDs() : Bool;
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
		var transformedNormal : Vec3;
		var transformedTangent : Vec4;
		var previousTransformedPosition : Vec3;

		function __init__vertex() {
			transformedPosition = transformedPosition * followMatrix.mat3x4();
			transformedNormal = normalize(transformedNormal * followMatrix.mat3());
			transformedTangent.xyz = normalize(transformedTangent.xyz * followMatrix.mat3());
			previousTransformedPosition = previousTransformedPosition * prevFollowMatrix.mat3x4();
		}
	};
}

@:allow(h3d.scene.GroupData, h3d.scene.BatchPass)
private class Batch {
	public var batcher : h3d.scene.Batcher;
	public var primitive : h3d.prim.BatchPrimitive;

	public var totalInstanceCount : Int;
	public var instancesDirty : Bool;

	public var needLogicNormal : Bool = false;
	var passes : Array<BatchPass> = [];
	var groups : Array<GroupData> = [];

	public function new( b : Batcher, prim : h3d.prim.BatchPrimitive ) {
		batcher = b;
		primitive = prim;
	}

	public function addModel( mesh : h3d.scene.Mesh ) : Int {
		return primitive.addModel(cast mesh.primitive);
	}

	function findPassID( globals : hxsl.Globals, shaders : hxsl.ShaderList, pass : h3d.mat.Pass ) : Int {
		for ( i => bp in passes ) @:privateAccess {
			if ( pass.bits == bp.pass.bits && pass.name == bp.pass.name && pass.layer == bp.pass.layer ) {
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
			var passID = findPassID(globals, shaders, p);
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

	public function emitMesh( mesh : MeshInstance, worldPosition : h3d.Matrix, syncID : Int, groupID : Int ) {
		var group = groups[groupID];
		if ( group == null ) {
			group = new GroupData(this);
			groups[groupID] = group;
		}

		var subMeshID = mesh.subMeshID;

		instancesDirty = true;
		totalInstanceCount++;

		group.emitMesh(primitive, subMeshID, mesh.materials, worldPosition, syncID, groupID);
	}

	public function uploadPrimitive(ctx : h3d.scene.RenderContext) {
		if ( primitive.gpuSubMeshInfos == null || primitive.gpuSubMeshInfos.isDisposed() ) {
			primitive.alloc(ctx.engine);
			if ( batcher.library.instancesOffset != null )
				primitive.addBuffer(batcher.library.instancesOffset);
		}
		if ( needLogicNormal )
			primitive.addLogicNormal();
	}

	public function disposeGroup(groupID : Int) {
		groups[groupID]?.dispose();
	}

	public function syncGPU(ctx : h3d.scene.RenderContext) {
		for ( i => p in passes ) {
			if ( p.totalInstanceCount == 0 )
				continue;
			p.syncGPU(ctx);
		}
	}

	public function emitGPU(ctx : h3d.scene.RenderContext) {
		for ( i => p in passes ) {
			if ( p.totalInstanceCount == 0 )
				continue;
			p.emitGPU(ctx);
		}
	}

	public function emit( ctx : h3d.scene.RenderContext, batchID : Int, doEmitGPU : Bool ) {
		if ( totalInstanceCount == 0 )
			return;

		for ( i => p in passes ) {
			if ( p.totalInstanceCount == 0 )
				continue;
			if ( doEmitGPU )
				p.emitGPU(ctx);
			var hasFollowShader = p.pass.getShader(FollowShader) != null;
			if ( !batcher.isRelative && hasFollowShader )
				p.pass.removeShader(batcher.followShader);
			if ( batcher.isRelative && !hasFollowShader )
				p.pass.addShader(batcher.followShader);
			ctx.emitPass(p.pass, batcher).index = i << 16 | batchID;
			batcher.library.checkOffsetBuffer(p.totalInstanceCount);
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
		if ( totalInstanceCount != 0 )
			throw "Instance leak in batcher";
		totalInstanceCount = 0;
		instancesDirty = false;
		needLogicNormal = false;
	}
}

private class GroupData {
	var passToEmitData : Map<BatchPass, EmitData> = [];
	var batch : Batch;

	public var instanceCount(default, null) = 0;

	public function new( b : Batch ) {
		batch = b;
	}

	public function emitMesh( primitive : h3d.prim.BatchPrimitive, subMeshID : Int, materials : Array<MaterialInstance>, worldPosition : h3d.Matrix, syncID : Int, groupID : Int ) {
		instanceCount++;

		var subMesh = primitive.subMeshes[subMeshID];
		var subPartStart = subMesh.subPartStart;
		for ( subPartIdx => m in materials ) {
			for ( draw in m.draws ) {
				var bp = batch.passes[draw.passID];
				var emitData = passToEmitData.get(bp);
				if ( emitData == null ) {
					emitData = new EmitData(bp);
					passToEmitData.set(bp, emitData);
				}
				emitData.emitInstance(subMeshID, subPartStart + subPartIdx * subMesh.lodCount, draw.shaderData, worldPosition, syncID );
			}
		}
	}

	public function dispose() {
		for ( e in passToEmitData ) {
			e.dispose();
			if ( instanceCount < e.instanceCount )
				throw "assert";
			instanceCount -= e.instanceCount;
		}
		passToEmitData.clear();
		batch.instancesDirty = true;
		if ( batch.totalInstanceCount < instanceCount )
			throw "assert";
		batch.totalInstanceCount -= instanceCount;
		instanceCount = 0;
	}
}

private class BatchCommandBuilder extends hxsl.Shader {
	static var SRC = {
		@const var ENABLE_FRUSTUM_CULLING : Bool;
		@const var ENABLE_DISTANCE_CLIPPING : Bool;
		@const var ENABLE_DIRLIGHT_OBB_CULLING : Bool;
		
		@global var camera : {
			var position : Vec3;
			var proj : Mat4;
		}

		@param var instancesData : StorageBuffer<Vec4>;
		@param var instanceStride : Int;
		@param var modelViewOffset : Int;
		@param var instancesInfos : StorageBuffer<Int>; // 1 elements => 0 : flags = subPartID(16 bits) + subMeshID(16 bits)
		@param var subMeshInfos : StorageBuffer<Float>; // 3 elements => 0 : lodStart, 1 : lodCount, 2 : boundingSphere
		@param var lodInfos : StorageBuffer<Float>; // x : screenRatio
		@param var subPartInfos : StorageBuffer<Int>; // 2 elements => 0 : indexCount, 1 : indexStart
		@param var countBuffer : RWBuffer<Int>;
		@param var commandBuffer : RWBuffer<Int>;
		@param var instanceCount : Int;

		@const var IS_RELATIVE : Bool;
		@param var worldMatrix : Mat4;

		@param var frustum : Buffer<Vec4, 6>;

		@param var maxDistance : Float = -1;

		final subMeshInfosStride : Int = 3;
		final subPartInfosStride : Int = 2;

		@param var lightMatrix : Mat3;
		@param var lightOBBMin : Vec3;
		@param var lightOBBMax : Vec3;

		function insideOBB(pos : Vec3, radius : Float, min : Vec3, max : Vec3) : Bool {
			return (pos.x + radius) > min.x && (pos.x - radius) < max.x &&
					(pos.y + radius) > min.y && (pos.y - radius) < max.y &&
					(pos.z + radius) > min.z && (pos.z - radius) < max.z;
		}

		function emitInstance(instanceID : Int, indexCount : Int, instanceCount : Int, startIndex : Int, startVertex : Int, baseInstance : Int ) {
			var instancePos = instanceID * 5;
			commandBuffer[instancePos + 0] = indexCount;
			commandBuffer[instancePos + 1] = instanceCount;
			commandBuffer[instancePos + 2] = startIndex;
			commandBuffer[instancePos + 3] = startVertex;
			commandBuffer[instancePos + 4] = baseInstance;
		}

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

			var modelViewPos = instanceID * instanceStride + modelViewOffset;
			var modelView = mat4(
				instancesData[modelViewPos + 0],
				instancesData[modelViewPos + 1],
				instancesData[modelViewPos + 2],
				instancesData[modelViewPos + 3],
			);
			var position = vec3(modelView[0].w, modelView[1].w, modelView[2].w);
			var scale = vec3(
				length(vec3(modelView[0].x,modelView[1].x,modelView[2].x)),
				length(vec3(modelView[0].y,modelView[1].y,modelView[2].y)),
				length(vec3(modelView[0].z,modelView[1].z,modelView[2].z))
			);

			if ( IS_RELATIVE ) {
				position = position * worldMatrix.mat3x4();
				var worldScale = vec3(
					length(vec3(worldMatrix[0].x,worldMatrix[1].x,worldMatrix[2].x)),
					length(vec3(worldMatrix[0].y,worldMatrix[1].y,worldMatrix[2].y)),
					length(vec3(worldMatrix[0].z,worldMatrix[1].z,worldMatrix[2].z))
				);
				scale *= worldScale;
			}

			var flags : Int = instancesInfos[instanceID];
			var subMeshID : Int = flags >> 16;

			var subMeshPos = subMeshID * subMeshInfosStride;
			var lodStart : Int = floatBitsToInt(subMeshInfos[subMeshPos + 0]);
			var lodCount : Int = floatBitsToInt(subMeshInfos[subMeshPos + 1]);
			var boundingSphere = subMeshInfos[subMeshPos + 2] * max(scale.x,max(scale.y, scale.z));

			if ( ENABLE_FRUSTUM_CULLING ) {
				@unroll for ( i  in 0...6 ) {
					var plane = frustum[i];
				 	if ((dot(plane.xyz, position) - plane.w) < -boundingSphere)
						return;
				}
			}

			if ( ENABLE_DIRLIGHT_OBB_CULLING ) {
				var objPosLs = position * lightMatrix;			
				if ( !insideOBB(objPosLs, boundingSphere, lightOBBMin, lightOBBMax) )
					return;
			}

			var toCam = camera.position - position.xyz;
			var distToCam = length(toCam);
			if ( ENABLE_DISTANCE_CLIPPING )
				if ( distToCam > maxDistance)
					return;

			var screenRatio = computeScreenRatio(distToCam, boundingSphere);
			var lodSelected : Int = 0;
			for ( i in 0...lodCount ) {
				var minScreenRatio = lodInfos[lodStart + i];
				if ( screenRatio > minScreenRatio )
					break;
				lodSelected++;
			}

			if ( lodSelected >= lodCount )
				return;

			var subPartID : Int = flags & 0xFFFF;
			var subPartPos = (subPartID + lodSelected) * subPartInfosStride;
			var indexCount : Int = subPartInfos[subPartPos + 0];
			var indexStart : Int = subPartInfos[subPartPos + 1];

			var id = atomicAdd( countBuffer, 0, 1 );
			emitInstance( id, indexCount, 1, indexStart, 0, instanceID );
		}
	}
}

@:allow(h3d.scene.EmitData)
private class BatchPass {
	static var shaderTexParamsCache : Map<Int, Array<String>> = [];

	static final INDIRECT_DRAW_ARGUMENTS_FMT = hxd.BufferFormat.make([{ name : "", type : DVec4 }, { name : "", type : DFloat }]);
	static final PASS_INSTANCES_INFOS_FMT = hxd.BufferFormat.make([{ name : "flags", type : DFloat }]); // flags = subPartID(16 bits) + subMeshID(16 bits)

	static final modelViewID = hxsl.Globals.allocID("global.modelView");
	static final modelViewInverseID = hxsl.Globals.allocID("global.modelViewInverse");
	static final previousModelViewID = hxsl.Globals.allocID("global.previousModelView");

	public var primitive : h3d.prim.BatchPrimitive;
	public var pass : h3d.mat.Pass;
	public var batchShader : hxsl.BatchShader;
	public var shaders : Array<hxsl.Shader>;
	var batcher : Batcher;
	var isShadowPass = false;
	var modelViewOffset : Int;

	public var totalInstanceCount(default, null) = 0;
	var toEmit : Array<EmitData> = [];
	var instancesDirty = false;
	var instancesData : h3d.Buffer;
	var instancesInfos : h3d.Buffer;
	var instancesFormat : hxd.BufferFormat;
	var syncIDs : h3d.Buffer;

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
		batcher = batch.batcher;

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
		isShadowPass = pass.name == "shadow";
		var p = batchShader.params;
		while ( p != null ) {
			if( p.perObjectGlobal != null && p.perObjectGlobal.gid == modelViewID ) {
				modelViewOffset = p.pos >> 2;
				break;
			}
			p = p.next;
		}
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
		var alloc = hxd.impl.Allocator.get();

		var instanceDataSize = totalInstanceCount * batchShader.paramsSize;
		if ( instancesData == null || instancesData.vertices < instanceDataSize ) {
			if ( instancesData != null )
				alloc.disposeBuffer(instancesData);
			instancesData = alloc.allocBuffer( instanceDataSize, hxd.BufferFormat.VEC4_DATA, UniformReadWrite );
		}
		batchShader.Batch_StorageBuffer = instancesData;

		var hasSyncIDs = batcher.syncShader?.hasSyncIDs() == true;
		if ( hasSyncIDs ) {
			if ( syncIDs == null || syncIDs.vertices < totalInstanceCount ) {
				if ( syncIDs != null )
					alloc.disposeBuffer(syncIDs);
				syncIDs = alloc.allocBuffer( totalInstanceCount, hxd.BufferFormat.INDEX32, Uniform );
			}
		}

		if ( instancesInfos == null || instancesInfos.vertices < totalInstanceCount ) {
			if ( instancesInfos != null )
				alloc.disposeBuffer(instancesInfos);
			instancesInfos = alloc.allocBuffer( totalInstanceCount, PASS_INSTANCES_INFOS_FMT, Uniform );
		}

		var instanceCursor = 0;
		for ( ed in toEmit ) {
			instancesData.uploadFloats( ed.instancesData, 0, ed.instanceCount * batchShader.paramsSize, instanceCursor * batchShader.paramsSize );
			instancesInfos.uploadBytes( ed.instancesInfos, 0, ed.instanceCount, instanceCursor );
			if ( hasSyncIDs )
				syncIDs.uploadBytes( ed.syncIDs, 0, ed.instanceCount, instanceCursor);
			instanceCursor += ed.instanceCount;
		}

		if ( commandBuffer == null || commandBuffer.vertices < totalInstanceCount )  {
			if ( commandBuffer != null )
				alloc.disposeBuffer(commandBuffer);
			commandBuffer = alloc.allocBuffer( totalInstanceCount, INDIRECT_DRAW_ARGUMENTS_FMT, UniformReadWrite );
			if ( command == null )
				command = new h3d.impl.InstanceBuffer();
			@:privateAccess command.data = commandBuffer.vbuf;
		}

		if ( countBuffer == null ) {
			countBuffer = new GPUCounter();
			@:privateAccess command.countBuffer = countBuffer.buffer.vbuf;
		}
	}

	public function syncGPU(ctx : h3d.scene.RenderContext) {
		uploadInstances();
		var s = batcher.syncShader;
		s.instancesData = instancesData;
		s.instanceStride = batchShader.paramsSize;
		s.modelViewOffset = modelViewOffset;
		s.instanceCount = totalInstanceCount;
		s.syncIDs = syncIDs;
		ctx.computeDispatch(cast s, hxd.Math.ceil(totalInstanceCount/64.0), false);
	}

	var tmpMinLs = new h3d.Vector();
	var tmpMaxLs = new h3d.Vector();
	var tmpUp = new h3d.Vector(0, 1, 0);

	public function emitGPU(ctx : h3d.scene.RenderContext) {
		uploadInstances();
		builderShader.instancesData = instancesData;
		builderShader.instanceStride = batchShader.paramsSize;
		builderShader.modelViewOffset = modelViewOffset;
		builderShader.instancesInfos = instancesInfos;
		builderShader.subMeshInfos = primitive.gpuSubMeshInfos;
		builderShader.lodInfos = primitive.gpuLodInfos;
		builderShader.subPartInfos = primitive.gpuSubPartInfos;
		builderShader.instanceCount = totalInstanceCount;
		builderShader.commandBuffer = commandBuffer;
		builderShader.countBuffer = countBuffer.buffer;
		builderShader.IS_RELATIVE = batcher.isRelative;
		builderShader.worldMatrix = batcher.getAbsPos();
		builderShader.ENABLE_DISTANCE_CLIPPING = isShadowPass && batcher.shadowMaxDistance > 0.0;

		builderShader.frustum = ctx.getCameraFrustumBuffer();

		if ( isShadowPass && !batcher.shadowCameraFrustumCulling ) {
			builderShader.maxDistance = batcher.shadowMaxDistance;
			var ls = ctx.lightSystem;
			if ( ls != null ) {
				var sl = ls.shadowLight;
				if ( sl != null ) {
					var pbrSl = Std.downcast(sl, h3d.scene.pbr.Light);
					if ( pbrSl != null ) {
						var z = @:privateAccess pbrSl.getShadowDirection();
						z.normalize();
						var x = tmpUp.cross(z);
						x.normalize();
						var y = z.cross(x);
						y.normalize();

						var lightMatrix = h3d.Matrix.L([
							x.x, y.x, z.x, 0,
							x.y, y.y, z.y, 0,
							x.z, y.z, z.z, 0
						]);

						tmpMinLs.set(1e30, 1e30, 1e30);
						tmpMaxLs.set(-1e30, -1e30, -1e30);

						var frustumPoints = ctx.camera.frustum.getPoints();
						for ( i in 0...8 ) {
							var p = frustumPoints[i];
							var pLs = p * lightMatrix;
							tmpMinLs.min(pLs);
							tmpMaxLs.max(pLs);
						}

						tmpMinLs.z = tmpMinLs.z - batcher.shadowCullingOffset;
						builderShader.lightMatrix = lightMatrix;
						builderShader.lightOBBMin.set(tmpMinLs.x, tmpMinLs.y, tmpMinLs.z);
						builderShader.lightOBBMax.set(tmpMaxLs.x, tmpMaxLs.y, tmpMaxLs.z);

						builderShader.ENABLE_DIRLIGHT_OBB_CULLING = true;
					}
				}
			}
		} else {
			builderShader.ENABLE_FRUSTUM_CULLING = true;
			builderShader.ENABLE_DIRLIGHT_OBB_CULLING = false;
		}

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
		var alloc = hxd.impl.Allocator.get();
		if ( instancesData != null ) {
			alloc.disposeBuffer(instancesData);
			instancesData = null;
		}
		if ( instancesInfos != null ) {
			alloc.disposeBuffer(instancesInfos);
			instancesInfos = null;
		}
		if ( commandBuffer != null ) {
			alloc.disposeBuffer(commandBuffer);
			commandBuffer = null;
		}
		countBuffer?.dispose();
		countBuffer = null;
		command = null;
	}
}

@:allow(h3d.scene.BatchPass)
private class EmitData {
	public var instanceCount(default, null) : Int;
	var instancesInfos : haxe.io.Bytes;
	var instancesData : hxd.FloatBuffer;
	var syncIDs : haxe.io.Bytes;
	var batchPass : BatchPass;

	public function new(bp : BatchPass) {
		batchPass = bp;
		bp.toEmit.push(this);
	};

	public function emitInstance( subMeshID : Int, subPartID : Int, shaderData : hxd.FloatBuffer, worldPosition : h3d.Matrix, syncID : Int ) {
		batchPass.instancesDirty = true;
		batchPass.totalInstanceCount++;
		var instanceID = instanceCount++;

		if ( subPartID > 0xFFFF || subMeshID > 0xFFFF )
			throw 'ID overflow. Too many models';

		var instanceInfosStride = BatchPass.PASS_INSTANCES_INFOS_FMT.strideBytes;
		var minInstanceInfosSize = instanceCount * instanceInfosStride;
		if ( instancesInfos == null )
			instancesInfos = haxe.io.Bytes.alloc(minInstanceInfosSize);
		if ( instancesInfos.length < minInstanceInfosSize) {
			var old = instancesInfos;
			instancesInfos = haxe.io.Bytes.alloc( hxd.Math.imax((old.length >> 1) * 3, minInstanceInfosSize) );
			instancesInfos.blit(0, old, 0, old.length);
		}
		instancesInfos.setInt32(instanceID * instanceInfosStride, subMeshID << 16 | subPartID );

		if ( @:privateAccess batchPass.batcher.syncShader?.hasSyncIDs() ) {
			var minSyncDataSize = instanceCount << 2;
			if ( syncIDs == null )
				syncIDs = haxe.io.Bytes.alloc(minSyncDataSize);
			if ( syncIDs.length < minSyncDataSize ) {
				var old = syncIDs;
				syncIDs = haxe.io.Bytes.alloc( hxd.Math.imax((old.length >> 1) * 3, minSyncDataSize) );
				syncIDs.blit(0, old, 0, old.length);
			}
			syncIDs.setInt32(instanceID << 2, syncID);
		}

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
