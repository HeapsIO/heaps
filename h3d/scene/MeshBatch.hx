package h3d.scene;

private class BatchData {

	public var count : Int;
	public var buffer : h3d.Buffer;
	public var data : hxd.FloatBuffer;
	public var params : hxsl.RuntimeShader.AllocParam;
	public var shader : hxsl.BatchShader;
	public var shaders : Array<hxsl.Shader>;
	public var pass : h3d.mat.Pass;
	public var next : BatchData;

	public function new() {
	}

}

/**
	h3d.scene.MeshBatch allows to draw multiple meshed in a single draw call.
	See samples/MeshBatch.hx for an example.
**/
class MeshBatch extends Mesh {

	var instanced : h3d.prim.Instanced;
	var curInstances : Int = 0;
	var maxInstances : Int = 0;
	var lastInstances : Int = 0;
	var shaderInstances : Int = 0;
	var commandBytes = haxe.io.Bytes.alloc(20);
	var dataBuffer : h3d.Buffer;
	var dataPasses : BatchData;
	var modelViewID = hxsl.Globals.allocID("global.modelView");
	var modelViewInverseID = hxsl.Globals.allocID("global.modelViewInverse");

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
		instanced.setMesh(primitive);
		super(instanced, material, parent);
		for( p in this.material.getPasses() )
			@:privateAccess p.batchMode = true;
		commandBytes.setInt32(0, primitive.indexes == null ? primitive.triCount() * 3 : primitive.indexes.count);
	}

	override function onRemove() {
		super.onRemove();
		cleanPasses();
	}

	function cleanPasses() {
		while( dataPasses != null ) {
			dataPasses.pass.removeShader(dataPasses.shader);
			dataPasses.buffer.dispose();
			dataPasses = dataPasses.next;
		}
		if( instanced.commands != null ) {
			instanced.commands.dispose();
			instanced.commands = null;
			lastInstances = 0;
		}
		shaderInstances = 0;
		shadersChanged = true;
	}

	function initShadersMapping() {
		var scene = getScene();
		if( scene == null ) return;
		cleanPasses();
		shaderInstances = maxInstances;
		for( p in material.getPasses() ) @:privateAccess {
			var ctx = scene.renderer.getPassByName(p.name);
			if( ctx == null ) throw "Could't find renderer pass "+p.name;

			var manager = cast(ctx,h3d.pass.Default).manager;
			var shaders = p.getShadersRec();
			var rt = manager.compileShaders(shaders,false);

			var shader = manager.shaderCache.makeBatchShader(rt);

			var b = new BatchData();
			b.count = rt.vertex.paramsSize + rt.fragment.paramsSize;
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

			var tot = b.count * shaderInstances;
			b.shader = shader;
			b.pass = p;
			b.shaders = [null/*link shader*/];
			b.buffer = new h3d.Buffer(tot,4,[UniformBuffer,Dynamic]);
			b.data = new hxd.FloatBuffer(tot * 4);
			b.next = dataPasses;
			dataPasses = b;

			var sl = shaders;
			while( sl != null ) {
				b.shaders.push(sl.s);
				sl = sl.next;
			}

			shader.Batch_Count = tot;
			shader.Batch_Buffer = b.buffer;
			shader.constBits = tot;
			shader.updateConstants(null);
		}
		// add batch shaders
		var p = dataPasses;
		while( p != null ) {
			p.pass.addShader(p.shader);
			p = p.next;
		}
	}

	public function begin( maxCount : Int ) {
		if( maxCount > shaderInstances )
			shadersChanged = true;
		curInstances = 0;
		maxInstances = maxCount;
		if( shadersChanged ) {
			initShadersMapping();
			shadersChanged = false;
		}
	}

	function syncData( data : BatchData ) {
		var p = data.params;
		var buf = data.data;
		var shaders = data.shaders;
		var startPos = data.count * curInstances * 4;
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
	}

	public function emitInstance() {
		if( curInstances == maxInstances ) throw "Too many instances";
		syncPos();
		var p = dataPasses;
		while( p != null ) {
			syncData(p);
			p = p.next;
		}
		curInstances++;
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		if( curInstances == 0 ) return;
		var p = dataPasses;
		while( p != null ) {
			p.buffer.uploadVector(p.data,0,curInstances * p.count);
			p = p.next;
		}
		if( curInstances != lastInstances ) {
			if( instanced.commands != null ) instanced.commands.dispose();
			commandBytes.setInt32(4,curInstances);
			instanced.commands = new h3d.impl.InstanceBuffer(1,commandBytes);
			lastInstances = curInstances;
		}
	}

	override function emit(ctx:RenderContext) {
		if( curInstances == 0 ) return;
		super.emit(ctx);
	}

}