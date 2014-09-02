package h3d.prim;

class MeshPrimitive extends Primitive {

	var bufferCache : Map<Int,h3d.Buffer.BufferOffset>;

	function allocBuffer( engine : h3d.Engine, name : String ) {
		return null;
	}

	function addBuffer( name : String, buf, offset = 0 ) {
		if( bufferCache == null )
			bufferCache = new Map();
		var id = hxsl.Globals.allocID(name);
		var old = bufferCache.get(id);
		if( old != null ) old.dispose();
		bufferCache.set(id, new h3d.Buffer.BufferOffset(buf, offset));
	}

	override public function dispose() {
		super.dispose();
		if( bufferCache != null )
			for( b in bufferCache )
				b.dispose();
		bufferCache = null;
	}

	function getBuffers( engine : h3d.Engine ) {
		if( bufferCache == null )
			bufferCache = new Map();
		var buffers = null, prev = null;
		for( name in @:privateAccess engine.driver.getShaderInputNames() ) {
			var id = hxsl.Globals.allocID(name);
			var b = bufferCache.get(id);
			if( b == null ) {
				b = allocBuffer(engine, name);
				if( b == null ) throw "Buffer " + name + " is not available";
				bufferCache.set(id, b);
			}
			b.next = null;
			if( prev == null ) {
				buffers = prev = b;
			} else {
				prev.next = b;
				prev = b;
			}
		}
		return buffers;
	}

	override function render( engine : h3d.Engine ) {
		// the actual alloc() cache will be implemented by subclasses
		if( indexes == null || indexes.isDisposed() )
			alloc(engine);
		engine.renderMultiBuffers(getBuffers(engine), indexes);
	}

}