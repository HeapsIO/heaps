package h2d;
import hxd.fmt.kframes.Data;

typedef KeyframesLayer = {
	var name : String;
	var spr : Sprite;
	var animations : Array<KFAnimation>;
}

/**
	Adobe After effect player, see https://github.com/heapsio/keyframes/
**/
class KeyFrames extends Mask {

	var layers : Map<String, KeyframesLayer>;
	var filePrefix : String;
	var curFrame : Float;

	public var frameRate : Float;
	public var frameCount : Int;
	public var currentFrame(get,set) : Float;
	public var speed : Float = 1.;
	public var pause : Bool = false;
	public var loop : Bool = false;

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

		layers = new Map();
		for( f in file.features ) {
			var spr;
			if( f.backed_image == null ) {
				spr = new h2d.Sprite(this);
			} else {
				var bmp = new h2d.Bitmap(loadTile(f.backed_image), this);
				bmp.tile.scaleToSize(f.size.x, f.size.y);
				bmp.smooth = true;
				if( f.name.toLowerCase().indexOf("(add)") >= 0 )
					bmp.blendMode = Add;
				spr = bmp;
			}
			var l : KeyframesLayer = {
				name : f.name,
				spr : spr,
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
			layers.set(l.name, l);
		}
	}

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
		var xVal;
		if( next == null ) {
			next = cur;
			xVal = 0.;
		} else
			xVal = (curFrame - cur.start_frame) / (next.start_frame - cur.start_frame);

		function calcValue( index : Int ) : Float {
			var v0 = cur.data[index];
			if( xVal <= 0 ) return v0;

			var minT = 0.;
			var maxT = 1.;
			var maxDelta = 1 / (next.start_frame - cur.start_frame);

			inline function bezier(c1:Float, c2:Float, t:Float) {
				var u = 1 - t;
				return u * u * u * 0 + c1 * 3 * t * u * u + c2 * 3 * t * t * u + t * t * t * 1;
			}

			var curves = f.timing_curves[index];
			var c1x = curves[0].x;
			var c2x = curves[1].x;
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

			var c1y = curves[0].y;
			var c2y = curves[1].y;
			var y0 = bezier(c1y, c2y, minT);
			var y1 = bezier(c1y, c2y, maxT);
			var y = y0 + (y1 - y0) * xfactor;

			var v1 = next.data[index];
			return v0 + (v1 - v0) * y;
		}

		switch( f.property ) {
		case AnchorPoint:
			var bmp = Std.instance(l.spr, h2d.Bitmap);
			if( bmp != null ) {
				bmp.tile.dx = -Std.int(calcValue(0));
				bmp.tile.dy = -Std.int(calcValue(1));
			}
		case XPosition:
			l.spr.x = calcValue(0);
		case YPosition:
			l.spr.y = calcValue(0);
		case Scale:
			l.spr.setScale(calcValue(0) / 100.);
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

	public function getLayer( name : String ) {
		var l = layers.get(name);
		return l == null ? null : l.spr;
	}

	override function sync( ctx : RenderContext ) {
		super.sync(ctx);
		var prev = curFrame;
		if( !pause )
			curFrame += speed * frameRate * ctx.elapsedTime;

		for( l in layers )
			for( a in l.animations )
				apply(l, a);

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

	public dynamic function onAnimEnd() {
	}

}