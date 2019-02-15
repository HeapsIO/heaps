package h3d.prim;

class Instanced extends MeshPrimitive {

	public var commands : h3d.impl.InstanceBuffer;

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

	// make public
	public override function addBuffer( name, buffer, offset = 0 ) {
		super.addBuffer(name, buffer, offset);
	}

	override function render( engine : h3d.Engine ) {
		engine.renderInstanced(getBuffers(engine),indexes,commands);
	}

}