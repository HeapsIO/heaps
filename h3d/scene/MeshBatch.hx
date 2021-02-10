package h3d.scene;

import hxsl.ShaderList;

private class BatchData {

	public var paramsCount : Int;
	public var maxInstance : Int;
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

interface MeshBatchAccess {
	var perInstance : Bool;
}

/**
	h3d.scene.MeshBatch allows to draw multiple meshed in a single draw call.
	See samples/MeshBatch.hx for an example.
**/
class MeshBatch extends Mesh {

	var instanced : h3d.prim.Instanced;
	var curInstances : Int = 0;
	var dataPasses : BatchData;
	var indexCount : Int;
	var modelViewID = hxsl.Globals.allocID("global.modelView");
	var modelViewInverseID = hxsl.Globals.allocID("global.modelViewInverse");
	var colorSave = new h3d.Vector();
	var colorMult : h3d.shader.ColorMult;
	var needUpload = false;

	static var MAX_BUFFER_ELEMENTS = 4096;

	/**
		Tells if we can use material.color as a global multiply over each instance color (default: true)
	**/
	public var allowGlobalMaterialColor : Bool = true;

	/**
	 * 	If set, use this position in emitInstance() instead MeshBatch absolute position
	**/
	public var worldPosition : Matrix;
	var invWorldPosition : Matrix;

	/**
		Set if shader list or shader constants has changed, before calling begin()
	**/
	public var shadersChanged = true;

	public function new( primitive, ?material, ?parent ) {
		instanced = new h3d.prim.Instanced();
		instanced.commands = new h3d.impl.InstanceBuffer();
		instanced.setMesh(primitive);
		super(instanced, material, parent);
		for( p in this.material.getPasses() )
			@:privateAccess p.batchMode = true;
		indexCount = primitive.indexes == null ? primitive.triCount() * 3 : primitive.indexes.count;
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
		for( p in material.getPasses() ) @:privateAccess {
			var ctx = scene.renderer.getPassByName(p.name);
			if( ctx == null ) throw "Could't find renderer pass "+p.name;

			var manager = cast(ctx,h3d.pass.Default).manager;
			var shaders = p.getShadersRec();

			// Keep only batched shader
			var batchShaders : ShaderList = shaders;
			var prev = null;
			var cur = batchShaders;
			while( cur != null ) {
				if( hxd.impl.Api.isOfType(cur.s, MeshBatchAccess) ) {
					var access : MeshBatchAccess = cast cur.s;
					if( !access.perInstance ) {
						if( prev != null )
							prev.next = cur.next;
						else
							batchShaders = cur.next;
						cur = cur.next;
					}
				}
				else {
					prev = cur;
					cur = cur.next;
				}
			}

			var rt = manager.compileShaders(batchShaders, false);
			var shader = manager.shaderCache.makeBatchShader(rt);

			var b = new BatchData();
			b.paramsCount = rt.vertex.paramsSize + rt.fragment.paramsSize;
			b.maxInstance = Std.int(MAX_BUFFER_ELEMENTS / b.paramsCount);
			b.params = rt.fragment.params == null ? null : rt.fragment.params.clone();

			var hd = b.params;
			while( hd != null ) {
				hd.pos += rt.vertex.paramsSize << 2;
				hd = hd.next;
			}

			if( b.params == null )
				b.params = rt.vertex.params;
			else if( rt.vertex != null ) {
				var vl = rt.vertex.params.clone();
				var hd = vl;
				while( vl.next != null ) vl = vl.next;
				vl.next = b.params;
				b.params = hd;
			}

			b.shader = shader;
			b.pass = p;
			b.shaders = [null/*link shader*/];
			p.dynamicParameters = true;

			var alloc = hxd.impl.Allocator.get();
			b.next = dataPasses;
			dataPasses = b;

			var sl = batchShaders;
			while( sl != null ) {
				b.shaders.push(sl.s);
				sl = sl.next;
			}
			shader.Batch_Count = b.maxInstance * b.paramsCount;
			shader.constBits = b.maxInstance * b.paramsCount;
			shader.updateConstants(null);
		}

		// add batch shaders
		var p = dataPasses;
		while( p != null ) {
			p.pass.addShader(p.shader);
			p = p.next;
		}
	}

	public function begin( emitCountTip = -1, resizeDown = false ) {
		colorSave.load(material.color);

		curInstances = 0;
		if( shadersChanged ) {
			if( colorMult != null ) {
				material.mainPass.removeShader(colorMult);
				colorMult = null;
			}
			initShadersMapping();
			shadersChanged = false;
			if( allowGlobalMaterialColor ) {
				if( colorMult == null ) {
					colorMult = new h3d.shader.ColorMult();
					material.mainPass.addShader(colorMult);
				}
			} else {
				if( colorMult != null ) {
					material.mainPass.removeShader(colorMult);
					colorMult = null;
				}
			}
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

		var startPos = batch.paramsCount * curInstances << 2;
		// in case we are bigger than emitCountTip
		if( startPos + batch.paramsCount > batch.data.length )
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
		syncPos();
		var p = dataPasses;
		while( p != null ) {
			syncData(p);
			p = p.next;
		}
		if( allowGlobalMaterialColor ) material.color.load(colorSave);
		curInstances++;
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		if( curInstances == 0 ) return;
		var p = dataPasses;
		var alloc = hxd.impl.Allocator.get();
		while( p != null ) {
			var index = 0;
			var start = 0;
			while( start < curInstances ) {
				var upload = needUpload;
				var buf = p.buffers[index];
				if( buf == null || buf.isDisposed() ) {
					buf = alloc.allocBuffer(MAX_BUFFER_ELEMENTS,4,UniformDynamic);
					p.buffers[index] = buf;
					upload = true;
				}
				var count = curInstances - start;
				if( count > p.maxInstance )
					count = p.maxInstance;
				if( upload )
					buf.uploadVector(p.data, start * p.paramsCount * 4, count * p.paramsCount);
				start += count;
				index++;
			}
			while( p.buffers.length > index )
				alloc.disposeBuffer(p.buffers.pop());
			p = p.next;
		}
		needUpload = false;
		if( colorMult != null ) colorMult.color.load(material.color);
	}

	override function draw(ctx:RenderContext) {
		var p = dataPasses;
		while( true ) {
			if( p.pass == ctx.drawPass.pass ) {
				p.shader.Batch_Buffer = p.buffers[ctx.drawPass.index];
				var count = curInstances - p.maxInstance * ctx.drawPass.index;
				instanced.commands.setCommand(count,indexCount);
				break;
			}
			p = p.next;
		}
		ctx.uploadParams();
		super.draw(ctx);
	}

	override function emit(ctx:RenderContext) {
		if( curInstances == 0 ) return;
		var p = dataPasses;
		while( p != null ) {
			var pass = p.pass;
			// check that the pass is still enable
			if( material.getPass(pass.name) != null ) {
				for( i in 0...p.buffers.length )
					ctx.emitPass(pass, this).index = i;
			}
			p = p.next;
		}
	}

}