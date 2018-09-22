package h2d;

/**
	h2d.Anim is used to display an animated sequence of bitmap tiles on the screen.
**/
class Anim extends Drawable {

	/**
		The current animation, as a list of tile frames to display.
		If the frames are empty or if a tile is frames is null, a pink 5x5 bitmap will be displayed instead. Use remove() or visible=false to hide a h2d.Anim
	**/
	public var frames(default,null) : Array<Tile>;

	/**
		The current frame the animation is currently playing. Always in `[0,frames.length]` range
	**/
	public var currentFrame(get,set) : Float;

	/**
		The speed (in frames per second) at which the animation is playing (default 15.)
	**/
	public var speed : Float;

	/**
		Setting pause will pause the animation, preventing any automatic change to currentFrame.
	**/
	public var pause : Bool = false;

	/**
		Disabling loop will stop the animation at the last frame (default : true)
	**/
	public var loop : Bool = true;

	/**
		When enable, fading will draw two consecutive frames with alpha transition between
		them instead of directly switching from one to another when it reaches the next frame.
		This can be used to have smoother animation on some effects.
	**/
	public var fading : Bool = false;

	var curFrame : Float;

	/**
		Create a new animation with the specified frames, speed and parent object
	**/
	public function new( ?frames : Array<Tile>, ?speed : Float, ?parent : h2d.Object ) {
		super(parent);
		this.frames = frames == null ? [] : frames;
		this.curFrame = 0;
		this.speed = speed == null ? 15 : speed;
	}

	inline function get_currentFrame() {
		return curFrame;
	}

	/**
		Change the currently playing animation and unset the pause if it was set.
	**/
	public function play( frames : Array<Tile>, atFrame = 0. ) {
		this.frames = frames == null ? [] : frames;
		currentFrame = atFrame;
		pause = false;
	}

	/**
		onAnimEnd is automatically called each time the animation will reach past the last frame.
		If loop is true, it is called everytime the animation loops.
		If loop is false, it is called once when the animation reachs `currentFrame == frames.length`
	**/
	public dynamic function onAnimEnd() {
	}

	function set_currentFrame( frame : Float ) {
		curFrame = frames.length == 0 ? 0 : frame % frames.length;
		if( curFrame < 0 ) curFrame += frames.length;
		return curFrame;
	}

	override function getBoundsRec( relativeTo : Object, out : h2d.col.Bounds, forSize : Bool ) {
		super.getBoundsRec(relativeTo, out, forSize);
		var tile = getFrame();
		if( tile != null ) addBounds(relativeTo, out, tile.dx, tile.dy, tile.width, tile.height);
	}

	override function sync( ctx : RenderContext ) {
		super.sync(ctx);
		var prev = curFrame;
		if (!pause)
			curFrame += speed * ctx.elapsedTime;
		if( curFrame < frames.length )
			return;
		if( loop ) {
			if( frames.length == 0 )
				curFrame = 0;
			else
				curFrame %= frames.length;
			onAnimEnd();
		} else if( curFrame >= frames.length ) {
			curFrame = frames.length;
			if( curFrame != prev ) onAnimEnd();
		}
	}

	/**
		Return the tile at current frame.
	**/
	public function getFrame() : Tile {
		var i = Std.int(curFrame);
		if( i == frames.length ) i--;
		return frames[i];
	}

	override function draw( ctx : RenderContext ) {
		var t = getFrame();
		if( fading ) {
			var i = Std.int(curFrame) + 1;
			if( i >= frames.length ) {
				if( !loop ) return;
				i = 0;
			}
			var t2 = frames[i];
			var old = ctx.globalAlpha;
			var alpha = curFrame - Std.int(curFrame);
			ctx.globalAlpha *= 1 - alpha;
			emitTile(ctx, t);
			ctx.globalAlpha = old * alpha;
			emitTile(ctx, t2);
			ctx.globalAlpha = old;
		} else {
			emitTile(ctx,t);
		}
	}

}
