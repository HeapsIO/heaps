package h3d.scene;

private class FeedbackSlot {
	public var buffer : h3d.Buffer;
	public var bytes : haxe.io.Bytes;
	public var size = 0;
	public var handles : Array<h3d.mat.TextureHandle> = [];
	public var pending = false;
	public var disposed = false;
	public var seq = 0;
	public function new() {
	}
}

@:access(h3d.mat.Texture)
class StreamingFeedback {

	public static var ENABLED = true;

	static inline var SLOT_COUNT = 3;
	static inline var MAX_SLOT_COUNT = 8;
	static inline var SIZE_ALIGN = 1024;

	var slots : Array<FeedbackSlot> = [];
	var slotIndex = 0;
	var current : FeedbackSlot;
	var maxIndex = 0;
	var zero : haxe.io.Bytes;
	var frameId = 0;
	var trackedFrame : Map<Int, Int> = [];
	var submitSeq = 0;
	var heldSeq = 0;
	var held : Array<h3d.mat.Texture> = [];

	public function new() {
		for( i in 0...SLOT_COUNT )
			slots.push(new FeedbackSlot());
	}

	public inline function isActive() {
		return current != null;
	}

	public function getBuffer() {
		return current.buffer;
	}

	public function getSize() {
		return current.size;
	}

	public function begin() {
		for( t in held )
			if( t.t != null ) t.markVisible();
		current = null;
		var count = slots.length;
		for( i in 0...count ) {
			var s = slots[(slotIndex + i) % count];
			if( !s.pending ) {
				current = s;
				slotIndex = (slotIndex + i + 1) % count;
				break;
			}
		}
		if( current == null ) {
			if( count >= MAX_SLOT_COUNT )
				return;
			current = new FeedbackSlot();
			slots.insert(slotIndex, current);
			slotIndex = (slotIndex + 1) % slots.length;
		}
		var s = current;
		if( s.size <= maxIndex ) {
			s.buffer?.dispose();
			s.size = (maxIndex + SIZE_ALIGN) & ~(SIZE_ALIGN - 1);
			s.buffer = new h3d.Buffer(s.size, hxd.BufferFormat.INDEX32, [UniformBuffer, ReadWriteBuffer]);
			s.bytes = haxe.io.Bytes.alloc(s.size << 2);
		}
		if( zero == null || zero.length < s.size << 2 ) {
			zero = haxe.io.Bytes.alloc(s.size << 2);
			zero.fill(0, zero.length, 0);
		}
		s.buffer.uploadBytes(zero, 0, s.size);
		s.handles.resize(0);
		frameId++;
	}

	public function track( handles : Array<h3d.mat.TextureHandle> ) {
		var s = current;
		if( s == null ) return;
		for( h in handles ) {
			var t = h.texture;
			if( t == null || !t.flags.has(Streamed) )
				continue;
			var index = h.handle.low;
			if( index >= s.size ) {
				if( index > maxIndex )
					maxIndex = index;
				t.markVisible();
				continue;
			}
			if( trackedFrame.get(index) == frameId )
				continue;
			trackedFrame.set(index, frameId);
			s.handles.push(h);
		}
	}

	public function end() {
		var s = current;
		current = null;
		if( s == null )
			return;
		if( s.handles.length == 0 ) {
			heldSeq = ++submitSeq;
			held.resize(0);
			return;
		}
		s.seq = ++submitSeq;
		s.pending = true;
		s.buffer.readBytesAsync(s.bytes, 0, s.size, 0, () -> decode(s));
	}

	function decode( s : FeedbackSlot ) {
		s.pending = false;
		if( s.disposed ) {
			s.buffer.dispose();
			return;
		}
		if( s.seq < heldSeq ) {
			s.handles.resize(0);
			return;
		}
		heldSeq = s.seq;
		held.resize(0);
		for( h in s.handles ) {
			var t = h.texture;
			if( t.t == null || s.bytes.getInt32(h.handle.low << 2) == 0 )
				continue;
			t.markVisible();
			held.push(t);
		}
		s.handles.resize(0);
	}

	public function dispose() {
		current = null;
		held.resize(0);
		for( s in slots ) {
			if( s.buffer == null ) continue;
			if( s.pending )
				s.disposed = true;
			else
				s.buffer.dispose();
		}
		slots = [];
	}

}
