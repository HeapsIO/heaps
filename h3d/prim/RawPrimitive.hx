package h3d.prim;

class RawPrimitive extends Primitive {

	var vcount : Int;
	var tcount : Int;
	var bounds : h3d.col.Bounds;
	public var onContextLost : Void -> { vbuf : hxd.FloatBuffer, format : hxd.BufferFormat, ?ibuf : hxd.IndexBuffer };

	public function new( inf : { vbuf : hxd.FloatBuffer, format : hxd.BufferFormat, ?ibuf : hxd.IndexBuffer, ?bounds : h3d.col.Bounds }, persist = false ) {
		onContextLost = function() return inf;
		this.bounds = inf.bounds;
		alloc(null);
		if( !persist ) onContextLost = null;
	}

	override function alloc( engine : h3d.Engine ) {
		if( onContextLost == null ) throw "Cannot realloc " + this;
		var alloc = hxd.impl.Allocator.get();
		if( buffer != null ) alloc.disposeBuffer(buffer);
		if( indexes != null ) alloc.disposeIndexBuffer(indexes);
		var inf = onContextLost();
		buffer = alloc.ofFloats(inf.vbuf, inf.format);
		vcount = buffer.vertices;
		tcount = inf.ibuf != null ? Std.int(inf.ibuf.length / 3) : Std.int(vcount/3);
		if( inf.ibuf != null )
			indexes = alloc.ofIndexes(inf.ibuf);
	}

	override public function getBounds() {
		if( bounds == null ) throw "Bounds not defined for " + this;
		return bounds;
	}

	override function triCount() {
		return tcount;
	}

	override function vertexCount() {
		return vcount;
	}

}