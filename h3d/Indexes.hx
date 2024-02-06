package h3d;

@:forward(isDisposed, dispose, uploadBytes)
abstract Indexes(Buffer) to Buffer {

	public var count(get,never) : Int;

	public function new(count:Int,is32=false) {
		this = new Buffer(count,is32 ? hxd.BufferFormat.INDEX32 : hxd.BufferFormat.INDEX16, [IndexBuffer]);
	}

	public function uploadIndexes( ibuf : hxd.IndexBuffer, bufPos : Int, indices : Int, startIndice = 0 ) {
		if( startIndice < 0 || indices < 0 || startIndice + indices > this.vertices )
			throw "Invalid indices count";
		if( @:privateAccess this.format.inputs[0].precision != F16 )
			throw "Can't upload indexes on a 32-bit buffer";
		if( indices == 0 )
			return;
		h3d.Engine.getCurrent().driver.uploadIndexData(this, startIndice, indices, ibuf, bufPos);
	}

	inline function get_count() return this.vertices;

	public static function alloc( i : hxd.IndexBuffer, startPos = 0, length = -1 ) : Indexes {
		if( length < 0 ) length = i.length;
		var idx = new Indexes(length);
		idx.uploadIndexes(i, 0, length);
		return idx;
	}

}