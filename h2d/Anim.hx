package h2d;

class Anim extends Drawable {

	public var frames : Array<Tile>;
	public var currentFrame(get,set) : Float;
	public var speed : Float;
	public var loop : Bool = true;
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

	override function getBoundsRec( relativeTo, out ) {
		super.getBoundsRec(relativeTo, out);
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
		emitTile(ctx,t);
	}

}