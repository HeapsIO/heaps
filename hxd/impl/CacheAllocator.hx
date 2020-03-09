package hxd.impl;
import hxd.impl.Allocator;
import h3d.impl.AllocPos;

private class Cache<T> {
	public var content : Array<T> = [];
	public var lastUse : Float = haxe.Timer.stamp();
	public var onDispose : T -> Void;
	public function new( ?dispose ) {
		onDispose = dispose;
	}
	public inline function get() {
		var b = content.pop();
		if( content.length == 0 ) lastUse = haxe.Timer.stamp();
		return b;
	}
	public inline function put(v) {
		content.push(v);
	}
	public function gc() {
		var b = content.pop();
		if( b == null ) return false;
		if( onDispose != null ) onDispose(b);
		lastUse += 1;
		return true;
	}
}

class CacheAllocator extends Allocator {

	var buffers = new Map<Int,Cache<h3d.Buffer>>();
	var lastGC = haxe.Timer.stamp();
	/**
	 * How long do we keep some buffer than hasn't been used in memory (in seconds, default 60)
	**/
	public var maxKeepTime = 60.;

	override function allocBuffer(vertices:Int, stride:Int, flags:BufferFlags, ?pos:AllocPos):h3d.Buffer {
		if( vertices >= 65536 ) throw "assert";
		var id = flags.toInt() | (stride << 3) | (vertices << 16);
		var c = buffers.get(id);
		if( c != null ) {
			var b = c.get();
			if( b != null ) return b;
		}
		checkGC();
		return super.allocBuffer(vertices,stride,flags,pos);
	}

	override function disposeBuffer(b:h3d.Buffer) {
		var flags = b.flags.has(UniformBuffer) ? UniformDynamic : Dynamic;
		var id = flags.toInt() | (b.buffer.stride << 3) | (b.vertices << 16);
		var c = buffers.get(id);
		if( c == null ) {
			c = new Cache(function(b:h3d.Buffer) b.dispose());
			buffers.set(id, c);
		}
		c.put(b);
		checkGC();
	}

	public function checkGC() {
		var t = haxe.Timer.stamp();
		if( t - lastGC > maxKeepTime * 0.1 ) gc();
	}

	public function gc() {
		var now = haxe.Timer.stamp();
		for( b in buffers.keys() ) {
			var c = buffers.get(b);
			if( now - c.lastUse > maxKeepTime && !c.gc() )
				buffers.remove(b);
		}
		lastGC = now;
	}

}
