package h3d.prim;

class RawPrimitive extends Primitive {

	public function new( engine : h3d.Engine, vbuf : hxd.FloatBuffer, stride : Int, ?ibuf : hxd.IndexBuffer ) {
		buffer = h3d.Buffer.ofFloats(vbuf, stride, ibuf == null ? [Triangles] : null);
		if( ibuf != null )
			indexes = engine.mem.allocIndex(ibuf);
	}

}