package h3d.prim;

class RawPrimitive extends Primitive {

	public var onContextLost : Void -> { vbuf : hxd.FloatBuffer, stride : Int, ?ibuf : hxd.IndexBuffer, ?quads : Bool };

	public function new( inf : { vbuf : hxd.FloatBuffer, stride : Int, ?ibuf : hxd.IndexBuffer, ?quads : Bool }, persist = false ) {
		onContextLost = function() return inf;
		alloc(null);
		if( !persist ) onContextLost = null;
	}

	override function alloc( engine : h3d.Engine ) {
		if( onContextLost == null ) throw "Cannot realloc " + this;
		var inf = onContextLost();
		var flags : Array<h3d.Buffer.BufferFlag> = [];
		if( inf.ibuf == null ) flags.push(inf.quads ? Quads : Triangles);
		if( inf.stride < 8 ) flags.push(RawFormat);
		buffer = h3d.Buffer.ofFloats(inf.vbuf, inf.stride, flags);
		if( inf.ibuf != null )
			indexes = h3d.Indexes.alloc(inf.ibuf);
	}

}