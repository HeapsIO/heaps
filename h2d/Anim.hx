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
		var prev = curFrame;
		curFrame += speed * ctx.elapsedTime;
		if( curFrame >= frames.length ) {
			if( frames.length == 0 )
				curFrame = 0;
			else if( loop ) {
				curFrame %= frames.length;
				onAnimEnd();
			} else {
				curFrame = frames.length - 0.000001;
				if( curFrame != prev ) onAnimEnd();
			}
		}
	}
	
	public dynamic function onAnimEnd() {
	}

	public function getFrame() {
		return frames[Std.int(curFrame)];
	}

	override function draw( ctx : RenderContext ) {
		var t = getFrame();
		emitTile(ctx,t);
	}

}