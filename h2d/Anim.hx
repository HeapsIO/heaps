package h2d;

class Anim extends Drawable {

	public var frames : Array<Tile>;
	public var currentFrame(get,set) : Float;
	public var speed : Float;
	public var loop : Bool = true;
	
	/**
		When enable, fading will draw two consecutive frames with alpha transition between
		them instead of directly switching from one to another when it reaches the next frame.
		This can be used to have smoother animation on some effects.
	**/
	public var fading : Bool = false;
	var curFrame : Float;

	public function new( ?frames, ?speed, ?parent ) {
		super(parent);
		this.frames = frames == null ? [] : frames;
		this.curFrame = 0;
		this.speed = speed == null ? 15 : speed;
	}

	inline function get_currentFrame() {
		return curFrame;
	}

	public function play( frames, atFrame = 0. ) {
		this.frames = frames == null ? [] : frames;
		currentFrame = atFrame;
	}

	public dynamic function onAnimEnd() {
	}

	function set_currentFrame( frame : Float ) {
		curFrame = frames.length == 0 ? 0 : frame % frames.length;
		if( curFrame < 0 ) curFrame += frames.length;
		return curFrame;
	}

	override function getBoundsRec( relativeTo, out, forSize ) {
		super.getBoundsRec(relativeTo, out, forSize);
		var tile = getFrame();
		if( tile != null ) addBounds(relativeTo, out, tile.dx, tile.dy, tile.width, tile.height);
	}

	override function sync( ctx : RenderContext ) {
		super.sync(ctx);
		var prev = curFrame;
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

	public function getFrame() {
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