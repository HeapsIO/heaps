package h2d;

#if hl
private abstract VideoImpl(hl.Abstract<"hl_video">) {

	@:hlNative("video","video_close") public function close() : Void {
	}

	@:hlNative("video","video_decode_frame") public function decodeFrame( out : hl.Bytes, time : hl.Ref<Float> ) : Bool {
		return false;
	}

	@:hlNative("video","video_get_size") public function getSize( width : hl.Ref<Int>, height : hl.Ref<Int> ) : Void {
	}

	@:hlNative("video","video_open") public static function open( file : hl.Bytes ) : VideoImpl {
		return null;
	}

	@:hlNative("video","video_init") public static function init() {
	}

}
#end

/**
	A video file playback Drawable. Due to platform specifics, each target have their own limitations.

	* <span class="label">Hashlink</span>: Playback ability depends on `video` library.
		At the time of HL 1.11 it's not bundled and have to be [compiled manually](https://github.com/HaxeFoundation/hashlink/tree/master/libs/video) with FFMPEG.
	* <span class="label">JavaScript</span>: HTML Video element will be used. Playback is restricted by content-security policy and browser decoder capabilities.
**/
class Video extends Drawable {

	#if hl
	static var INIT_DONE = false;
	var v : VideoImpl;
	var pixels : hxd.Pixels;
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
	public var playing(default, null) : Bool;
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
	**/
	public function new(?parent) {
		super(parent);
		blendMode = None;
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
		return v.loop = loopVideo = value;
		#else
		return loopVideo = value;
		#end
	}

	/**
		Disposes of the currently playing Video and frees GPU memory.
	**/
	public function dispose() {
		#if hl
		if( v != null ) {
			v.close();
			v = null;
		};
		pixels = null;
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

		* <span class="label">Hashlink</span>: Playback being immediately after `load`, unless video was not being able to initialize.
		* <span class="label">JavaScript</span>: There won't be any video output until video is properly buffered enough data by the browser, in which case `onReady` is called.

		@param path The video path. Have to be valid file-system path for HL or valid URL (full or relative) for JS.
		@param onReady An optional callback signalling that video is initialized and began the video playback.
	**/
	public function load( path : String, ?onReady : Void -> Void ) {
		dispose();

		#if hl
		if( !INIT_DONE ) { INIT_DONE = true; VideoImpl.init(); }
		v = VideoImpl.open(@:privateAccess path.toUtf8());
		if( v == null ) {
			onError("Failed to init video " + path);
			return;
		}
		var w = 0, h = 0;
		v.getSize(w, h);
		videoWidth = w;
		videoHeight = h;
		playing = true;
		playTime = haxe.Timer.stamp();
		videoTime = 0.;
		if( onReady != null ) onReady();
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
			playing = true;
			playTime = haxe.Timer.stamp();
			videoTime = 0.0;
			if ( onReady != null )
			{
				onReady();
				onReady = null;
			}
		}
	}
	#end

	override function draw(ctx:RenderContext) {
		if( tile != null )
			ctx.drawTile(this, tile);
	}

	#if js
	@:access(h3d.mat.Texture)
	#end
	override function sync(ctx:RenderContext) {
		if( !playing )
			return;
		if( texture == null ) {
			var w = videoWidth, h = videoHeight;
			texture = new h3d.mat.Texture(w, h);
			tile = h2d.Tile.fromTexture(texture);
			#if hl
			pixels = new hxd.Pixels(w, h, haxe.io.Bytes.alloc(w * h * 4), h3d.mat.Texture.nativeFormat);
			#end
		}
		if( frameReady ) {
			#if hl
			texture.uploadPixels(pixels);
			frameReady = false;
			#elseif js
			texture.alloc();
			texture.checkSize(videoWidth, videoHeight, 0);
			@:privateAccess cast (@:privateAccess texture.mem.driver, h3d.impl.GlDriver).uploadTextureVideoElement(texture, v, 0, 0);
			texture.flags.set(WasCleared);
			texture.checkMipMapGen(0, 0);
			#end
		}
		#if hl
		if( time >= videoTime ) {
			var t = 0.;
			v.decodeFrame(pixels.bytes, t);
			videoTime = t;
			frameReady = true; // delay decode/upload for more reliable FPS
		}
		#end
	}

}