package h3d.prim;
import h3d.Engine;

class RawPrimitive extends Primitive {

	var vbuf : flash.Vector<Float>;
	var ibuf : flash.Vector<UInt>;
	var stride : Int;
	
	public function new( vbuf : flash.Vector<Float>, stride : Int, ?ibuf : flash.Vector<UInt> ) {
		this.vbuf = vbuf;
		this.ibuf = ibuf;
		this.stride = stride;
	}
	
	override public function alloc(engine:h3d.Engine) 
	{
		buffer = engine.mem.allocVector(vbuf, stride, ibuf == null ? 3 : 0);
		if( ibuf != null )
			indexes = engine.mem.allocIndex(ibuf);
	}

}