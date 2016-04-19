package h3d.prim;

class RawPrimitive extends Primitive {

	var vcount : Int;
	var tcount : Int;
	var bounds : h3d.col.Bounds;
	public var onContextLost : Void -> { vbuf : hxd.FloatBuffer, stride : Int, ?ibuf : hxd.IndexBuffer, ?quads : Bool };

	public function new( inf : { vbuf : hxd.FloatBuffer, stride : Int, ?ibuf : hxd.IndexBuffer, ?quads : Bool, ?bounds : h3d.col.Bounds }, persist = false ) {
		onContextLost = function() return inf;
		this.bounds = inf.bounds;
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
		vcount = buffer.vertices;
		tcount = inf.ibuf != null ? Std.int(inf.ibuf.length / 3) : inf.quads ? vcount >> 1 : Std.int(vcount/3);
		if( inf.ibuf != null )
			indexes = h3d.Indexes.alloc(inf.ibuf);
		else if( indexes != null ) {
			indexes.dispose();
			indexes = null;
		}
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