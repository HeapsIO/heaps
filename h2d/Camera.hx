package h2d;

class Camera extends h2d.Object {

	/** X position of the camera screen center point. **/
	public var centerX(get, set) : Float;
	/** Y position of the camera screen center point. **/
	public var centerY(get, set) : Float;

	public var width(default, null) : Int;
	public var height(default, null) : Int;
	private var halfWidth : Float;
	private var halfHeight : Float;
	private var scene : Scene;

	private var camA : Float;
	private var camB : Float;
	private var camC : Float;
	private var camD : Float;
	private var camX : Float;
	private var camY : Float;

	public function new(scene : h2d.Scene) {
		super(scene);
		this.scene = scene;
		this.width = scene.width;
		this.height = scene.height;
		this.halfWidth = width * 0.5;
		this.halfHeight = height * 0.5;
	}

	inline function get_centerX() { return this.x + halfWidth; }
	inline function get_centerY() { return this.y + halfHeight; }

	inline function set_centerX(v : Float) : Float {
		this.x = v - halfWidth;
		return v;
	}
	inline function set_centerY(v : Float) : Float {
		this.y = v - halfHeight;
		return v;
	}

	override private function calcAbsPos()
	{
		if( rotation == 0 ) {
			camA = scaleX * scene.matA;
			camB = scaleX * scene.matB;
			camC = scaleY * scene.matC;
			camD = scaleY * scene.matD;
		} else {
			var cr = Math.cos(rotation);
			var sr = Math.sin(rotation);
			var tmpA = scaleX * cr;
			var tmpB = scaleX * sr;
			var tmpC = scaleY * -sr;
			var tmpD = scaleY * cr;
			camA = tmpA * scene.matA + tmpB * scene.matC;
			camB = tmpA * scene.matB + tmpB * scene.matD;
			camC = tmpC * scene.matA + tmpD * scene.matC;
			camD = tmpC * scene.matB + tmpD * scene.matD;
		}
		camX = -x * scene.matA + -y * scene.matC + scene.absX;
		camY = -x * scene.matB + -y * scene.matD + scene.absY;
	}

	override private function sync(ctx : RenderContext)
	{
		if (scene.width != width || scene.height != height) {
			// TODO: Anchor point
			var oldX = this.x + halfWidth;
			var oldY = this.y + halfHeight;
			this.width = scene.width;
			this.height = scene.height;
			this.halfWidth = width * 0.5;
			this.halfHeight = height * 0.5;
			this.x = oldX - halfWidth;
			this.y = oldY - halfHeight;
		}
		super.sync(ctx);
	}

	override private function drawRec(ctx : RenderContext)
	{
		if ( !visible ) return;

		if (posChanged) {
			calcAbsPos();
			for ( c in children )
				c.posChanged = true;
			posChanged = false;
		}
		ctx.setCamera(this);
		super.drawRec(ctx);
		ctx.clearCamera();
	}
}