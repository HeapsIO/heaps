package h3d.prim;

class Instanced extends MeshPrimitive {

	public var commands : h3d.impl.InstanceBuffer;
	public var bounds : h3d.col.Bounds;
	var baseBounds : h3d.col.Bounds;
	var tmpBounds : h3d.col.Bounds;
	var primitive : MeshPrimitive;

	public function new() {
		bounds = new h3d.col.Bounds();
		bounds.addPos(0,0,0); // if not init
		tmpBounds = new h3d.col.Bounds();
	}

	public function setMesh( m : MeshPrimitive ) {
		if(refCount > 0) {
			if(primitive != null)
				primitive.decref();
			m.incref();
		}
		primitive = m;
		var engine = h3d.Engine.getCurrent();
		if( m.buffer == null || m.buffer.isDisposed() ) m.alloc(engine);
		buffer = m.buffer;
		indexes = m.indexes;
		baseBounds = m.getBounds();
		if( indexes == null ) indexes = engine.mem.triIndexes;
		for( bid in m.bufferCache.keys() ) {
			var b = m.bufferCache.get(bid);
			addBuffer(hxsl.Globals.getIDName(bid), b.buffer, b.offset);
		}
	}

	public function initBounds() {
		bounds.empty();
	}

	public inline function addInstanceBounds( absPos : h3d.Matrix ) {
		tmpBounds.load(baseBounds);
		tmpBounds.transform(absPos);
		bounds.add(tmpBounds);
	}

	override function dispose() {
		// Not owning any resources
	}

	override function incref() {
		if(refCount == 0 && primitive != null)
			primitive.incref();
		super.incref();
	}

	override function decref() {
		super.decref();
		if(refCount == 0 && primitive != null)
			primitive.decref();
	}

	override function getBounds():h3d.col.Bounds {
		return bounds;
	}

	// make public
	public override function addBuffer( name, buffer, offset = 0 ) {
		super.addBuffer(name, buffer, offset);
	}

	override function render( engine : h3d.Engine ) {
		if( buffer.isDisposed() )
			setMesh(primitive);
		engine.renderInstanced(getBuffers(engine),indexes,commands);
	}

}