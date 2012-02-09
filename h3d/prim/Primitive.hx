package h3d.prim;

class Primitive {
	
	public var buffer : h3d.impl.Buffer;
	public var indexes : h3d.impl.Indexes;
	
	public function triCount() {
		var count = 0;
		var b = buffer;
		while( b != null ) {
			count += Std.int(b.nvect / 3);
			b = b.next;
		}
		return count;
	}
	
	public function alloc( mem : h3d.impl.MemoryManager ) {
		throw "assert";
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