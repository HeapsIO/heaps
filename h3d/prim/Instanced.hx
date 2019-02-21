package h3d.prim;

class Instanced extends MeshPrimitive {

	public var commands : h3d.impl.InstanceBuffer;
	public var offset : h3d.col.Sphere;
	var baseBounds : h3d.col.Bounds;
	var tmpBounds : h3d.col.Bounds;

	public function new() {
		offset = new h3d.col.Sphere();
		tmpBounds = new h3d.col.Bounds();
	}

	public function setMesh( m : MeshPrimitive ) {
		var engine = h3d.Engine.getCurrent();
		if( m.buffer == null ) m.alloc(engine);
		buffer = m.buffer;
		indexes = m.indexes;
		baseBounds = m.getBounds();
		if( indexes == null ) indexes = engine.mem.triIndexes;
		for( bid in m.bufferCache.keys() ) {
			var b = m.bufferCache.get(bid);
			addBuffer(hxsl.Globals.getIDName(bid), b.buffer, b.offset);
		}
	}

	override function getBounds():h3d.col.Bounds {
		tmpBounds.load(baseBounds);
		var r = offset.r;
		tmpBounds.offset(offset.x, offset.y, offset.z);
		tmpBounds.xMin -= r;
		tmpBounds.yMin -= r;
		tmpBounds.zMin -= r;
		tmpBounds.xMax += r;
		tmpBounds.yMax += r;
		tmpBounds.zMax += r;
		return tmpBounds;
	}

	// make public
	public override function addBuffer( name, buffer, offset = 0 ) {
		super.addBuffer(name, buffer, offset);
	}

	override function render( engine : h3d.Engine ) {
		engine.renderInstanced(getBuffers(engine),indexes,commands);
	}

}