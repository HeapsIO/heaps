package h3d.prim;

class Instanced extends MeshPrimitive {

	public var commands : h3d.impl.InstanceBuffer;
	public var instanceBuffer : h3d.Buffer;

	public function new() {
	}

	public function setMesh( m : MeshPrimitive ) {
		var engine = h3d.Engine.getCurrent();
		if( m.buffer == null ) m.alloc(engine);
		buffer = m.buffer;
		indexes = m.indexes;
		if( indexes == null ) indexes = engine.mem.triIndexes;
		for( bid in m.bufferCache.keys() ) {
			var b = m.bufferCache.get(bid);
			addBuffer(hxsl.Globals.getIDName(bid), b.buffer, b.offset);
		}
	}

	public function defineBuffer( name, offset, isInst = false ) {
		addBuffer(name, isInst ? instanceBuffer : buffer, offset);
	}

	override function render( engine : h3d.Engine ) {
		engine.renderInstanced(getBuffers(engine),indexes,commands);
	}

}