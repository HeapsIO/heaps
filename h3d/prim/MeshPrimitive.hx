package h3d.prim;

class MeshPrimitive extends Primitive {

	var bufferCache : Map<Int,h3d.Buffer.BufferOffset>;
	var layouts : Map<Int,h3d.Buffer.BufferOffset>;

	function allocBuffer( engine : h3d.Engine, name : String ) {
		return null;
	}

	public function hasBuffer( name : String ) {
		if( bufferCache == null )
			return false;
		return bufferCache.exists(hxsl.Globals.allocID(name));
	}

	function getBuffer( name : String ) {
		if( bufferCache == null )
			return null;
		var b = bufferCache.get(hxsl.Globals.allocID(name));
		return b == null ? null : b.buffer;
	}

	function addBuffer( name : String, buf, offset = 0 ) {
		if( bufferCache == null )
			bufferCache = new Map();
		var id = hxsl.Globals.allocID(name);
		var old = bufferCache.get(id);
		if( old != null ) old.dispose();
		bufferCache.set(id, new h3d.Buffer.BufferOffset(buf, offset));
		layouts = null;
	}

	override public function dispose() {
		super.dispose();
		if( bufferCache != null )
			for( b in bufferCache )
				b.dispose();
		bufferCache = null;
		layouts = null;
	}

	function getBuffers( engine : h3d.Engine ) {
		if( bufferCache == null )
			bufferCache = new Map();
		if( layouts == null )
			layouts = new Map();
		var inputs = @:privateAccess engine.driver.getShaderInputNames();
		var buffers = layouts.get(inputs.id);
		if( buffers != null )
			return buffers;
		var prev = null;
		for( name in inputs.names ) {
			var id = hxsl.Globals.allocID(name);
			var b = bufferCache.get(id);
			if( b == null ) {
				b = allocBuffer(engine, name);
				if( b == null ) throw "Buffer " + name + " is not available";
				bufferCache.set(id, b);
			}
			b = b.clone();
			if( prev == null ) {
				buffers = prev = b;
			} else {
				prev.next = b;
				prev = b;
			}
		}
		layouts.set(inputs.id, buffers);
		return buffers;
	}

	override function render( engine : h3d.Engine ) {
		// the actual alloc() cache will be implemented by subclasses
		if( indexes == null || indexes.isDisposed() )
			alloc(engine);
		engine.renderMultiBuffers(getBuffers(engine), indexes);
	}

}