package h3d.prim;

class RawPrimitive extends Primitive {

	public function new( engine : h3d.Engine, vbuf : hxd.FloatBuffer, stride : Int, ?ibuf : hxd.IndexBuffer ) {
		var flags : Array<h3d.Buffer.BufferFlag> = [];
		if( ibuf == null ) flags.push(Triangles);
		if( stride < 8 ) flags.push(RawFormat);
		buffer = h3d.Buffer.ofFloats(vbuf, stride, flags);
		if( ibuf != null )
			indexes = h3d.Indexes.alloc(ibuf);
	}

}