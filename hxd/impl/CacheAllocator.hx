package hxd.impl;
import hxd.impl.Allocator;

@:allow(hxd.impl.CacheAllocator)
@:access(hxd.impl.CacheAllocator)
@:access(h3d.Buffer)
private class Cache<T:h3d.Buffer> {
	var allocator : CacheAllocator;
	var available : Array<T> = [];
	var disposed : Array<T> = [];
	public var lastUse : Float = haxe.Timer.stamp();
	public var onDispose : T -> Void;

	public function new(allocator, ?dispose) {
		this.allocator = allocator;
		onDispose = dispose;
	}
	public inline function get() {
		var b = available.pop();
		if( b != null ) {
			allocator.curMemory -= b.getMemSize();
			allocator.curBuffers--;
		}
		if( available.length == 0 ) lastUse = haxe.Timer.stamp();
		return b;
	}

	public inline function put(v:T) {
		disposed.push(v);
		allocator.curMemory += v.getMemSize();
		allocator.curBuffers++;
	}

	public function nextFrame() {
		while( available.length > 0 )
			disposed.push(available.pop());
		var tmp = available;
		available = disposed;
		disposed = tmp;
	}

	public function gc() {
		var b = available.pop();
		if( b == null ) b = disposed.pop();
		if( b == null ) return false;
		allocator.curMemory -= b.getMemSize();
		allocator.curBuffers--;
		if( onDispose != null ) onDispose(b);
		return true;
	}
}

class CacheAllocator extends Allocator {

	public var currentFrame = -1;
	var buffers = new Map<Int,Cache<h3d.Buffer>>();
	var indexBuffers = new Map<Int,Cache<h3d.Indexes>>();

	var lastGC = haxe.Timer.stamp();
	/**
	 * How long do we keep some buffer than hasn't been used in memory (in seconds, default 60)
	**/
	public var maxKeepTime = 60.;

	public var maxMemSize : Int = 512 * 1024 * 1024;

	public var maxBuffers : Int = 10000;

	var curMemory : Int = 0;
	var curBuffers : Int = 0;

	function getId(vertices:Int, format:hxd.BufferFormat, flags:BufferFlags) {
		return flags.toInt() | (format.uid << 3) | (vertices << 16);
	}

	override function allocBuffer(vertices:Int, format:hxd.BufferFormat, flags:BufferFlags=Dynamic):h3d.Buffer {
		if( vertices >= 65536 ) {
			switch ( flags ) {
			case UniformReadWrite:
			default: throw "assert";
			}
		}
		checkFrame();
		var id = getId(vertices, format, flags);
		var c = buffers.get(id);
		if( c != null ) {
			var b = c.get();
			if( b != null ) return b;
		}
		checkGC();
		return super.allocBuffer(vertices,format,flags);
	}

	override function disposeBuffer(b:h3d.Buffer) {
		if( b.isDisposed() ) return;
		var id = getId(b.vertices, b.format, fromBufferFlags(b.flags));
		var c = buffers.get(id);
		if( c == null ) {
			c = new Cache(this, function(b:h3d.Buffer) b.dispose());
			buffers.set(id, c);
		}
		c.put(b);
		checkGC();
	}

	override function allocIndexBuffer( count : Int, is32 : Bool = false ) {
		var id = count << 1 + (is32 ? 1 : 0);
		checkFrame();
		var c = indexBuffers.get(id);
		if( c != null ) {
			var i = c.get();
			if( i != null ) return i;
		}
		checkGC();
		return super.allocIndexBuffer(count, is32);
	}

	override function disposeIndexBuffer( i : h3d.Indexes ) {
		if( i.isDisposed() ) return;
		var is32 = cast(i, h3d.Buffer).format.strideBytes == 4;
		var id = i.count << 1 + (is32 ? 1 : 0);
		var c = indexBuffers.get(id);
		if( c == null ) {
			c = new Cache(this, function(i:h3d.Indexes) i.dispose());
			indexBuffers.set(id, c);
		}
		c.put(i);
		checkGC();
	}

	override function onContextLost() {
		buffers = new Map();
		indexBuffers = new Map();
	}

	public function checkFrame() {
		if( currentFrame == hxd.Timer.frameCount )
			return;
		currentFrame = hxd.Timer.frameCount;
		for( b in buffers )
			b.nextFrame();
		for( b in indexBuffers )
			b.nextFrame();
	}

	public function checkGC() {
		var t = haxe.Timer.stamp();
		if( t - lastGC > maxKeepTime * 0.1 ) gc();
	}

	public function gc() {
		var now = haxe.Timer.stamp();

		while( curMemory > maxMemSize || curBuffers > maxBuffers ) {
			var oldest : Cache<Dynamic> = null;
			for( c in buffers ) if( oldest == null || c.lastUse < oldest.lastUse ) oldest = c;
			for( c in indexBuffers ) if( oldest == null || c.lastUse < oldest.lastUse ) oldest = c;
			if( oldest == null || !oldest.gc() ) break;
		}

		for( b in buffers.keys() ) {
			var c = buffers.get(b);
			if( now - c.lastUse > maxKeepTime && !c.gc() )
				buffers.remove(b);
		}
		for( b in indexBuffers.keys() ) {
			var c = indexBuffers.get(b);
			if( now - c.lastUse > maxKeepTime && !c.gc() )
				indexBuffers.remove(b);
		}
		lastGC = now;
	}

	public function clear() {
		for ( c in buffers ) {
			for ( b in c.available ) {
				b.dispose();
			}
			for ( b in c.disposed ) {
				b.dispose();
			}
		}
		for ( c in indexBuffers ) {
			for ( b in c.available ) {
				b.dispose();
			}
			for ( b in c.disposed ) {
				b.dispose();
			}
		}
		buffers = [];
		indexBuffers = [];
	}

}
