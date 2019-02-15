package h3d.scene;

private enum abstract BatchType(Int) {
	var TFloat;
	var TVec2;
	var TVec3;
	var TVec4;
	var TMat4;
	var TPad1;
	var TPad2;
	var TPad3;
	var TModelView;
	var TModelViewInverse;
}

private class BatchParam {
	public var next : BatchParam;
	public var shader : hxsl.Shader;
	public var index : Int;
	public var type : BatchType;
	public function new() {
	}
}

private class BatchData {

	public var count : Int;
	public var buffer : h3d.Buffer;
	public var data : hxd.FloatBuffer;
	public var params : BatchParam;
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
			var rt = manager.compileShaders(p.getShadersRec(),false);

			var shader = manager.shaderCache.makeBatchShader(rt);

			var b = new BatchData();
			b.count = 4;
			var tot = b.count * shaderInstances;
			b.params = new BatchParam();
			b.params.type = TModelView;
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
		var pos = data.count * curInstances * 4;
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
		while( p != null ) {
			switch( p.type ) {
			case TFloat:
				buf[pos++] = p.shader.getParamFloatValue(p.index);
			case TVec2:
				var v : h3d.Vector = p.shader.getParamValue(p.index);
				buf[pos++] = v.x;
				buf[pos++] = v.y;
			case TVec3:
				var v : h3d.Vector = p.shader.getParamValue(p.index);
				buf[pos++] = v.x;
				buf[pos++] = v.y;
				buf[pos++] = v.z;
			case TVec4:
				var v : h3d.Vector = p.shader.getParamValue(p.index);
				buf[pos++] = v.x;
				buf[pos++] = v.y;
				buf[pos++] = v.z;
				buf[pos++] = v.w;
			case TMat4:
				var m : h3d.Matrix  = p.shader.getParamValue(p.index);
				addMatrix(m);
			case TModelView:
				addMatrix(absPos);
			case TModelViewInverse:
				addMatrix(getInvPos());
			case TPad1:
				pos++;
			case TPad2:
				pos+=2;
			case TPad3:
				pos+=3;
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