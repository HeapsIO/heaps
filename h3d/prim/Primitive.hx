package h3d.prim;

class Primitive {
	
	public var buffer : h3d.impl.Buffer;
	public var indexes : h3d.impl.Indexes;
	
	public function triCount() {
		if( indexes != null )
			return Std.int(indexes.count / 3);
		var count = 0;
		var b = buffer;
		while( b != null ) {
			count += Std.int(b.nvert / 3);
			b = b.next;
		}
		return count;
	}
	
	public function getBounds() : Bounds {
		throw "not implemented";
		return null;
	}
	
	public function alloc( engine : h3d.Engine ) {
		throw "not implemented";
	}

	public function render( engine : h3d.Engine ) {
		if( buffer == null || buffer.isDisposed() ) alloc(engine);
		if( indexes == null )
			engine.renderTriBuffer(buffer);
		else
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