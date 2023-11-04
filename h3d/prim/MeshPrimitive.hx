package h3d.prim;

class MeshPrimitive extends Primitive {

	var buffers : Array<h3d.Buffer>;
	var formats : hxd.BufferFormat.MultiFormat;

	public function hasInput( name : String ) {
		return resolveBuffer(name) != null;
	}

	public function resolveBuffer( name : String ) {
		if( buffers != null ) {
			for( b in buffers )
				if( b.format.hasInput(name) )
					return b;
			return null;
		}
		if( buffer != null && buffer.format.hasInput(name) )
			return buffer;
		return null;
	}

	public function removeBuffer( buf : h3d.Buffer ) {
		if( buffers != null ) {
			buffers.remove(buf);
			if( buf == buffer )
				buffer = buffers[buffers.length - 1];
			if( buffers.length == 1 ) {
				buffers = null;
				formats = null;
			}
		} else if( buffer == buf ) {
			buffer = null;
		}
	}

	public function addBuffer( buf : h3d.Buffer ) {
		if( buffer == null )
			buffer = buf;
		else {
			if( buffers == null ) {
				if( buf == buffer ) throw "Duplicate addBuffer()";
				buffers = [buffer];
			} else if( buffers.indexOf(buf) >= 0 )
				throw "Duplicate addBuffer()";
			buffers.unshift(buf);
			formats = hxd.BufferFormat.MultiFormat.make([for( b in buffers ) b.format]);
		}
	}


	override public function dispose() {
		super.dispose();
		if( buffers != null ) {
			for( b in buffers )
				b.dispose();
			buffers = null;
			formats = null;
		}
	}

	override function render( engine : h3d.Engine ) {
		if( indexes == null || indexes.isDisposed() || buffer == null || buffer.isDisposed() )
			alloc(engine);
		if( buffers != null )
			engine.renderMultiBuffers(formats, buffers, indexes);
		else
			engine.renderIndexed(buffer, indexes);
	}

}