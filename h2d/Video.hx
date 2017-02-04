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

class Video extends Drawable {

	#if hl
	static var INIT_DONE = false;
	var v : VideoImpl;
	#end
	var pixels : hxd.Pixels;
	var texture : h3d.mat.Texture;
	var tile : h2d.Tile;
	var playTime : Float;
	var videoTime : Float;
	var frameReady : Bool;

	public var videoWidth(default, null) : Int;
	public var videoHeight(default, null) : Int;
	public var playing(default, null) : Bool;
	public var time(get, null) : Float;

	public function new(?parent) {
		super(parent);
		blendMode = None;
		filter = true;
	}

	public dynamic function onError( msg : String ) {
	}

	public dynamic function onEnd() {
	}

	public function get_time() {
		return playing ? haxe.Timer.stamp() - playTime : 0;
	}

	public function dispose() {
		#if hl
		if( v != null ) {
			v.close();
			v = null;
		};
		#end
		if( texture != null ) {
			texture.dispose();
			texture = null;
		}
		tile = null;
		pixels = null;
		videoWidth = 0;
		videoHeight = 0;
		time = 0;
		playing = false;
		frameReady = false;
	}

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
		#else
		onError("Video not supported on this platform");
		#end
	}

	override function draw(ctx:RenderContext) {
		if( tile != null )
			ctx.drawTile(this, tile);
	}


	override function sync(ctx:RenderContext) {
		if( !playing )
			return;
		if( texture == null ) {
			var w = videoWidth, h = videoHeight;
			pixels = new hxd.Pixels(w, h, haxe.io.Bytes.alloc(w * h * 4), h3d.mat.Texture.nativeFormat);
			texture = new h3d.mat.Texture(w, h);
			tile = h2d.Tile.fromTexture(texture);
			if( h3d.mat.Texture.nativeFlip ) {
				pixels.flags.set(FlipY);
				tile.flipY();
				tile.dy = 0;
			}
		}
		if( frameReady ) {
			texture.uploadPixels(pixels);
			frameReady = false;
		}
		if( time >= videoTime ) {
			#if hl
			var t = 0.;
			v.decodeFrame(pixels.bytes, t);
			videoTime = t;
			#end
			frameReady = true; // delay decode/upload for more reliable FPS
		}
	}

}