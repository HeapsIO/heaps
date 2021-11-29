package hxd.impl;


interface AsyncLoader {
	public function load( img : hxd.res.Image ) : Void;
	public function isSupported( t : hxd.res.Image ) : Bool;
}


#if hl

@:access(hxd.res.Image)
class ThreadAsyncLoader implements AsyncLoader {

	var deque : sys.thread.Deque<hxd.res.Image>;
	var internalBuffer : haxe.io.Bytes;
	var lock : sys.thread.Lock;
	var currentTex : hxd.res.Image;

	public function new() {
		deque = new sys.thread.Deque();
		lock = new sys.thread.Lock();
		sys.thread.Thread.create(threadLoop);
		haxe.MainLoop.add(uploadTextures);
	}

	function threadLoop() {
		while( true ) {
			var t = deque.pop(true);
			if( t.tex == null || t.tex.isDisposed() ) continue;

			var size;
			var inf = t.inf;
			switch( t.inf.dataFormat ) {
			case Dds:
				var pos = 128;
				if( inf.flags.has(Dxt10Header) ) pos += 20;
				for( layer in 0...t.tex.layerCount ) {
					for( mip in 0...inf.mipLevels ) {
						var w = inf.width >> mip;
						var h = inf.height >> mip;
						if( w == 0 ) w = 1;
						if( h == 0 ) h = 1;
						var size = hxd.Pixels.calcDataSize(w, h, inf.pixelFormat);
						pos += size;
					}
				}
				size = pos;
			case Raw:
				size = hxd.Pixels.calcDataSize(inf.width, inf.height, inf.pixelFormat);
			default:
				throw "Unsupported texture data format "+t.inf.dataFormat;
			}
			if( internalBuffer == null || internalBuffer.length < size )
				internalBuffer = haxe.io.Bytes.alloc(size);
			if( t.entry.readBytes(internalBuffer, 0, 0, size) != size )
				throw "assert";
			currentTex = t;
			lock.wait();
		}
	}

	function uploadTextures() {
		if( currentTex == null ) return;
		currentTex.asyncLoad(internalBuffer);
		currentTex = null;
		lock.release();
	}

	public function load(img) {
		deque.add(img);
	}

	public function isSupported(t:hxd.res.Image) {
		return switch( t.getFormat() ) {
		case Dds, Raw: true;
		default: false;
		}
	}

}
#end