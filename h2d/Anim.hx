package h2d;

class Anim extends Drawable {

	public var frames : Array<Tile>;
	public var currentFrame : Float;
	public var speed : Float;
	
	public function new( ?parent ) {
		super(parent);
		this.frames = [];
		this.currentFrame = 0;
		this.speed = 1.;
	}
	
	public function play( frames ) {
		this.frames = frames;
		this.currentFrame = 0;
	}
	
	override function sync( ctx : RenderContext ) {
		currentFrame += speed * ctx.elapsedTime;
		currentFrame %= frames.length;
	}
	
	public function getFrame() {
		return frames[Std.int(currentFrame)];
	}
	
	override function draw( ctx : RenderContext ) {
		var t = getFrame();
		if( t != null ) drawTile(ctx.engine,t);
	}
	
}