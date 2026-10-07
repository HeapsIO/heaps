package hxd.res;

/**
	Handles the asynchronous loading of an Image texture.

	Mipmapped textures are streamed if the driver supports the ResidentMips feature : the mip levels up to BASE_SIZE
	are always loaded synchronously, the more detailed ones are loaded on demand with `loadMips` or `loadSync`.

	Other textures having the AsyncLoading flag use a 1x1 black placeholder while the file is read asynchronously.
**/
@:access(hxd.res.Image)
@:access(h3d.mat.Texture)
class TextureStream {

	public var image(default, null) : Image;
	public var texture(get, never) : h3d.mat.Texture;
	/**
		Tells if the texture mip levels are streamed.
	**/
	public var mipStreaming(default, null) : Bool;
	/**
		The most detailed mip level requested, it will be reloaded if the texture is reallocated.
	**/
	public var targetMip(default, null) : Int = 0;

	var inf(get, never) : hxd.res.Image.ImageInfo;
	var pendingRead : hxd.fs.AsyncRead;
	var pendingMip : Int;
	var queued = false;
	var readPos : Int;
	var readSize : Int;
	var readPriority : Float;
	var onRead : haxe.io.Bytes -> Void;
	var readBuffer : haxe.io.Bytes;

	public function new( image : Image ) {
		this.image = image;
		update();
	}

	inline function get_texture() return image.tex;
	inline function get_inf() return image.inf;

	/**
		Tells if some data is being loaded.
	**/
	public function isLoading() {
		return queued || pendingRead != null;
	}

	/**
		Load asynchronously the mip levels up to `mip` (0 for full resolution).
		`onDone` is called when the texture is loaded (immediately if it is already loaded).
		If the texture is not allocated, the mip levels will be loaded with it.
	**/
	public function loadMips( mip : Int, ?onDone : Void -> Void, priority = 0. ) {
		if( mipStreaming ) {
			targetMip = getValidMip(mip);
			if( texture.t != null ) requestMips(targetMip, priority);
		}
		if( onDone != null ) texture.waitLoad(onDone);
	}

	/**
		Release the mip levels that are more detailed than `mip`.
		The mip levels up to BASE_SIZE are always kept.
	**/
	public function unloadMips( mip : Int ) {
		if( !mipStreaming ) return;
		mip = getValidMip(mip);
		if( mip <= targetMip ) return;
		targetMip = mip;
		if( texture.t == null ) return;
		if( isLoading() && pendingMip < mip )
			cancelRead();
		if( mip > texture.residentMip ) texture.setResidentMip(mip);
		requestMips(mip, 0.);
	}

	/**
		Load synchronously the texture, up to the given size for streamed mip levels (0 for full resolution).
	**/
	public function loadSync( maxSize = 0 ) {
		if( texture.t == null || texture.isPlaceholder )
			image.loadTexture(true);
		if( !mipStreaming )
			return;
		var mip = 0;
		if( maxSize > 0 )
			while( mip < inf.mipLevels - 1 && ((inf.width >> mip) > maxSize || (inf.height >> mip) > maxSize) )
				mip++;
		mip = getValidMip(mip);
		if( mip < targetMip ) targetMip = mip;
		var last = texture.residentMip;
		if( mip < last ) {
			cancelRead();
			var pos = getMipPos(mip);
			var bytes = image.entry.fetchBytes(pos, getMipPos(last) - pos);
			if( texture.setResidentMip(mip) ) uploadMips(bytes, 0, mip, last);
		}
		requestMips(targetMip, 0.);
	}

	/**
		Cancel the pending load, if any.
	**/
	public function cancel() {
		cancelRead();
		removePlaceholder();
	}

	function update() {
		mipStreaming = !image.disableStreaming && inf.dataFormat == Dds && inf.mipLevels > 1 && inf.layerCount == 1 && !inf.flags.has(IsCube)
			&& h3d.Engine.getCurrent().driver.hasFeature(h3d.impl.Driver.Feature.ResidentMips);
	}

	inline function isAsync() {
		return Image.ASYNC_LOADING && (image.enableAsyncLoading || texture.flags.has(AsyncLoading));
	}

	function load( sync : Bool ) {
		cancel();
		if( mipStreaming )
			loadBaseMips(sync);
		else if( !sync && isAsync() )
			loadPlaceholder();
		else {
			image.loadFull();
			endLoading();
		}
	}

	function loadBaseMips( sync : Bool ) {
		var base = getValidMip(inf.mipLevels);
		var first = sync || !isAsync() ? hxd.Math.imin(targetMip, base) : base;
		if( texture.residentMip != first ) {
			texture.dispose();
			texture.setResidentMip(first);
		}
		texture.alloc();
		var pos = getMipPos(first);
		var bytes = image.entry.fetchBytes(pos, getMipPos(inf.mipLevels) - pos);
		uploadMips(bytes, 0, first, inf.mipLevels);
		requestMips(targetMip, 0.);
	}

	function loadPlaceholder() {
		var tex = texture;
		tex.dispose();
		tex.format = RGBA;
		tex.width = 1;
		tex.height = 1;
		tex.customMipLevels = 1;
		tex.residentMip = 0;
		tex.isPlaceholder = true;
		tex.alloc();
		tex.uploadPixels(BLACK_1x1);
		tex.width = inf.width;
		tex.height = inf.height;
		tex.flags.set(Loading);
		read(0, image.entry.size, 0., function(bytes) {
			// texture might have been disposed in the meantime
			var disposed = tex.t == null;
			removePlaceholder();
			if( !disposed ) image.loadFull(bytes);
			endLoading();
		});
	}

	function removePlaceholder() {
		var tex = texture;
		if( !tex.isPlaceholder ) return;
		tex.dispose();
		tex.isPlaceholder = false;
		tex.format = image.texFormat;
		tex.customMipLevels = inf.mipLevels;
	}

	function endLoading() {
		var tex = texture;
		if( !tex.flags.has(Loading) ) return;
		tex.flags.unset(Loading);
		if( tex.waitLoads != null ) {
			var arr = tex.waitLoads;
			tex.waitLoads = null;
			for( f in arr )
				f();
		}
	}

	function getValidMip( mip : Int ) {
		var base = 0;
		while( base < inf.mipLevels - 1 && ((inf.width >> base) > BASE_SIZE || (inf.height >> base) > BASE_SIZE) )
			base++;
		if( mip > base ) mip = base;
		if( mip < 0 ) mip = 0;
		// compressed resident mips must be 4x4 multiples
		if( inf.pixelFormat.match(S3TC(_)) )
			while( mip > 0 && ((inf.width >> mip) & 3 != 0 || (inf.height >> mip) & 3 != 0) )
				mip--;
		return mip;
	}

	function getMipPos( mip : Int ) {
		var pos = inf.flags.has(Dxt10Header) ? 148 : 128;
		var w = inf.width << inf.mipOffset;
		var h = inf.height << inf.mipOffset;
		for( i in 0...mip + inf.mipOffset )
			pos += hxd.Pixels.calcDataSize(hxd.Math.imax(w >> i, 1), hxd.Math.imax(h >> i, 1), inf.pixelFormat);
		return pos;
	}

	function uploadMips( bytes : haxe.io.Bytes, pos : Int, first : Int, last : Int ) {
		for( mip in first...last ) {
			var w = hxd.Math.imax(inf.width >> mip, 1);
			var h = hxd.Math.imax(inf.height >> mip, 1);
			texture.uploadPixels(new hxd.Pixels(w, h, bytes, inf.pixelFormat, pos), mip, 0);
			pos += hxd.Pixels.calcDataSize(w, h, inf.pixelFormat);
		}
	}

	function requestMips( mip : Int, priority : Float ) {
		if( isLoading() ) {
			if( pendingMip == mip ) {
				readPriority = priority;
				if( pendingRead != null ) pendingRead.priority = priority;
				return;
			}
			cancelRead();
		}
		var tex = texture;
		var last = tex.residentMip;
		if( mip >= last ) {
			endLoading();
			return;
		}
		var pos = getMipPos(mip);
		tex.flags.set(Loading);
		pendingMip = mip;
		read(pos, getMipPos(last) - pos, priority, function(bytes) {
			// texture might have been disposed in the meantime
			if( tex.t != null && tex.residentMip == last && tex.setResidentMip(mip) )
				uploadMips(bytes, 0, mip, last);
			endLoading();
		});
	}

	function read( pos : Int, size : Int, priority : Float, onRead : haxe.io.Bytes -> Void ) {
		readPos = pos;
		readSize = size;
		readPriority = priority;
		this.onRead = onRead;
		queued = true;
		queue.push(this);
		processQueue();
	}

	function cancelRead() {
		if( queued ) {
			queue.remove(this);
			queued = false;
		}
		if( pendingRead != null ) {
			// the buffer might still be written by the reader : don't reuse it
			pendingRead.cancel();
			pendingRead = null;
			loadingBytes -= readBuffer.length;
			readBuffer = null;
			processQueue();
		}
		onRead = null;
	}

	function startRead() {
		var size = readSize;
		var onRead = this.onRead;
		var bytes = allocBuffer(size);
		readBuffer = bytes;
		loadingBytes += bytes.length;
		pendingRead = image.entry.readBytesAsync(bytes, 0, readPos, size, function(len) {
			pendingRead = null;
			readBuffer = null;
			this.onRead = null;
			loadingBytes -= bytes.length;
			if( len != size ) {
				processQueue();
				throw "Failed to read " + image.entry.path;
			}
			try {
				onRead(bytes);
			} catch( e : Dynamic ) {
				freeBuffer(bytes);
				processQueue();
				throw e;
			}
			freeBuffer(bytes);
			processQueue();
		}, readPriority);
	}

	/**
		The mip levels up to this size are always loaded.
	**/
	public static var BASE_SIZE = 32;

	/**
		The maximum size of the buffers used to read data asynchronously : other requests are queued until it's available.
		A request bigger than this size is read without waiting. The released buffers are kept for reuse within this size.
	**/
	public static var MAX_LOADING_BYTES = 256 << 20;

	static var BLACK_1x1 = hxd.Pixels.alloc(1, 1, RGBA);
	static var queue : Array<TextureStream> = [];
	static var loadingBytes = 0;
	static var pool : Array<haxe.io.Bytes> = [];
	static var pooledBytes = 0;

	static function allocBuffer( size : Int ) {
		var best = null;
		for( b in pool )
			if( b.length >= size && (best == null || b.length < best.length) )
				best = b;
		if( best != null ) {
			pool.remove(best);
			pooledBytes -= best.length;
			return best;
		}
		size = (size + 0xFFFF) & ~0xFFFF;
		trimPool(size);
		return haxe.io.Bytes.alloc(size);
	}

	static function freeBuffer( b : haxe.io.Bytes ) {
		pool.push(b);
		pooledBytes += b.length;
		trimPool(0);
	}

	// release the smallest buffers until there is enough room
	static function trimPool( size : Int ) {
		while( pool.length > 0 && loadingBytes + pooledBytes + size > MAX_LOADING_BYTES ) {
			var min = pool[0];
			for( b in pool )
				if( b.length < min.length )
					min = b;
			pool.remove(min);
			pooledBytes -= min.length;
		}
	}

	static function processQueue() {
		while( queue.length > 0 ) {
			var best = queue[0];
			for( s in queue )
				if( s.readPriority > best.readPriority )
					best = s;
			// a request bigger than the max size would never fit : don't wait for it
			if( best.readSize <= MAX_LOADING_BYTES && loadingBytes + best.readSize > MAX_LOADING_BYTES )
				break;
			queue.remove(best);
			best.queued = false;
			best.startRead();
		}
	}

}
