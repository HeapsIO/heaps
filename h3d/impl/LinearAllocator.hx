package h3d.impl;

#if (hl || dx12)

@:generic
private class LinearAllocatorPage<T> {
	public var resource : T;
	public var ptr : hl.Bytes;
	public var capacity : Int;
	public var offset : Int = 0;
	public var unusedFrames : Int = 0;
	public function new( resource : T, ptr : hl.Bytes, capacity : Int ) {
		this.resource = resource;
		this.ptr = ptr;
		this.capacity = capacity;
	}
}

@:generic
class LinearAllocator<T> {

	public var maxKeepFrames = 3600;

	var pages : Array<LinearAllocatorPage<T>> = [];
	var createPage : Int -> T;
	var mapPage : T -> hl.Bytes;
	var disposePage : T -> Void;
	var maxPageSize : Int;

	public var resource(default, null) : T;
	public var offset(default, null) : Int;
	public var ptr(default, null) : hl.Bytes;

	public function new( initialSize : Int, createPage : Int -> T, mapPage : T -> hl.Bytes, disposePage : T -> Void, maxPageSize = 0 ) {
		this.createPage = createPage;
		this.mapPage = mapPage;
		this.disposePage = disposePage;
		this.maxPageSize = maxPageSize;
		addPage(initialSize);
	}

	function addPage( size : Int ) {
		var res = createPage(size);
		var p = new LinearAllocatorPage<T>(res, mapPage(res), size);
		pages.push(p);
		return p;
	}

	inline function tryAlloc( p : LinearAllocatorPage<T>, size : Int, align : Int ) {
		var pos = (p.offset + align - 1) & ~(align - 1);
		if( pos + size > p.capacity )
			return false;
		p.offset = pos + size;
		resource = p.resource;
		offset = pos;
		ptr = p.ptr.offset(pos);
		return true;
	}

	public function alloc( size : Int, align : Int ) {
		for( p in pages )
			if( tryAlloc(p, size, align) )
				return;
		var cap = (pages[pages.length - 1].capacity >> 1) * 3;
		if( maxPageSize > 0 && cap > maxPageSize ) cap = maxPageSize;
		if( cap < size ) cap = size;
		tryAlloc(addPage(cap), size, align);
	}

	public function reset( forceDispose = false ) {
		for( p in pages ) {
			if( p.offset == 0 ) p.unusedFrames++ else p.unusedFrames = 0;
			p.offset = 0;
		}
		var i = 1;
		while( i < pages.length ) {
			var p = pages[i];
			if( p.unusedFrames > maxKeepFrames || forceDispose ) {
				disposePage(p.resource);
				pages[i] = pages[pages.length - 1];
				pages.pop();
				continue;
			}
			i++;
		}
	}

	public function getSize() : Float {
		var size = 0.;
		for( p in pages ) size += p.capacity;
		return size;
	}

	public function dispose() {
		for( p in pages ) disposePage(p.resource);
		pages = [];
	}
}

#end
