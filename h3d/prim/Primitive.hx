package h3d.prim;

class Primitive {

	public var buffer : Buffer;
	public var indexes : Indexes;

	public function triCount() {
		return if( indexes != null ) Std.int(indexes.count / 3) else if( buffer == null ) 0 else Std.int(buffer.totalVertices() / 3);
	}

	public function vertexCount() {
		return 0;
	}

	public function getCollider() : h3d.col.Collider {
		throw "not implemented for "+this;
		return null;
	}

	public function getBounds() : h3d.col.Bounds {
		throw "not implemented for "+this;
		return null;
	}

	public function alloc( engine : h3d.Engine ) {
		throw "not implemented";
	}

	public function selectMaterial( material : Int ) {
	}

	public function buildNormalsDisplay() : Primitive {
		throw "not implemented for "+this;
		return null;
	}

	public function render( engine : h3d.Engine ) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		if( indexes == null ) {
			if( buffer.flags.has(Quads) )
				engine.renderQuadBuffer(buffer);
			else
				engine.renderTriBuffer(buffer);
		} else
			engine.renderIndexed(buffer,indexes);
	}

	public function dispose() {
		if( buffer != null ) {
			buffer.dispose();
			buffer = null;
		}
		if( indexes != null ) {
			indexes.dispose();
			indexes = null;
		}
	}

}