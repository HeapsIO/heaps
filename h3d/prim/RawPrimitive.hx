package h3d.prim;

class RawPrimitive extends Primitive {

	public function new( engine : h3d.Engine, vbuf : flash.Vector<Float>, stride : Int, ?ibuf : flash.Vector<UInt> ) {
		buffer = engine.mem.allocVector(vbuf, stride, ibuf == null ? 3 : 0);
		if( ibuf != null )
			indexes = engine.mem.allocIndex(ibuf);
	}

}