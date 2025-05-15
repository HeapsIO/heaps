package hxd.impl;
import hxd.impl.Allocator;

@:access(hxd.impl.FIFOBufferAllocator)
@:allow(hxd.impl.FIFOBufferAllocator)
@:access(h3d.Buffer)
private class Cache<T:h3d.Buffer> {
	var config : BufferConfig;
	var allocator : FIFOBufferAllocator;
	var maxKeepFrame : Int;
	var available : Array<T> = [];
	var disposed : Array<T> = [];
	public var onDispose : T -> Void;

	public function new( config, allocator, maxKeepFrame : Int, ?dispose ) {
		this.config = config;
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

typedef BufferConfig = {
	var vertices : Int;
	var formatId : Int;
	var flags : Int;
}

class FIFOBufferAllocator extends Allocator {

	public var currentFrame = -1;
	var buffers : Array<Cache<h3d.Buffer>> = [];
	var indexBuffers : Array<Cache<h3d.Indexes>> = [];

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

	function findCache<T:h3d.Buffer>(cache : Array<Cache<T>>, vertices : Int, formatId : Int, flags : Int) {
		for ( c in cache ) {
			var config = c.config;
			if ( config.flags == flags && config.formatId == formatId && config.vertices == vertices )
				return c;
		}
		return null;
	}

	function findBufferCache(vertices : Int, formatId : Int, flags : Int) {
		return findCache(buffers, vertices, formatId, flags);
	}

	function findIndexCache(count : Int) {
		return findCache(indexBuffers, count, 0, 0);
	}

	override function allocBuffer(vertices:Int, format:hxd.BufferFormat, flags:BufferFlags=Dynamic):h3d.Buffer {
		checkFrame();
		var c = findBufferCache(vertices, format.uid, flags.toInt());
		if( c != null ) {
			var b = c.get();
			if( b != null )
				return b;
		}
		checkGC();
		return super.allocBuffer(vertices,format,flags);
	}

	override function disposeBuffer(b:h3d.Buffer) {
		if( b.isDisposed() ) return;
		var flags = fromBufferFlags(b.flags).toInt();
		var formatId = b.format.uid;
		var c = findBufferCache(b.vertices, formatId, flags);
		if( c == null ) {
			var config = { vertices : b.vertices, formatId : formatId, flags : flags };
			c = new Cache(config, this, maxKeepFrame, function(b:h3d.Buffer) b.dispose());
			buffers.push(c);
		}
		c.put(b);
		checkGC();
	}

	override function allocIndexBuffer( count : Int ) {
		var id = count;
		checkFrame();
		var c = findIndexCache(count);
		if( c != null ) {
			var i = c.get();
			if( i != null ) return i;
		}
		checkGC();
		return super.allocIndexBuffer(count);
	}

	override function disposeIndexBuffer( i : h3d.Indexes ) {
		if( i.isDisposed() ) return;
		var c = findIndexCache(i.count);
		if( c == null ) {
			var config = { vertices : i.count, formatId : 0, flags : 0 };
			c = new Cache(config, this, maxKeepFrame, function(i:h3d.Indexes) i.dispose());
			indexBuffers.push(c);
		}
		c.put(i);
		checkGC();
	}

	override function onContextLost() {
		buffers = [];
		indexBuffers = [];
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
		var i = buffers.length;
		while ( i-- > 0 ) {
			var c = buffers[i];
			if ( !c.gc() )
				buffers.remove(c);
		}

		var i = indexBuffers.length;
		while ( i-- > 0 ) {
			var c = indexBuffers[i];
			if ( !c.gc() )
				indexBuffers.remove(c);
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
