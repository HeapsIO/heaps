package h3d.prim;

class MeshPrimitive extends Primitive {
		
	var bufferCache : Map<String,h3d.impl.Buffer.BufferOffset>;
	
	function allocBuffer( engine : h3d.Engine, name : String ) {
		return null;
	}
	
	function addBuffer( name : String, buf, offset = 0 ) {
		if( bufferCache == null )
			bufferCache = new Map();
		var old = bufferCache.get(name);
		if( old != null ) old.dispose();
		bufferCache.set(name, new h3d.impl.Buffer.BufferOffset(buf, offset));
	}

	override public function dispose() {
		super.dispose();
		if( bufferCache != null )
			for( b in bufferCache )
				b.dispose();
		bufferCache = null;
	}

	@:access(h3d.Engine.driver)
	function getBuffers( engine : h3d.Engine ) {
		if( bufferCache == null )
			bufferCache = new Map();
		var buffers = [];
		for( name in engine.driver.getShaderInputNames() ) {
			var b = bufferCache.get(name);
			if( b == null ) {
				b = allocBuffer(engine, name);
				if( b == null ) throw "Buffer " + name + " is not available";
				bufferCache.set(name, b);
			}
			buffers.push(b);
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