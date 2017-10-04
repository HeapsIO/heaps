package h3d.prim;

class DynamicPrimitive extends Primitive {

	var vbuf : hxd.FloatBuffer;
	var ibuf : hxd.IndexBuffer;
	var vsize : Int;
	var isize : Int;
	var stride : Int;

	public var bounds = new h3d.col.Bounds();

	public function new( stride : Int ) {
		this.stride = stride;
	}

	override function getBounds() {
		return bounds;
	}

	public function getBuffer( vertices : Int ) {
		if( vbuf == null ) vbuf = new hxd.FloatBuffer(vertices * stride) else vbuf.grow(vertices * stride);
		vsize = vertices;
		return vbuf;
	}

	public function getIndexes( count : Int ) {
		if( ibuf == null ) ibuf = new hxd.IndexBuffer(count) else ibuf.grow(count);
		isize = count;
		return ibuf;
	}

	public function flush() {
		if( vsize == 0 || isize == 0 ) {
			if( buffer != null ) {
				buffer.dispose();
				buffer = null;
			}
			if( indexes != null ) {
				indexes.dispose();
				indexes = null;
			}
			return;
		}

		if( buffer != null && (buffer.isDisposed() || buffer.vertices < vsize) ) {
			buffer.dispose();
			buffer = null;
		}
		if( indexes != null && (indexes.isDisposed() || indexes.count < isize) ) {
			indexes.dispose();
			indexes = null;
		}

		if( buffer == null )
			buffer = new h3d.Buffer(vsize, stride);
		if( indexes == null )
			indexes = new h3d.Indexes(isize);

		buffer.uploadVector(vbuf, 0, vsize);
		indexes.upload(ibuf, 0, isize);
	}

	override function dispose() {
		super.dispose();
		vbuf = null;
		ibuf = null;
	}

	override function triCount() {
		return Std.int(isize / 3);
	}

	override public function render(engine:h3d.Engine) {
		if( buffer != null ) engine.renderIndexed(buffer, indexes, 0, triCount());
	}

}