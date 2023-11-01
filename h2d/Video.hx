package h2d;

#if (hl && hlvideo)

enum FrameState {
	Free;
	Loading;
	Ready;
	Ended;
}

typedef Frame = {
	var pixels : hxd.Pixels;
	var state : FrameState;
	var time : Float;
}

class FrameCache {
	var frames : Array<Frame> = [];
	var readCursor = 0;
	var writeCursor = 0;
	var width : Int;
	var height : Int;

	public function new(size : Int, w : Int, h : Int) {
		width = w;
		height = h;
		frames = [];
		for(i in 0 ... size) {
			frames[i] = {
				pixels: new hxd.Pixels(w, h, haxe.io.Bytes.alloc(w * h * 4), h3d.mat.Texture.nativeFormat),
				state: Free,
				time: 0
			}
		}
	}

	public function currentFrame() : Frame {
		if( frames == null )
			return null;
		return frames[readCursor];
	}

	public function nextFrame() : Bool {
		var nextCursor = (readCursor + 1) % frames.length;
		frames[readCursor].state = Free;
		readCursor = nextCursor;
		return true;
	}

	function frameBufferSize() {
		if(writeCursor < readCursor)
			return frames.length - readCursor + writeCursor;
		else
			return writeCursor - readCursor;
	}

	public function isFull() {
		if(writeCursor < readCursor)
			return frames.length - readCursor + writeCursor >= frames.length - 1;
		else
			return writeCursor - readCursor >= frames.length - 1;
	}

	public function isEmpty() {
		return readCursor == writeCursor;
	}

	public function prepareFrame(webm : hl.video.Webm, codec : hl.video.Aom.Codec, loop : Bool) : Frame {
		if(frames[writeCursor].state != Free)
			return null;

		var savedCursor = writeCursor;
		var f = frames[writeCursor];

		var time = webm.readFrame(codec, f.pixels.bytes);
		if(time == null) {
			if(loop) {
				webm.rewind();
				time = webm.readFrame(codec, f.pixels.bytes);
			}
			else {
				f.time = 0;
				f.state = Ended;
				return f;
			}
		}
		f.time = time;
		f.state = Ready;
		writeCursor++;
		if(writeCursor >= frames.length)
			writeCursor %= frames.length;
		return f;
	}

	public function dispose() {
		for(f in frames)
			f.pixels.dispose();
	}
}

#end

/**
	A video file playback Drawable. Due to platform specifics, each target have their own limitations.

	* <span class="label">Hashlink</span>: Playback ability depends on `https://github.com/HeapsIO/hlvideo` library. It support only video with the AV1 codec packed into a WEBM container.

	* <span class="label">JavaScript</span>: HTML Video element will be used. Playback is restricted by content-security policy and browser decoder capabilities.
**/
class Video extends Drawable {

	#if (hl && hlvideo)
	var webm : hl.video.Webm;
	var codec : hl.video.Aom.Codec;
	var multithread : Bool;
	var cache : FrameCache;
	var frameCacheSize : Int = 20;
	var stopThread = false;
	#elseif js
	var v : js.html.VideoElement;
	var videoPlaying : Bool;
	var videoTimeupdate : Bool;
	var onReady : Void->Void;
	#end
	var texture : h3d.mat.Texture;
	var tile : h2d.Tile;
	var playTime : Float;
	var videoTime : Float;
	var frameReady : Bool;
	var loopVideo : Bool;

	/**
		Video width. Value is undefined until video is ready to play.
	**/
	public var videoWidth(default, null) : Int;
	/**
		Video height. Value is undefined until video is ready to play.
	**/
	public var videoHeight(default, null) : Int;
	/**
		Tells if video currently playing.
	**/
	public var playing : Bool;
	/**
		Tells current timestamp of the video.
	**/
	public var time(get, null) : Float;
	/**
		When enabled, video will loop indefinitely.
	**/
	public var loop(get, set) : Bool;

	/**
		Create a new Video instance.
		@param parent An optional parent `h2d.Object` instance to which Video adds itself if set.
		@param cacheSize <span class="label">Hashlink</span>: async precomputing up to `cache` frame. If 0, synchronized computing
	**/
	public function new(?parent) {
		super(parent);
		smooth = true;
	}

	/**
		Sent when there is an error with the decoding or playback of the video.
	**/
	public dynamic function onError( msg : String ) {
	}

	/**
		Sent when video playback is finished.
	**/
	public dynamic function onEnd() {
	}

	@:dox(hide) @:noCompletion
	public function get_time() {
		#if js
		return playing ? v.currentTime : 0;
		#else
		return playing ? haxe.Timer.stamp() - playTime : 0;
		#end
	}

	@:dox(hide) @:noCompletion
	public inline function get_loop() {
		return loopVideo;
	}

	@:dox(hide) @:noCompletion
	public function set_loop(value : Bool) : Bool {
		#if js
		loopVideo = value;
		if(v != null)
			v.loop = loopVideo;
		return loopVideo;
		#else
		return loopVideo = value;
		#end
	}

	/**
		Disposes of the currently playing Video and frees GPU memory.
	**/
	public function dispose() {
		#if (hl && hlvideo)
		if( frameCacheSize > 1 ) {
			stopThread = true;
			while(stopThread)
				Sys.sleep(0.01);
		}
		if( webm != null ) {
			webm.close();
			webm = null;
		}
		if( codec != null ) {
			codec.close();
			codec = null;
		}
		if( cache != null )
			cache.dispose();
		cache = null;
		#elseif js
		if ( v != null ) {
			v.removeEventListener("ended", endHandler, true);
			v.removeEventListener("error", errorHandler, true);
			if (!v.paused) v.pause();
			v = null;
		}
		#end
		if( texture != null ) {
			texture.dispose();
			texture = null;
		}
		tile = null;
		videoWidth = 0;
		videoHeight = 0;
		time = 0;
		playing = false;
		frameReady = false;
	}

	/**
		Loads and starts the video playback by specified `path` and calls `onReady` when playback becomes possible.

		* <span class="label">Hashlink</span>: Playback being immediately after `loadFile`, unless video was not being able to initialize.
		* <span class="label">JavaScript</span>: There won't be any video output until video is properly buffered enough data by the browser, in which case `onReady` is called.

		@param path The video path. Have to be valid file-system path for HL or valid URL (full or relative) for JS.
		@param onReady An optional callback signalling that video is initialized and began the video playback.
	**/
	public function loadFile( path : String, ?onReady : Void -> Void ) {
		dispose();

		#if (hl && hlvideo)
		webm = hl.video.Webm.fromFile(path);
		#elseif js
		v = js.Browser.document.createVideoElement();
		v.autoplay = true;
		v.muted = true;
		v.loop = loopVideo;

		videoPlaying = false;
		videoTimeupdate = false;
		this.onReady = onReady;

		v.addEventListener("playing", checkReady, true);
		v.addEventListener("timeupdate", checkReady, true);
		v.addEventListener("ended", endHandler, true);
		v.addEventListener("error", errorHandler, true);
		v.src = path;
		v.play();
		#else
		onError("Video not supported on this platform");
		return;
		#end
		start();
		if( onReady != null ) onReady();
	}

	/**
		Loads and starts the video playback by specified `res` and calls `onReady` when playback becomes possible.

		* <span class="label">Hashlink</span>: Playback being immediately after `loadResource`, unless video was not being able to initialize.
		* <span class="label">JavaScript</span>: Not implemented

		@param res The heaps resource of a valid video file
		@param onReady An optional callback signalling that video is initialized and began the video playback.
	**/
	public function loadResource( res : hxd.res.Resource, ?onReady : Void -> Void ) {
		#if (hl && hlvideo)
		var e = res.entry;
		webm = hl.video.Webm.fromReader(function(offset : Int, len : Int) {
			var buf = haxe.io.Bytes.alloc(len);
			var n = e.readBytes(buf, 0, offset, len);
			return buf;
		}, res.entry.size);
		webm.availableSize = res.entry.size;
		start();
		if( onReady != null ) onReady();
		#else
		onError("Video from resource not supported on this platform");
		#end
	}

	function start() {
		#if (hl && hlvideo)
		try {
			webm.init();
		} catch(e:Any) {
			onError("Failed to init video : " + e);
			return;
		}
		codec = webm.createCodec();
		if(codec == null) {
			onError("Can't create codec " + webm.videoCodec);
			return;
		}
		var w = 0, h = 0;
		videoWidth = webm.width;
		videoHeight = webm.height;
		videoTime = 0.;
		texture = new h3d.mat.Texture(videoWidth, videoHeight);
		tile = h2d.Tile.fromTexture(texture);
		var multithread = frameCacheSize > 1;
		cache = new FrameCache(multithread ? frameCacheSize : 1, webm.width, webm.height);
		if(multithread) {
			threadInit();
			while(!cache.isFull()) Sys.sleep(0.01);
		}
		else
			loadNextFrame();
		playing = true;
		playTime = haxe.Timer.stamp();
		#end
	}

	#if js

	function errorHandler(e : js.html.Event) {
		#if (haxe_ver >= 4)
		onError(v.error.code + ": " + v.error.message);
		#else
		onError(Std.string(v.error.code));
		#end
	}

	function endHandler(e : js.html.Event) {
		onEnd();
	}

	function checkReady(e : js.html.Event) {
		if (e.type == "playing") {
			videoPlaying = true;
			v.removeEventListener("playing", checkReady, true);
		} else {
			videoTimeupdate = true;
			v.removeEventListener("timeupdate", checkReady, true);
		}

		if (videoPlaying && videoTimeupdate) {
			frameReady = true;
			videoWidth = v.videoWidth;
			videoHeight = v.videoHeight;
			texture = new h3d.mat.Texture(videoWidth, videoHeight);
			tile = h2d.Tile.fromTexture(texture);
			playing = true;
			playTime = haxe.Timer.stamp();
			videoTime = 0.0;
			if ( onReady != null )
			{
				onReady();
				onReady = null;
			}
			loadNextFrame();
		}
	}
	#end

	override function draw(ctx:RenderContext) {
		if( tile != null )
			ctx.drawTile(this, tile);
	}

	function loadNextFrame() {
		#if (hl && hlvideo)
		cache.prepareFrame(webm, codec, loopVideo);
		#end
	}

	#if js
	@:access(h3d.mat.Texture)
	#end
	override function sync(ctx:RenderContext) {
		if( !playing )
			return;

		#if js
		if( frameReady && time >= videoTime ) {
			texture.alloc();
			texture.checkSize(videoWidth, videoHeight, 0);
			@:privateAccess cast (@:privateAccess texture.mem.driver, h3d.impl.GlDriver).uploadTextureVideoElement(texture, v, 0, 0);
			texture.flags.set(WasCleared);
			texture.checkMipMapGen(0, 0);
		}
		#elseif (hl && hlvideo)
		var frame = cache.currentFrame();
		if( frame != null && frame.state == Ended )
			playing = false;
		if( frame != null && frame.state == Ready) {
			if(frame.time == 0) {
				videoTime = 0;
			}
			if(haxe.Timer.stamp() - playTime >= frame.time) {
				texture.uploadPixels(frame.pixels);
				videoTime = frame.time;
				cache.nextFrame();
				if(frameCacheSize <= 1)
					loadNextFrame();
			}
		}
		#end
	}

	#if (hl && hlvideo)
	function threadInit() {
		sys.thread.Thread.create(function() {
			var first = true;
			var finished = false;
			while(!stopThread) {
				if( cache.isFull() || finished ) {
					first = false;
					Sys.sleep(0.01);
				}
				else {
					var f = null;
					try {
						f = cache.prepareFrame(webm, codec, loopVideo);
					} catch(e : Dynamic) {
						trace(e);
					}
					if( !loopVideo && (f == null || f.state == Ended) )
						finished = true;
				}
			}
			stopThread = false;
			// trace("Stopping thread");
		});
	}
	#end

    override function getBoundsRec( relativeTo : Object, out : h2d.col.Bounds, forSize : Bool ) {
        super.getBoundsRec(relativeTo, out, forSize);
        if( tile != null ) addBounds(relativeTo, out, tile.dx, tile.dy, tile.width, tile.height);
    }
}