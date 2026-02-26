package hxd.impl;
import hxd.impl.Allocator;

@:allow(hxd.impl.CacheAllocator)
@:access(hxd.impl.CacheAllocator)
@:access(h3d.Buffer)
private class Bucket<T:h3d.Buffer> {
	var allocator : CacheAllocator;
	var available : Array<T> = [];
	var disposed : Array<T> = [];
	public var lastUse : Float = haxe.Timer.stamp();
	public var memSize : Int;  // debugging
	public var id : Int;
	public var allocCount : Int = 0;
	public var prev : Bucket<T>;
	public var next : Bucket<T>;

	public function new(allocator, id, memSize) {
		this.allocator = allocator;
		this.id = id;
		this.memSize = memSize;
	}
	public function get() {
		var b = available.pop();
		if( b != null ) {
			allocator.curMemory -= memSize;
			allocator.curBuffers--;
		}
		return b;
	}

	public function put(v:T) {
		disposed.push(v);
		allocator.curMemory += memSize;
		allocator.curBuffers++;
	}

	public function nextFrame() {
		while( available.length > 0 )
			disposed.push(available.pop());
		var tmp = available;
		available = disposed;
		disposed = tmp;
	}

	public function disposeAll() {
		var total = available.length + disposed.length;
		for( b in available ) b.dispose();
		for( b in disposed ) b.dispose();

		allocator.curMemory -= memSize * total;
		allocator.curBuffers -= total;
		available = [];
		disposed = [];
	}

	public inline function isEmpty() {
		return available.length == 0 && disposed.length == 0;
	}
}

@:allow(hxd.impl.CacheAllocator)
@:access(hxd.impl.CacheAllocator)
@:access(h3d.Buffer)
private class Cache<T:h3d.Buffer> {
	var map : Map<Int, Bucket<T>> = new Map();
	var head : Bucket<T>;
	var tail : Bucket<T>;
	var lookup : Map<T, Bool>;
	var allocator : CacheAllocator;

	function new(allocator) {
		this.allocator = allocator;
		if(allocator.debug )
			lookup = [];
	}

	function alloc(id:Int, memSize:Int):T {
		var bucket = map.get(id);
		if( bucket == null ) {
			bucket = new Bucket(allocator, id, memSize);
			map.set(id, bucket);
			linkHead(bucket);
		} else {
			moveToHead(bucket);
		}
		bucket.allocCount++;
		bucket.lastUse = haxe.Timer.stamp();
		var b = bucket.get();
		if( b != null )
			lookup?.remove(b);
		return b;
	}

	function dispose(id:Int, memSize:Int, v:T) {
		var bucket = map.get(id);
		if( bucket == null || bucket.allocCount < allocator.cacheThreshold )
			return v.dispose();

		if( lookup != null ) {
			if( lookup.exists(v) )
				throw "Buffer already disposed";
			lookup.set(v, true);
		}
		bucket.put(v);
	}

	function oldestTime():Float {
		return tail != null ? tail.lastUse : Math.POSITIVE_INFINITY;
	}

	function gc():Bool {
		if( tail == null )
			return false;
		var bucket = tail;
		bucket.disposeAll();
		unlink(bucket);
		map.remove(bucket.id);
		return true;
	}

	function nextFrame() {
		var b = head;
		while( b != null ) {
			b.nextFrame();
			b = b.next;
		}
	}

	function clear() {
		var b = head;
		while( b != null ) {
			b.disposeAll();
			b = b.next;
		}
		map = [];
		head = null;
		tail = null;
	}

	function reset() {
		map = [];
		head = null;
		tail = null;
	}

	function moveToHead(b:Bucket<T>) {
		if( b == head )
			return;
		unlink(b);
		linkHead(b);
	}

	function unlink(b:Bucket<T>) {
		if( b.prev != null )
			b.prev.next = b.next;
		else
			head = b.next;
		if( b.next != null )
			b.next.prev = b.prev;
		else
			tail = b.prev;
		b.prev = null;
		b.next = null;
	}

	function linkHead(b:Bucket<T>) {
		b.next = head;
		b.prev = null;
		if( head != null )
			head.prev = b;
		else
			tail = b;
		head = b;
	}
}

class CacheAllocator extends Allocator {

	public var currentFrame = -1;
	var buffers:Cache<h3d.Buffer>;
	var indexBuffers:Cache<h3d.Indexes>;

	var lastGC = haxe.Timer.stamp();
	/**
	 * How long do we keep some buffer than hasn't been used in memory (in seconds, default 60)
	**/
	public var maxKeepTime = 60.;

	public var maxMemSize : Int = 512 * 1024 * 1024;

	/**
	 * Minimum number of allocations for a given config before its buffers start being cached.
	**/
	public var cacheThreshold : Int = 2;

	static final MAX_VERTICES = (1 << 16);
	static final MAX_UID = (1 << 13);

	var curMemory : Int = 0;
	var curBuffers : Int = 0;
	var debug = false;

	public function new(debug = false) {
		super();
		this.debug = debug;
		buffers = new Cache(this);
		indexBuffers = new Cache(this);
	}

	function getId(vertices:Int, format:hxd.BufferFormat, flags:BufferFlags) {
		if( format.uid >= MAX_UID ) throw 'Format uid overflow: ${format.uid}';
		return flags.toInt() | (format.uid << 3) | (vertices << 16);
	}

	override function allocBuffer(vertices:Int, format:hxd.BufferFormat, flags:BufferFlags=Dynamic):h3d.Buffer {
		if( vertices >= MAX_VERTICES )
			return super.allocBuffer(vertices,format,flags);

		checkFrame();
		var id = getId(vertices, format, flags);
		var b = buffers.alloc(id, vertices * format.strideBytes);
		if( b != null )
			return b;
		checkGC();
		return super.allocBuffer(vertices,format,flags);
	}

	override function disposeBuffer(b:h3d.Buffer) {
		if( b.isDisposed() ) return;
		if( b.vertices >= MAX_VERTICES ) {
			b.dispose();
			return;
		}
		var id = getId(b.vertices, b.format, fromBufferFlags(b.flags));
		buffers.dispose(id, b.vertices * b.format.strideBytes, b);
		checkGC();
	}

	override function allocIndexBuffer( count : Int, is32 : Bool = false ) {
		var id = (count << 1) + (is32 ? 1 : 0);
		var memSize = count * (is32 ? 4 : 2);
		checkFrame();
		var i = indexBuffers.alloc(id, memSize);
		if( i != null )
			return i;
		checkGC();
		return super.allocIndexBuffer(count, is32);
	}

	override function disposeIndexBuffer( i : h3d.Indexes ) {
		if( i.isDisposed() ) return;
		var is32 = cast(i, h3d.Buffer).format.strideBytes == 4;
		var id = (i.count << 1) + (is32 ? 1 : 0);
		var memSize = i.count * (is32 ? 4 : 2);
		indexBuffers.dispose(id, memSize, i);
		checkGC();
	}

	override function onContextLost() {
		buffers.reset();
		indexBuffers.reset();
		curMemory = 0;
		curBuffers = 0;
	}

	public function checkFrame() {
		if( currentFrame == hxd.Timer.frameCount )
			return;
		currentFrame = hxd.Timer.frameCount;
		buffers.nextFrame();
		indexBuffers.nextFrame();
	}

	public function checkGC() {
		var t = haxe.Timer.stamp();
		if( t - lastGC > maxKeepTime * 0.1 ) gc();
	}

	public function gc() {
		var now = haxe.Timer.stamp();

		while( curMemory > maxMemSize ) {
			var bt = buffers.oldestTime();
			var it = indexBuffers.oldestTime();
			if( bt <= it )
				buffers.gc();
			else
				indexBuffers.gc();
		}

		while( buffers.tail != null && now - buffers.tail.lastUse > maxKeepTime )
			buffers.gc();
		while( indexBuffers.tail != null && now - indexBuffers.tail.lastUse > maxKeepTime )
			indexBuffers.gc();

		lastGC = now;
	}

	public function clear() {
		buffers.clear();
		indexBuffers.clear();
		curMemory = 0;
		curBuffers = 0;
	}

	#if hl
	@:access(h3d.Buffer)
	public function printStats(filePath:String) {
		var fo = sys.io.File.write(filePath);

		inline function line(s:String) {
			fo.writeString(s + "\n");
		}
		inline function formatSize(bytes:Int):String {
			return if (bytes >= 1024 * 1024) Std.string(Math.round(bytes / (1024 * 1024) * 10) / 10) + " MB";
			else if (bytes >= 1024) Std.string(Math.round(bytes / 1024 * 10) / 10) + " KB";
			else Std.string(bytes) + " B";
		}

		line("=== CacheAllocator Stats ===");
		line('Total cached memory: ${formatSize(curMemory)}  Total cached buffers: $curBuffers');
		line("");

		function dumpCache(cache:Cache<h3d.Buffer>, label:String) {
			// Collect all buckets
			var buckets = [];
			var b = cache.head;
			while (b != null) {
				buckets.push(b);
				b = b.next;
			}
			buckets.sort(function(a, b) return b.available.length - a.available.length);

			line('--- $label ---');
			for (bucket in buckets) {
				var count = bucket.available.length;
				if (count == 0) continue;
				var totalMem = count * bucket.memSize;
				line('  $count x ${formatSize(bucket.memSize)} = ${formatSize(totalMem)}, allocCount=${bucket.allocCount}');

				var groups = new Map<String, Int>();
				for (buf in bucket.available) {
					var key = buf.allocPos != null ? buf.allocPos.stack.join("\n") : "";
					groups.set(key, (groups.get(key) ?? 0) + 1);
				}
				for (stack => n in groups) {
					line('    ${n} x');
					if (stack.length > 0)
						for (l in stack.split("\n"))
							line('      $l');
				}
			}
			line("");
		}

		dumpCache(buffers, "Vertex Buffers");
		dumpCache(indexBuffers, "Index Buffers");
		fo.close();
	}
	#end
}
