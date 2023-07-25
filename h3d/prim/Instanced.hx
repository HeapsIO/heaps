package h3d.prim;

class Instanced extends Primitive {

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
		if( refCount > 0 ) {
			if( primitive != null )
				primitive.decref();
			m.incref();
		}
		primitive = m;
		baseBounds = m.getBounds();
		if( m.buffer == null )
			m.alloc(h3d.Engine.getCurrent()); // make sure first alloc is done
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
		// Not owning any buffer
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

	override function render( engine : h3d.Engine ) {
		if( primitive.buffer == null || primitive.buffer.isDisposed() )
			primitive.alloc(engine);
		@:privateAccess engine.flushTarget();
		@:privateAccess if( primitive.buffers == null )
			engine.driver.selectBuffer(primitive.buffer);
		else
			engine.driver.selectMultiBuffers(primitive.formats,primitive.buffers);
		var indexes = primitive.indexes;
		if( indexes == null )
			indexes = engine.mem.getTriIndexes(triCount() * 3);
		engine.renderInstanced(indexes,commands);
	}

}