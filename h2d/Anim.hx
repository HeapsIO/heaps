package h2d;

class Anim extends Drawable {

	public var frames : Array<Tile>;
	public var currentFrame : Float;
	public var speed : Float;
	public var loop : Bool = true;

	public function new( ?frames, ?speed, ?parent ) {
		super(parent);
		this.frames = frames == null ? [] : frames;
		this.currentFrame = 0;
		this.speed = speed == null ? 15 : speed;
	}

	public function play( frames ) {
		this.frames = frames;
		this.currentFrame = 0;
	}

	public dynamic function onAnimEnd() {
	}

	override function getBoundsRec( relativeTo, out ) {
		super.getBoundsRec(relativeTo, out);
		var tile = getFrame();
		if( tile != null ) addBounds(relativeTo, out, tile.dx, tile.dy, tile.width, tile.height);
	}

	override function sync( ctx : RenderContext ) {
		currentFrame += speed * ctx.elapsedTime;
		if( currentFrame < frames.length )
			return;
		if( loop )
			currentFrame %= frames.length;
		else if( currentFrame >= frames.length )
			currentFrame = frames.length - 0.00001;
		onAnimEnd();
	}

	public function getFrame() {
		return frames[Std.int(currentFrame)];
	}

	override function draw( ctx : RenderContext ) {
		var t = getFrame();
		if( t != null ) drawTile(ctx.engine,t);
	}

}