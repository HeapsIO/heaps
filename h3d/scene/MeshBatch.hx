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
	public var data : hxd.FloatBuffer;
	public var params : hxsl.RuntimeShader.AllocParam;
	public var shader : hxsl.BatchShader;
	public var shaders : Array<hxsl.Shader>;
	public var pass : h3d.mat.Pass;
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
			if( dataPasses.instanceBuffers != null ) {
				for( b in dataPasses.instanceBuffers )
					b.dispose();
			}
			alloc.disposeFloats(dataPasses.data);
			dataPasses = dataPasses.next;
		}
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

				var manager = cast(ctx,h3d.pass.Default).manager;
				var shaders = p.getShadersRec();
				var rt = manager.compileShaders(shaders, false);
				var shader = manager.shaderCache.makeBatchShader(rt, shaders);

				var b = new BatchData();
				b.indexCount = matInfo.count;
				b.indexStart = matInfo.start;
				b.paramsCount = shader.paramsSize;
				b.maxInstance = Std.int(MAX_BUFFER_ELEMENTS / b.paramsCount);
				b.params = shader.params;
				b.shader = shader;
				b.pass = p;
				b.matIndex = index;
				b.shaders = [null/*link shader*/];
				p.dynamicParameters = true;
				p.batchMode = true;

				b.next = dataPasses;
				dataPasses = b;

				var sl = shaders;
				while( sl != null ) {
					b.shaders.push(sl.s);
					sl = sl.next;
				}
				shader.Batch_Count = b.maxInstance * b.paramsCount;
				shader.Batch_HasOffset = primitiveSubPart != null;
				shader.constBits = (shader.Batch_Count << 1) | (shader.Batch_HasOffset ? 1 : 0);
				shader.updateConstants(null);
			}
		}

		// add batch shaders
		var p = dataPasses;
		while( p != null ) {
			p.pass.addShader(p.shader);
			p = p.next;
		}
	}

	public function begin( emitCountTip = -1, resizeDown = false ) {
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
			if( p.data == null || p.data.length < size || (resizeDown && p.data.length > size << 1) ) {
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
			case TVec(size, _):
				var v : h3d.Vector = curShader.getParamValue(p.index);
				switch( size ) {
				case 2:
					buf[pos++] = v.x;
					buf[pos++] = v.y;
				case 3:
					buf[pos++] = v.x;
					buf[pos++] = v.y;
					buf[pos++] = v.z;
				default:
					buf[pos++] = v.x;
					buf[pos++] = v.y;
					buf[pos++] = v.z;
					buf[pos++] = v.w;
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

	public function emitInstance() {
		if( worldPosition == null ) syncPos();
		var ps = primitiveSubPart;
		if( ps != null ) @:privateAccess {
			instanced.tmpBounds.load(primitiveSubPart.bounds);
			instanced.tmpBounds.transform(worldPosition == null ? absPos : worldPosition);
			instanced.bounds.add(instanced.tmpBounds);

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
		} else
			instanced.addInstanceBounds(worldPosition == null ? absPos : worldPosition);
		var p = dataPasses;
		while( p != null ) {
			syncData(p);
			p = p.next;
		}
		instanceCount++;
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		if( instanceCount == 0 ) return;
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
					buf = alloc.allocBuffer(MAX_BUFFER_ELEMENTS,4,UniformDynamic);
					p.buffers[index] = buf;
					upload = true;
				}
				if( upload )
					buf.uploadVector(p.data, start * p.paramsCount * 4, count * p.paramsCount);
				if( psBytes != null ) {
					if( p.instanceBuffers == null ) p.instanceBuffers = [];
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
				start += count;
				index++;
			}
			while( p.buffers.length > index )
				alloc.disposeBuffer(p.buffers.pop());
			p = p.next;
		}
		if( psBytes != null ) {
			var prim = cast(primitive,h3d.prim.MeshPrimitive);
			var offsets = @:privateAccess prim.getBuffer("Batch_Start");
			if( offsets == null || offsets.vertices < instanceCount || offsets.isDisposed() ) {
				if( offsets != null ) offsets.dispose();
				var tmp = haxe.io.Bytes.alloc(4 * instanceCount);
				for( i in 0...instanceCount )
					tmp.setFloat(i<<2, i);
				offsets = new h3d.Buffer(instanceCount, 1);
				offsets.uploadBytes(tmp,0,instanceCount);
				@:privateAccess prim.addBuffer("Batch_Start", offsets);
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
			// check that the pass is still enable
			var material = materials[p.matIndex];
			if( material != null && material.getPass(pass.name) != null ) {
				for( i in 0...p.buffers.length )
					ctx.emitPass(pass, this).index = i | (p.matIndex << 16);
			}
			p = p.next;
		}
	}

}