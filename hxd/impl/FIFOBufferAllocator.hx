package hxd.impl;
import hxd.impl.Allocator;

@:access(hxd.impl.FIFOBufferAllocator)
@:allow(hxd.impl.FIFOBufferAllocator)
@:access(h3d.Buffer)
private class Cache<T:h3d.Buffer> {
	var allocator : FIFOBufferAllocator;
	var maxKeepFrame : Int;
	var available : Array<T> = [];
	var disposed : Array<T> = [];
	public var onDispose : T -> Void;

	public function new( allocator, maxKeepFrame : Int, ?dispose ) {
		onDispose = dispose;
		this.maxKeepFrame = maxKeepFrame;
		this.allocator = allocator;
	}

	public function get() {
		var b = available.pop();
		if ( b != null )
			allocator.curMemory -= b.getMemSize();
		return b;
	}

	public function put(v : T) {
		v.lastFrame = hxd.Timer.frameCount;
		disposed.push(v);
		allocator.curMemory += v.getMemSize();
	}

	public function nextFrame() {
		// always sorted as FIFO.
		available = disposed.concat(available);
		disposed = [];
	}

	public function gc() {
		var curFrame = hxd.Timer.frameCount;
		while ( true ) {
			var b = available.pop();
			if ( b == null ) break;
			if ( onDispose != null ) onDispose(b);
			allocator.curMemory -= b.getMemSize();
			if ( allocator.curMemory > allocator.maxMemSize ) continue;
			if ( curFrame < b.lastFrame + maxKeepFrame ) break;
		}
		return available.length != 0 || disposed.length != 0;
	}
}

class FIFOBufferAllocator extends Allocator {

	public var currentFrame = -1;
	var buffers = new Map<Int,Cache<h3d.Buffer>>();
	var indexBuffers = new Map<Int,Cache<h3d.Indexes>>();

	var lastGC = hxd.Timer.frameCount;
	var curMemory : Int = 0;

	/**
	 * How long do we keep some buffer than hasn't been used in memory (in frames)
	**/
	public var maxKeepFrame(default, set) : Int = 60 * 10;
	public function set_maxKeepFrame(v) {
		maxKeepFrame = v;
		for ( b in buffers )
			b.maxKeepFrame = maxKeepFrame;
		for ( i in indexBuffers )
			i.maxKeepFrame = maxKeepFrame;
		return maxKeepFrame;
	}
	/**
	 * Maximum buffers memory in bytes.
	**/
	public var maxMemSize : Int = 512 * 1024 * 1024;

	override function allocBuffer(vertices:Int, format:hxd.BufferFormat, flags:BufferFlags=Dynamic):h3d.Buffer {
		if( vertices >= 65536 ) {
			switch ( flags ) {
			case UniformReadWrite:
			default: throw "assert";
			}
		}
		checkFrame();
		var id = flags.toInt() | (format.uid << 3) | (vertices << 16);
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
		var id = fromBufferFlags(b.flags).toInt() | (b.format.uid << 3) | (b.vertices << 16);
		var c = buffers.get(id);
		if( c == null ) {
			c = new Cache(this, maxKeepFrame, function(b:h3d.Buffer) b.dispose());
			buffers.set(id, c);
		}
		c.put(b);
		checkGC();
	}

	override function allocIndexBuffer( count : Int ) {
		var id = count;
		checkFrame();
		var c = indexBuffers.get(id);
		if( c != null ) {
			var i = c.get();
			if( i != null ) return i;
		}
		checkGC();
		return super.allocIndexBuffer(count);
	}

	override function disposeIndexBuffer( i : h3d.Indexes ) {
		if( i.isDisposed() ) return;
		var id = i.count;
		var c = indexBuffers.get(id);
		if( c == null ) {
			c = new Cache(this, maxKeepFrame, function(i:h3d.Indexes) i.dispose());
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
		var t = hxd.Timer.frameCount;
		if ( t != lastGC ) gc();
	}

	public function gc() {
		var now = hxd.Timer.frameCount;
		for( b in buffers.keys() ) {
			var c = buffers.get(b);
			if( !c.gc() )
				buffers.remove(b);
		}
		for( b in indexBuffers.keys() ) {
			var c = indexBuffers.get(b);
			if( !c.gc() )
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
