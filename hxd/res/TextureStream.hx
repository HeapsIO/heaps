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
	var completedBytes : haxe.io.Bytes;
	var completedTime = 0.;
	var allocTime = 0.;
	var registered = false;
	var canStream = false;
	var mipPos : Array<Int>;

	public function new( image : Image ) {
		this.image = image;
		if( updateEvent == null )
			updateEvent = haxe.MainLoop.add(updateStreaming);
		update();
	}

	inline function get_texture() return image.tex;
	inline function get_inf() return image.inf;

	/**
		Tells if some data is being loaded.
	**/
	public function isLoading() {
		return queued || pendingRead != null || completedBytes != null;
	}

	/**
		Load asynchronously the mip levels up to `mip` (0 for full resolution).
		`onDone` is called when the texture is loaded (immediately if it is already loaded).
		If the texture is not allocated, the mip levels will be loaded with it.
	**/
	public function loadMips( mip : Int, ?onDone : Void -> Void, priority = 0. ) {
		if( mipStreaming ) {
			targetMip = isDisabled() ? 0 : getValidMip(mip);
			if( texture.t != null ) requestMips(targetMip, priority);
		}
		if( onDone != null ) texture.waitLoad(onDone);
	}

	/**
		Release the mip levels that are more detailed than `mip`.
		The mip levels up to BASE_SIZE are always kept.
	**/
	public function unloadMips( mip : Int ) {
		if( !mipStreaming || isDisabled() ) return;
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
		canStream = !image.disableStreaming && inf.dataFormat == Dds && inf.mipLevels > 1 && inf.layerCount == 1 && !inf.flags.has(IsCube)
			&& h3d.Engine.getCurrent().driver.hasFeature(h3d.impl.Driver.Feature.ResidentMips);
		mipStreaming = canStream && ENABLED;
		if( mipStreaming )
			texture.flags.set(Streamed);
		else
			texture.flags.unset(Streamed);
		mipPos = null;
		if( canStream && !registered ) {
			registered = true;
			streams.push(this);
		}
	}

	inline function isDisabled() {
		return !ENABLED || image.disableStreaming;
	}

	function stopStreaming( priority : Float ) {
		var t = texture;
		if( t.t != null && t.residentMip > 0 ) {
			targetMip = 0;
			requestMips(0, priority);
			return;
		}
		if( t.t == null ) {
			cancelRead();
			endLoading();
		}
		update();
	}

	/**
		The GPU memory used by the resident mip levels.
	**/
	public function getResidentBytes() {
		var t = texture;
		if( t.t == null || t.isPlaceholder )
			return 0;
		return getMipPos(inf.mipLevels) - getMipPos(t.residentMip);
	}

	// the coarsest mip level that unloadMips can reach
	function getMinMip() {
		return getValidMip(inf.mipLevels);
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
		if( mipPos == null ) {
			mipPos = [];
			var pos = inf.flags.has(Dxt10Header) ? 148 : 128;
			var w = inf.width << inf.mipOffset;
			var h = inf.height << inf.mipOffset;
			for( i in 0...inf.mipOffset )
				pos += hxd.Pixels.calcDataSize(hxd.Math.imax(w >> i, 1), hxd.Math.imax(h >> i, 1), inf.pixelFormat);
			for( i in 0...inf.mipLevels + 1 ) {
				mipPos.push(pos);
				var k = i + inf.mipOffset;
				pos += hxd.Pixels.calcDataSize(hxd.Math.imax(w >> k, 1), hxd.Math.imax(h >> k, 1), inf.pixelFormat);
			}
		}
		return mipPos[mip];
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
			if( tex.t != null && tex.residentMip == last ) {
				var start = TextureStreamDebug.PROFILING ? haxe.Timer.stamp() : 0.;
				if( tex.setResidentMip(mip) ) {
					if( TextureStreamDebug.PROFILING ) allocTime = haxe.Timer.stamp() - start;
					uploadMips(bytes, 0, mip, last);
				}
			}
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
			readsInFlight--;
			loadingBytes -= readBuffer.length;
			readBuffer = null;
			processQueue();
		}
		if( completedBytes != null ) {
			completed.remove(this);
			loadingBytes -= completedBytes.length;
			freeBuffer(completedBytes);
			completedBytes = null;
			processQueue();
		}
		onRead = null;
	}

	function applyCompleted() {
		var bytes = completedBytes;
		var onRead = this.onRead;
		completedBytes = null;
		this.onRead = null;
		loadingBytes -= bytes.length;
		var profiling = TextureStreamDebug.PROFILING;
		var fromMip = texture.residentMip;
		var start = profiling ? haxe.Timer.stamp() : 0.;
		allocTime = 0;
		try {
			onRead(bytes);
		} catch( e : Dynamic ) {
			freeBuffer(bytes);
			throw e;
		}
		freeBuffer(bytes);
		if( profiling ) TextureStreamDebug.recordCompletion(this, fromMip, start, haxe.Timer.stamp());
		completedTime = 0;
	}

	static function processCompleted() {
		if( completed.length == 0 )
			return;
		var start = haxe.Timer.stamp();
		while( completedPos < completed.length ) {
			completed[completedPos++].applyCompleted();
			if( haxe.Timer.stamp() - start >= COMPLETION_TIME_BUDGET )
				break;
		}
		completed.splice(0, completedPos);
		completedPos = 0; // completedPos is retained in case of throw
		processQueue();
	}

	function startRead() {
		var size = readSize;
		var bytes = allocBuffer(size);
		readBuffer = bytes;
		loadingBytes += bytes.length;
		readsInFlight++;
		pendingRead = image.entry.readBytesAsync(bytes, 0, readPos, size, function(len) {
			pendingRead = null;
			readBuffer = null;
			readsInFlight--;
			if( TextureStreamDebug.PROFILING ) completedTime = haxe.Timer.stamp();
			if( len != size ) {
				this.onRead = null;
				loadingBytes -= bytes.length;
				processQueue();
				throw "Failed to read " + image.entry.path;
			}
			completedBytes = bytes;
			completed.push(this);
		}, readPriority);
	}

	/**
		Set to false to disable mip levels streaming : textures are loaded at full resolution.
		Streamed textures then load their missing mip levels asynchronously, and are streamed again once it is set back to true.
	**/
	public static var ENABLED = true;

	/**
		The mip levels up to this size are always loaded.
	**/
	public static var BASE_SIZE = 32;

	/**
		The maximum size of the buffers used to read data asynchronously : other requests are queued until it's available.
		A request bigger than this size is read without waiting. The released buffers are kept for reuse within this size.
	**/
	public static var MAX_LOADING_BYTES = 256 << 20;

	/**
		Main thread time in seconds spent per frame applying completed reads (allocation and upload), at least one is applied.
	**/
	public static var COMPLETION_TIME_BUDGET = 0.002;

	static var BLACK_1x1 = hxd.Pixels.alloc(1, 1, RGBA);
	static var queue : Array<TextureStream> = [];
	static var completed : Array<TextureStream> = [];
	static var completedPos = 0;
	static var loadingBytes = 0;
	static var pool : Array<haxe.io.Bytes> = [];
	static var pooledBytes = 0;

	/**
		Budget in bytes for the resident mip levels of all streamed textures, -1 for no limit.
	**/
	public static var MEMORY_BUDGET : Float = -1;
	/**
		GPU memory in bytes to keep free when the driver reports its memory usage (see Driver.getMemoryUsage), -1 to ignore it.
	**/
	public static var MIN_GPU_FREE : Float = 256 << 20;
	/**
		Frames without being visible (see Texture.markVisible) before a texture can lose mip levels.
	**/
	public static var HIDDEN_FRAMES = 60;
	/**
		Maximum number of mip levels released per frame when over budget, so that the reduction is spread over time.
	**/
	public static var MAX_UNLOADS_PER_FRAME = 4;
	/**
		Frames between two queries of the GPU memory usage.
	**/
	public static var GPU_QUERY_FRAMES = 30;
	/**
		Minimum frames between two changes of `maxVisibleSize`.
	**/
	public static var MAX_SIZE_FRAMES = 30;
	/**
		Extra free memory in bytes required to raise `maxVisibleSize`, on top of what the raise and the loads in progress need.
	**/
	public static var MAX_SIZE_RAISE_MARGIN : Float = 64 << 20;
	/**
		Set to true to let visible textures lose mip levels (see `maxVisibleSize`) when releasing hidden ones is not enough to meet the budget.
	**/
	public static var REDUCE_VISIBLE = false;

	/**
		When visible textures alone exceed the budget and REDUCE_VISIBLE is set, the largest size (in pixels) they can load, 0 for no limit.
		It is halved from the largest visible texture size (a 4K texture becomes 2K) until the budget is met, and doubled back when it fits.
	**/
	public static var maxVisibleSize(default, null) = 0;

	/**
		Bytes of all streamed textures resident mip levels, computed by the last `updateStreaming`.
	**/
	public static var residentBytes(default, null) : Float = 0;
	/**
		Bytes over budget after the last `updateStreaming`, 0 or less when within budget.
	**/
	public static var excessBytes(default, null) : Float = 0;

	/**
		A virtual budget in bytes, combined with MEMORY_BUDGET (the smaller wins), to force streaming operations
		while profiling (see h3d.impl.TextureStreamProfiler). -1 when unused.
	**/
	public static var debugBudget : Float = -1;

	static var streams : Array<TextureStream> = [];
	static var updateEvent : haxe.MainLoop.MainEvent;
	static var readsInFlight = 0;
	static var gpuExcess : Null<Float>;
	static var lastGpuQuery = -1;
	static var candidates : Array<TextureStream> = [];
	static var maxSizeFrame = -1;
	static var maxSizeRaiseFrame = -1;
	static var status = "";
	static var frameUnloads = 0;
	static var pendingMaxSize = 0;
	static var largestVisibleSize = 0;
	static var largestVisibleFullSize = 0;

	inline function isVisible( frame : Int ) {
		return texture.visibleFrame >= frame - 1;
	}

	inline function getMaxSize() {
		return inf.width > inf.height ? inf.width : inf.height;
	}

	function getMaxSizeMip() {
		var mip = 0;
		if( maxVisibleSize > 0 ) {
			var size = getMaxSize();
			while( (size >> mip) > maxVisibleSize ) mip++;
		}
		return getValidMip(mip);
	}

	/**
		Runs once per main loop iteration, between two frames (a haxe.MainLoop event added with the first TextureStream). Visible streamed textures load all their mip levels, up to `maxVisibleSize`.
		When over budget, the textures not visible for HIDDEN_FRAMES lose one mip level at a time, least recently visible first.
		If that is not enough and REDUCE_VISIBLE is set, `maxVisibleSize` is halved.
	**/
	static function updateStreaming() {
		var engine = h3d.Engine.getCurrent();
		if( engine == null || engine.driver.isDisposed() )
			return;
		if( TextureStreamDebug.PROFILING ) TextureStreamDebug.beginFrame();
		processCompleted();
		manageStreams();
	}

	public static function getBudget() : Float {
		if( debugBudget >= 0 && (MEMORY_BUDGET < 0 || debugBudget < MEMORY_BUDGET) )
			return debugBudget;
		return MEMORY_BUDGET;
	}

	static function manageStreams() {
		var frame = hxd.Timer.frameCount;
		frameUnloads = 0;
		if( !REDUCE_VISIBLE ) maxVisibleSize = 0;
		updateStreams(frame);
		var excess = computeExcess(frame);
		excessBytes = excess;
		var maxSizeReady = pendingMaxSize == 0 && frame - maxSizeFrame >= MAX_SIZE_FRAMES;
		if( excess <= 0 ) {
			if( TextureStreamDebug.PROFILING ) status = "within budget";
			if( maxVisibleSize > 0 && maxSizeReady && frame - maxSizeRaiseFrame >= MAX_SIZE_FRAMES )
				tryRaiseMaxSize(frame);
			return;
		}
		var waiting = collectHiddenCandidates(frame);
		if( candidates.length == 0 ) {
			if( waiting > 0 ) {
				if( TextureStreamDebug.PROFILING ) status = "over budget, waiting for " + waiting + " recently hidden textures";
			} else if( !REDUCE_VISIBLE ) {
				if( TextureStreamDebug.PROFILING ) status = "over budget, visible textures kept (REDUCE_VISIBLE disabled)";
			} else
				lowerMaxSize(frame, maxSizeReady);
			return;
		}
		unloadHidden(excess);
	}

	static function updateStreams( frame : Int ) {
		var total = 0.;
		pendingMaxSize = largestVisibleSize = largestVisibleFullSize = 0;
		var i = 0;
		while( i < streams.length ) {
			var s = streams[i];
			if( s.image.stream == s && s.canStream ) {
				if( s.mipStreaming ) {
					if( s.isDisabled() )
						s.stopStreaming(s.isVisible(frame) ? s.texture.residentMip : 0.);
				} else if( ENABLED )
					s.update();
			}
			if( s.image.stream != s || !s.canStream ) {
				s.registered = false;
				streams.splice(i, 1);
				continue;
			}
			i++;
			var t = s.texture;
			if( t.t == null || !s.mipStreaming )
				continue;
			if( s.isVisible(frame) && !s.isDisabled() )
				updateVisible(s);
			total += s.getResidentBytes();
		}
		residentBytes = total;
	}

	static function updateVisible( s : TextureStream ) {
		var t = s.texture;
		var maxMip = s.getMaxSizeMip();
		var size = s.getMaxSize();
		if( size > largestVisibleFullSize ) largestVisibleFullSize = size;
		if( (size >> maxMip) > largestVisibleSize ) largestVisibleSize = size >> maxMip;
		if( t.residentMip < maxMip ) {
			if( frameUnloads < MAX_UNLOADS_PER_FRAME ) {
				s.unloadMips(t.residentMip + 1);
				countUnload();
			}
			if( t.residentMip < maxMip ) pendingMaxSize++;
		} else if( t.residentMip > maxMip || s.targetMip != maxMip )
			s.loadMips(maxMip, null, t.residentMip);
	}

	static function computeExcess( frame : Int ) {
		if( MIN_GPU_FREE >= 0 && (lastGpuQuery < 0 || frame - lastGpuQuery >= GPU_QUERY_FRAMES) )
			queryGpu(frame);
		var excess = Math.NEGATIVE_INFINITY;
		var budget = getBudget();
		if( budget >= 0 )
			excess = residentBytes - budget;
		if( MIN_GPU_FREE >= 0 && gpuExcess != null && gpuExcess > excess )
			excess = gpuExcess;
		return excess;
	}

	static function queryGpu( frame : Int ) {
		var engine = h3d.Engine.getCurrent();
		lastGpuQuery = frame;
		var stats = engine.driver.getMemoryUsage();
		gpuExcess = stats == null ? null : MIN_GPU_FREE - stats.free;
	}

	static function tryRaiseMaxSize( frame : Int ) {
		maxSizeRaiseFrame = frame;
		var up = maxVisibleSize << 1;
		var cost = getRaiseCost(frame, up);
		var budget = getBudget();
		var room = budget >= 0 ? budget - residentBytes : Math.POSITIVE_INFINITY;
		if( MIN_GPU_FREE >= 0 ) {
			queryGpu(frame);
			if( gpuExcess != null && -gpuExcess < room ) room = -gpuExcess;
		}
		if( cost + MAX_SIZE_RAISE_MARGIN <= room ) {
			maxVisibleSize = up >= largestVisibleFullSize ? 0 : up;
			maxSizeFrame = frame;
		} else if( TextureStreamDebug.PROFILING )
			status = 'within budget, max size kept : raising it needs ${Math.round((cost + MAX_SIZE_RAISE_MARGIN) / 1048576)} MB, ${Math.round(room / 1048576)} MB available';
	}

	static function getRaiseCost( frame : Int, up : Int ) {
		var cost = 0.;
		for( s in streams ) {
			var t = s.texture;
			if( t.t == null || !s.isVisible(frame) || s.isDisabled() ) continue;
			var mip = s.getMaxSizeMip();
			if( t.residentMip > mip )
				cost += s.getMipPos(t.residentMip) - s.getMipPos(mip);
			if( mip > 0 && (s.getMaxSize() >> (mip - 1)) <= up )
				cost += s.getMipPos(mip) - s.getMipPos(mip - 1);
		}
		return cost;
	}

	static function collectHiddenCandidates( frame : Int ) {
		candidates.resize(0);
		var waiting = 0;
		for( s in streams ) {
			var t = s.texture;
			if( t.t == null || s.isVisible(frame) || s.isDisabled() || t.residentMip >= s.getMinMip() )
				continue;
			if( t.visibleFrame < frame - HIDDEN_FRAMES )
				candidates.push(s);
			else
				waiting++;
		}
		return waiting;
	}

	static function lowerMaxSize( frame : Int, ready : Bool ) {
		if( (largestVisibleSize >> 1) < BASE_SIZE ) {
			if( TextureStreamDebug.PROFILING ) status = "over budget, visible textures at minimum size";
		} else if( !ready ) {
			if( TextureStreamDebug.PROFILING ) status = "over budget, max size " + (pendingMaxSize > 0 ? "being applied" : "change delayed");
		} else {
			maxVisibleSize = largestVisibleSize >> 1;
			maxSizeFrame = frame;
			if( TextureStreamDebug.PROFILING ) status = "over budget, max size lowered to " + maxVisibleSize + " px";
		}
	}

	static function unloadHidden( excess : Float ) {
		if( TextureStreamDebug.PROFILING ) status = "over budget, unloading hidden textures";
		candidates.sort(function(a, b) return a.texture.visibleFrame - b.texture.visibleFrame);
		for( s in candidates ) {
			if( excess <= 0 || frameUnloads >= MAX_UNLOADS_PER_FRAME )
				break;
			var before = s.getResidentBytes();
			s.unloadMips(s.texture.residentMip + 1);
			var freed = before - s.getResidentBytes();
			if( freed <= 0 )
				continue;
			countUnload();
			excess -= freed;
			residentBytes -= freed;
			if( gpuExcess != null ) gpuExcess -= freed;
		}
		excessBytes = excess;
		candidates.resize(0);
	}

	static inline function countUnload() {
		frameUnloads++;
		if( TextureStreamDebug.PROFILING ) TextureStreamDebug.frameStats.unloads++;
	}

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
