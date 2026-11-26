package h3d;

/**
	Rows of `format` allocated in ranges, mirrored on the CPU and uploaded to a GPU buffer by dirty range.
	Components are 32 bits: formats with a lower precision are not supported.
**/
class GPUTable {

	public var stride(default, null) : Int;
	public var buffer(default, null) : h3d.Buffer;
	public var capacity(get, never) : Int;
	var format : hxd.BufferFormat;
	var flags : Array<h3d.Buffer.BufferFlag>;
	var bytes : haxe.io.Bytes;
	var allocator : hxd.impl.RangeAllocator;
	var dirtyMin = 0x7FFFFFFF;
	var dirtyMax = -1;

	public function new( format : hxd.BufferFormat, capacity : Int, ?flags : Array<h3d.Buffer.BufferFlag> ) {
		if( format.hasLowPrecision )
			throw "GPUTable requires 32-bit components: " + format;
		this.format = format;
		this.flags = flags ?? [UniformBuffer];
		stride = format.stride;
		allocator = new hxd.impl.RangeAllocator(capacity);
		bytes = haxe.io.Bytes.alloc(capacity * stride * 4);
	}

	inline function get_capacity() return allocator.capacity;

	public function alloc( count : Int ) {
		var start = allocator.alloc(count);
		if( start < 0 ) {
			var cap = hxd.Math.imax(allocator.capacity * 2, 1);
			while( cap < allocator.capacity + count )
				cap *= 2;
			var nb = haxe.io.Bytes.alloc(cap * stride * 4);
			nb.blit(0, bytes, 0, bytes.length);
			bytes = nb;
			allocator.grow(cap);
			start = allocator.alloc(count);
		}
		return start;
	}

	public function free( start : Int, count : Int ) {
		allocator.free(start, count);
	}

	inline function markDirty( row : Int ) {
		if( row < dirtyMin ) dirtyMin = row;
		if( row > dirtyMax ) dirtyMax = row;
	}

	public function getField( name : String ) : Int {
		return format.calculateInputOffset(name) >> 2;
	}

	public inline function setInt( row : Int, field : Int, v : Int ) {
		bytes.setInt32((row * stride + field) << 2, v);
		markDirty(row);
	}

	public inline function setFloat( row : Int, field : Int, v : Float ) {
		bytes.setFloat((row * stride + field) << 2, v);
		markDirty(row);
	}

	public inline function setVec3( row : Int, field : Int, v : h3d.Vector ) {
		var pos = (row * stride + field) << 2;
		bytes.setFloat(pos, v.x);
		bytes.setFloat(pos + 4, v.y);
		bytes.setFloat(pos + 8, v.z);
		markDirty(row);
	}

	public inline function setVec4( row : Int, field : Int, v : h3d.Vector4 ) {
		var pos = (row * stride + field) << 2;
		bytes.setFloat(pos, v.x);
		bytes.setFloat(pos + 4, v.y);
		bytes.setFloat(pos + 8, v.z);
		bytes.setFloat(pos + 12, v.w);
		markDirty(row);
	}

	public inline function setMatrix( row : Int, field : Int, m : h3d.Matrix ) {
		setMatrix3x4(row, field, m);
		var pos = (row * stride + field + 12) << 2;
		bytes.setFloat(pos, m._14);
		bytes.setFloat(pos + 4, m._24);
		bytes.setFloat(pos + 8, m._34);
		bytes.setFloat(pos + 12, m._44);
	}

	public inline function setMatrix3x4( row : Int, field : Int, m : h3d.Matrix ) {
		var pos = (row * stride + field) << 2;
		bytes.setFloat(pos, m._11);
		bytes.setFloat(pos + 4, m._21);
		bytes.setFloat(pos + 8, m._31);
		bytes.setFloat(pos + 12, m._41);
		bytes.setFloat(pos + 16, m._12);
		bytes.setFloat(pos + 20, m._22);
		bytes.setFloat(pos + 24, m._32);
		bytes.setFloat(pos + 28, m._42);
		bytes.setFloat(pos + 32, m._13);
		bytes.setFloat(pos + 36, m._23);
		bytes.setFloat(pos + 40, m._33);
		bytes.setFloat(pos + 44, m._43);
		markDirty(row);
	}

	public inline function getInt( row : Int, field : Int ) {
		return bytes.getInt32((row * stride + field) << 2);
	}

	public inline function getFloat( row : Int, field : Int ) {
		return bytes.getFloat((row * stride + field) << 2);
	}

	public function getMemSize() {
		return buffer == null || buffer.isDisposed() ? 0 : buffer.getMemSize();
	}

	public function upload() {
		var capacity = allocator.capacity;
		if( buffer == null || buffer.isDisposed() || buffer.vertices < capacity ) {
			buffer?.dispose();
			buffer = new h3d.Buffer(capacity, format, flags);
			buffer.uploadBytes(bytes, 0, capacity);
		} else if( dirtyMax >= dirtyMin )
			buffer.uploadBytes(bytes, dirtyMin * stride * 4, dirtyMax - dirtyMin + 1, dirtyMin);
		dirtyMin = 0x7FFFFFFF;
		dirtyMax = -1;
	}

	public function dispose() {
		buffer?.dispose();
		buffer = null;
	}
}
