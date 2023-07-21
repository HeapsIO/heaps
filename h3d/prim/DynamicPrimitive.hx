package h3d.prim;

class DynamicPrimitive extends Primitive {

	var vbuf : hxd.FloatBuffer;
	var ibuf : hxd.IndexBuffer;
	var vsize : Int;
	var isize : Int;
	var format : hxd.BufferFormat;

	/** Minimum number of elements in vertex buffer **/
	public var minVSize = 0;
	/** Minimum number of elements in index index buffer **/
	public var minISize = 0;

	public var bounds = new h3d.col.Bounds();

	public function new( format ) {
		this.format = format;
	}

	override function getBounds() {
		return bounds;
	}

	public function getBuffer( vertices : Int ) {
		if( vbuf == null ) vbuf = hxd.impl.Allocator.get().allocFloats(vertices * format.stride) else vbuf.grow(vertices * format.stride);
		vsize = vertices;
		return vbuf;
	}

	public function getIndexes( count : Int ) {
		if( ibuf == null ) ibuf = hxd.impl.Allocator.get().allocIndexes(count) else ibuf.grow(count);
		isize = count;
		return ibuf;
	}

	public function flush() {
		var alloc = hxd.impl.Allocator.get();
		if( vsize == 0 || isize == 0 ) {
			if( buffer != null ) {
				alloc.disposeBuffer(buffer);
				buffer = null;
			}
			if( indexes != null ) {
				alloc.disposeIndexBuffer(indexes);
				indexes = null;
			}
			return;
		}

		if( buffer != null && (buffer.isDisposed() || buffer.vertices < vsize) ) {
			alloc.disposeBuffer(buffer);
			buffer = null;
		}
		if( indexes != null && (indexes.isDisposed() || indexes.count < isize) ) {
			alloc.disposeIndexBuffer(indexes);
			indexes = null;
		}

		if( buffer == null )
			buffer = alloc.allocBuffer(hxd.Math.imax(minVSize, vsize), format, Dynamic);
		if( indexes == null )
			indexes = alloc.allocIndexBuffer(hxd.Math.imax(minISize, isize));

		buffer.uploadVector(vbuf, 0, vsize);
		indexes.upload(ibuf, 0, isize);
	}

	override function dispose() {
		var alloc = hxd.impl.Allocator.get();
		if( buffer != null ) {
			alloc.disposeBuffer(buffer);
			buffer = null;
		}
		if( vbuf != null ) {
			alloc.disposeFloats(vbuf);
			vbuf = null;
		}
		if( ibuf != null ) {
			alloc.disposeIndexes(ibuf);
			ibuf = null;
		}
		super.dispose();
	}

	override function triCount() {
		return Std.int(isize / 3);
	}

	override public function render(engine:h3d.Engine) {
		if( buffer != null ) engine.renderIndexed(buffer, indexes, 0, triCount());
	}

}