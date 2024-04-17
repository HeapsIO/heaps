package h3d.scene;

import hxsl.ShaderList;

private class BatchData {

	public var paramsCount : Int;
	public var maxInstance : Int;
	public var matIndex : Int;
	public var indexCount : Int;
	public var indexStart : Int;
	public var instanceBuffers : Array<h3d.impl.InstanceBuffer>;
	public var buffers : Array<h3d.Buffer> = [];
	public var bufferFormat : hxd.BufferFormat;
	public var data : hxd.FloatBuffer;
	public var params : hxsl.RuntimeShader.AllocParam;
	public var shader : hxsl.BatchShader;
	public var shaders : Array<hxsl.Shader>;
	public var modelViewPos : Int;
	public var pass : h3d.mat.Pass;
	public var computeShaders : Array<ComputeIndirect>;
	public var next : BatchData;

	public function new() {
	}

}

class MeshBatchPart {
	public var indexStart : Int;
	public var indexCount : Int;
	public var baseVertex : Int;
	public var bounds : h3d.col.Bounds;
	public function new() {
	}
}

enum MeshBatchFlag {
	EnableGPUCulling;
	EnableLOD;
	EnableResizeDown;
}

class ComputeIndirect extends hxsl.Shader {
	static var SRC = {

		@global var camera : {
			var position : Vec3;
		}

		@const(4096) var MAX_INSTANCE : Int;
		@param var commandBuffer : RWBuffer<Int, MAX_INSTANCE>;
		@param var instanceData : PartialBuffer<{ modelView : Mat4}, MAX_INSTANCE>;
		@param var radius : Float;

		@const(16) var MATERIAL_COUNT : Int = 1;
		@param var matIndex : Float;
		// x : indexCount, y : startIndex, z : minScreenRatio, w : unused
		@param var matInfos : Buffer<Vec4, MATERIAL_COUNT>;

		@const var ENABLE_CULLING : Bool;
		@param var frustum : Buffer<Vec4, 6>;

		@const var ENABLE_LOD : Bool;
		@param var lodCount : Float = 1;

		function main() {
			var invocID = computeVar.globalInvocation.x;
			var lod : Int = 0;
			var modelView = instanceData[invocID].modelView;
			var pos = vec3(0) * modelView.mat3x4();
			var vScale = vec3(1) * modelView.mat3x4() - pos;
			var scaledRadius = max(max(vScale.x, vScale.y), vScale.z) * radius;
			var toCam = camera.position - pos.xyz;
			var distToCam = length(toCam);

			var culled = false;

			if ( ENABLE_CULLING ) {
				for ( i  in 0...6 ) {
					var plane = frustum[i];
					if ( plane.x * pos.x + plane.y * pos.y + plane.z * pos.z - plane.w < -scaledRadius ) {
						culled = true;
						break;
					}
				}
			}

			if ( ENABLE_LOD ) {
				var screenRatio = scaledRadius / distToCam;
				for ( i in 0...int(lodCount) ) {
					var minScreenRatio = matInfos[i *  MATERIAL_COUNT].z;
					if (  screenRatio > minScreenRatio )
						break;
					lod++;
				}
				lod = clamp(lod, 0, int(lodCount) - 1);
			}

			if ( !culled ) {
				commandBuffer[ invocID * 5 ] = floatBitsToInt(matInfos[ int(matIndex) + lod * MATERIAL_COUNT ].x) ;
				commandBuffer[ invocID * 5 + 1] = 1;
				commandBuffer[ invocID * 5 + 2] = floatBitsToInt(matInfos[ int(matIndex) + lod * MATERIAL_COUNT ].y);
				commandBuffer[ invocID * 5 + 3] = 0;
				commandBuffer[ invocID * 5 + 4] = invocID;
			}
			else {
				commandBuffer[ invocID * 5 ] = 0;
				commandBuffer[ invocID * 5 + 1] = 0;
				commandBuffer[ invocID * 5 + 2] = 0;
				commandBuffer[ invocID * 5 + 3] = 0;
				commandBuffer[ invocID * 5 + 4] = 0;
			}
		}
	}
}

/**
	h3d.scene.MeshBatch allows to draw multiple meshed in a single draw call.
	See samples/MeshBatch.hx for an example.
**/
class MeshBatch extends MultiMaterial {

	static var modelViewID = hxsl.Globals.allocID("global.modelView");
	static var modelViewInverseID = hxsl.Globals.allocID("global.modelViewInverse");
	static var MAX_BUFFER_ELEMENTS = 4096;

	var instanced : h3d.prim.Instanced;
	var dataPasses : BatchData;
	var needUpload = false;

	public var meshBatchFlags(default, null) : haxe.EnumFlags<MeshBatchFlag>;
	var enableLOD(get, null) : Bool;
	function get_enableLOD() return meshBatchFlags.has( EnableLOD );
	var enableGPUCulling(get, null) : Bool;
	function get_enableGPUCulling() return meshBatchFlags.has( EnableGPUCulling ); 
	
	var matInfos : h3d.Buffer;

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
	var invWorldPosition : Matrix;

	/**
		Tells the mesh batch to draw only a subpart of the primitive
	**/
	public var primitiveSubPart : MeshBatchPart;
	var primitiveSubBytes : haxe.io.Bytes;

	/**
		If set, exact bounds will be recalculated during emitInstance (default true)
	**/
	public var calcBounds = true;

	/**
	 	Tells the per instance buffer to support gpu write using comptue shaders.
	**/
	public var allowGpuUpdate : Bool = false;


	var instancedParams : hxsl.Cache.BatchInstanceParams;

	public function new( primitive, ?material, ?parent ) {
		instanced = new h3d.prim.Instanced();
		instanced.commands = new h3d.impl.InstanceBuffer();
		instanced.setMesh(primitive);
		super(instanced, material == null ? null : [material], parent);
		for( p in this.material.getPasses() )
			@:privateAccess p.batchMode = true;
	}

	override function onRemove() {
		super.onRemove();
		cleanPasses();
	}

	function cleanPasses() {
		var alloc = hxd.impl.Allocator.get();
		while( dataPasses != null ) {
			dataPasses.pass.removeShader(dataPasses.shader);
			for( b in dataPasses.buffers )
				alloc.disposeBuffer(b);

			if ( dataPasses.computeShaders != null && dataPasses.computeShaders.length > 0 ) {
				@:privateAccess instanced.commands.data = null;
				for ( compute in dataPasses.computeShaders) {
					alloc.disposeBuffer(compute.commandBuffer);
					compute.commandBuffer = null;
				}
				dataPasses.computeShaders.resize(0);
			}

			if( dataPasses.instanceBuffers != null ) {
				for( b in dataPasses.instanceBuffers )
					b.dispose();
			}
			alloc.disposeFloats(dataPasses.data);
			dataPasses = dataPasses.next;
		}
		if ( matInfos != null ) {
			alloc.disposeBuffer(matInfos);
			matInfos = null;
		}
		if( instanced.commands != null )
			instanced.commands.dispose();
		shadersChanged = true;
	}

	function initShadersMapping() {
		var scene = getScene();
		if( scene == null ) return;
		cleanPasses();
		for( index in 0...materials.length ) {
			var mat = materials[index];
			if( mat == null ) continue;
			var matInfo = @:privateAccess instanced.primitive.getMaterialIndexes(index);
			for( p in mat.getPasses() ) @:privateAccess {
				var ctx = scene.renderer.getPassByName(p.name);
				if( ctx == null ) throw "Could't find renderer pass "+p.name;

				var output = ctx.output;
				var shaders = p.getShadersRec();
				var rt = output.compileShaders(scene.ctx.globals, shaders, Default);
				var shader = output.shaderCache.makeBatchShader(rt, shaders, instancedParams);

				var b = new BatchData();
				b.indexCount = matInfo.count;
				b.indexStart = matInfo.start;
				b.paramsCount = shader.paramsSize;
				b.maxInstance = Std.int(MAX_BUFFER_ELEMENTS / b.paramsCount);
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

				if( allowGpuUpdate || enableGPUCulling || enableLOD ) {
					var pl = [];
					var p = b.params;
					while( p != null ) {
						pl.push(p);
						p = p.next;
					}
					pl.sort(function(p1,p2) return p1.pos - p2.pos);
					var fmt : Array<hxd.BufferFormat.BufferInput> = [];
					var curPos = 0;
					for( p in pl ) {
						if( curPos != p.pos )
							throw "Buffer has padding";
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
					b.bufferFormat = hxd.BufferFormat.make(fmt);
				}

				b.next = dataPasses;
				dataPasses = b;

				var sl = shaders;
				while( sl != null ) {
					b.shaders.push(sl.s);
					sl = sl.next;
				}
				shader.Batch_Count = b.maxInstance * b.paramsCount;
				shader.Batch_HasOffset = primitiveSubPart != null || enableLOD || enableGPUCulling;
				shader.constBits = (shader.Batch_Count << 1) | (shader.Batch_HasOffset ? 1 : 0);
				shader.updateConstants(null);
			}
		}

		// add batch shaders
		var p = dataPasses;
		while( p != null ) {
			@:privateAccess p.pass.addSelfShader(p.shader);
			p = p.next;
		}
	}

	public function begin( emitCountTip = -1, ?flags : haxe.EnumFlags<MeshBatchFlag> ) {
		if ( flags != null ) {
			meshBatchFlags.setTo(EnableResizeDown, flags.has(EnableResizeDown));
			#if !js
			// TODO : Add LOD and GPU Culling support for mesh batch using sub parts
			var allowedLOD = flags.has(EnableLOD) && primitiveSubPart == null && Std.isOfType(@:privateAccess instanced.primitive, h3d.prim.HMDModel);
			var allowedGPUCulling = flags.has(EnableGPUCulling) && primitiveSubPart == null;

			if ( meshBatchFlags.has(EnableLOD) != allowedLOD || meshBatchFlags.has(EnableGPUCulling) != allowedGPUCulling ) {
				shadersChanged = true;
				meshBatchFlags.setTo(EnableLOD, allowedLOD);
				meshBatchFlags.setTo(EnableGPUCulling, allowedGPUCulling);
			}
			#end
		}

		instanceCount = 0;
		instanced.initBounds();
		if( shadersChanged ) {
			initShadersMapping();
			shadersChanged = false;
		}

		if( emitCountTip < 0 )
			emitCountTip = 128;
		var p = dataPasses;
		var alloc = hxd.impl.Allocator.get();
		while( p != null ) {
			var size = emitCountTip * p.paramsCount * 4;
			if( p.data == null || p.data.length < size || ( meshBatchFlags.has(EnableResizeDown) && p.data.length > size << 1) ) {
				if( p.data != null ) alloc.disposeFloats(p.data);
				p.data = alloc.allocFloats(size);
			}
			p = p.next;
		}
	}

	function syncData( batch : BatchData ) {

		var startPos = batch.paramsCount * instanceCount << 2;
		// in case we are bigger than emitCountTip
		if( startPos + (batch.paramsCount<<2) > batch.data.length )
			batch.data.grow(batch.data.length << 1);

		var p = batch.params;
		var buf = batch.data;
		var shaders = batch.shaders;

		var calcInv = false;
		while( p != null ) {
			var pos = startPos + p.pos;
			inline function addMatrix(m:h3d.Matrix) {
				buf[pos++] = m._11;
				buf[pos++] = m._21;
				buf[pos++] = m._31;
				buf[pos++] = m._41;
				buf[pos++] = m._12;
				buf[pos++] = m._22;
				buf[pos++] = m._32;
				buf[pos++] = m._42;
				buf[pos++] = m._13;
				buf[pos++] = m._23;
				buf[pos++] = m._33;
				buf[pos++] = m._43;
				buf[pos++] = m._14;
				buf[pos++] = m._24;
				buf[pos++] = m._34;
				buf[pos++] = m._44;
			}
			if( p.perObjectGlobal != null ) {
				if( p.perObjectGlobal.gid == modelViewID ) {
					batch.modelViewPos = pos - startPos;
					addMatrix(worldPosition != null ? worldPosition : absPos);
				} else if( p.perObjectGlobal.gid == modelViewInverseID ) {
					if( worldPosition == null )
						addMatrix(getInvPos());
					else {
						if( !calcInv ) {
							calcInv = true;
							if( invWorldPosition == null ) invWorldPosition = new h3d.Matrix();
							invWorldPosition.initInverse(worldPosition);
						}
						addMatrix(invWorldPosition);
					}
				} else
					throw "Unsupported global param "+p.perObjectGlobal.path;
				p = p.next;
				continue;
			}
			var curShader = shaders[p.instance];
			switch( p.type ) {
			case TVec(4, _):
				var v : h3d.Vector4 = curShader.getParamValue(p.index);
				buf[pos++] = v.x;
				buf[pos++] = v.y;
				buf[pos++] = v.z;
				buf[pos++] = v.w;
			case TVec(size, _):
				var v : h3d.Vector = curShader.getParamValue(p.index);
				switch( size ) {
				case 2:
					buf[pos++] = v.x;
					buf[pos++] = v.y;
				default:
					buf[pos++] = v.x;
					buf[pos++] = v.y;
					buf[pos++] = v.z;
				}
			case TFloat:
				buf[pos++] = curShader.getParamFloatValue(p.index);
			case TMat4:
				var m : h3d.Matrix = curShader.getParamValue(p.index);
				addMatrix(m);
			default:
				throw "Unsupported batch type "+p.type;
			}
			p = p.next;
		}
		needUpload = true;
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

	public function emitInstance() {
		if( worldPosition == null ) syncPos();
		var ps = primitiveSubPart;
		if( ps != null ) @:privateAccess {
			if(calcBounds) {
				instanced.tmpBounds.load(primitiveSubPart.bounds);
				instanced.tmpBounds.transform(worldPosition == null ? absPos : worldPosition);
				instanced.bounds.add(instanced.tmpBounds);
			}

			if( primitiveSubBytes == null ) {
				primitiveSubBytes = haxe.io.Bytes.alloc(128);
				instanced.commands = null;
			}
			if( primitiveSubBytes.length < (instanceCount+1) * 20 ) {
				var next = haxe.io.Bytes.alloc(Std.int(primitiveSubBytes.length*3/2));
				next.blit(0, primitiveSubBytes, 0, instanceCount * 20);
				primitiveSubBytes = next;
			}
			var p = instanceCount * 20;
			primitiveSubBytes.setInt32(p, ps.indexCount);
			primitiveSubBytes.setInt32(p + 4, 1);
			primitiveSubBytes.setInt32(p + 8, ps.indexStart);
			primitiveSubBytes.setInt32(p + 12, ps.baseVertex);
			primitiveSubBytes.setInt32(p + 16, 0);
		} else if(calcBounds)
			instanced.addInstanceBounds(worldPosition == null ? absPos : worldPosition);
		var p = dataPasses;
		while( p != null ) {
			syncData(p);
			p = p.next;
		}
		instanceCount++;
	}

	public function disposeBuffers() {
		if( instanceCount == 0 ) return;
		var p = dataPasses;
		var alloc = hxd.impl.Allocator.get();
		while( p != null ) {
			for ( b in p.buffers )
				alloc.disposeBuffer(b);
			p = p.next;
		}
	}

	static var BATCH_START_FMT = hxd.BufferFormat.make([{ name : "Batch_Start", type : DFloat }]);
	static var INDIRECT_DRAW_ARGUMENTS_FMT = hxd.BufferFormat.make([{ name : "", type : DVec4 }, { name : "", type : DFloat }]);

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		if( instanceCount == 0 ) return;
		flush(ctx);
	}

	public function flush(ctx:RenderContext) {
		var p = dataPasses;
		var alloc = hxd.impl.Allocator.get();
		var psBytes = primitiveSubBytes;
		while( p != null ) {
			var index = 0;
			var start = 0;
			while( start < instanceCount ) {
				var upload = needUpload;
				var buf = p.buffers[index];
				var count = instanceCount - start;
				if( count > p.maxInstance )
					count = p.maxInstance;
				if( buf == null || buf.isDisposed() ) {
					var bufferFlags : hxd.impl.Allocator.BufferFlags = allowGpuUpdate ? UniformReadWrite : UniformDynamic;
					buf = alloc.allocBuffer(Std.int(MAX_BUFFER_ELEMENTS * (4 / p.bufferFormat.stride)),p.bufferFormat,bufferFlags);
					p.buffers[index] = buf;
					upload = true;
				}
				if( upload )
					buf.uploadFloats(p.data, start * p.paramsCount * 4, Std.int(count * 4 * p.paramsCount / p.bufferFormat.stride));
				if( psBytes != null ) {
					if( p.instanceBuffers == null )
						p.instanceBuffers = [];
					var buf = p.instanceBuffers[index];
					if( buf == null /*|| buf.isDisposed()*/ ) {
						buf = new h3d.impl.InstanceBuffer();
						var sub = psBytes.sub(start*20,count*20);
						for( i in 0...count )
							sub.setInt32(i*20+16, i);
						buf.setBuffer(count, sub);
						p.instanceBuffers[index] = buf;
					}
				}

				if ( ( enableLOD || enableGPUCulling ) ) {
					if( p.computeShaders == null )
						p.computeShaders = [];

					var compute = p.computeShaders[index];

					if( compute == null ) {
						compute = new ComputeIndirect();
						compute.MAX_INSTANCE = p.maxInstance;
						compute.ENABLE_LOD = enableLOD;
						compute.ENABLE_CULLING = enableGPUCulling;
						p.computeShaders[index] = compute;
						compute.commandBuffer = alloc.allocBuffer( count, INDIRECT_DRAW_ARGUMENTS_FMT, UniformReadWrite );

						var prim = @:privateAccess instanced.primitive;
						var bounds = prim.getBounds();
						compute.radius = bounds.dimension();

						var lodCount = ( enableLOD ) ? prim.lodCount() : 1;
						if ( matInfos == null ) {
							if ( enableLOD ) {
								var hmd : h3d.prim.HMDModel = cast prim;
								var lodConfig = @:privateAccess h3d.prim.HMDModel.lodConfig;
								var materialCount = materials.length;
								var tmpMatInfos = haxe.io.Bytes.alloc( 16 * materialCount * lodCount );
								compute.matInfos = alloc.allocBuffer( materialCount * lodCount, hxd.BufferFormat.VEC4_DATA, Uniform );
								var pos : Int = 0;
								var startIndex : Int = 0;
								for ( i => lod in @:privateAccess hmd.lods ) {
									for ( j in 0...materials.length ) {
										var indexCount = lod.indexCounts[j % materialCount];
										tmpMatInfos.setInt32( pos, indexCount );
										tmpMatInfos.setInt32( pos + 4, startIndex );
										tmpMatInfos.setFloat( pos + 8, ( i < lodConfig.length ) ? lodConfig[i] : 0.0 );
										startIndex += indexCount;
										pos += 16;
									}
								}
								compute.matInfos.uploadBytes( tmpMatInfos, 0, materialCount * lodCount );
							}
							else {
								var materialCount = materials.length;
								var tmpMatInfos = haxe.io.Bytes.alloc(16 * materialCount);
								compute.matInfos = alloc.allocBuffer( materialCount, hxd.BufferFormat.VEC4_DATA, Uniform );
								var pos : Int = 0;
								for ( i in 0...materials.length ) {
									var matInfo = prim.getMaterialIndexes(i);
									tmpMatInfos.setInt32( pos, matInfo.count );
									tmpMatInfos.setInt32( pos + 4, matInfo.start );
									pos += 16;
								}
								compute.matInfos.uploadBytes( tmpMatInfos, 0, materialCount );
							}
						}
						compute.lodCount = lodCount;

						if ( enableGPUCulling )
							compute.frustum = ctx.getCameraFrustumBuffer();
					}
					else if ( compute.commandBuffer.vertices != count ) {
						if ( compute.commandBuffer != null )
							alloc.disposeBuffer( compute.commandBuffer );
						compute.commandBuffer = alloc.allocBuffer( count, INDIRECT_DRAW_ARGUMENTS_FMT, UniformReadWrite );
					}
				}
				start += count;
				index++;
			}
			while( p.buffers.length > index )
				alloc.disposeBuffer( p.buffers.pop() );
			p = p.next;
		}
		if( psBytes != null || enableLOD || enableGPUCulling ) {
			var offsets = @:privateAccess instanced.primitive.resolveBuffer("Batch_Start");
			if( offsets == null || offsets.vertices < instanceCount || offsets.isDisposed() ) {
				if( offsets != null ) {
					offsets.dispose();
					@:privateAccess instanced.primitive.removeBuffer(offsets);
				}
				var tmp = haxe.io.Bytes.alloc(4 * instanceCount);
				for( i in 0...instanceCount )
					tmp.setFloat(i<<2, i);
				offsets = new h3d.Buffer(instanceCount, BATCH_START_FMT);
				offsets.uploadBytes(tmp,0,instanceCount);
				@:privateAccess instanced.primitive.addBuffer(offsets);
			}
		}
		needUpload = false;
	}

	override function draw(ctx:RenderContext) {
		var p = dataPasses;
		while( true ) {
			if( p.pass == ctx.drawPass.pass ) {
				var bufferIndex = ctx.drawPass.index & 0xFFFF;
				p.shader.Batch_Buffer = p.buffers[bufferIndex];
				if( p.instanceBuffers == null ) {
					var count = instanceCount - p.maxInstance * bufferIndex;
					instanced.commands.setCommand(count,p.indexCount,p.indexStart);
					if ( p.computeShaders != null && p.computeShaders.length > 0 )
						@:privateAccess instanced.commands.data = p.computeShaders[bufferIndex].commandBuffer.vbuf;
				} else
					instanced.commands = p.instanceBuffers[bufferIndex];
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

	override function emit(ctx:RenderContext) {
		if( instanceCount == 0 ) return;
		var p = dataPasses;
		while( p != null ) {
			var pass = p.pass;
			
			// Triggers upload
			if ( enableGPUCulling )
				ctx.getCameraFrustumBuffer();

			// check that the pass is still enable
			var material = materials[p.matIndex];
			if( material != null && material.getPass(pass.name) != null ) {
				for( i => buf in p.buffers ) {
					ctx.emitPass(pass, this).index = i | (p.matIndex << 16);
					if ( p.computeShaders != null && p.computeShaders.length > 0 ) {
						var compute = p.computeShaders[i];
						var count = instanceCount - p.maxInstance * i;
						compute.instanceData = buf;
						compute.matIndex = p.matIndex;
						ctx.computeDispatch( compute, count );
					}
				}
			}
			p = p.next;
		}
	}

}