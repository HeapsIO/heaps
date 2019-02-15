package h3d.scene;

private class BatchData {

	public var count : Int;
	public var buffer : h3d.Buffer;
	public var data : hxd.FloatBuffer;
	public var params : hxsl.RuntimeShader.AllocParam;
	public var shader : hxsl.BatchShader;
	public var shaders : hxsl.ShaderList;
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

	function initShadersMapping() {
		var scene = getScene();
		if( dataPasses != null ) throw "TODO:remove previous shaders";
		dataPasses = null;
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
			b.params = rt.fragment.params.clone();

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
			b.shaders = shaders;
			b.buffer = new h3d.Buffer(tot,4,[UniformBuffer,Dynamic]);
			b.data = new hxd.FloatBuffer(tot * 4);
			dataPasses = b;

			shader.Batch_Count = tot;
			shader.Batch_Buffer = b.buffer;
			@:privateAccess shader.constBits = tot;
			p.addShader(shader);
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
		var startPos = data.count * curInstances * 4;
		var curInstance = -1;
		var curShader : hxsl.Shader = null;
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
					addMatrix(absPos);
				} else if( p.perObjectGlobal.gid == modelViewInverseID ) {
					addMatrix(getInvPos());
				} else
					throw "Unsupported global param "+p.perObjectGlobal.path;
				p = p.next;
				continue;
			}
			if( p.instance != curInstance ) {
				curInstance = p.instance;
				var index = curInstance;
				var si = data.shaders;
				while( --index > 0 ) si = si.next;
				curShader = si.s;
			}
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

}