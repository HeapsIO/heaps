package h3d.impl;

abstract class MemoryType {
	public var stride : Int = 1;
	public var alignment : Int = 1;
	abstract public function alloc( size : Int ) : MemoryPage;
	abstract public function free( m : MemoryPage ) : Void;
}

class MemoryPage {
	public var cpuAddress : hl.Bytes;
	public var gpuAddress : haxe.Int64;
	public var size : Int;
	public var ref : Dynamic;
	public function new(cpu,gpu,size,ref) {
		this.cpuAddress = cpu;
		this.gpuAddress = gpu;
		this.size = size;
		this.ref = ref;
	}
}

class MemoryBlock {
	public var cpuAddress(get,never) : hl.Bytes;
	public var gpuAddress(get,never) : haxe.Int64;
	public var page : MemoryPage;
	public var size : Int;
	public var offset : Int;
	public function new() {}
	inline function get_cpuAddress() return page.cpuAddress.offset(offset);
	inline function get_gpuAddress() return page.gpuAddress + offset;
}

abstract class AllocatorPolicy {
	public abstract function getNewPageSize( pages : Array<MemoryPage>, reqSize : Int ) : Int;
	public dynamic function garbageMem() : Void { throw "Out of memory"; }
}

class ScalePolicy extends AllocatorPolicy {

	var minSize : Int;
	var scaleFactor : Float;

	public function new( minSize = 0, scaleFactor = 1.5 ) {
		if( minSize <= 2 ) minSize = 2;
		this.minSize = minSize;
		this.scaleFactor = scaleFactor;
	}

	public function getNewPageSize( pages : Array<MemoryPage>, reqSize : Int ) : Int {
		var sc = Math.pow(scaleFactor, pages.length);
		var size = Std.int(minSize * sc);
		while( size < reqSize ) {
			sc *= scaleFactor;
			size = Std.int(size * sc);
			if( size < 0 ) break;
		}
		return size;
	}

}

abstract class Allocator {
	public var mem : MemoryType;
	public var policy : AllocatorPolicy;
	public var pages : Array<MemoryPage> = [];
	public var debug = false;
	public var name : String;
	public var useMemoryPool = false;
	var tmp = new MemoryBlock();
	var lastLogTime : Float;
	var allocCounter : Int;
	var pool : Array<MemoryBlock> = [];

	public static var MAX_DEBUG_FREQ = 1.;

	public function new( mem : MemoryType, policy : AllocatorPolicy ) {
		name = Type.getClassName(Type.getClass(this));
		this.mem = mem;
		this.policy = policy;
		init();
	}

	function init() {
	}

	public function getTotalSize() {
		var tot : Float = 0.;
		for( p in pages )
			tot += p.size;
		return tot * mem.stride;
	}

	public function dispose() {
		for( p in pages )
			mem.free(p);
		pages = [];
		pool = [];
	}

	function toString() {
		var tot = getTotalSize();
		var used = getUsedSize();
		return name+"["+fmtSize(tot)+"/"+Std.int(tot == 0 ? 0 : used*100/tot)+"%]";
	}

	function fmtSize( size : Float ) {
		static final units = ["B", "KB", "MB", "GB"];
		var i = 0;
		while ( size > 1024 && i < units.length - 1) {
			size /= 1024;
			i++;
		}
		return (Std.int(size*100)/100) + units[i];
	}

	function freePage( p : MemoryPage ) {
		mem.free(p);
		pages.remove(p);
		if( debug ) trace(this+" free "+fmtSize(p.size));
	}

	function allocPage( minSize : Int ) : MemoryPage {
		var size = policy.getNewPageSize(pages, minSize);
		if( minSize > size ) size = minSize;
		if( size <= 0 ) throw "assert";
		if( mem.alignment != 1 ) {
			var d = size % mem.alignment;
			if( d != 0 ) size += mem.alignment - d;
		}
		var p = mem.alloc(size);
		while( p == null ) {
			policy.garbageMem();
			p = mem.alloc(size);
		}
		pages.push(p);
		if( debug ) trace(this+" alloc-page "+fmtSize(p.size));
		return p;
	}

	public function alloc( size : Int, ?out : MemoryBlock ) {
		if( useMemoryPool ) {
			if( out != null ) throw "assert";
			out = pool.pop();
			if( out == null ) out = new MemoryBlock();
		} else if( out == null )
			out = tmp;
		if( mem.alignment != 1 ) {
			var d = size % mem.alignment;
			if( d != 0 ) size += mem.alignment - d;
		}
		out.page = null;
		out.size = size;
		var pos = tryAlloc(size, out);
		if( pos < 0 ) {
			allocPage(size);
			pos = tryAlloc(size, out);
			if( pos < 0 ) throw "assert";
		}
		out.offset = pos * mem.stride;
		allocCounter++;
		if( debug ) {
			frequentLog(() -> {
				trace(this+" "+allocCounter+" allocs");
				allocCounter = 0;
			});
		}
		return out;
	}

	inline function frequentLog( f ) {
		var t = haxe.Timer.stamp();
		if( t - lastLogTime > MAX_DEBUG_FREQ ) {
			lastLogTime = t;
			f();
		}
	}

	public abstract function free( m : MemoryBlock ) : Void;
	abstract function tryAlloc( size : Int, out : MemoryBlock ) : Int;
	abstract public function getUsedSize() : Float;

}

class BlockAllocator extends Allocator {
	var cursor : Int;
	var currentPage : Int;

	override function dispose() {
		super.dispose();
		cursor = 0;
		currentPage = 0;
	}

	override function freePage(p:MemoryPage) {
		var idx = pages.indexOf(p);
		if( currentPage == idx ) {
			cursor = 0; // next page
		} else if( currentPage > idx )
			currentPage--;
		super.freePage(p);
	}

	public function free( m : MemoryBlock ) {
		throw "Cannot free in BlockAllocator";
	}

	function tryAlloc( size : Int, out : MemoryBlock ) {
		while( true ) {
			var p = pages[currentPage];
			if( p == null )
				return -1;
			if( cursor + size < p.size ) {
				out.page = p;
				var pos = cursor;
				cursor += size;
				return pos;
			}
			cursor = 0;
			currentPage++;
		}
	}

	function getUsedSize() {
		var size : Float = cursor;
		for( i in 0...currentPage )
			size += pages[i].size;
		return size * mem.stride;
	}

	public function reset() {
		cursor = 0;
		currentPage = 0;
	}

}

class FreeListAllocator extends Allocator {

	var lists : Array<FreeList> = [];

	override function init() {
		super.init();
		useMemoryPool = true;
	}

	override function dispose() {
		super.dispose();
		lists = [];
	}

	override function freePage(p:MemoryPage) {
		var idx = pages.indexOf(p);
		lists.remove(lists[idx]);
		super.freePage(p);
	}

	function tryAlloc(size:Int, out:MemoryBlock):Int {
		for( i => p in pages ) {
			var f = lists[i];
			if( f == null ) {
				f = new FreeList(p.size);
				lists[i] = f;
			}
			var pos = f.alloc(size, true);
			if( pos >= 0 ) {
				out.page = p;
				return pos;
			}
		}
		return -1;
	}

	function getUsedSize() {
		var free = 0.;
		for( l in lists )
			free += l.getFreeSize();
		return getTotalSize() - free * mem.stride;
	}

	public function free( m : MemoryBlock ) {
		if( m.page == null ) throw "assert";
		var idx = pages.indexOf(m.page);
		var fl = lists[idx];
		fl.free(mem.stride == 1 ? m.offset : Std.int(m.offset / mem.stride), m.size);
		m.page = null;
		if( useMemoryPool ) pool.push(m);
	}

}

// --- HELPERS

class FreeList {
	var list : Array<Int>;
	var count : Int;

	public function new( size : Int ) {
		list = [size,0];
		count = 1;
	}

	public function alloc( size : Int, bestFit : Bool ) : Int {
		if( size < 0 ) throw "assert";
		var k = 0, best = -1, bestLen = -1;
		for( i in 0...count ) {
			var len = list[i << 1];
			if( len >= size && (best < 0 || len < bestLen) ) {
				best = i;
				bestLen = len;
				if( !bestFit || bestLen == len ) break;
			}
		}
		if( best < 0 ) return -1;
		k = best << 1;
		var len = bestLen;
		var pos = list[k+1];
		if( len == size ) {
			merge(k);
		} else {
			list[k] = len - size;
			list[k+1] = pos + size;
		}
		return pos;
	}

	inline function merge( k : Int ) {
		count--;
		blit(k,k+2,(count << 1) - k);
	}

	public function free( pos : Int, size : Int ) {
		if( size == 0 ) return;
		if( pos < 0 || size < 0 ) throw "assert";

		var k = 0;
		var max = count << 1;
		while( k < max && list[k+1] < pos )
			k += 2;

		// merge left
		if( k > 0 ) {
			var ppos = list[k-1];
			var plen = list[k-2];
			if( ppos + plen == pos ) {
				plen += size;
				list[k-2] = plen;
				// merge both
				if( k < max ) {
					var npos = list[k+1];
					if( npos == ppos + plen ) {
						plen += list[k];
						list[k-2] = plen;
						merge(k);
					}
				}
				return;
			}
		}

		// merge right
		if( k < max ) {
			var npos = list[k+1];
			if( pos + size == npos ) {
				var nlen = list[k] + size;
				list[k] = nlen;
				list[k+1] = pos;
				return;
			}
		}

		// insert
		if( max == list.length ) {
			list.push(0);
			list.push(0);
		}
		blit(k + 2, k, max - k);
		list[k] = size;
		list[k+1] = pos;
		count++;
	}

	public function getFreeSize() {
		var tot = 0;
		for( i in 0...count )
			tot += list[i<<1];
		return tot;
	}

	public function toString() {
		return Std.string([for( i in 0...count ) list[(i<<1)+1]+":"+list[(i<<1)]]);
	}

	inline function blit( dst : Int, src : Int, size : Int ) {
		#if hl
		var b = hl.Bytes.getArray(list);
		b.blit(dst << 2, b, src << 2, size << 2);
		#else
		if( dst < src ) {
			for( i in 0...size )
				list[dst+i] = list[src+i];
		} else {
			var i = size - 1;
			while( i >= 0 ) {
				list[dst+i] = list[src+i];
				i--;
			}
		}
		#end
	}

}

