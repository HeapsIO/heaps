package h2d;
import hxd.fmt.kframes.Data;

/**
	[Keyframes](https://github.com/heapsio/keyframes/) integration; A `KeyFrames` animation layer.
**/
typedef KeyframesLayer = {
	var id : Int;
	var name : String;
	var spr : Object;
	var tiles : Array<h2d.Tile>;
	var animations : Array<KFAnimation>;
	var from : Int;
	var to : Int;
}

/**
	Adobe After effect player, see [Keyframes](https://github.com/heapsio/keyframes/) library.
**/
class KeyFrames extends Mask {

	var layers : Array<KeyframesLayer>;
	var filePrefix : String;
	var curFrame : Float;

	/**
		The FPS provided by the KeyFrames file.
	**/
	public var frameRate : Float;
	/**
		The total amount of frames in the animation.
	**/
	public var frameCount : Int;
	/**
		The current playback frame with the frame display progress fraction.
	**/
	public var currentFrame(get,set) : Float;
	/**
		The playback speed multiplier.
	**/
	public var speed : Float = 1.;
	/**
		Pauses the playback when enabled.
	**/
	public var pause : Bool = false;
	/**
		Whether to loop the animation or not.
	**/
	public var loop : Bool = false;

	/**
		When looping, will interpolate between last frame and first frame.
	**/
	public var loopInterpolate : Bool = false;

	/**
		Use bilinear texture sampling instead of nearest neighbor.
		@see `Drawable.smooth`
	**/
	public var smooth(default,set) = true;

	/**
		Create a new KeyFrames animation instance.
		@param file The source file of the animation.
		@param filePrefix An optional directory prefix when looking up images.
		@param parent An optional parent `h2d.Object` instance to which KeyFrames adds itself if set.
	**/
	public function new( file : KeyframesFile, ?filePrefix : String, ?parent ) {
		super(0,0,parent);
		if( file.formatVersion == null )
			throw "Invalid keyframe file";
		if( file.formatVersion.split(".")[0] != "1" )
			throw "Invalid format version " + file.formatVersion;
		this.filePrefix = filePrefix;
		this.width = file.canvas_size.x;
		this.height = file.canvas_size.y;
		this.frameCount = file.animation_frame_count;
		this.frameRate = file.frame_rate;
		this.curFrame = 0;

		layers = [];
		for( f in file.features ) {
			var spr, tiles = null;
			if( f.backed_image == null ) {
				spr = new h2d.Object(this);
			} else {
				var reg = ~/(.*?)\[([0-9]+)-([0-9]+)\](.*)/;
				if( reg.match(f.backed_image) ){
					var from = Std.parseInt(reg.matched(2));
					var to = Std.parseInt(reg.matched(3));
					var l = reg.matched(2).length;
					tiles = [for( i in from...to+1) loadTile(reg.matched(1)+StringTools.lpad(Std.string(i), "0", l)+reg.matched(4))];
				}else{
					tiles = [loadTile(f.backed_image)];
				}

				if (f.size != null) {
					for( t in tiles ) t.scaleToSize(f.size.x, f.size.y);
				}
				var bmp = new h2d.Bitmap(tiles[0], this);
				bmp.smooth = smooth;
				if( f.name.toLowerCase().indexOf("(add)") >= 0 )
					bmp.blendMode = Add;
				spr = bmp;
			}
			var l : KeyframesLayer = {
				id: f.feature_id,
				name: f.name,
				from: f.from_frame == null ? 0 : f.from_frame,
				to: f.to_frame == null ? file.animation_frame_count : f.to_frame,
				tiles: tiles,
				spr: spr,
				animations : [],
			};
			for( f in f.feature_animations ) {
				switch( f.key_values.length ) {
				case 0: // nothing
				case 1:
					apply(l, f);
				default:
					apply(l, f);
					l.animations.push(f);
				}
			}
			layers.push(l);
		}
	}

	@:dox(hide) @:noCompletion
	public function set_smooth( v : Bool ) : Bool {
		for( l in layers ){
			var bmp = hxd.impl.Api.downcast(l.spr, h2d.Bitmap);
			if( bmp != null )
				bmp.smooth = v;
		}
		return smooth = v;
	}

	/**
		Unpauses the playback and starts it at the specified frame.
		@param speed The playback speed multiplier at which animation should run.
		@param startFrame The frame at which the animation should start.
	**/
	public function play( speed : Float = 1., startFrame = 0 ) {
		this.speed = speed;
		pause = false;
		currentFrame = startFrame;
	}

	function apply( l : KeyframesLayer, f : KFAnimation ) {
		var index = 0;
		for( i in 0...f.key_values.length ) {
			var v = f.key_values[i];
			if( curFrame >= v.start_frame )
				index = i;
		}
		var cur = f.key_values[index];
		var next = f.key_values[index + 1];
		var yVal;
		var xVal;
		if( next == null ) {
			if( loop && loopInterpolate ) {
				next = f.key_values[0];
				yVal = ((next.start_frame + frameCount) - cur.start_frame);
				xVal = (curFrame - cur.start_frame) / yVal;
			} else {
				next = cur;
				yVal = 1;
				xVal = 0.;
			}
		} else {
			yVal = (next.start_frame - cur.start_frame);
			xVal = (curFrame - cur.start_frame) / yVal;
		}

		function calcValue( index : Int ) : Float {
			var v0 = cur.data[index];
			if( xVal <= 0 ) return v0;

			var minT = 0.;
			var maxT = 1.;
			var maxDelta = 1 / yVal;

			inline function bezier(c1:Float, c2:Float, t:Float) {
				var u = 1 - t;
				return u * u * u * 0 + c1 * 3 * t * u * u + c2 * 3 * t * t * u + t * t * t * 1;
			}

			var curves = f.timing_curves[0];
			var c1x = curves[0].x;
			var c2x = curves[1].x;
			var c1y = curves[0].y;
			var c2y = curves[1].y;

			{
				// For now, force control points to stay within the [0,1] range
				// See https://github.com/facebookincubator/Keyframes/issues/148
				if(c1y > 1.0) {
					c1x /= c1y;
					c1y = 1.0;
				}
				else if(c1y < 0) {
					c1y = 0;
				}

				if(c2y > 1.0) {
					c2x /= c2y;
					c2y = 1.0;
				}
				else if(c2y < 0) {
					c2y = 0;
				}
			}


			var count = 0;
			while( maxT - minT > maxDelta ) {
				var t = (maxT + minT) * 0.5;
				var x = bezier(c1x, c2x, t);
				if( x > xVal )
					maxT = t;
				else
					minT = t;
				count++;
			}

			var x0 = bezier(c1x, c2x, minT);
			var x1 = bezier(c1x, c2x, maxT);
			var dx = x1 - x0;
			var xfactor = dx == 0 ? 0.5 : (xVal - x0) / dx;

			var y0 = bezier(c1y, c2y, minT);
			var y1 = bezier(c1y, c2y, maxT);
			var y = y0 + (y1 - y0) * xfactor;

			var v1 = next.data[index];
			return v0 + (v1 - v0) * y;
		}

		switch( f.property ) {
		case AnchorPoint:
			var bmp = hxd.impl.Api.downcast(l.spr, h2d.Bitmap);
			if( bmp != null ) {
				bmp.tile.dx = -calcValue(0);
				bmp.tile.dy = -calcValue(1);
			}
		case XPosition:
			l.spr.x = calcValue(0);
		case YPosition:
			l.spr.y = calcValue(0);
		case Scale:
			l.spr.scaleX = calcValue(0) / 100.;
			l.spr.scaleY = calcValue(1) / 100.;
		case Opacity:
			l.spr.alpha = calcValue(0) / 100.;
		case Rotation:
			l.spr.rotation = calcValue(0) * Math.PI / 180;
		}
	}

	inline function get_currentFrame() {
		return curFrame;
	}

	function set_currentFrame( frame : Float ) {
		curFrame = frameCount == 0 ? 0 : frame % frameCount;
		if( curFrame < 0 ) curFrame += frameCount;
		return curFrame;
	}

	function loadTile( path : String ) {
		return hxd.res.Loader.currentInstance.load(filePrefix == null ? path : filePrefix + path).toTile();
	}

	/**
		Returns the animation layer objects under specified name.
	**/
	public function getLayer( name : String ) {
		var layer = null;
		for( l in layers ) {
			if( l.name == name ){
				layer = l;
				break;
			}
		}
		return layer == null ? null : layer.spr;
	}

	override function sync( ctx : RenderContext ) {
		super.sync(ctx);
		var prev = curFrame;
		if( !pause ){
			curFrame += speed * frameRate * ctx.elapsedTime;
			if( curFrame > frameCount )
				curFrame = frameCount;
		}

		for( l in layers ){
			l.spr.visible = curFrame >= l.from && curFrame <= l.to;
			if( l.spr.visible && l.tiles != null && l.tiles.length > 1 ){
				var bmp : h2d.Bitmap = cast l.spr;
				var curTile = hxd.Math.iclamp( Std.int( (curFrame - l.from) * l.tiles.length / (l.to - l.from) ), 0, l.tiles.length );
				var newTile = l.tiles[curTile];
				if( bmp.tile != newTile ){
					newTile.dx = bmp.tile.dx;
					newTile.dy = bmp.tile.dy;
					bmp.tile = newTile;
				}
			}
			for( a in l.animations )
				apply(l, a);
		}

		if( curFrame < frameCount )
			return;
		if( loop ) {
			if( frameCount == 0 )
				curFrame = 0;
			else
				curFrame %= frameCount;
			onAnimEnd();
		} else if( curFrame >= frameCount ) {
			curFrame = frameCount;
			if( curFrame != prev ) onAnimEnd();
		}
	}

	/**
		Sent when animation reaches the end.
		`KeyFrames.currentFrame` equals to `KeyFrames.frameCount` when `KeyFrames.loop` is disabled,
		is wrapped around to 0th frame if loop is enabled.
	**/
	public dynamic function onAnimEnd() {
	}

}