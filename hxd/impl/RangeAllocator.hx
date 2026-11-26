package hxd.impl;

/**
	Best-fit allocator of integer ranges in [0, capacity), with free ranges kept sorted and merged.
**/
class RangeAllocator {

	public var capacity(default, null) : Int;
	public var used(default, null) : Int = 0;
	var starts : Array<Int> = [];
	var sizes : Array<Int> = [];

	public function new( capacity : Int ) {
		this.capacity = 0;
		grow(capacity);
	}

	/**
		Returns the start of a free range of `size`, or -1 if none is large enough.
	**/
	public function alloc( size : Int ) : Int {
		if( size <= 0 )
			throw "Invalid range size " + size;
		var best = -1;
		for( i in 0...sizes.length )
			if( sizes[i] >= size && (best < 0 || sizes[i] < sizes[best]) ) {
				best = i;
				if( sizes[i] == size ) break;
			}
		if( best < 0 )
			return -1;
		var start = starts[best];
		if( sizes[best] == size ) {
			starts.splice(best, 1);
			sizes.splice(best, 1);
		} else {
			starts[best] += size;
			sizes[best] -= size;
		}
		used += size;
		return start;
	}

	public function free( start : Int, size : Int ) {
		if( size <= 0 )
			return;
		used -= size;
		var i = 0;
		while( i < starts.length && starts[i] < start )
			i++;
		var mergePrev = i > 0 && starts[i - 1] + sizes[i - 1] == start;
		var mergeNext = i < starts.length && start + size == starts[i];
		if( mergePrev && mergeNext ) {
			sizes[i - 1] += size + sizes[i];
			starts.splice(i, 1);
			sizes.splice(i, 1);
		} else if( mergePrev )
			sizes[i - 1] += size;
		else if( mergeNext ) {
			starts[i] = start;
			sizes[i] += size;
		} else {
			starts.insert(i, start);
			sizes.insert(i, size);
		}
	}

	public function grow( newCapacity : Int ) {
		if( newCapacity <= capacity )
			return;
		var add = newCapacity - capacity;
		var start = capacity;
		capacity = newCapacity;
		used += add;
		free(start, add);
	}

	public function largestFree() {
		var m = 0;
		for( s in sizes )
			if( s > m ) m = s;
		return m;
	}

}
